Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:16122 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3AaLDj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 06:03:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2 PATCH] em28xx: fix bytesperline calculation in G/TRY_FMT
Date: Thu, 31 Jan 2013 12:02:59 +0100
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201301300901.22486.hverkuil@xs4all.nl> <201301310816.39891.hverkuil@xs4all.nl> <20130131080807.55e796ea@redhat.com>
In-Reply-To: <20130131080807.55e796ea@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301311202.59402.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 31 January 2013 11:08:07 Mauro Carvalho Chehab wrote:
> Em Thu, 31 Jan 2013 08:16:39 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Wed January 30 2013 20:07:29 Mauro Carvalho Chehab wrote:
> > > Em Wed, 30 Jan 2013 10:49:25 +0100
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > On Wed 30 January 2013 10:40:30 Mauro Carvalho Chehab wrote:
> > > > > Em Wed, 30 Jan 2013 09:01:22 +0100
> > > > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > > > 
> > > > > > This was part of my original em28xx patch series. That particular patch
> > > > > > combined two things: this fix and the change where TRY_FMT would no
> > > > > > longer return -EINVAL for unsupported pixelformats. The latter change was
> > > > > > rejected (correctly), but we all forgot about the second part of the patch
> > > > > > which fixed a real bug. I'm reposting just that fix.
> > > > > > 
> > > > > > Changes since v1:
> > > > > > 
> > > > > > - v1 still miscalculated the bytesperline and imagesize values (they were
> > > > > >   too large).
> > > > > > - G_FMT had the same calculation bug.
> > > > > > 
> > > > > > Tested with my em28xx.
> > > > > > 
> > > > > > Regards,
> > > > > > 
> > > > > >         Hans
> > > > > > 
> > > > > > The bytesperline calculation was incorrect: it used the old width instead of
> > > > > > the provided width in the case of TRY_FMT, and it miscalculated the bytesperline
> > > > > > value for the depth == 12 (planar YUV 4:1:1) case. For planar formats the
> > > > > > bytesperline value should be the bytesperline of the widest plane, which is
> > > > > > the Y plane which has 8 bits per pixel, not 12.
> > > > > > 
> > > > > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > > ---
> > > > > >  drivers/media/usb/em28xx/em28xx-video.c |    8 ++++----
> > > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > > > > > index 2eabf2a..6ced426 100644
> > > > > > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > > > > > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > > > > > @@ -837,8 +837,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > > > > >  	f->fmt.pix.width = dev->width;
> > > > > >  	f->fmt.pix.height = dev->height;
> > > > > >  	f->fmt.pix.pixelformat = dev->format->fourcc;
> > > > > > -	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
> > > > > > -	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline  * dev->height;
> > > > > > +	f->fmt.pix.bytesperline = dev->width * (dev->format->depth >> 3);
> > > > > 
> > > > > Why did you remove the round up here?
> > > > 
> > > > Because that would give the wrong result. Depth can be 8, 12 or 16. The YUV 4:1:1
> > > > planar format is the one with depth 12. But for the purposes of the bytesperline
> > > > calculation only the depth of the largest plane counts, which is the luma plane
> > > > with a depth of 8. So for a width of 720 the value of bytesperline should be:
> > > > 
> > > > depth=8 -> bytesperline = 720
> > > > depth=12 -> bytesperline = 720
> > > 
> > > With depth=12, it should be, instead, 1080, as 2 pixels need 3 bytes.
> > 
> > No, it's not. It's a *planar* format: first the Y plane, then the two smaller
> > chroma planes. The spec says that bytesperline for planar formats refers to
> > the largest plane.
> > 
> > For this format the luma plane is one byte per pixel. Each of the two chroma
> > planes have effectively two bits per pixel (actually one byte per four pixels),
> > so you end up with 8+2+2=12 bits per pixel.
> > 
> > Hence bytesperline should be 720 for this particular format.
> 
> If I understood what you just said, you're talking that the only format marked
> as depth=12 is actually depth=8, right? Then the fix would be to change depth
> in the table, and not here.
> 
> Yet, I'm not sure if this is the proper fix.
> 
> The only used I saw on userspace apps for this field is to allocate size for
> the memory buffer. Some userspace applications use to get bytesperline and
> multiply by the image height and get the image size, instead of relying
> on sizeimage, as some drivers didn't use to fill sizeimage properly.
> 
> By using bytesperline equal to 1080 in this case warrants that the buffers
> on userspace will have enough space.

I did some research into planar formats in our drivers and (of course) it's a big
mess.

I looked at drivers that support V4L2_PIX_FMT_YUV422P, which is fairly common:

s5p-fimc:	follows the spec
arv:		follows the spec
vpif_capture:	follows the spec
vpif_display:	follows the spec
pxa_camera:	no idea, I can't figure this out
s3c-camif:	follows the spec
exynos-gsc:	uses depth
s2255:		uses depth
usbvision:	uses depth
saa7146:	uses depth
saa7134:	uses depth
bttv:		follows the spec

I think we should follow the spec here. In practice, nobody uses planar formats
for consumer-type hardware as it is a very awkward format, and libv4l doesn't
support it either. Since there is no clear common practice in our drivers, I'd
say we stick to the spec.

Regards,

	Hans
