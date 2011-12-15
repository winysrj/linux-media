Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1LOJVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:21:48 -0500
Message-ID: <4EE9BC25.7020303@infradead.org>
Date: Thu, 15 Dec 2011 07:21:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
	stable@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [patch -longterm] V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()
References: <20111215063445.GA2424@elgon.mountain>
In-Reply-To: <20111215063445.GA2424@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 04:34, Dan Carpenter wrote:
> On a 32bit system the multiplication here could overflow.  p->count is
> used in some of the V4L drivers.

ULONG_MAX / sizeof(v4l2_ext_control) is too much. This ioctl is used on things
like setting MPEG paramenters, where several parameters need adjustments at
the same time. I risk to say that 64 is probably a reasonably safe upper limit.

Btw, the upstream code also seems to have the same issue:

static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
                            void * __user *user_ptr, void ***kernel_ptr)
{
...
	if (ctrls->count != 0) {
...	
	*array_size = sizeof(struct v4l2_ext_control)
                                    * ctrls->count;
	ret = 1;
...
}
	
long
video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
               v4l2_kioctl func)
{
...
        err = check_array_args(cmd, parg, &array_size, &user_ptr, &kernel_ptr);
        if (err < 0)
                goto out;
        has_array_args = err;

        if (has_array_args) {
                mbuf = kmalloc(array_size, GFP_KERNEL);
...

so, if is there any overflow at check_array_args(), instead of returning
an error to userspace, it will allocate the array with less space than
needed. 

On both upstream and longterm, I think that it is more reasonable to 
state a limit for the maximum number of controls that can be passed at
the same time, and live with that.

A dummy check says:
$ more include/linux/videodev2.h |grep V4L2_CID|wc -l
    209

So, an upper limit of 256 is enough to allow userspace to change all existing controls
at the same time.

The proper way seems to add a define at include/linux/videodev2.h
and enforce it at the usercopy code.

Regards,
Mauro

> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is a patch against the 2.6.32-longterm kernel.  In the stock
> kernel, this code was totally rewritten and fixed in 2010 by d14e6d76ebf
> "[media] v4l: Add multi-planar ioctl handling code".
> 
> Hopefully, someone can Ack this and we merge it into the stable tree.
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 265bfb5..7196303 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -414,6 +414,9 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  		p->error_idx = p->count;
>  		user_ptr = (void __user *)p->controls;
>  		if (p->count) {
> +			err = -EINVAL;
> +			if (p->count > ULONG_MAX / sizeof(struct v4l2_ext_control))
> +				goto out_ext_ctrl;
>  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
>  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
>  			mbuf = kmalloc(ctrls_size, GFP_KERNEL);
> @@ -1912,6 +1915,9 @@ long video_ioctl2(struct file *file,
>  		p->error_idx = p->count;
>  		user_ptr = (void __user *)p->controls;
>  		if (p->count) {
> +			err = -EINVAL;
> +			if (p->count > ULONG_MAX / sizeof(struct v4l2_ext_control))
> +				goto out_ext_ctrl;
>  			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
>  			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
>  			mbuf = kmalloc(ctrls_size, GFP_KERNEL);

