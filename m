Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14179 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932441AbdLOQRi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 11:17:38 -0500
Date: Fri, 15 Dec 2017 18:17:04 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, kieran.bingham@ideasonboard.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 5/5] v4l2: async: Add debug output to v4l2-async module
Message-ID: <20171215161704.lnsaut4d2nxliaca@paasikivi.fi.intel.com>
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
 <1513189580-32202-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1513189580-32202-6-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Dec 13, 2017 at 07:26:20PM +0100, Jacopo Mondi wrote:
> The v4l2-async module operations are quite complex to follow, due to the
> asynchronous nature of subdevices and notifiers registration and
> matching procedures. In order to help with debugging of failed or
> erroneous matching between a subdevice and the notifier collected
> async_subdevice it gets matched against, introduce a few dev_dbg() calls
> in v4l2_async core operations.
> 
> Protect the debug operations with a Kconfig defined symbol, to make sure
> when debugging is disabled, no additional code or data is added to the
> module.
> 
> Notifiers are identified by the name of the subdevice or v4l2_dev they are
> registered by, while subdevice matching which now happens on endpoints,
> need a longer description built walking the fwnode graph backwards
> collecting parent nodes names (otherwise we would have had printouts
> like: "Matching "endpoint" with "endpoint"" which are not that useful).
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> ---
> For fwnodes backed by OF, I may have used the "%pOF" format modifier to
> get the full node name instead of parsing the fwnode graph by myself with
> "v4l2_async_fwnode_full_name()". Unfortunately I'm not aware of anything
> like "%pOF" for ACPI backed fwnodes. Also, walking the fwnode graph by
> myself allows me to reduce the depth, to reduce the debug messages output
> length which is anyway long enough to result disturbing on a 80columns
> terminal window.

ACPI doesn't have such at the moment. I think printing the full path would
still be better. There isn't that much more to print after all.

> ---
> 
>  drivers/media/v4l2-core/Kconfig      |  8 ++++
>  drivers/media/v4l2-core/v4l2-async.c | 81 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 89 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index a35c336..8331736 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -17,6 +17,14 @@ config VIDEO_ADV_DEBUG
>  	  V4L devices.
>  	  In doubt, say N.
> 
> +config VIDEO_V4L2_ASYNC_DEBUG
> +	bool "Enable debug functionalities for V4L2 async module"
> +	depends on VIDEO_V4L2

I'm not sure I'd add a Kconfig option. This is adding a fairly simple
function only to the kernel.

> +	default n
> +	---help---
> +	  Say Y here to enable debug output in V4L2 async module.
> +	  In doubt, say N.
> +
>  config VIDEO_FIXED_MINOR_RANGES
>  	bool "Enable old-style fixed minor ranges on drivers/video devices"
>  	default n
> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
> index c13a781..307e1a5 100644
> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c
> @@ -8,6 +8,10 @@
>   * published by the Free Software Foundation.
>   */
> 
> +#if defined(CONFIG_VIDEO_V4L2_ASYNC_DEBUG)
> +#define DEBUG

Do you need this?

