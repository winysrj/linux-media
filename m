Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39118
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932821AbcIFJ4l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 05:56:41 -0400
Date: Tue, 6 Sep 2016 06:56:17 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4 1/5] media: Determine early whether an IOCTL is
 supported
Message-ID: <20160906065617.1295d104@vento.lan>
In-Reply-To: <1470947358-31168-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
        <1470947358-31168-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 11 Aug 2016 23:29:14 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Preparation for refactoring media IOCTL handling to unify common parts.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 54 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 1795abe..aedd64e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -419,13 +419,41 @@ static long media_device_get_topology(struct media_device *mdev,
>  	return 0;
>  }
>  
> -static long media_device_ioctl(struct file *filp, unsigned int cmd,
> -			       unsigned long arg)
> +#define MEDIA_IOC(__cmd) \
> +	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
> +
> +/* the table is indexed by _IOC_NR(cmd) */
> +struct media_ioctl_info {
> +	unsigned int cmd;
> +};
> +
> +static const struct media_ioctl_info ioctl_info[] = {
> +	MEDIA_IOC(DEVICE_INFO),
> +	MEDIA_IOC(ENUM_ENTITIES),
> +	MEDIA_IOC(ENUM_LINKS),
> +	MEDIA_IOC(SETUP_LINK),
> +	MEDIA_IOC(G_TOPOLOGY),
> +};
> +
> +static inline long is_valid_ioctl(const struct media_ioctl_info *info,
> +				  unsigned int cmd)
> +{
> +	return (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
> +		|| info[_IOC_NR(cmd)].cmd != cmd) ? -ENOIOCTLCMD : 0;
> +}
> +
> +static long __media_device_ioctl(
> +	struct file *filp, unsigned int cmd, void __user *arg,
> +	const struct media_ioctl_info *info_array)
>  {
>  	struct media_devnode *devnode = media_devnode_data(filp);
>  	struct media_device *dev = devnode->media_dev;
>  	long ret;
>  
> +	ret = is_valid_ioctl(info_array, cmd);
> +	if (ret)
> +		return ret;
> +
>  	mutex_lock(&dev->graph_mutex);
>  	switch (cmd) {
>  	case MEDIA_IOC_DEVICE_INFO:
> @@ -461,6 +489,13 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  	return ret;
>  }
>  
> +static long media_device_ioctl(struct file *filp, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	return __media_device_ioctl(
> +		filp, cmd, (void __user *)arg, ioctl_info);
> +}
> +
>  #ifdef CONFIG_COMPAT
>  
>  struct media_links_enum32 {
> @@ -491,6 +526,14 @@ static long media_device_enum_links32(struct media_device *mdev,
>  
>  #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)


Hmm...

> +static const struct media_ioctl_info compat_ioctl_info[] = {
> +	MEDIA_IOC(DEVICE_INFO),
> +	MEDIA_IOC(ENUM_ENTITIES),
> +	MEDIA_IOC(ENUM_LINKS32),
> +	MEDIA_IOC(SETUP_LINK),
> +	MEDIA_IOC(G_TOPOLOGY),
> +};
> +
>  static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
>  				      unsigned long arg)
>  {
> @@ -498,6 +541,13 @@ static long media_device_compat_ioctl(struct file *filp, unsigned int cmd,
>  	struct media_device *dev = devnode->media_dev;
>  	long ret;
>  
> +	/*
> +	 * The number of supported IOCTLs is the same for both regular and
> +	 * compat cases. Instead of passing the sizes around, ensure that
> +	 * they match.
> +	 */
> +	BUILD_BUG_ON(ARRAY_SIZE(ioctl_info) != ARRAY_SIZE(compat_ioctl_info));
> +
>  	switch (cmd) {
>  	case MEDIA_IOC_ENUM_LINKS32:
>  		mutex_lock(&dev->graph_mutex);


Why do we need the above? The only ioctl that it is handled inside
the compat logic is MEDIA_IOC_ENUM_LINKS. all the others fall back
to the usual handler, and we don't intend to add any other new
special case, as we're now using a different logic to handle 32 bit
pointers passed to a 64 bit Kernel that it is compatible with both 32
and 64 bits.

So, we don't expect to have the V4L2 compat32 mess here, but, instead,
to keep this untouched as we add more ioctl's.

Regards,
Mauro
