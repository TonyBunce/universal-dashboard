param([Switch]$Release)

Import-Module "$PSScriptRoot\..\TestFramework.psm1" -Force
$ModulePath = Get-ModulePath -Release:$Release
$BrowserPort = Get-BrowserPort -Release:$Release

Import-Module $ModulePath -Force


Get-UDDashboard | Stop-UDDashboard

Describe "New-UDImageCarousel" {

    Context "Image Carousel With Slides" {

        $Page1 = New-UDPage -Name "Carousel" -Content {

            $FirstSlide = @{
                backgroundRepeat = 'no-repeat'
                BackgroundImage = 'https://stmed.net/sites/default/files/lady-deadpool-wallpapers-27626-5413437.jpg'
                BackgroundColor  = 'transparent'
                BackgroundSize = 'cover'
                BackgroundPosition = '0% 0%'
                Url  = 'https://universaldashboard.io/'
            }
            $SecondSlide = @{
                BackgroundColor  = 'transparent'
                BackgroundSize = 'cover'
                BackgroundPosition = '0% 0%'
                Url  = 'images/thor_-ragnarok-wallpapers-30137-2449291.jpg'
                BackgroundImage  = 'images/thor_-ragnarok-wallpapers-30137-2449291.jpg'
            }
            $ThirdSlide = @{
                BackgroundColor  = 'transparent'
                BackgroundSize = 'cover'
                BackgroundPosition = '0% 0%'
                Url  = 'https://stmed.net/sites/default/files/ultimate-spider-man-wallpapers-27724-2035627.jpg'
                BackgroundImage  = 'https://stmed.net/sites/default/files/ultimate-spider-man-wallpapers-27724-2035627.jpg'
            }
            New-UDImageCarousel -Id 'carousel-demo' -Items {
                New-UDImageCarouselItem @FirstSlide
                New-UDImageCarouselItem @SecondSlide
                New-UDImageCarouselItem @ThirdSlide
            }  -Height 750px -FullWidth -ShowIndecators -AutoCycle -Speed 8000 -ButtonText 'Button' -FixButton
        
        }
        
        $dashboard = New-UDDashboard -Title "Test Carousel" -Pages $Page1
        $Server = Start-UDDashboard -Port 10001 -Dashboard $dashboard
        $Driver = Start-SeFirefox
        Enter-SeUrl -Driver $Driver -Url "http://localhost:$BrowserPort/Carousel"
        Start-Sleep 2

        $carousel = Find-SeElement -Driver $driver -Id 'carousel-demo
        '
        it "Should have image carousel component" {
            $carousel -eq $null | Should be $false
        }

        it "Should have 3 slides in the image carousel" {
            $carousel.FindElementsByClassName('carousel-item').count | Should be 3
        }

        it "Should have fixed button" {
            $carousel.FindElementsByClassName('carousel-fixed-item').count | should be 1
        }

        it "Should have custom height Size" {
            $carousel.Size.Height | should be 750
        }
        Stop-SeDriver $Driver
        Stop-UDDashboard -Server $Server 
    }

}
