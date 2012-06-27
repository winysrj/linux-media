Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42800 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0Jyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 05:54:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 19/34] v4l2-dev.c: add debug sysfs entry.
Date: Wed, 27 Jun 2012 11:54:40 +0200
Message-ID: <2029394.km7RaaeAMe@avalon>
In-Reply-To: <a497cef0c59c8872218faa5d83095fe03c01a430.1340366355.git.hans.verkuil@cisco.com>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <a497cef0c59c8872218faa5d83095fe03c01a430.1340366355.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 22 June 2012 14:21:13 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Since this could theoretically change the debug value while in the middle
> of v4l2-ioctl.c, we make a copy of vfd->debug to ensure consistent debug
> behavior.

In my review of RFCv1, I wrote that this could introduce a race condition:

"You test the debug value several times in the __video_do_ioctl() function. I 
haven't checked in details whether changing the value between the two tests 
could for instance lead to a KERN_CONT print without a previous non-KERN_CONT 
message. That won't crash the machine  but it should still be avoided."

Have you verified whether that problem can occur ?

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-dev.c   |   24 ++++++++++++++++++++++++
>  drivers/media/video/v4l2-ioctl.c |    9 +++++----
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 1500208..5c0bb18 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -46,6 +46,29 @@ static ssize_t show_index(struct device *cd,
>  	return sprintf(buf, "%i\n", vdev->index);
>  }
> 
> +static ssize_t show_debug(struct device *cd,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	struct video_device *vdev = to_video_device(cd);
> +
> +	return sprintf(buf, "%i\n", vdev->debug);
> +}
> +
> +static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
> +		   const char *buf, size_t len)
> +{
> +	struct video_device *vdev = to_video_device(cd);
> +	int res = 0;
> +	u16 value;
> +
> +	res = kstrtou16(buf, 0, &value);
> +	if (res)
> +		return res;
> +
> +	vdev->debug = value;
> +	return len;
> +}
> +
>  static ssize_t show_name(struct device *cd,
>  			 struct device_attribute *attr, char *buf)
>  {
> @@ -56,6 +79,7 @@ static ssize_t show_name(struct device *cd,
> 
>  static struct device_attribute video_device_attrs[] = {
>  	__ATTR(name, S_IRUGO, show_name, NULL),
> +	__ATTR(debug, 0644, show_debug, set_debug),
>  	__ATTR(index, S_IRUGO, show_index, NULL),
>  	__ATTR_NULL
>  };
> diff --git a/drivers/media/video/v4l2-ioctl.c
> b/drivers/media/video/v4l2-ioctl.c index 0531d9a..2e1421b 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1998,6 +1998,7 @@ static long __video_do_ioctl(struct file *file,
>  	void *fh = file->private_data;
>  	struct v4l2_fh *vfh = NULL;
>  	int use_fh_prio = 0;
> +	int debug = vfd->debug;
>  	long ret = -ENOTTY;
> 
>  	if (ops == NULL) {
> @@ -2031,7 +2032,7 @@ static long __video_do_ioctl(struct file *file,
>  	}
> 
>  	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
> -	if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> +	if (write_only && debug > V4L2_DEBUG_IOCTL) {
>  		v4l_print_ioctl(vfd->name, cmd);
>  		pr_cont(": ");
>  		info->debug(arg, write_only);
> @@ -2053,8 +2054,8 @@ static long __video_do_ioctl(struct file *file,
>  	}
> 
>  done:
> -	if (vfd->debug) {
> -		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
> +	if (debug) {
> +		if (write_only && debug > V4L2_DEBUG_IOCTL) {
>  			if (ret < 0)
>  				printk(KERN_DEBUG "%s: error %ld\n",
>  					video_device_node_name(vfd), ret);
> @@ -2063,7 +2064,7 @@ done:
>  		v4l_print_ioctl(vfd->name, cmd);
>  		if (ret < 0)
>  			pr_cont(": error %ld\n", ret);
> -		else if (vfd->debug == V4L2_DEBUG_IOCTL)
> +		else if (debug == V4L2_DEBUG_IOCTL)
>  			pr_cont("\n");
>  		else if (_IOC_DIR(cmd) == _IOC_NONE)
>  			info->debug(arg, write_only);
-- 
Regards,

Laurent Pinchart

