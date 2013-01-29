Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3485 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3A2SV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 13:21:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH] em28xx: fix bytesperline calculation in TRY_FMT
Date: Tue, 29 Jan 2013 19:21:50 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201301291049.58085.hverkuil@xs4all.nl> <51080C32.40601@googlemail.com>
In-Reply-To: <51080C32.40601@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301291921.50844.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 29 2013 18:51:46 Frank Schäfer wrote:
> Am 29.01.2013 10:49, schrieb Hans Verkuil:
> > This was part of my original em28xx patch series. That particular patch
> > combined two things: this fix and the change where TRY_FMT would no
> > longer return -EINVAL for unsupported pixelformats. The latter change was
> > rejected (correctly), but we all forgot about the second part of the patch
> > which fixed a real bug. I'm reposting just that fix.
> >
> > Regards,
> >
> > 	Hans
> >
> > The bytesperline calculation was incorrect: it used the old width instead
> > of the provided width, and it miscalculated the bytesperline value for the
> > depth == 12 case.
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > index 2eabf2a..070506d 100644
> > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > @@ -906,7 +906,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> >  	f->fmt.pix.width = width;
> >  	f->fmt.pix.height = height;
> >  	f->fmt.pix.pixelformat = fmt->fourcc;
> > -	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
> > +	f->fmt.pix.bytesperline = width * ((fmt->depth + 7) >> 3);
> >  	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
> >  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> >  	if (dev->progressive)
> 
> Hmm... how are 12 bit pixels stored ? Are padding bits used so that 2
> bytes per pixel are needed ?

It's a planar format where the luma plane is twice as big as the two chroma
planes combined. So that gives an effective 'depth' of 12 bits per pixel.
The bytesperline value should be that of the largest plane.

I now realize that that is still wrong in the calculation above. It should
be this instead:

	f->fmt.pix.bytesperline = width * (fmt->depth >> 3);
  	f->fmt.pix.sizeimage = (width * height * fmt->depth) >> 3;

> I wonder if V4L2_PIX_FMT_YUV411P has ever been tested (libv4lconvert
> doesn't support it)...
> 
> While we are at it, we should check and fix the other size calculations,
> too.
> For example, in em28xx-video.c we have in
> 
> vidioc_g_fmt_vid_cap():
> f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
> 
> queue_setup():
> size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
> 
> buffer_prepare():
> size = (dev->width * dev->height * dev->format->depth + 7) >> 3;
> 
> em28xx_copy_video():
> int bytesperline = dev->width << 1;

Hmm, I'll have to prepare a RFCv2.

Regards,

	Hans

> 
> and there are probably more places...
> 
> 
> Regards,
> Frank
> 
> 
