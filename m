Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab3AECzS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 21:55:18 -0500
Date: Sat, 5 Jan 2013 00:54:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 10/15] em28xx: fix broken TRY_FMT.
Message-ID: <20130105005444.361b2604@redhat.com>
In-Reply-To: <1357333186-8466-11-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
	<1357333186-8466-11-git-send-email-dheitmueller@kernellabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans/Devin,

Em Fri,  4 Jan 2013 15:59:40 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> TRY_FMT should not return an error if a pixelformat is unsupported. Instead just
> pick a common pixelformat.
> 
> Also the bytesperline calculation was incorrect: it used the old width instead of
> the provided with, and it miscalculated the bytesperline value for the depth == 12
> case.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index a91a248..7c09b55 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -821,7 +821,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	if (!fmt) {
>  		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
>  				f->fmt.pix.pixelformat);
> -		return -EINVAL;
> +		fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);

This change has the potential of causing userspace regressions, so,
for now, I won't apply such change.

We need to discuss it better, before risk breaking things, and likely fix
applications first.

Regards,
Mauro
