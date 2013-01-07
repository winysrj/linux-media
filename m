Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47733 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3AGVRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 16:17:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/6] media: soc-camera: split struct soc_camera_link into host and subdevice parts
Date: Mon, 07 Jan 2013 22:18:52 +0100
Message-ID: <2516620.yLmXLDLnye@avalon>
In-Reply-To: <Pine.LNX.4.64.1301031710470.17494@axis700.grange>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de> <1356543358-6180-5-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1301031710470.17494@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Thursday 03 January 2013 17:13:15 Guennadi Liakhovetski wrote:
> struct soc_camera_link currently contains fields, used both by sensor and
> bridge drivers. To make subdevice driver re-use simpler, split it into a
> host and a subdevice parts.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2: following an off-list discussion with Laurent, .add_device() and
> .del_device() callbacks are moved over from the subdevice part of the
> platform data to the host part.
> 
>  drivers/media/i2c/soc_camera/imx074.c              |   14 ++--
>  drivers/media/i2c/soc_camera/mt9m001.c             |   38 ++++----
>  drivers/media/i2c/soc_camera/mt9m111.c             |   21 ++--
>  drivers/media/i2c/soc_camera/mt9t031.c             |   22 ++--
>  drivers/media/i2c/soc_camera/mt9t112.c             |   18 ++--
>  drivers/media/i2c/soc_camera/mt9v022.c             |   36 ++++----
>  drivers/media/i2c/soc_camera/ov2640.c              |   12 +-
>  drivers/media/i2c/soc_camera/ov5642.c              |   16 ++--
>  drivers/media/i2c/soc_camera/ov6650.c              |   16 ++--
>  drivers/media/i2c/soc_camera/ov772x.c              |   14 ++--
>  drivers/media/i2c/soc_camera/ov9640.c              |   12 +-
>  drivers/media/i2c/soc_camera/ov9740.c              |   14 ++--
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   24 +++---
>  drivers/media/i2c/soc_camera/tw9910.c              |   18 ++--
>  drivers/media/platform/soc_camera/soc_camera.c     |   98 +++++++++--------
>  .../platform/soc_camera/soc_camera_platform.c      |    2 +-
>  include/media/soc_camera.h                         |  102 +++++++++++++----
>  include/media/soc_camera_platform.h                |   10 ++-
>  18 files changed, 279 insertions(+), 208 deletions(-)

[snip]

> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> b/drivers/media/platform/soc_camera/soc_camera.c index 04ce718..8ec9805
> 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -50,22 +50,22 @@ static LIST_HEAD(hosts);
>  static LIST_HEAD(devices);
>  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> 
> -int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
> +int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc
> *ssdd) {
> -	int ret = regulator_bulk_enable(icl->num_regulators,
> -					icl->regulators);
> +	int ret = regulator_bulk_enable(ssdd->num_regulators,
> +					ssdd->regulators);
>  	if (ret < 0) {
>  		dev_err(dev, "Cannot enable regulators\n");
>  		return ret;
>  	}
> 
> -	if (icl->power) {
> -		ret = icl->power(dev, 1);
> +	if (ssdd->power) {
> +		ret = ssdd->power(dev, 1);

While we're at it, do you plan to get rid of this callback ? What do the 
supported board need to perform there ?

>  		if (ret < 0) {
>  			dev_err(dev,
>  				"Platform failed to power-on the camera.\n");
> -			regulator_bulk_disable(icl->num_regulators,
> -					       icl->regulators);
> +			regulator_bulk_disable(ssdd->num_regulators,
> +					       ssdd->regulators);
>  		}
>  	}
> 

[snip]

> @@ -552,8 +552,8 @@ static int soc_camera_open(struct file *file)
>  		};
> 
>  		/* The camera could have been already on, try to reset */
> -		if (icl->reset)
> -			icl->reset(icd->pdev);
> +		if (sdesc->subdev_desc.reset)
> +			sdesc->subdev_desc.reset(icd->pdev);
> 
>  		ret = ici->ops->add(icd);
>  		if (ret < 0) {

Same question here, would a GPIO do ?

> @@ -1072,23 +1072,24 @@ static void scan_add_host(struct soc_camera_host
> *ici)
> 
>  #ifdef CONFIG_I2C_BOARDINFO
>  static int soc_camera_init_i2c(struct soc_camera_device *icd,
> -			       struct soc_camera_link *icl)
> +			       struct soc_camera_desc *sdesc)
>  {
>  	struct i2c_client *client;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct i2c_adapter *adap = i2c_get_adapter(icl->i2c_adapter_id);
> +	struct soc_camera_host_desc *shd = &sdesc->host_desc;
> +	struct i2c_adapter *adap = i2c_get_adapter(shd->i2c_adapter_id);
>  	struct v4l2_subdev *subdev;
> 
>  	if (!adap) {
>  		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
> -			icl->i2c_adapter_id);
> +			shd->i2c_adapter_id);
>  		goto ei2cga;
>  	}
> 
> -	icl->board_info->platform_data = icl;
> +	shd->board_info->platform_data = &sdesc->subdev_desc;

