Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49089 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaIWTad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 15:30:33 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so9420583lbv.30
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 12:30:31 -0700 (PDT)
Message-ID: <5421CAB2.3030804@googlemail.com>
Date: Tue, 23 Sep 2014 21:32:02 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] em28xx: fix VBI handling logic
References: <c3e1b2c823189385494c01a7c776700f0e8d5913.1411142521.git.mchehab@osg.samsung.com> <8444ab3f16a454ab8d2eaefb8990193313c2ac33.1411142521.git.mchehab@osg.samsung.com>
In-Reply-To: <8444ab3f16a454ab8d2eaefb8990193313c2ac33.1411142521.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 19.09.2014 um 18:02 schrieb Mauro Carvalho Chehab:
> When both VBI and video are streaming, and video stream is stopped,
> a subsequent trial to restart it will fail, because S_FMT will
> return -EBUSY.
>
> That prevents applications like zvbi to work properly.
>
> Please notice that, while this fix it fully for zvbi, the
> best is to get rid of streaming_users and res_get logic as a hole.
>
> However, this single-line patch is better to be merged at -stable.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 08569cbccd95..d75e7f82dfb9 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -1351,7 +1351,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	struct em28xx *dev = video_drvdata(file);
>  	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>  
> -	if (v4l2->streaming_users > 0)
> +	if (vb2_is_busy(&v4l2->vb_vidq))
Looks dangerous.
Are you 100% sure that VIDIOC_S_FMT can have no effect on VBI capturing ?
It seems to trigger writes to multiple registers...

Regards,
Frank

>  		return -EBUSY;
>  
>  	vidioc_try_fmt_vid_cap(file, priv, f);

