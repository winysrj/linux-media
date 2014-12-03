Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41448 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750969AbaLCRIW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 12:08:22 -0500
Date: Wed, 3 Dec 2014 19:08:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 02/19] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141203170818.GN14746@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Dec 03, 2014 at 05:06:37PM +0100, Jacek Anaszewski wrote:
> The documentation being added contains overall description of the
> LED Flash Class and the related sysfs attributes.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  Documentation/leds/leds-class-flash.txt |   50 +++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/leds/leds-class-flash.txt
> 
> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
> new file mode 100644
> index 0000000..82e58b1
> --- /dev/null
> +++ b/Documentation/leds/leds-class-flash.txt
> @@ -0,0 +1,50 @@
> +
> +Flash LED handling under Linux
> +==============================
> +
> +Some LED devices support two modes - torch and flash. The modes are
> +supported by the LED class (see Documentation/leds/leds-class.txt)
> +and LED Flash class respectively.
> +
> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
> +must be defined in the kernel config. A flash LED driver must register
> +in the LED subsystem with led_classdev_flash_register to gain flash
> +capabilities.
> +
> +Following sysfs attributes are exposed for controlling flash led devices:
> +
> +	- flash_brightness - flash LED brightness in microamperes (RW)
> +	- max_flash_brightness - maximum available flash LED brightness (RO)
> +	- flash_timeout - flash strobe duration in microseconds (RW)
> +	- max_flash_timeout - maximum available flash strobe duration (RO)
> +	- flash_strobe - flash strobe state (RW)
> +	- flash_sync_strobe - one flash device can control more than one
> +			      sub-led; when this atrribute is set to 1

s/atrribute/attribute/

> +			      the flash led will be strobed synchronously
> +			      with the other one controlled by the same
> +			      device; flash timeout setting is inherited
> +			      from the led being strobed explicitly and
> +			      flash brightness setting of a sub-led's
> +			      being synchronized is used (RW)

The flash brightness shouldn't be determined by the strobed LED. If this is
a property of the hardware, then be it, but in general no, it it shouldn't
be an interface requirement. I think this should just say that the strobe is
synchronised.

How does the user btw. figure out which flash LEDs may be strobed
synchronously using the LED flash interface?

> +	- flash_fault - bitmask of flash faults that may have occurred
> +			possible flags are:
> +		* 0x01 - flash controller voltage to the flash LED has exceeded
> +			 the limit specific to the flash controller
> +		* 0x02 - the flash strobe was still on when the timeout set by
> +			 the user has expired; not all flash controllers may
> +			 set this in all such conditions
> +		* 0x04 - the flash controller has overheated
> +		* 0x08 - the short circuit protection of the flash controller
> +			 has been triggered
> +		* 0x10 - current in the LED power supply has exceeded the limit
> +			 specific to the flash controller
> +		* 0x40 - flash controller voltage to the flash LED has been
> +			 below the minimum limit specific to the flash
> +		* 0x80 - the input voltage of the flash controller is below
> +			 the limit under which strobing the flash at full
> +			 current will not be possible. The condition persists
> +			 until this flag is no longer set
> +		* 0x100 - the temperature of the LED has exceeded its allowed
> +			  upper limit
> +
> +		Flash faults are cleared by reading the attribute.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
