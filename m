Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:56940 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaGZDdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 23:33:43 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A00L2FV86TE10@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 23:33:42 -0400 (EDT)
Date: Sat, 26 Jul 2014 00:33:38 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L2: fix VIDIOC_CREATE_BUFS 32-bit compatibility mode
 data copy-back
Message-id: <20140726003338.7ff2835d.m.chehab@samsung.com>
In-reply-to: <1502861.x1mpGJtZG6@avalon>
References: <Pine.LNX.4.64.1405310125260.17582@axis700.grange>
 <1502861.x1mpGJtZG6@avalon>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 31 May 2014 01:36:16 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Saturday 31 May 2014 01:26:38 Guennadi Liakhovetski wrote:
> > Similar to an earlier patch,
> 
> Could you please mention the commit ID in the commit message ?
> 
> > fixing reading user-space data for the
> > VIDIOC_CREATE_BUFS ioctl() in 32-bit compatibility mode, this patch fixes
> > writing back of the possibly modified struct to the user. However, unlike
> > the former bug, this one is much less harmful, because it only results in
> > the kernel failing to write the .type field back to the user, but in fact
> > this is likely unneeded, because the kernel will hardly want to change
> > that field. Therefore this bug is more of a theoretical nature.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > ---
> > 
> > Not tested yet, I'll (try not to forget to) test it next week.

What's the status of this patch? The above message is scary...

Was it tested already?

Regards,
Mauro


> > 
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 7e2411c..c86a7e8
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -222,6 +222,9 @@ static int get_v4l2_create32(struct v4l2_create_buffers
> > *kp, struct v4l2_create_
> > 
> >  static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> > __user *up) {
> > +	if (put_user(kp->type, &up->type))
> > +		return -EFAULT;
> > +
> >  	switch (kp->type) {
> >  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> > @@ -248,8 +251,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp,
> > struct v4l2_format32 __us
> > 
> >  static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> > __user *up) {
> > -	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> > -		put_user(kp->type, &up->type))
> > +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)))
> >  		return -EFAULT;
> >  	return __put_v4l2_format32(kp, up);
> >  }
> > @@ -257,8 +259,8 @@ static int put_v4l2_format32(struct v4l2_format *kp,
> > struct v4l2_format32 __user static int put_v4l2_create32(struct
> > v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up) {
> >  	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
> > -	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32,
> > format.fmt)))
> > -			return -EFAULT;
> > +	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format)))
> > +		return -EFAULT;
> >  	return __put_v4l2_format32(&kp->format, &up->format);
> >  }
> 
