Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4396 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2FRLZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:25:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv1 PATCH 04/32] v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.
Date: Mon, 18 Jun 2012 13:25:32 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <04d048ef96f333b1dfd644ee8861d81080123e01.1339321562.git.hans.verkuil@cisco.com> <6945599.iYfJgtEiGu@avalon>
In-Reply-To: <6945599.iYfJgtEiGu@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206181325.32282.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 11:47:07 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Sunday 10 June 2012 12:25:26 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add the necessary plumbing to make it possible to replace the switch by a
> > table driven implementation.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/v4l2-ioctl.c |   91
> > ++++++++++++++++++++++++++++++++------ 1 file changed, 78 insertions(+), 13
> > deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> > b/drivers/media/video/v4l2-ioctl.c index a9602db..a4115ce 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -563,23 +595,40 @@ static long __video_do_ioctl(struct file *file,
> >  	}
> > 
> >  	if (v4l2_is_known_ioctl(cmd)) {
> > -		struct v4l2_ioctl_info *info = &v4l2_ioctls[_IOC_NR(cmd)];
> > +		info = &v4l2_ioctls[_IOC_NR(cmd)];
> > 
> >  	        if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls) &&
> >  		    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
> > -			return -ENOTTY;
> > +			goto error;
> > 
> >  		if (use_fh_prio && (info->flags & INFO_FL_PRIO)) {
> >  			ret = v4l2_prio_check(vfd->prio, vfh->prio);
> >  			if (ret)
> > -				return ret;
> > +				goto error;
> >  		}
> > +	} else {
> > +		default_info.ioctl = cmd;
> > +		default_info.flags = 0;
> > +		default_info.debug = NULL;
> > +		info = &default_info;
> >  	}
> > 
> > -	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
> > -				!(vfd->debug & V4L2_DEBUG_IOCTL_ARG)) {
> > +	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> > +	if (info->debug && write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> >  		v4l_print_ioctl(vfd->name, cmd);
> > -		printk(KERN_CONT "\n");
> > +		pr_cont(": ");
> > +		info->debug(arg);
> > +	}
> 
> Shouldn't you print the ioctl name and information even if info->debug is NULL 
> ?

The 'info->debug' test is temporary. Once the conversion is finished this test
will be removed since then info->debug will never be NULL.

> 
> > +	if (info->flags & INFO_FL_STD) {
> > +		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
> > +		const void *p = vfd->ioctl_ops;
> > +		const vidioc_op *vidioc = p + info->offset;
> > +
> > +		ret = (*vidioc)(file, fh, arg);
> > +		goto error;
> > +	} else if (info->flags & INFO_FL_FUNC) {
> > +		ret = info->func(ops, file, fh, arg);
> > +		goto error;
> >  	}
> > 
> >  	switch (cmd) {
> > @@ -2100,10 +2149,26 @@ static long __video_do_ioctl(struct file *file,
> >  		break;
> >  	} /* switch */
> > 
> > -	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
> > -		if (ret < 0) {
> > -			v4l_print_ioctl(vfd->name, cmd);
> > -			printk(KERN_CONT " error %ld\n", ret);
> > +error:
> 
> This isn't an error, is it ? I'd call it done instead.

True, I'll change this.

> 
> > +	if (vfd->debug) {
> > +		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> 
> vfd->debug is a bitmask (or at least is documented as being a bitmask in 
> include/media/v4l2-ioctl.h).

Yeah, and that makes no sense. Having V4L2_DEBUG_IOCTL_ARG without
V4L2_DEBUG_IOCTL is undefined. It is much more logical to have 0 for no
debugging, 1 for just ioctl name debugging and >= 2 for extensive debugging.
It's just weird to have to set the debug sysfs entry to 0, 1 or 3.

In a later patch I want to change the few drivers that use this accordingly.

> 
> > +			if (ret)
> 
> Shouldn't you test for < 0 instead ? Driver-specific ioctls might return a > 0 
> value in case of success.

Good catch. Yes, I need to do that.

> 
> > +				pr_info("%s: error %ld\n",
> > +					video_device_node_name(vfd), ret);
> > +			return ret;
> > +		}
> > +		v4l_print_ioctl(vfd->name, cmd);
> > +		if (ret)
> > +			pr_cont(": error %ld\n", ret);
> > +		else if (vfd->debug == V4L2_DEBUG_IOCTL)
> > +			pr_cont("\n");
> > +		else if (!info->debug)
> > +			return ret;
> > +		else if (_IOC_DIR(cmd) == _IOC_NONE)
> > +			info->debug(arg);
> > +		else {
> > +			pr_cont(": ");
> > +			info->debug(arg);
> >  		}
> 
> Ouch. What are you trying to do here ? Can't we simplify debug messages ?

It's simplified a bit in a later patch when the temporary info->debug test
can be dropped.

Regards,

	Hans
