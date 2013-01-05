Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574Ab3AEPhj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 10:37:39 -0500
Date: Sat, 5 Jan 2013 13:36:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/15] em28xx: fix broken TRY_FMT.
Message-ID: <20130105133647.021d4d80@redhat.com>
In-Reply-To: <201301051434.04835.hverkuil@xs4all.nl>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
	<1357333186-8466-11-git-send-email-dheitmueller@kernellabs.com>
	<20130105005444.361b2604@redhat.com>
	<201301051434.04835.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 5 Jan 2013 14:34:04 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Sat January 5 2013 03:54:44 Mauro Carvalho Chehab wrote:
> > Hans/Devin,
> > 
> > Em Fri,  4 Jan 2013 15:59:40 -0500
> > Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:
> > 
> > > TRY_FMT should not return an error if a pixelformat is unsupported. Instead just
> > > pick a common pixelformat.
> > > 
> > > Also the bytesperline calculation was incorrect: it used the old width instead of
> > > the provided with, and it miscalculated the bytesperline value for the depth == 12
> > > case.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> > > ---
> > >  drivers/media/usb/em28xx/em28xx-video.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > > index a91a248..7c09b55 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > > @@ -821,7 +821,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > >  	if (!fmt) {
> > >  		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
> > >  				f->fmt.pix.pixelformat);
> > > -		return -EINVAL;
> > > +		fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
> > 
> > This change has the potential of causing userspace regressions, so,
> > for now, I won't apply such change.
> 
> Good!
> 
> > We need to discuss it better, before risk breaking things, and likely fix
> > applications first.
> 
> Absolutely. I also want to change this test in v4l2-compliance from 'failure'
> to 'warning' for the time being.

Sounds reasonable for me.

Regards,
Mauro
