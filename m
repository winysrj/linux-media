Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56821 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3BCOpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 09:45:33 -0500
Received: by mail-pa0-f50.google.com with SMTP id fa11so354535pad.23
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 06:45:33 -0800 (PST)
Message-ID: <510F2FAA.3020606@gmail.com>
Date: Sun, 03 Feb 2013 22:48:58 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/18] tlg2300: switch to unlocked_ioctl.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <d1b82f78da6c96ca5d0bd8608af7060192342513.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <d1b82f78da6c96ca5d0bd8608af7060192342513.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The driver already does locking, so it is safe to switch to unlocked_ioctl.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-radio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index 90dc1d1..c4feffb 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -156,7 +156,7 @@ static const struct v4l2_file_operations poseidon_fm_fops = {
>  	.owner         = THIS_MODULE,
>  	.open          = poseidon_fm_open,
>  	.release       = poseidon_fm_close,
> -	.ioctl	       = video_ioctl2,
> +	.unlocked_ioctl = video_ioctl2,
>  };
>  
>  static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
Acked-by: Huang Shijie <shijie8@gmail.com>
