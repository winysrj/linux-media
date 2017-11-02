Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51970 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754859AbdKBJIe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Nov 2017 05:08:34 -0400
Date: Thu, 2 Nov 2017 11:08:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 03/26] media: led-class-flash: better handle NULL
 flash struct
Message-ID: <20171102090832.irvz5px745lz55kh@valkosipuli.retiisi.org.uk>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
 <7e38ad92ea843f1ec1130a64ab50afeb72b850c1.1509569763.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e38ad92ea843f1ec1130a64ab50afeb72b850c1.1509569763.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Somehow the To header in your message ends up being:

To: unlisted-recipients: no To-header on input <;

This doesn't end well when replying to the messages.

On Wed, Nov 01, 2017 at 05:05:40PM -0400, Mauro Carvalho Chehab wrote:
> The logic at V4L2 led core assumes that the flash struct
> can be null. However, it doesn't check for null while
> trying to set, causing some smatch  to warn:
> 
> 	drivers/media/v4l2-core/v4l2-flash-led-class.c:210 v4l2_flash_s_ctrl() error: we previously assumed 'fled_cdev' could be null (see line 200)

I guess this is fine for suppressing the warning but there's not a
technical problem it fixes: if there's no flash, then the flash controls
aren't registered with the control handler.

Anyway,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  include/linux/led-class-flash.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
> index e97966d1fb8d..700efaa9e115 100644
> --- a/include/linux/led-class-flash.h
> +++ b/include/linux/led-class-flash.h
> @@ -121,6 +121,8 @@ extern void led_classdev_flash_unregister(struct led_classdev_flash *fled_cdev);
>  static inline int led_set_flash_strobe(struct led_classdev_flash *fled_cdev,
>  					bool state)
>  {
> +	if (!fled_cdev)
> +		return -EINVAL;
>  	return fled_cdev->ops->strobe_set(fled_cdev, state);
>  }
>  
> @@ -136,6 +138,8 @@ static inline int led_set_flash_strobe(struct led_classdev_flash *fled_cdev,
>  static inline int led_get_flash_strobe(struct led_classdev_flash *fled_cdev,
>  					bool *state)
>  {
> +	if (!fled_cdev)
> +		return -EINVAL;
>  	if (fled_cdev->ops->strobe_get)
>  		return fled_cdev->ops->strobe_get(fled_cdev, state);
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
