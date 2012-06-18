Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53271 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2FRJq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 05:46:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 04/32] v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.
Date: Mon, 18 Jun 2012 11:47:07 +0200
Message-ID: <6945599.iYfJgtEiGu@avalon>
In-Reply-To: <04d048ef96f333b1dfd644ee8861d81080123e01.1339321562.git.hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <04d048ef96f333b1dfd644ee8861d81080123e01.1339321562.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 10 June 2012 12:25:26 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add the necessary plumbing to make it possible to replace the switch by a
> table driven implementation.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   91
> ++++++++++++++++++++++++++++++++------ 1 file changed, 78 insertions(+), 13
> deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index a9602db..a4115ce 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -396,12 +396,22 @@ struct v4l2_ioctl_info {
>  	unsigned int ioctl;
>  	u32 flags;
>  	const char * const name;
> +	union {
> +		u32 offset;
> +		int (*func)(const struct v4l2_ioctl_ops *ops,
> +				struct file *file, void *fh, void *p);
> +	};
> +	void (*debug)(const void *arg);
>  };
> 
>  /* This control needs a priority check */
>  #define INFO_FL_PRIO	(1 << 0)
>  /* This control can be valid if the filehandle passes a control handler. */
> #define INFO_FL_CTRL	(1 << 1)
> +/* This is a standard ioctl, no need for special code */
> +#define INFO_FL_STD	(1 << 2)
> +/* This is ioctl has its own function */
> +#define INFO_FL_FUNC	(1 << 3)
>  /* Zero struct from after the field to the end */
>  #define INFO_FL_CLEAR(v4l2_struct, field)			\
>  	((offsetof(struct v4l2_struct, field) +			\
> @@ -414,6 +424,24 @@ struct v4l2_ioctl_info {
>  	.name = #_ioctl,					\
>  }
> 
> +#define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
> +	[_IOC_NR(_ioctl)] = {						\
> +		.ioctl = _ioctl,					\
> +		.flags = _flags | INFO_FL_STD,				\
> +		.name = #_ioctl,					\
> +		.offset = offsetof(struct v4l2_ioctl_ops, _vidioc),	\
> +		.debug = _debug,					\
> +	}
> +
> +#define IOCTL_INFO_FNC(_ioctl, _func, _debug, _flags)			\
> +	[_IOC_NR(_ioctl)] = {						\
> +		.ioctl = _ioctl,					\
> +		.flags = _flags | INFO_FL_FUNC,				\
> +		.name = #_ioctl,					\
> +		.func = _func,						\
> +		.debug = _debug,					\
> +	}
> +
>  static struct v4l2_ioctl_info v4l2_ioctls[] = {
>  	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
>  	IOCTL_INFO(VIDIOC_ENUM_FMT, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
> @@ -512,7 +540,7 @@ bool v4l2_is_known_ioctl(unsigned int cmd)
>     external ioctl messages as well as internal V4L ioctl */
>  void v4l_printk_ioctl(unsigned int cmd)
>  {
> -	char *dir, *type;
> +	const char *dir, *type;
> 
>  	switch (_IOC_TYPE(cmd)) {
>  	case 'd':
> @@ -523,10 +551,11 @@ void v4l_printk_ioctl(unsigned int cmd)
>  			type = "v4l2";
>  			break;
>  		}
> -		printk("%s", v4l2_ioctls[_IOC_NR(cmd)].name);
> +		pr_cont("%s", v4l2_ioctls[_IOC_NR(cmd)].name);
>  		return;
>  	default:
>  		type = "unknown";
> +		break;
>  	}
> 
>  	switch (_IOC_DIR(cmd)) {
> @@ -536,7 +565,7 @@ void v4l_printk_ioctl(unsigned int cmd)
>  	case _IOC_READ | _IOC_WRITE: dir = "rw"; break;
>  	default:                     dir = "*ERR*"; break;
>  	}
> -	printk("%s ioctl '%c', dir=%s, #%d (0x%08x)",
> +	pr_cont("%s ioctl '%c', dir=%s, #%d (0x%08x)",
>  		type, _IOC_TYPE(cmd), dir, _IOC_NR(cmd), cmd);
>  }
>  EXPORT_SYMBOL(v4l_printk_ioctl);
> @@ -546,6 +575,9 @@ static long __video_do_ioctl(struct file *file,
>  {
>  	struct video_device *vfd = video_devdata(file);
>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
> +	bool write_only = false;
> +	struct v4l2_ioctl_info default_info;
> +	const struct v4l2_ioctl_info *info;
>  	void *fh = file->private_data;
>  	struct v4l2_fh *vfh = NULL;
>  	int use_fh_prio = 0;
> @@ -563,23 +595,40 @@ static long __video_do_ioctl(struct file *file,
>  	}
> 
>  	if (v4l2_is_known_ioctl(cmd)) {
> -		struct v4l2_ioctl_info *info = &v4l2_ioctls[_IOC_NR(cmd)];
> +		info = &v4l2_ioctls[_IOC_NR(cmd)];
> 
>  	        if (!test_bit(_IOC_NR(cmd), vfd->valid_ioctls) &&
>  		    !((info->flags & INFO_FL_CTRL) && vfh && vfh->ctrl_handler))
> -			return -ENOTTY;
> +			goto error;
> 
>  		if (use_fh_prio && (info->flags & INFO_FL_PRIO)) {
>  			ret = v4l2_prio_check(vfd->prio, vfh->prio);
>  			if (ret)
> -				return ret;
> +				goto error;
>  		}
> +	} else {
> +		default_info.ioctl = cmd;
> +		default_info.flags = 0;
> +		default_info.debug = NULL;
> +		info = &default_info;
>  	}
> 
> -	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
> -				!(vfd->debug & V4L2_DEBUG_IOCTL_ARG)) {
> +	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> +	if (info->debug && write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
>  		v4l_print_ioctl(vfd->name, cmd);
> -		printk(KERN_CONT "\n");
> +		pr_cont(": ");
> +		info->debug(arg);
> +	}

Shouldn't you print the ioctl name and information even if info->debug is NULL 
?

> +	if (info->flags & INFO_FL_STD) {
> +		typedef int (*vidioc_op)(struct file *file, void *fh, void *p);
> +		const void *p = vfd->ioctl_ops;
> +		const vidioc_op *vidioc = p + info->offset;
> +
> +		ret = (*vidioc)(file, fh, arg);
> +		goto error;
> +	} else if (info->flags & INFO_FL_FUNC) {
> +		ret = info->func(ops, file, fh, arg);
> +		goto error;
>  	}
> 
>  	switch (cmd) {
> @@ -2100,10 +2149,26 @@ static long __video_do_ioctl(struct file *file,
>  		break;
>  	} /* switch */
> 
> -	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
> -		if (ret < 0) {
> -			v4l_print_ioctl(vfd->name, cmd);
> -			printk(KERN_CONT " error %ld\n", ret);
> +error:

This isn't an error, is it ? I'd call it done instead.

> +	if (vfd->debug) {
> +		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {

vfd->debug is a bitmask (or at least is documented as being a bitmask in 
include/media/v4l2-ioctl.h).

> +			if (ret)

Shouldn't you test for < 0 instead ? Driver-specific ioctls might return a > 0 
value in case of success.

> +				pr_info("%s: error %ld\n",
> +					video_device_node_name(vfd), ret);
> +			return ret;
> +		}
> +		v4l_print_ioctl(vfd->name, cmd);
> +		if (ret)
> +			pr_cont(": error %ld\n", ret);
> +		else if (vfd->debug == V4L2_DEBUG_IOCTL)
> +			pr_cont("\n");
> +		else if (!info->debug)
> +			return ret;
> +		else if (_IOC_DIR(cmd) == _IOC_NONE)
> +			info->debug(arg);
> +		else {
> +			pr_cont(": ");
> +			info->debug(arg);
>  		}

Ouch. What are you trying to do here ? Can't we simplify debug messages ?

>  	}

-- 
Regards,

Laurent Pinchart

