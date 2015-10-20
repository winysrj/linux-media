Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbbJTIQp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 04:16:45 -0400
Subject: Re: [PATCH] m5602: correctly check failed thread creation
To: Insu Yun <wuninsu@gmail.com>, erik.andren@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1445268253-23157-1-git-send-email-wuninsu@gmail.com>
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5625F865.9080400@redhat.com>
Date: Tue, 20 Oct 2015 10:16:37 +0200
MIME-Version: 1.0
In-Reply-To: <1445268253-23157-1-git-send-email-wuninsu@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 19-10-15 17:24, Insu Yun wrote:
> Since thread creation can be failed, check return value of
> kthread_create and handle an error.
>
> Signed-off-by: Insu Yun <wuninsu@gmail.com>
> ---
>   drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
> index bf6b215..76b40d1 100644
> --- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
> +++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
> @@ -221,6 +221,10 @@ int s5k83a_start(struct sd *sd)
>   	   to assume that there is no better way of accomplishing this */
>   	sd->rotation_thread = kthread_create(rotation_thread_function,
>   					     sd, "rotation thread");
> +	if (IS_ERR(sd->rotation_thread)) {
> +		err = PTR_ERR(sd->rotation_thread);
> +		goto fail;
> +	}

There is no need to use a goto here you can simply directly return
the error.

>   	wake_up_process(sd->rotation_thread);
>
>   	/* Preinit the sensor */
> @@ -234,9 +238,11 @@ int s5k83a_start(struct sd *sd)
>   				data[0]);
>   	}
>   	if (err < 0)
> -		return err;
> +		goto fail;

No need for introducing a goto here either.

>
>   	return s5k83a_set_led_indication(sd, 1);
> +fail:
> +	return err;
>   }
>
>   int s5k83a_stop(struct sd *sd)

Regards,

Hans
