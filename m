Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1332 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3AENeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 08:34:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 10/15] em28xx: fix broken TRY_FMT.
Date: Sat, 5 Jan 2013 14:34:04 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com> <1357333186-8466-11-git-send-email-dheitmueller@kernellabs.com> <20130105005444.361b2604@redhat.com>
In-Reply-To: <20130105005444.361b2604@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301051434.04835.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat January 5 2013 03:54:44 Mauro Carvalho Chehab wrote:
> Hans/Devin,
> 
> Em Fri,  4 Jan 2013 15:59:40 -0500
> Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> 
> > TRY_FMT should not return an error if a pixelformat is unsupported. Instead just
> > pick a common pixelformat.
> > 
> > Also the bytesperline calculation was incorrect: it used the old width instead of
> > the provided with, and it miscalculated the bytesperline value for the depth == 12
> > case.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-video.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index a91a248..7c09b55 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -821,7 +821,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> >  	if (!fmt) {
> >  		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
> >  				f->fmt.pix.pixelformat);
> > -		return -EINVAL;
> > +		fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
> 
> This change has the potential of causing userspace regressions, so,
> for now, I won't apply such change.

Good!

> We need to discuss it better, before risk breaking things, and likely fix
> applications first.

Absolutely. I also want to change this test in v4l2-compliance from 'failure'
to 'warning' for the time being.

Regards,

	Hans
