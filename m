Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:33676 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZEYTWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 15:22:05 -0400
Date: Mon, 25 May 2009 12:22:06 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
cc: linux-media@vger.kernel.org, nm127@freemail.hu
Subject: Re: [RFC,PATCH] VIDIOC_G_EXT_CTRLS does not handle NULL pointer
 correctly
In-Reply-To: <200905251317.02633.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.58.0905251213500.32713@shell2.speakeasy.net>
References: <200905251317.02633.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 25 May 2009, Laurent Pinchart wrote:
> diff -r e0d881b21bc9 linux/drivers/media/video/v4l2-ioctl.c
> --- a/linux/drivers/media/video/v4l2-ioctl.c	Tue May 19 15:12:17 2009 +0200
> +++ b/linux/drivers/media/video/v4l2-ioctl.c	Sun May 24 18:26:29 2009 +0200
> @@ -402,6 +402,10 @@
>  		   a specific control that caused it. */
>  		p->error_idx = p->count;
>  		user_ptr = (void __user *)p->controls;
> +		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
> +			err = -ENOMEM;
> +			goto out_ext_ctrl;
> +		}
>  		if (p->count) {
>  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
>  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
> @@ -1859,6 +1863,10 @@
>  		   a specific control that caused it. */
>  		p->error_idx = p->count;
>  		user_ptr = (void __user *)p->controls;
> +		if (p->count > KMALLOC_MAX_SIZE / sizeof(p->controls[0])) {
> +			err = -ENOMEM;
> +			goto out_ext_ctrl;
> +		}
>  		if (p->count) {
>  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
>  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
>
> Restricting v4l2_ext_controls::count to values smaller than KMALLOC_MAX_SIZE /
> sizeof(struct v4l2_ext_control) should be enough, but we might want to
> restrict the value even further. I'd like opinions on this.

One thing that could be done is to call access_ok() on the range before
kmalloc'ing a buffer.  If p->count is too high, then it's possible that the
copy_from_user will fail because the process does not have the address
space to copy.
