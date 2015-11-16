Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44552 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbbKPJf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 04:35:57 -0500
Message-id: <5649A37A.2050902@samsung.com>
Date: Mon, 16 Nov 2015 10:35:54 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@ucw.cz, sakari.ailus@linux.intel.com, andrew@lunn.ch,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 10/10] media: flash: use led_set_brightness_sync for
 torch brightness
References: <1444209048-29415-1-git-send-email-j.anaszewski@samsung.com>
 <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1444209048-29415-11-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch depends on the preceding LED core improvements patches
from this patch set, and it would be best if it was merged through
the LED tree. Can I get your ack for this? I've already obtained acks
for the whole set from Sakari.

Best Regards,
Jacek Anaszewski

On 10/07/2015 11:10 AM, Jacek Anaszewski wrote:
> LED subsystem shifted responsibility for choosing between SYNC or ASYNC
> way of setting brightness from drivers to the caller. Adapt the wrapper
> to those changes.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: linux-media@vger.kernel.org
> ---
>   drivers/media/v4l2-core/v4l2-flash-led-class.c |    8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> index 5bdfb8d..5d67335 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -107,10 +107,10 @@ static void v4l2_flash_set_led_brightness(struct v4l2_flash *v4l2_flash,
>   		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
>   			return;
>
> -		led_set_brightness(&v4l2_flash->fled_cdev->led_cdev,
> +		led_set_brightness_sync(&v4l2_flash->fled_cdev->led_cdev,
>   					brightness);
>   	} else {
> -		led_set_brightness(&v4l2_flash->iled_cdev->led_cdev,
> +		led_set_brightness_sync(&v4l2_flash->iled_cdev->led_cdev,
>   					brightness);
>   	}
>   }
> @@ -206,11 +206,11 @@ static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>   	case V4L2_CID_FLASH_LED_MODE:
>   		switch (c->val) {
>   		case V4L2_FLASH_LED_MODE_NONE:
> -			led_set_brightness(led_cdev, LED_OFF);
> +			led_set_brightness_sync(led_cdev, LED_OFF);
>   			return led_set_flash_strobe(fled_cdev, false);
>   		case V4L2_FLASH_LED_MODE_FLASH:
>   			/* Turn the torch LED off */
> -			led_set_brightness(led_cdev, LED_OFF);
> +			led_set_brightness_sync(led_cdev, LED_OFF);
>   			if (ctrls[STROBE_SOURCE]) {
>   				external_strobe = (ctrls[STROBE_SOURCE]->val ==
>   					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>