I'm looking forward to async registration here (yes, I know, I need to review 
your latest patches :-)).

>  	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
> -				icl->board_info, NULL);
> +				shd->board_info, NULL);
>  	if (!subdev)
>  		goto ei2cnd;
> 
> @@ -1116,7 +1117,7 @@ static void soc_camera_free_i2c(struct
> soc_camera_device *icd) i2c_put_adapter(adap);
>  }
>  #else
> -#define soc_camera_init_i2c(icd, icl)	(-ENODEV)
> +#define soc_camera_init_i2c(icd, sdesc)	(-ENODEV)
>  #define soc_camera_free_i2c(icd)	do {} while (0)
>  #endif
> 
> @@ -1126,7 +1127,9 @@ static int video_dev_create(struct soc_camera_device
> *icd); static int soc_camera_probe(struct soc_camera_device *icd)
>  {
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct soc_camera_link *icl = to_soc_camera_link(icd);
> +	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
> +	struct soc_camera_host_desc *shd = &sdesc->host_desc;
> +	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
>  	struct device *control = NULL;
>  	struct v4l2_subdev *sd;
>  	struct v4l2_mbus_framefmt mf;
> @@ -1146,8 +1149,8 @@ static int soc_camera_probe(struct soc_camera_device
> *icd) return ret;
> 
>  	/* The camera could have been already on, try to reset */
> -	if (icl->reset)
> -		icl->reset(icd->pdev);
> +	if (ssdd->reset)
> +		ssdd->reset(icd->pdev);

I don't think the core should access the reset method here directly (although 
it's obviously fine to keep it for now). This will hopefully be fixed by async 
registration.

>  	mutex_lock(&ici->host_lock);
>  	ret = ici->ops->add(icd);
> @@ -1161,18 +1164,18 @@ static int soc_camera_probe(struct soc_camera_device
> *icd) goto evdc;
> 
>  	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
> -	if (icl->board_info) {
> -		ret = soc_camera_init_i2c(icd, icl);
> +	if (shd->board_info) {
> +		ret = soc_camera_init_i2c(icd, sdesc);
>  		if (ret < 0)
>  			goto eadddev;
> -	} else if (!icl->add_device || !icl->del_device) {
> +	} else if (!shd->add_device || !shd->del_device) {

Once again I hope that async registration will remove the add_device and 
del_device methods.

>  		ret = -EINVAL;
>  		goto eadddev;
>  	} else {
> -		if (icl->module_name)
> -			ret = request_module(icl->module_name);
> +		if (shd->module_name)
> +			ret = request_module(shd->module_name);
> 
> -		ret = icl->add_device(icd);
> +		ret = shd->add_device(icd);
>  		if (ret < 0)
>  			goto eadddev;
> 

[snip]

> @@ -1534,24 +1537,25 @@ static int soc_camera_video_start(struct
> soc_camera_device *icd)
> 
>  static int soc_camera_pdrv_probe(struct platform_device *pdev)
>  {
> -	struct soc_camera_link *icl = pdev->dev.platform_data;
> +	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
> +	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
>  	struct soc_camera_device *icd;
>  	int ret;
> 
> -	if (!icl)
> +	if (!sdesc)
>  		return -EINVAL;
> 
>  	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
>  	if (!icd)
>  		return -ENOMEM;
> 
> -	ret = devm_regulator_bulk_get(&pdev->dev, icl->num_regulators,
> -				      icl->regulators);
> +	ret = devm_regulator_bulk_get(&pdev->dev, ssdd->num_regulators,
> +				      ssdd->regulators);

Do you plan to move this to the client drivers (or more accurately to a soc-
camera helper function called by client drivers at probe time) ?

>  	if (ret < 0)
>  		return ret;
> 
> -	icd->iface = icl->bus_id;
> -	icd->link = icl;
> +	icd->iface = sdesc->host_desc.bus_id;
> +	icd->sdesc = sdesc;
>  	icd->pdev = &pdev->dev;
>  	platform_set_drvdata(pdev, icd);
> 

[snip]

> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 5a662c9..2cc70cf 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -23,11 +23,11 @@
>  #include <media/v4l2-device.h>
> 
>  struct file;
> -struct soc_camera_link;
> +struct soc_camera_desc;
> 
>  struct soc_camera_device {
>  	struct list_head list;		/* list of all registered devices */
> -	struct soc_camera_link *link;
> +	struct soc_camera_desc *sdesc;
>  	struct device *pdev;		/* Platform device */
>  	struct device *parent;		/* Camera host device */
>  	struct device *control;		/* E.g., the i2c client */
> @@ -116,26 +116,72 @@ struct soc_camera_host_ops {
>  struct i2c_board_info;
>  struct regulator_bulk_data;
> 
> -struct soc_camera_link {
> -	/* Camera bus id, used to match a camera and a bus */
> -	int bus_id;
> +struct soc_camera_subdev_desc {
>  	/* Per camera SOCAM_SENSOR_* bus flags */
>  	unsigned long flags;
> -	int i2c_adapter_id;
> -	struct i2c_board_info *board_info;
> -	const char *module_name;
> -	void *priv;
> +
> +	/* sensor driver private platform data */
> +	void *drv_priv;

As discussed privately, just for the record, this should go at some point 
(with async registration ? ;-)).

>  	/* Optional regulators that have to be managed on power on/off events */
>  	struct regulator_bulk_data *regulators;
>  	int num_regulators;
> 
> +	/* Optional callbacks to power on or off and reset the sensor */
> +	int (*power)(struct device *, int);
> +	int (*reset)(struct device *);
> +
> +	/*
> +	 * some platforms may support different data widths than the sensors
> +	 * native ones due to different data line routing. Let the board code
> +	 * overwrite the width flags.
> +	 */
> +	int (*set_bus_param)(struct soc_camera_subdev_desc *, unsigned long
> flags);
> +	unsigned long (*query_bus_param)(struct soc_camera_subdev_desc *);
> +	void (*free_bus)(struct soc_camera_subdev_desc *);
> +};

The structure otherwise looks pretty good to me (except of course that board 
callbacks should go at some point, as discussed above). Nice work.

> +struct soc_camera_host_desc {
> +	/* Camera bus id, used to match a camera and a bus */
> +	int bus_id;
> +	int i2c_adapter_id;
> +	struct i2c_board_info *board_info;
> +	const char *module_name;
> +
>  	/*
>  	 * For non-I2C devices platform has to provide methods to add a device
>  	 * to the system and to remove it
>  	 */
>  	int (*add_device)(struct soc_camera_device *);
>  	void (*del_device)(struct soc_camera_device *);
> +};
> +
> +/*
> + * This MUST be kept binary-identical to struct soc_camera_link below,
> until + * it is completely replaced by this one, after which we can split
> it into its + * two components.
> + */
> +struct soc_camera_desc {
> +	struct soc_camera_subdev_desc subdev_desc;
> +	struct soc_camera_host_desc host_desc;
> +};
> +
> +/* Prepare to replace this struct: don't change its layout any more! */
> +struct soc_camera_link {
> +	/*
> +	 * Subdevice part - keep at top and compatible to
> +	 * struct soc_camera_subdev_desc
> +	 */
> +
> +	/* Per camera SOCAM_SENSOR_* bus flags */
> +	unsigned long flags;
> +
> +	void *priv;
> +
> +	/* Optional regulators that have to be managed on power on/off events */
> +	struct regulator_bulk_data *regulators;
> +	int num_regulators;
> +
>  	/* Optional callbacks to power on or off and reset the sensor */
>  	int (*power)(struct device *, int);
>  	int (*reset)(struct device *);
> @@ -147,6 +193,24 @@ struct soc_camera_link {
>  	int (*set_bus_param)(struct soc_camera_link *, unsigned long flags);
>  	unsigned long (*query_bus_param)(struct soc_camera_link *);
>  	void (*free_bus)(struct soc_camera_link *);
> +
> +	/*
> +	 * Host part - keep at bottom and compatible to
> +	 * struct soc_camera_host_desc
> +	 */
> +
> +	/* Camera bus id, used to match a camera and a bus */
> +	int bus_id;
> +	int i2c_adapter_id;
> +	struct i2c_board_info *board_info;
> +	const char *module_name;
> +
> +	/*
> +	 * For non-I2C devices platform has to provide methods to add a device
> +	 * to the system and to remove it
> +	 */
> +	int (*add_device)(struct soc_camera_device *);
> +	void (*del_device)(struct soc_camera_device *);
>  };
> 
>  static inline struct soc_camera_host *to_soc_camera_host(

-- 
Regards,

Laurent Pinchart

