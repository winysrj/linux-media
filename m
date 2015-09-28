Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59749 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbI1Uhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2015 16:37:52 -0400
Date: Mon, 28 Sep 2015 22:37:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	sakari.ailus@linux.intel.com, andrew@lunn.ch, rpurdie@rpsys.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/12] media: flash: use led_set_brightness_sync for
 torch brightness
Message-ID: <20150928203747.GA19666@amd>
References: <1443445641-9529-1-git-send-email-j.anaszewski@samsung.com>
 <1443445641-9529-13-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443445641-9529-13-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2015-09-28 15:07:21, Jacek Anaszewski wrote:
> LED subsystem shifted responsibility for choosing between SYNC or ASYNC
> way of setting brightness from drivers to the caller. Adapt the wrapper
> to those changes.

Umm. Maybe right patch, but wrong position in the queue, no?

If I understand changelog correctly, LED flashes will be subtly broken
before this patch is applied.

I guess this patch should be moved sooner so everything works at each
position in bisect...?

Best regards,
								Pavel

> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/v4l2-core/v4l2-flash-led-class.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> index 5bdfb8d..5d67335 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -107,10 +107,10 @@ static void v4l2_flash_set_led_brightness(struct v4l2_flash *v4l2_flash,
>  		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
>  			return;
>  
> -		led_set_brightness(&v4l2_flash->fled_cdev->led_cdev,
> +		led_set_brightness_sync(&v4l2_flash->fled_cdev->led_cdev,
>  					brightness);
>  	} else {
> -		led_set_brightness(&v4l2_flash->iled_cdev->led_cdev,
> +		led_set_brightness_sync(&v4l2_flash->iled_cdev->led_cdev,
>  					brightness);
>  	}
>  }
> @@ -206,11 +206,11 @@ static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>  	case V4L2_CID_FLASH_LED_MODE:
>  		switch (c->val) {
>  		case V4L2_FLASH_LED_MODE_NONE:
> -			led_set_brightness(led_cdev, LED_OFF);
> +			led_set_brightness_sync(led_cdev, LED_OFF);
>  			return led_set_flash_strobe(fled_cdev, false);
>  		case V4L2_FLASH_LED_MODE_FLASH:
>  			/* Turn the torch LED off */
> -			led_set_brightness(led_cdev, LED_OFF);
> +			led_set_brightness_sync(led_cdev, LED_OFF);
>  			if (ctrls[STROBE_SOURCE]) {
>  				external_strobe = (ctrls[STROBE_SOURCE]->val ==
>  					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
