Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33187 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbEDSbl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 14:31:41 -0400
MIME-Version: 1.0
In-Reply-To: <1430390061-7090-1-git-send-email-j.anaszewski@samsung.com>
References: <1430390061-7090-1-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 4 May 2015 11:31:20 -0700
Message-ID: <CAK5ve-J4tpEj1BXf70dH9SU43b9PG38k_fWNis0c05D-5Q7+fA@mail.gmail.com>
Subject: Re: [PATCH v7] Documentation: leds: Add description of v4l2-flash sub-device
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 30, 2015 at 3:34 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This patch extends LED Flash class documention by
> the description of interactions with v4l2-flash sub-device.
>

Thanks, applied
-Bryan

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  Documentation/leds/leds-class-flash.txt |   47 +++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
> index 19bb673..4cedc58 100644
> --- a/Documentation/leds/leds-class-flash.txt
> +++ b/Documentation/leds/leds-class-flash.txt
> @@ -20,3 +20,50 @@ Following sysfs attributes are exposed for controlling flash LED devices:
>         - max_flash_timeout
>         - flash_strobe
>         - flash_fault
> +
> +
> +V4L2 flash wrapper for flash LEDs
> +=================================
> +
> +A LED subsystem driver can be controlled also from the level of VideoForLinux2
> +subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
> +be defined in the kernel config.
> +
> +The driver must call the v4l2_flash_init function to get registered in the
> +V4L2 subsystem. The function takes three arguments:
> +- fled_cdev : the LED Flash class device to wrap
> +- ops : V4L2 specific ops
> +       * external_strobe_set - defines the source of the flash LED strobe -
> +               V4L2_CID_FLASH_STROBE control or external source, typically
> +               a sensor, which makes it possible to synchronise the flash
> +               strobe start with exposure start,
> +       * intensity_to_led_brightness and led_brightness_to_intensity - perform
> +               enum led_brightness <-> V4L2 intensity conversion in a device
> +               specific manner - they can be used for devices with non-linear
> +               LED current scale.
> +- config : configuration for V4L2 Flash sub-device
> +       * dev_name - the name of the media entity, unique in the system,
> +       * flash_faults - bitmask of flash faults that the LED Flash class
> +               device can report; corresponding LED_FAULT* bit definitions are
> +               available in <linux/led-class-flash.h>,
> +       * intensity - constraints for the LED in the TORCH or INDICATOR mode,
> +               in microamperes,
> +       * has_external_strobe - determines whether the flash strobe source
> +               can be switched to external,
> +       * indicator_led - signifies that a led is of indicator type, which
> +               implies that it can have only two V4L2 controls:
> +               V4L2_CID_FLASH_INDICATOR_INTENSITY and V4L2_CID_FLASH_FAULT.
> +
> +On remove the v4l2_flash_release function has to be called, which takes one
> +argument - struct v4l2_flash pointer returned previously by v4l2_flash_init.
> +
> +Please refer to drivers/leds/leds-max77693.c for an exemplary usage of the
> +v4l2 flash wrapper.
> +
> +Once the V4L2 sub-device is registered by the driver which created the Media
> +controller device, the sub-device node acts just as a node of a native V4L2
> +flash API device would. The calls are simply routed to the LED flash API.
> +
> +Opening the V4L2 flash sub-device makes the LED subsystem sysfs interface
> +unavailable. The interface is re-enabled after the V4L2 flash sub-device
> +is closed.
> --
> 1.7.9.5
>