> +#endif
> +
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/i2c.h>
> @@ -25,6 +29,52 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
> 
> +#if defined(CONFIG_VIDEO_V4L2_ASYNC_DEBUG)
> +#define V4L2_ASYNC_FWNODE_NAME_LEN	512
> +
> +static void __v4l2_async_fwnode_full_name(char *name,
> +					  unsigned int len,
> +					  unsigned int max_depth,
> +					  struct fwnode_handle *fwnode)
> +{
> +	unsigned int buf_len = len < V4L2_ASYNC_FWNODE_NAME_LEN ?
> +			       len : V4L2_ASYNC_FWNODE_NAME_LEN;
> +	char __tmp[V4L2_ASYNC_FWNODE_NAME_LEN];

That's a bit too much to allocate from the stack I think.

> +	struct fwnode_handle *parent;
> +
> +	memset(name, 0, buf_len);
> +	buf_len -= snprintf(__tmp, buf_len, "%s", fwnode_get_name(fwnode));
> +
> +	parent = fwnode;
> +	while ((parent = fwnode_get_parent(parent)) && buf_len &&
> +		--max_depth) {
> +		buf_len -= snprintf(name, buf_len, "%s/%s",
> +				    fwnode_get_name(parent), __tmp);
> +		strcpy(__tmp, name);
> +	}
> +}
> +
> +static void v4l2_async_fwnode_full_name(char *name,
> +					unsigned int len,
> +					struct fwnode_handle *fwnode)
> +{
> +	/*
> +	 * Usually 4 as nesting level is sufficient to identify an
> +	 * endpoint firmware node uniquely.
> +	 */
> +	__v4l2_async_fwnode_full_name(name, len, 4, fwnode);
> +}
> +
> +#else /* CONFIG_VIDEO_V4L2_ASYNC_DEBUG */
> +#define V4L2_ASYNC_FWNODE_NAME_LEN	0
> +
> +static void v4l2_async_fwnode_full_name(char *name,
> +					unsigned int len,
> +					struct fwnode_handle *fwnode)
> +{
> +}
> +#endif /* CONFIG_VIDEO_V4L2_ASYNC_DEBUG */
> +
>  static struct device *v4l2_async_notifier_dev(
>  					struct v4l2_async_notifier *notifier)
>  {
> @@ -54,9 +104,12 @@ static void v4l2_async_notifier_call_unbind(struct v4l2_async_notifier *n,
> 
>  static int v4l2_async_notifier_call_complete(struct v4l2_async_notifier *n)
>  {
> +	struct device *dev = v4l2_async_notifier_dev(n);
>  	if (!n->ops || !n->ops->complete)
>  		return 0;
> 
> +	dev_dbg(dev, "Complete notifier \"%s\"\n", fwnode_get_name(n->owner));
> +
>  	return n->ops->complete(n);
>  }
> 
> @@ -100,8 +153,17 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  	struct v4l2_async_notifier *notifier, struct v4l2_subdev *sd)
>  {
>  	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
> +	struct device *dev = v4l2_async_notifier_dev(notifier);
> +	char asd_full_name[V4L2_ASYNC_FWNODE_NAME_LEN];
> +	char sd_full_name[V4L2_ASYNC_FWNODE_NAME_LEN];
>  	struct v4l2_async_subdev *asd;
> 
> +	v4l2_async_fwnode_full_name(sd_full_name, V4L2_ASYNC_FWNODE_NAME_LEN,
> +				    sd->fwnode);
> +
> +	dev_dbg(dev, "Match notifier \"%s\" with subdevice \"%s\"\n",
> +		fwnode_get_name(notifier->owner), sd_full_name);
> +
>  	list_for_each_entry(asd, &notifier->waiting, list) {
>  		/* bus_type has been verified valid before */
>  		switch (asd->match_type) {
> @@ -115,6 +177,11 @@ static struct v4l2_async_subdev *v4l2_async_find_match(
>  			match = match_i2c;
>  			break;
>  		case V4L2_ASYNC_MATCH_FWNODE:
> +			v4l2_async_fwnode_full_name(asd_full_name,
> +						    V4L2_ASYNC_FWNODE_NAME_LEN,
> +						    asd->match.fwnode.fwnode);
> +			dev_dbg(dev, "Test sd \"%s\" with async_sd \"%s\"\n",
> +				sd_full_name, asd_full_name);
>  			match = match_fwnode;
>  			break;
>  		default:
> @@ -198,9 +265,16 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_subdev *sd,
>  				   struct v4l2_async_subdev *asd)
>  {
> +	struct device *dev = v4l2_async_notifier_dev(notifier);
>  	struct v4l2_async_notifier *subdev_notifier;
> +	char sd_full_name[V4L2_ASYNC_FWNODE_NAME_LEN];
>  	int ret;
> 
> +	v4l2_async_fwnode_full_name(sd_full_name, V4L2_ASYNC_FWNODE_NAME_LEN,
> +				    sd->fwnode);
> +	dev_dbg(dev, "Matched sd: \"%s\" with notifier \"%s\"\n",
> +		sd_full_name, fwnode_get_name(notifier->owner));
> +
>  	ret = v4l2_device_register_subdev(v4l2_dev, sd);
>  	if (ret < 0)
>  		return ret;
> @@ -240,6 +314,7 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
>  static int v4l2_async_notifier_try_all_subdevs(
>  	struct v4l2_async_notifier *notifier)
>  {
> +	struct device *dev = v4l2_async_notifier_dev(notifier);
>  	struct v4l2_device *v4l2_dev =
>  		v4l2_async_notifier_find_v4l2_dev(notifier);
>  	struct v4l2_subdev *sd;
> @@ -247,6 +322,9 @@ static int v4l2_async_notifier_try_all_subdevs(
>  	if (!v4l2_dev)
>  		return 0;
> 
> +	dev_dbg(dev, "Testing notifier \"%s\" against all subdevices\n",
> +		fwnode_get_name(notifier->owner));
> +
>  again:
>  	list_for_each_entry(sd, &subdev_list, async_list) {
>  		struct v4l2_async_subdev *asd;
> @@ -378,6 +456,9 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
> 
>  	notifier->owner = dev_fwnode(dev);
> 
> +	dev_dbg(dev, "Registering notifier \"%s\"\n",
> +		fwnode_get_name(notifier->owner));
> +
>  	mutex_lock(&list_lock);
> 
>  	for (i = 0; i < notifier->num_subdevs; i++) {
> --
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
