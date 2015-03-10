Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41437 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbCJARV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 20:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1425485680-8417-3-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com> <1425485680-8417-3-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 9 Mar 2015 17:17:00 -0700
Message-ID: <CAK5ve-+JW4+bzxPSHCMBPdEDNWW8yWjgL_QyK+tNG_woTT=tLw@mail.gmail.com>
Subject: Re: [PATCH/RFC v12 02/19] leds: flash: document sysfs interface
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 4, 2015 at 8:14 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Add a documentation of LED Flash class specific sysfs attributes.
>

Thanks, merged!
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  Documentation/ABI/testing/sysfs-class-led-flash |   80 +++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-led-flash
>
> diff --git a/Documentation/ABI/testing/sysfs-class-led-flash b/Documentation/ABI/testing/sysfs-class-led-flash
> new file mode 100644
> index 0000000..220a027
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-led-flash
> @@ -0,0 +1,80 @@
> +What:          /sys/class/leds/<led>/flash_brightness
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read/write
> +               Set the brightness of this LED in the flash strobe mode, in
> +               microamperes. The file is created only for the flash LED devices
> +               that support setting flash brightness.
> +
> +               The value is between 0 and
> +               /sys/class/leds/<led>/max_flash_brightness.
> +
> +What:          /sys/class/leds/<led>/max_flash_brightness
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read only
> +               Maximum brightness level for this LED in the flash strobe mode,
> +               in microamperes.
> +
> +What:          /sys/class/leds/<led>/flash_timeout
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read/write
> +               Hardware timeout for flash, in microseconds. The flash strobe
> +               is stopped after this period of time has passed from the start
> +               of the strobe. The file is created only for the flash LED
> +               devices that support setting flash timeout.
> +
> +What:          /sys/class/leds/<led>/max_flash_timeout
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read only
> +               Maximum flash timeout for this LED, in microseconds.
> +
> +What:          /sys/class/leds/<led>/flash_strobe
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read/write
> +               Flash strobe state. When written with 1 it triggers flash strobe
> +               and when written with 0 it turns the flash off.
> +
> +               On read 1 means that flash is currently strobing and 0 means
> +               that flash is off.
> +
> +What:          /sys/class/leds/<led>/flash_fault
> +Date:          March 2015
> +KernelVersion: 4.0
> +Contact:       Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:   read only
> +               Space separated list of flash faults that may have occurred.
> +               Flash faults are re-read after strobing the flash. Possible
> +               flash faults:
> +
> +               * led-over-voltage - flash controller voltage to the flash LED
> +                       has exceeded the limit specific to the flash controller
> +               * flash-timeout-exceeded - the flash strobe was still on when
> +                       the timeout set by the user has expired; not all flash
> +                       controllers may set this in all such conditions
> +               * controller-over-temperature - the flash controller has
> +                       overheated
> +               * controller-short-circuit - the short circuit protection
> +                       of the flash controller has been triggered
> +               * led-power-supply-over-current - current in the LED power
> +                       supply has exceeded the limit specific to the flash
> +                       controller
> +               * indicator-led-fault - the flash controller has detected
> +                       a short or open circuit condition on the indicator LED
> +               * led-under-voltage - flash controller voltage to the flash
> +                       LED has been below the minimum limit specific to
> +                       the flash
> +               * controller-under-voltage - the input voltage of the flash
> +                       controller is below the limit under which strobing the
> +                       flash at full current will not be possible;
> +                       the condition persists until this flag is no longer set
> +               * led-over-temperature - the temperature of the LED has exceeded
> +                       its allowed upper limit
> --
> 1.7.9.5
>
