Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60346 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaKMS7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Nov 2014 13:59:04 -0500
MIME-Version: 1.0
In-Reply-To: <1415808557-29557-4-git-send-email-j.anaszewski@samsung.com>
References: <1415808557-29557-1-git-send-email-j.anaszewski@samsung.com> <1415808557-29557-4-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 13 Nov 2014 10:58:43 -0800
Message-ID: <CAK5ve-JH0KQs1Q4TcgaxmfAhOP9kDc-9r7HnbfOKECRPWQ2aXQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v7 3/3] Documentation: leds: Add description of LED
 Flash Class extension
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	sakari.ailus@linux.intel.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	b.zolnierkie@samsung.com, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 12, 2014 at 8:09 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> The documentation being added contains overall description of the
> LED Flash Class and the related sysfs attributes.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  Documentation/leds/leds-class-flash.txt |   39 +++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>  create mode 100644 Documentation/leds/leds-class-flash.txt
>
> diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
> new file mode 100644
> index 0000000..0164329
> --- /dev/null
> +++ b/Documentation/leds/leds-class-flash.txt
> @@ -0,0 +1,39 @@
> +
> +Flash LED handling under Linux
> +==============================
> +
> +Some LED devices support two modes - torch and flash. In order to enable

I think I asked this question before, Torch, Flash and Indicator. As
you answered torch is implemented by sync led brightness set operation
in our LEDS_CLASS and Flash is implemented in this LEDS_CLASS_FLASH.

I suggest put this information in document or code comments. Then
people know how to use torch and flash.

For indicator I still don't know why we need this since indicator is
like blinking and it should be support by LEDS_CLASS right?

Flash is for some camera capture, right?

> +support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol must be defined
> +in the kernel config. A flash LED driver must register in the LED subsystem
> +with led_classdev_flash_register to gain flash capabilities.
> +
> +Following sysfs attributes are exposed for controlling flash led devices:
> +
> +       - flash_brightness - flash LED brightness in microamperes (RW)
> +       - max_flash_brightness - maximum available flash LED brightness (RO)
> +       - indicator_brightness - privacy LED brightness in microamperes (RW)
> +       - max_indicator_brightness - maximum privacy LED brightness in
> +                                    microamperes (RO)

What's the privacy mean here?

> +       - flash_timeout - flash strobe duration in microseconds (RW)
> +       - max_flash_timeout - maximum available flash strobe duration (RO)
> +       - flash_strobe - flash strobe state (RW)
> +       - flash_fault - bitmask of flash faults that may have occurred,
> +                       possible flags are:
> +               * 0x01 - flash controller voltage to the flash LED has exceeded
> +                        the limit specific to the flash controller
> +               * 0x02 - the flash strobe was still on when the timeout set by
> +                        the user has expired; not all flash controllers may
> +                        set this in all such conditions
> +               * 0x04 - the flash controller has overheated
> +               * 0x08 - the short circuit protection of the flash controller
> +                        has been triggered
> +               * 0x10 - current in the LED power supply has exceeded the limit
> +                        specific to the flash controller
> +               * 0x40 - flash controller voltage to the flash LED has been
> +                        below the minimum limit specific to the flash
> +               * 0x80 - the input voltage of the flash controller is below
> +                        the limit under which strobing the flash at full
> +                        current will not be possible. The condition persists
> +                        until this flag is no longer set
> +               * 0x100 - the temperature of the LED has exceeded its allowed
> +                         upper limit

Are these error code the same for all the LED controller? Or just for
some specific chip?


> --
> 1.7.9.5
>
