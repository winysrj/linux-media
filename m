Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39175 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3BCPpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:45:02 -0500
Received: by mail-pb0-f49.google.com with SMTP id xa12so2817656pbc.36
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:45:01 -0800 (PST)
Message-ID: <510F3DA4.2030209@gmail.com>
Date: Sun, 03 Feb 2013 23:48:36 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 13/18] tlg2300: fix missing audioset.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <be96cdafc8e99572c58eeb92c14081705335aa0a.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <be96cdafc8e99572c58eeb92c14081705335aa0a.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index da7cbd4..122f299 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -903,7 +903,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *in)
>  	 * the audio input index mixed with this video input,
>  	 * Poseidon only have one audio/video, set to "0"
>  	 */
> -	in->audioset	= 0;
> +	in->audioset	= 1;
i think it should be 0. it's need to be test.

thanks
Huang Shijie
>  	in->tuner	= 0;
>  	in->std		= V4L2_STD_ALL;
>  	in->status	= 0;

