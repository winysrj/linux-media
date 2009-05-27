Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53903 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZE0PWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 11:22:41 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer correctly
Date: Wed, 27 May 2009 17:27:01 +0200
Cc: linux-media@vger.kernel.org, nm127@freemail.hu
References: <200905251317.02633.laurent.pinchart@skynet.be> <Pine.LNX.4.58.0905251213500.32713@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0905251213500.32713@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271727.01409.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 25 May 2009 21:22:06 Trent Piepho wrote:
> On Mon, 25 May 2009, Laurent Pinchart wrote:
> > diff -r e0d881b21bc9 linux/drivers/media/video/v4l2-ioctl.c
> > --- a/linux/drivers/media/video/v4l2-ioctl.c	Tue May 19 15:12:17 2009
> > +0200 +++ b/linux/drivers/media/video/v4l2-ioctl.c	Sun May 24 18:26:29
> > 2009 +0200 @@ -402,6 +402,10 @@
> >  		   a specific control that caused it. */
> >  		p->error_idx = p->count;
> >  		user_ptr = (void __user *)p->controls;
> > +		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
> > +			err = -ENOMEM;
> > +			goto out_ext_ctrl;
> > +		}
> >  		if (p->count) {
> >  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
> >  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
> > @@ -1859,6 +1863,10 @@
> >  		   a specific control that caused it. */
> >  		p->error_idx = p->count;
> >  		user_ptr = (void __user *)p->controls;
> > +		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
> > +			err = -ENOMEM;
> > +			goto out_ext_ctrl;
> > +		}
> >  		if (p->count) {
> >  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
> >  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
> >
> > Restricting v4l2_ext_controls::count to values smaller than
> > KMALLOC_MAX_SIZE / sizeof(struct v4l2_ext_control) should be enough, but
> > we might want to restrict the value even further. I'd like opinions on
> > this.
>
> One thing that could be done is to call access_ok() on the range before
> kmalloc'ing a buffer.  If p->count is too high, then it's possible that the
> copy_from_user will fail because the process does not have the address
> space to copy.

arch/x86/include/asm/uaccess.h, about access_ok():

 * Note that, depending on architecture, this function probably just
 * checks that the pointer is in the user space range - after calling
 * this function, memory access functions may still return -EFAULT.

I don't think it's worth it. Let's just kmalloc (or kzalloc) and 
copy_from_user. If one of them fails we'll return an error.

Could a very large number of control requests be used as a DoS attack vector ? 
A userspace application could kmalloc large amounts of memory without any 
restriction. Memory would be reclaimed eventually, but after performing a 
large number of USB requests, which could take quite a long time.

Best regards,

Laurent Pinchart

