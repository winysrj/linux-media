Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:59627 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3BCPdW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:33:22 -0500
Received: by mail-da0-f53.google.com with SMTP id x6so2315100dac.26
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:33:22 -0800 (PST)
Message-ID: <510F3AE8.3080205@gmail.com>
Date: Sun, 03 Feb 2013 23:36:56 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 08/18] tlg2300: fix radio querycap
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <e745ec830817f4eab48445b0e205a7b568a0e2b0.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <e745ec830817f4eab48445b0e205a7b568a0e2b0.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-radio.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index 854ffa0..80307d3 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -147,7 +147,12 @@ static int vidioc_querycap(struct file *file, void *priv,
>  	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
>  	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
>  	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
> -	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	/* Report all capabilities of the USB device */
> +	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS |
> +			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VBI_CAPTURE |
why add these video/vbi capabilities?

> +			V4L2_CAP_AUDIO | V4L2_CAP_STREAMING 
> +			V4L2_CAP_READWRITE;
>  	return 0;
>  }
>  

