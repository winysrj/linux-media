Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4708 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3A3Q7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 11:59:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFCv2 PATCH] em28xx: fix bytesperline calculation in G/TRY_FMT
Date: Wed, 30 Jan 2013 17:59:26 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201301300901.22486.hverkuil@xs4all.nl> <201301301049.25541.hverkuil@xs4all.nl> <51094B26.20303@googlemail.com>
In-Reply-To: <51094B26.20303@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301301759.27015.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed January 30 2013 17:32:38 Frank Schäfer wrote:
> Am 30.01.2013 10:49, schrieb Hans Verkuil:
> > On Wed 30 January 2013 10:40:30 Mauro Carvalho Chehab wrote:
> >> Em Wed, 30 Jan 2013 09:01:22 +0100
> >> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>
> >>> This was part of my original em28xx patch series. That particular patch
> >>> combined two things: this fix and the change where TRY_FMT would no
> >>> longer return -EINVAL for unsupported pixelformats. The latter change was
> >>> rejected (correctly), but we all forgot about the second part of the patch
> >>> which fixed a real bug. I'm reposting just that fix.
> >>>
> >>> Changes since v1:
> >>>
> >>> - v1 still miscalculated the bytesperline and imagesize values (they were
> >>>   too large).
> >>> - G_FMT had the same calculation bug.
> >>>
> >>> Tested with my em28xx.
> >>>
> >>> Regards,
> >>>
> >>>         Hans
> >>>
> >>> The bytesperline calculation was incorrect: it used the old width instead of
> >>> the provided width in the case of TRY_FMT, and it miscalculated the bytesperline
> >>> value for the depth == 12 (planar YUV 4:1:1) case. For planar formats the
> >>> bytesperline value should be the bytesperline of the widest plane, which is
> >>> the Y plane which has 8 bits per pixel, not 12.
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> ---
> >>>  drivers/media/usb/em28xx/em28xx-video.c |    8 ++++----
> >>>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> >>> index 2eabf2a..6ced426 100644
> >>> --- a/drivers/media/usb/em28xx/em28xx-video.c
> >>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> >>> @@ -837,8 +837,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> >>>  	f->fmt.pix.width = dev->width;
> >>>  	f->fmt.pix.height = dev->height;
> >>>  	f->fmt.pix.pixelformat = dev->format->fourcc;
> >>> -	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
> >>> -	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline  * dev->height;
> >>> +	f->fmt.pix.bytesperline = dev->width * (dev->format->depth >> 3);
> >> Why did you remove the round up here?
> > Because that would give the wrong result. Depth can be 8, 12 or 16. The YUV 4:1:1
> > planar format is the one with depth 12. But for the purposes of the bytesperline
> > calculation only the depth of the largest plane counts, which is the luma plane
> > with a depth of 8. So for a width of 720 the value of bytesperline should be:
> >
> > depth=8 -> bytesperline = 720
> > depth=12 -> bytesperline = 720
> > depth=16 -> bytesperline = 1440
> >
> > By rounding the bytesperline for depth = 12 would become 1440, which is wrong.
> 
> Isn't the actual problem that the bytesperline value is calculated based
> on the depth instead of size of the largest plane ?

Yes.

> While this formula gives us the right value for YUV411P (12bit), the
> calculated value for YUV422P (same plane size but 16bit depth) is wrong.

But em28xx doesn't support YUV422P :-)

Basically I just want to fix the bug without rewriting the whole thing...

> 
> I see two possibilities to solve this:
> 1) use switch/case(format_type) in vidioc_g_fmt_vid_cap() and
> vidioc_try_fmt_vid_cap()
> 2) add plane size to format data struct em28xx_fmt (either as total or
> relative value)
> 
> I prefer 2) to keep things together and to make adding new format easier.
> 
> Could you please also fix
> static void em28xx_copy_video()
> 
> -        int bytesperline = dev->width << 1;
> +        int bytesperline = (dev->width * dev->format->depth) >> 8

I'm hesitant to do this since I don't understand that code well enough.
It seems bytesperline is set to the worst case bytesperline, and that seems
to work.

To be honest, I don't have the time to work on this much more. If you want
to take this further, then feel free.

Regards,

	Hans

> AFAICS, bytesperline here is supposed to describe the actual number of
> bytes used per line (in opposition to g/try_fmt).
> 
> Regards,
> Frank
> 
> >
> >>> +	f->fmt.pix.sizeimage = (dev->width * dev->height * dev->format->depth + 7) >> 3;
> >>>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> >>>  
> >>>  	/* FIXME: TOP? NONE? BOTTOM? ALTENATE? */
> >>> @@ -906,8 +906,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> >>>  	f->fmt.pix.width = width;
> >>>  	f->fmt.pix.height = height;
> >>>  	f->fmt.pix.pixelformat = fmt->fourcc;
> >>> -	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
> >>> -	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
> >>> +	f->fmt.pix.bytesperline = width * (fmt->depth >> 3);
> >> Why did you remove the round up here?
> > See above.
> >
> > Regards,
> >
> > 	Hans
> >
> >>> +	f->fmt.pix.sizeimage = (width * height * fmt->depth + 7) >> 3;
> >>>  	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> >>>  	if (dev->progressive)
> >>>  		f->fmt.pix.field = V4L2_FIELD_NONE;
> >>
> >> Regards,
> >> Mauro
> >>
> 
