Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46799 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755045AbcHVMxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 08:53:50 -0400
Subject: Re: [PATCH v4 1/5] media: Determine early whether an IOCTL is
 supported
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1470947358-31168-1-git-send-email-sakari.ailus@linux.intel.com>
 <1470947358-31168-2-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9e27cb51-c37e-3751-a849-36299c8a334d@xs4all.nl>
Date: Mon, 22 Aug 2016 14:53:45 +0200
MIME-Version: 1.0
In-Reply-To: <1470947358-31168-2-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2016 10:29 PM, Sakari Ailus wrote:
> Preparation for refactoring media IOCTL handling to unify common parts.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

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
>  
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
> 
