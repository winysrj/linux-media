Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2FRJqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 05:46:53 -0400
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
Subject: Re: [RFCv1 PATCH 18/32] v4l2-ioctl.c: finalize table conversion.
Date: Mon, 18 Jun 2012 11:46:57 +0200
Message-ID: <10390224.oHYD7VJvJs@avalon>
In-Reply-To: <a6aa2dd1a2275addc83150d41f131a74c7f9b977.1339321562.git.hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <a6aa2dd1a2275addc83150d41f131a74c7f9b977.1339321562.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 10 June 2012 12:25:40 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   35 +++++++++++++----------------------
> 1 file changed, 13 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index 0de31c4..6c91674 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -870,6 +870,11 @@ static void v4l_print_newline(const void *arg)
>  	pr_cont("\n");
>  }
> 
> +static void v4l_print_default(const void *arg)
> +{
> +	pr_cont("non-standard ioctl\n");

I'd say "driver-specific ioctl" instead. "non-standard" may sound like an 
error to users.

> +}
> +
>  static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>  {
>  	__u32 i;
> @@ -1853,12 +1858,6 @@ struct v4l2_ioctl_info {
>  	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
>  #define INFO_FL_CLEAR_MASK (_IOC_SIZEMASK << 16)
> 
> -#define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
> -	.ioctl = _ioctl,					\
> -	.flags = _flags,					\
> -	.name = #_ioctl,					\
> -}
> -
>  #define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
>  	[_IOC_NR(_ioctl)] = {						\
>  		.ioctl = _ioctl,					\
> @@ -2042,12 +2041,12 @@ static long __video_do_ioctl(struct file *file,
>  	} else {
>  		default_info.ioctl = cmd;
>  		default_info.flags = 0;
> -		default_info.debug = NULL;
> +		default_info.debug = v4l_print_default;
>  		info = &default_info;
>  	}
> 
>  	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> -	if (info->debug && write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> +	if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
>  		v4l_print_ioctl(vfd->name, cmd);
>  		pr_cont(": ");
>  		info->debug(arg);
> @@ -2058,22 +2057,16 @@ static long __video_do_ioctl(struct file *file,
>  		const vidioc_op *vidioc = p + info->offset;
> 
>  		ret = (*vidioc)(file, fh, arg);
> -		goto error;
>  	} else if (info->flags & INFO_FL_FUNC) {
>  		ret = info->func(ops, file, fh, arg);
> -		goto error;
> +	} else if (!ops->vidioc_default) {
> +		ret = -ENOTTY;
> +	} else {
> +		ret = ops->vidioc_default(file, fh,
> +			use_fh_prio ? v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
> +			cmd, arg);
>  	}
> 
> -	switch (cmd) {
> -	default:
> -		if (!ops->vidioc_default)
> -			break;
> -		ret = ops->vidioc_default(file, fh, use_fh_prio ?
> -				v4l2_prio_check(vfd->prio, vfh->prio) >= 0 : 0,
> -				cmd, arg);
> -		break;
> -	} /* switch */
> -
>  error:
>  	if (vfd->debug) {
>  		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> @@ -2087,8 +2080,6 @@ error:
>  			pr_cont(": error %ld\n", ret);
>  		else if (vfd->debug == V4L2_DEBUG_IOCTL)
>  			pr_cont("\n");
> -		else if (!info->debug)
> -			return ret;
>  		else if (_IOC_DIR(cmd) == _IOC_NONE)
>  			info->debug(arg);
>  		else {
-- 
Regards,

Laurent Pinchart

