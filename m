Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49816 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbeKHAh3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 19:37:29 -0500
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v4 3/4] media: i2c: Add MAX9286 driver
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        luca@lucaceresoli.net
Cc: devicetree@vger.kernel.org, sakari.ailus@iki.fi,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
References: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
 <20181102154723.23662-4-kieran.bingham@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <bfae74db-aa54-32b3-966b-b8d17f2e366b@ideasonboard.com>
Date: Wed, 7 Nov 2018 15:06:36 +0000
MIME-Version: 1.0
In-Reply-To: <20181102154723.23662-4-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca

<Top posting for new topic>

> <lucaceresoli> kbingham: hi, I'm looking at your GMSL v4 patches
> <lucaceresoli> kbingham: jmondi helped me in understanding parts of it, but I still have a question
> <lucaceresoli> kbingham: are the drivers waiting for the established link before the remote chips are accessed? where?

I'm replying here rather than spam the IRC channel with a big paste.
It's also a useful description to the probe sequence, so I've kept it
with the driver posting.

I hope the following helps illustrate the sequences which are involved:

max9286_probe()
 - max9286_i2c_mux_close() # Disable all links
 - max9286_configure_i2c # Configure early communication settings
 - max9286_init():
   - regulator_enable() # Power up all cameras
   - max9286_setup() # Most link setup is done here.
   ... Set up v4l2/async/media-controller endpoints
   - max9286_i2c_mux_init() # Start configuring cameras:
     - i2c_mux_alloc() # Create our mux device
     - for_each_source(dev, source)
           i2c_mux_add_adapter() # This is where sensors get probed.

So yes sensors are only communicated with once the link is brought up as
much as possible.

Because the sensors are i2c devices on the i2c_mux - they are not probed
until their adapters are created and added.

At this stage the i2c-mux core framework will iterate all the devices
described by the DT for that adapter.

As each one is probed - the i2c_mux framework will call
max9286_i2c_mux_select() and enable only the single link.

This allows us to configure each camera independently

(which is essential because they are all configured to the same i2c
address by default at power on)


Hope this helps, and feel free to ask if you have any more questions.

--
Regards

Kieran


On 02/11/2018 15:47, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The MAX9286 is a 4-channel GMSL deserializer with coax or STP input and
> CSI-2 output. The device supports multicamera streaming applications,
> and features the ability to synchronise the attached cameras.
> 
> CSI-2 output can be configured with 1 to 4 lanes, and a control channel
> is supported over I2C, which implements an I2C mux to facilitate
> communications with connected cameras across the reverse control
> channel.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> --
> v2:
>  - Fix MAINTAINERS entry
> 
> This posting is released with the following modifications to work
> without Sakari's VC developments:
>  - max9286_g_mbus_config() re-instated
>  - max9286_get_frame_desc() is not bus/csi aware
>  - max9286_{get,set}_routing() removed
> 
> v3:
>  - Initialise notifier with v4l2_async_notifier_init
>  - Update for new mbus csi2 format V4L2_MBUS_CSI2_DPHY
> 
> v4: - Re-introduce required code to function with the VC series.
> 
>  - Implement max9286_get_routing, max9286_set_routing
>  - Remove max9286_g_mbus_config
> ---
>  MAINTAINERS                 |   10 +
>  drivers/media/i2c/Kconfig   |   11 +
>  drivers/media/i2c/Makefile  |    1 +
>  drivers/media/i2c/max9286.c | 1189 +++++++++++++++++++++++++++++++++++
>  4 files changed, 1211 insertions(+)
>  create mode 100644 drivers/media/i2c/max9286.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 23021e0df5d7..745f0fd1fff1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8864,6 +8864,16 @@ F:	Documentation/devicetree/bindings/hwmon/max6697.txt
>  F:	drivers/hwmon/max6697.c
>  F:	include/linux/platform_data/max6697.h
>  
> +MAX9286 QUAD GMSL DESERIALIZER DRIVER
> +M:	Jacopo Mondi <jacopo+renesas@jmondi.org>
> +M:	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> +M:	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> +M:	Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/media/i2c/max9286.txt
> +F:	drivers/media/i2c/max9286.c
> +
>  MAX9860 MONO AUDIO VOICE CODEC DRIVER
>  M:	Peter Rosin <peda@axentia.se>
>  L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 704af210e270..eadc00bdd3bf 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -472,6 +472,17 @@ config VIDEO_VPX3220
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vpx3220.
>  
> +config VIDEO_MAX9286
> +	tristate "Maxim MAX9286 GMSL deserializer support"
> +	depends on I2C && I2C_MUX
> +	depends on VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> +	select V4L2_FWNODE
> +	help
> +	  This driver supports the Maxim MAX9286 GMSL deserializer.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called max9286.
> +
>  comment "Video and audio decoders"
>  
>  config VIDEO_SAA717X
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 260d4d9ec2a1..4de7fe62b179 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -110,5 +110,6 @@ obj-$(CONFIG_VIDEO_IMX258)	+= imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)	+= imx274.o
>  obj-$(CONFIG_VIDEO_IMX319)	+= imx319.o
>  obj-$(CONFIG_VIDEO_IMX355)	+= imx355.o
> +obj-$(CONFIG_VIDEO_MAX9286)	+= max9286.o
>  
>  obj-$(CONFIG_SDR_MAX2175) += max2175.o
> diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
> new file mode 100644
> index 000000000000..c39c2f86e07d
> --- /dev/null
> +++ b/drivers/media/i2c/max9286.c
> @@ -0,0 +1,1189 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Maxim MAX9286 GMSL Deserializer Driver
> + *
> + * Copyright (C) 2017-2018 Jacopo Mondi
> + * Copyright (C) 2017-2018 Kieran Bingham
> + * Copyright (C) 2017-2018 Laurent Pinchart
> + * Copyright (C) 2017-2018 Niklas Söderlund
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + * Copyright (C) 2015 Cogent Embedded, Inc.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/fwnode.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-mux.h>
> +#include <linux/module.h>
> +#include <linux/of_graph.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-subdev.h>
> +
> +/* Register 0x00 */
> +#define MAX9286_MSTLINKSEL_AUTO		(7 << 5)
> +#define MAX9286_MSTLINKSEL(n)		((n) << 5)
> +#define MAX9286_EN_VS_GEN		BIT(4)
> +#define MAX9286_LINKEN(n)		(1 << (n))
> +/* Register 0x01 */
> +#define MAX9286_FSYNCMODE_ECU		(3 << 6)
> +#define MAX9286_FSYNCMODE_EXT		(2 << 6)
> +#define MAX9286_FSYNCMODE_INT_OUT	(1 << 6)
> +#define MAX9286_FSYNCMODE_INT_HIZ	(0 << 6)
> +#define MAX9286_GPIEN			BIT(5)
> +#define MAX9286_ENLMO_RSTFSYNC		BIT(2)
> +#define MAX9286_FSYNCMETH_AUTO		(2 << 0)
> +#define MAX9286_FSYNCMETH_SEMI_AUTO	(1 << 0)
> +#define MAX9286_FSYNCMETH_MANUAL	(0 << 0)
> +#define MAX9286_REG_FSYNC_PERIOD_L	0x06
> +#define MAX9286_REG_FSYNC_PERIOD_M	0x07
> +#define MAX9286_REG_FSYNC_PERIOD_H	0x08
> +/* Register 0x0a */
> +#define MAX9286_FWDCCEN(n)		(1 << ((n) + 4))
> +#define MAX9286_REVCCEN(n)		(1 << (n))
> +/* Register 0x0c */
> +#define MAX9286_HVEN			BIT(7)
> +#define MAX9286_EDC_6BIT_HAMMING	(2 << 5)
> +#define MAX9286_EDC_6BIT_CRC		(1 << 5)
> +#define MAX9286_EDC_1BIT_PARITY		(0 << 5)
> +#define MAX9286_DESEL			BIT(4)
> +#define MAX9286_INVVS			BIT(3)
> +#define MAX9286_INVHS			BIT(2)
> +#define MAX9286_HVSRC_D0		(2 << 0)
> +#define MAX9286_HVSRC_D14		(1 << 0)
> +#define MAX9286_HVSRC_D18		(0 << 0)
> +/* Register 0x12 */
> +#define MAX9286_CSILANECNT(n)		(((n) - 1) << 6)
> +#define MAX9286_CSIDBL			BIT(5)
> +#define MAX9286_DBL			BIT(4)
> +#define MAX9286_DATATYPE_USER_8BIT	(11 << 0)
> +#define MAX9286_DATATYPE_USER_YUV_12BIT	(10 << 0)
> +#define MAX9286_DATATYPE_USER_24BIT	(9 << 0)
> +#define MAX9286_DATATYPE_RAW14		(8 << 0)
> +#define MAX9286_DATATYPE_RAW11		(7 << 0)
> +#define MAX9286_DATATYPE_RAW10		(6 << 0)
> +#define MAX9286_DATATYPE_RAW8		(5 << 0)
> +#define MAX9286_DATATYPE_YUV422_10BIT	(4 << 0)
> +#define MAX9286_DATATYPE_YUV422_8BIT	(3 << 0)
> +#define MAX9286_DATATYPE_RGB555		(2 << 0)
> +#define MAX9286_DATATYPE_RGB565		(1 << 0)
> +#define MAX9286_DATATYPE_RGB888		(0 << 0)
> +/* Register 0x15 */
> +#define MAX9286_VC(n)			((n) << 5)
> +#define MAX9286_VCTYPE			BIT(4)
> +#define MAX9286_CSIOUTEN		BIT(3)
> +#define MAX9286_0X15_RESV		(3 << 0)
> +/* Register 0x1b */
> +#define MAX9286_SWITCHIN(n)		(1 << ((n) + 4))
> +#define MAX9286_ENEQ(n)			(1 << (n))
> +/* Register 0x27 */
> +#define MAX9286_LOCKED			BIT(7)
> +/* Register 0x31 */
> +#define MAX9286_FSYNC_LOCKED		BIT(6)
> +/* Register 0x34 */
> +#define MAX9286_I2CLOCACK		BIT(7)
> +#define MAX9286_I2CSLVSH_1046NS_469NS	(3 << 5)
> +#define MAX9286_I2CSLVSH_938NS_352NS	(2 << 5)
> +#define MAX9286_I2CSLVSH_469NS_234NS	(1 << 5)
> +#define MAX9286_I2CSLVSH_352NS_117NS	(0 << 5)
> +#define MAX9286_I2CMSTBT_837KBPS	(7 << 2)
> +#define MAX9286_I2CMSTBT_533KBPS	(6 << 2)
> +#define MAX9286_I2CMSTBT_339KBPS	(5 << 2)
> +#define MAX9286_I2CMSTBT_173KBPS	(4 << 2)
> +#define MAX9286_I2CMSTBT_105KBPS	(3 << 2)
> +#define MAX9286_I2CMSTBT_84KBPS		(2 << 2)
> +#define MAX9286_I2CMSTBT_28KBPS		(1 << 2)
> +#define MAX9286_I2CMSTBT_8KBPS		(0 << 2)
> +#define MAX9286_I2CSLVTO_NONE		(3 << 0)
> +#define MAX9286_I2CSLVTO_1024US		(2 << 0)
> +#define MAX9286_I2CSLVTO_256US		(1 << 0)
> +#define MAX9286_I2CSLVTO_64US		(0 << 0)
> +/* Register 0x3b */
> +#define MAX9286_REV_TRF(n)		((n) << 4)
> +#define MAX9286_REV_AMP(n)		((((n) - 30) / 10) << 1) /* in mV */
> +#define MAX9286_REV_AMP_X		BIT(0)
> +/* Register 0x3f */
> +#define MAX9286_EN_REV_CFG		BIT(6)
> +#define MAX9286_REV_FLEN(n)		((n) - 20)
> +/* Register 0x49 */
> +#define MAX9286_VIDEO_DETECT_MASK	0x0f
> +/* Register 0x69 */
> +#define MAX9286_LFLTBMONMASKED		BIT(7)
> +#define MAX9286_LOCKMONMASKED		BIT(6)
> +#define MAX9286_AUTOCOMBACKEN		BIT(5)
> +#define MAX9286_AUTOMASKEN		BIT(4)
> +#define MAX9286_MASKLINK(n)		((n) << 0)
> +
> +#define MAX9286_NUM_GMSL		4
> +#define MAX9286_N_SINKS			4
> +#define MAX9286_N_PADS			5
> +#define MAX9286_SRC_PAD			4
> +
> +#define MAXIM_I2C_I2C_SPEED_400KHZ	MAX9286_I2CMSTBT_339KBPS
> +#define MAXIM_I2C_I2C_SPEED_100KHZ	MAX9286_I2CMSTBT_105KBPS
> +#define MAXIM_I2C_SPEED			MAXIM_I2C_I2C_SPEED_100KHZ
> +
> +struct max9286_source {
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *sd;
> +	struct fwnode_handle *fwnode;
> +};
> +
> +#define asd_to_max9286_source(_asd) \
> +	container_of(_asd, struct max9286_source, asd)
> +
> +struct max9286_device {
> +	struct i2c_client *client;
> +	struct v4l2_subdev sd;
> +	struct media_pad pads[MAX9286_N_PADS];
> +	struct regulator *regulator;
> +	bool poc_enabled;
> +	int streaming;
> +
> +	struct i2c_mux_core *mux;
> +	unsigned int mux_channel;
> +
> +	struct v4l2_ctrl_handler ctrls;
> +
> +	struct v4l2_mbus_framefmt fmt[MAX9286_N_SINKS];
> +
> +	unsigned int nsources;
> +	unsigned int source_mask;
> +	unsigned int route_mask;
> +	unsigned int csi2_data_lanes;
> +	struct max9286_source sources[MAX9286_NUM_GMSL];
> +	struct v4l2_async_notifier notifier;
> +};
> +
> +static struct max9286_source *next_source(struct max9286_device *max9286,
> +					  struct max9286_source *source)
> +{
> +	if (!source)
> +		source = &max9286->sources[0];
> +	else
> +		source++;
> +
> +	for (; source < &max9286->sources[MAX9286_NUM_GMSL]; source++) {
> +		if (source->fwnode)
> +			return source;
> +	}
> +
> +	return NULL;
> +}
> +
> +#define for_each_source(max9286, source) \
> +	for (source = NULL; (source = next_source(max9286, source)); )
> +
> +#define to_index(max9286, source) (source - &max9286->sources[0])
> +
> +#define sd_to_max9286(_sd) container_of(_sd, struct max9286_device, sd)
> +
> +/* -----------------------------------------------------------------------------
> + * I2C IO
> + */
> +
> +static int max9286_read(struct max9286_device *dev, u8 reg)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(dev->client, reg);
> +	if (ret < 0)
> +		dev_err(&dev->client->dev,
> +			"%s: register 0x%02x read failed (%d)\n",
> +			__func__, reg, ret);
> +
> +	return ret;
> +}
> +
> +static int max9286_write(struct max9286_device *dev, u8 reg, u8 val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte_data(dev->client, reg, val);
> +	if (ret < 0)
> +		dev_err(&dev->client->dev,
> +			"%s: register 0x%02x write failed (%d)\n",
> +			__func__, reg, ret);
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * I2C Multiplexer
> + */
> +
> +static int max9286_i2c_mux_close(struct max9286_device *dev)
> +{
> +
> +	/* FIXME: See note in max9286_i2c_mux_select() */
> +	if (dev->streaming)
> +		return 0;
> +	/*
> +	 * Ensure that both the forward and reverse channel are disabled on the
> +	 * mux, and that the channel ID is invalidated to ensure we reconfigure
> +	 * on the next select call.
> +	 */
> +	dev->mux_channel = -1;
> +	max9286_write(dev, 0x0a, 0x00);
> +	usleep_range(3000, 5000);
> +
> +	return 0;
> +}
> +
> +static int max9286_i2c_mux_select(struct i2c_mux_core *muxc, u32 chan)
> +{
> +	struct max9286_device *dev = i2c_mux_priv(muxc);
> +
> +	/*
> +	 * FIXME: This state keeping is a hack and do the job. It should
> +	 * be should be reworked. One option to consider is that once all
> +	 * cameras are programmed the mux selection logic should be disabled
> +	 * and all all reverse and forward channels enable all the time.
> +	 *
> +	 * In any case this logic with a int that have two states should be
> +	 * reworked!
> +	 */
> +	if (dev->streaming == 1) {
> +		max9286_write(dev, 0x0a, 0xff);
> +		dev->streaming = 2;
> +		return 0;
> +	} else if (dev->streaming == 2) {
> +		return 0;
> +	}
> +
> +	if (dev->mux_channel == chan)
> +		return 0;
> +
> +	dev->mux_channel = chan;
> +
> +	max9286_write(dev, 0x0a, MAX9286_FWDCCEN(chan) | MAX9286_REVCCEN(chan));
> +
> +	/*
> +	 * We must sleep after any change to the forward or reverse channel
> +	 * configuration.
> +	 */
> +	usleep_range(3000, 5000);
> +
> +	return 0;
> +}
> +
> +static int max9286_i2c_mux_init(struct max9286_device *dev)
> +{
> +	struct max9286_source *source;
> +	int ret;
> +
> +	if (!i2c_check_functionality(dev->client->adapter,
> +				     I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
> +		return -ENODEV;
> +
> +	dev->mux = i2c_mux_alloc(dev->client->adapter, &dev->client->dev,
> +				 dev->nsources, 0, I2C_MUX_LOCKED,
> +				 max9286_i2c_mux_select, NULL);
> +	if (!dev->mux)
> +		return -ENOMEM;
> +
> +	dev->mux->priv = dev;
> +
> +	for_each_source(dev, source) {
> +		unsigned int index = to_index(dev, source);
> +
> +		ret = i2c_mux_add_adapter(dev->mux, 0, index, 0);
> +		if (ret < 0)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	i2c_mux_del_adapters(dev->mux);
> +	return ret;
> +}
> +
> +static void max9286_configure_i2c(struct max9286_device *dev, bool localack)
> +{
> +	u8 config = MAX9286_I2CSLVSH_469NS_234NS | MAX9286_I2CSLVTO_1024US |
> +		    MAXIM_I2C_SPEED;
> +
> +	if (localack)
> +		config |= MAX9286_I2CLOCACK;
> +
> +	max9286_write(dev, 0x34, config);
> +	usleep_range(3000, 5000);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 Subdev
> + */
> +
> +static int max9286_notify_bound(struct v4l2_async_notifier *notifier,
> +				struct v4l2_subdev *subdev,
> +				struct v4l2_async_subdev *asd)
> +{
> +	struct max9286_device *dev = sd_to_max9286(notifier->sd);
> +	struct max9286_source *source = asd_to_max9286_source(asd);
> +	unsigned int index = to_index(dev, source);
> +	unsigned int src_pad;
> +	int ret;
> +
> +	ret = media_entity_get_fwnode_pad(&subdev->entity,
> +					  source->fwnode,
> +					  MEDIA_PAD_FL_SOURCE);
> +	if (ret < 0) {
> +		dev_err(&dev->client->dev,
> +			"Failed to find pad for %s\n", subdev->name);
> +		return ret;
> +	}
> +
> +	source->sd = subdev;
> +	src_pad = ret;
> +
> +	ret = media_create_pad_link(&source->sd->entity, src_pad,
> +				    &dev->sd.entity, index,
> +				    MEDIA_LNK_FL_ENABLED |
> +				    MEDIA_LNK_FL_IMMUTABLE);
> +	if (ret) {
> +		dev_err(&dev->client->dev,
> +			"Unable to link %s:%u -> %s:%u\n",
> +			source->sd->name, src_pad, dev->sd.name, index);
> +		return ret;
> +	}
> +
> +	dev_dbg(&dev->client->dev, "Bound %s pad: %u on index %u\n",
> +		subdev->name, src_pad, index);
> +
> +	return 0;
> +}
> +
> +static void max9286_notify_unbind(struct v4l2_async_notifier *notifier,
> +				  struct v4l2_subdev *subdev,
> +				  struct v4l2_async_subdev *asd)
> +{
> +	struct max9286_source *source = asd_to_max9286_source(asd);
> +
> +	source->sd = NULL;
> +}
> +
> +static const struct v4l2_async_notifier_operations max9286_notify_ops = {
> +	.bound = max9286_notify_bound,
> +	.unbind = max9286_notify_unbind,
> +};
> +
> +/*
> + * max9286_check_video_links() - Make sure video links are detected and locked
> + *
> + * Performs safety checks on video link status. Make sure they are detected
> + * and all enabled links are locked.
> + *
> + * Returns 0 for success, -EIO for errors.
> + */
> +static int max9286_check_video_links(struct max9286_device *dev)
> +{
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * Make sure valid video links are detected.
> +	 * The delay is not characterized in de-serializer manual, wait up
> +	 * to 5 ms.
> +	 */
> +	for (i = 0; i < 10; i++) {
> +		ret = max9286_read(dev, 0x49);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		if ((ret & MAX9286_VIDEO_DETECT_MASK) == dev->source_mask)
> +			break;
> +
> +		usleep_range(350, 500);
> +	}
> +
> +	if (i == 10) {
> +		dev_err(&dev->client->dev,
> +			"Unable to detect video links: 0x%2x\n", ret);
> +		return -EIO;
> +	}
> +
> +	/* Make sure all enabled links are locked (4ms max). */
> +	for (i = 0; i < 10; i++) {
> +		ret = max9286_read(dev, 0x27);
> +		if (ret < 0)
> +			return -EIO;
> +
> +		if (ret & MAX9286_LOCKED)
> +			break;
> +
> +		usleep_range(350, 450);
> +	}
> +
> +	if (i == 10) {
> +		dev_err(&dev->client->dev, "Not all enabled links locked\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int max9286_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct max9286_source *source;
> +	unsigned int i;
> +	bool sync = false;
> +	int ret;
> +
> +	if (enable) {
> +		/* FIXME: See note in max9286_i2c_mux_select() */
> +		dev->streaming = 1;
> +
> +		/* Start all cameras. */
> +		for_each_source(dev, source) {
> +			ret = v4l2_subdev_call(source->sd, video, s_stream, 1);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		ret = max9286_check_video_links(dev);
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * Wait until frame synchronization is locked.
> +		 *
> +		 * Manual says frame sync locking should take ~6 VTS.
> +		 * From pratical experience at least 8 are required. Give
> +		 * 12 complete frames time (~33ms at 30 fps) to achieve frame
> +		 * locking before returning error.
> +		 */
> +		for (i = 0; i < 36; i++) {
> +			if (max9286_read(dev, 0x31) & MAX9286_FSYNC_LOCKED) {
> +				sync = true;
> +				break;
> +			}
> +			usleep_range(9000, 11000);
> +		}
> +
> +		if (!sync) {
> +			dev_err(&dev->client->dev,
> +				"Failed to get frame synchronization\n");
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * Enable CSI output, VC set according to link number.
> +		 * Bit 7 must be set (chip manual says it's 0 and reserved).
> +		 */
> +		max9286_write(dev, 0x15, 0x80 | MAX9286_VCTYPE |
> +			      MAX9286_CSIOUTEN | MAX9286_0X15_RESV);
> +	} else {
> +		max9286_write(dev, 0x15, MAX9286_VCTYPE | MAX9286_0X15_RESV);
> +
> +		/* Stop all cameras. */
> +		for_each_source(dev, source)
> +			v4l2_subdev_call(source->sd, video, s_stream, 0);
> +
> +		/* FIXME: See note in max9286_i2c_mux_select() */
> +		dev->streaming = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static int max9286_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->pad || code->index > 0)
> +		return -EINVAL;
> +
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +
> +	return 0;
> +}
> +
> +static struct v4l2_mbus_framefmt *
> +max9286_get_pad_format(struct max9286_device *dev,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       unsigned int pad, u32 which)
> +{
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(&dev->sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &dev->fmt[pad];
> +	default:
> +		return NULL;
> +	}
> +}
> +
> +static int max9286_set_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct v4l2_mbus_framefmt *cfg_fmt;
> +
> +	if (format->pad >= MAX9286_SRC_PAD)
> +		return -EINVAL;
> +
> +	/* Refuse non YUV422 formats as we hardcode DT to 8 bit YUV422 */
> +	switch (format->format.code) {
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +		break;
> +	default:
> +		format->format.code = MEDIA_BUS_FMT_YUYV8_2X8;
> +		break;
> +	}
> +
> +	cfg_fmt = max9286_get_pad_format(dev, cfg, format->pad, format->which);
> +	if (!cfg_fmt)
> +		return -EINVAL;
> +
> +	*cfg_fmt = format->format;
> +
> +	return 0;
> +}
> +
> +static int max9286_get_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct v4l2_mbus_framefmt *cfg_fmt;
> +
> +	if (format->pad >= MAX9286_SRC_PAD)
> +		return -EINVAL;
> +
> +	cfg_fmt = max9286_get_pad_format(dev, cfg, format->pad, format->which);
> +	if (!cfg_fmt)
> +		return -EINVAL;
> +
> +	format->format = *cfg_fmt;
> +
> +	return 0;
> +}
> +
> +static int max9286_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> +			   struct v4l2_mbus_frame_desc *fd)
> +{
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct max9286_source *source;
> +	unsigned int i = 0;
> +
> +	memset(fd, 0, sizeof(*fd));
> +
> +	for_each_source(dev, source) {
> +		unsigned int index = to_index(dev, source);
> +
> +		fd->entry[i].stream = i;
> +		fd->entry[i].bus.csi2.channel = index;
> +		fd->entry[i].bus.csi2.data_type = 0x1e;
> +		i++;
> +	}
> +
> +	fd->type = V4L2_MBUS_FRAME_DESC_TYPE_CSI2;
> +	fd->num_entries = dev->nsources;
> +
> +	return 0;
> +}
> +
> +static int max9286_get_routing(struct v4l2_subdev *sd,
> +				 struct v4l2_subdev_routing *routing)
> +{
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct v4l2_subdev_route *r = routing->routes;
> +	struct max9286_source *source;
> +
> +	/* There is one route per sink pad. */
> +	if (routing->num_routes < dev->nsources) {
> +		routing->num_routes = dev->nsources;
> +		return -ENOSPC;
> +	}
> +
> +	routing->num_routes = dev->nsources;
> +
> +	for_each_source(dev, source) {
> +		unsigned int index = to_index(dev, source);
> +
> +		r->sink_pad = index;
> +		r->sink_stream = 0;
> +		r->source_pad = MAX9286_SRC_PAD;
> +		r->source_stream = index;
> +		r->flags = dev->route_mask & BIT(index) ?
> +			V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
> +		r++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int max9286_set_routing(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_routing *routing)
> +{
> +
> +	struct max9286_device *dev = sd_to_max9286(sd);
> +	struct v4l2_subdev_route *r = routing->routes;
> +	unsigned int i;
> +
> +	if (routing->num_routes > dev->nsources)
> +		return -ENOSPC;
> +
> +	for (i = 0; i < routing->num_routes; i++) {
> +		if (r->sink_pad >= MAX9286_SRC_PAD ||
> +		    r->sink_stream != 0 ||
> +		    r->source_pad != MAX9286_SRC_PAD ||
> +		    r->source_stream != r->sink_pad)
> +			return -EINVAL;
> +
> +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE)
> +			dev->route_mask |= BIT(r->sink_pad);
> +		else
> +			dev->route_mask &= ~BIT(r->sink_pad);
> +
> +		r++;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops max9286_video_ops = {
> +	.s_stream	= max9286_s_stream,
> +};
> +
> +static const struct v4l2_subdev_pad_ops max9286_pad_ops = {
> +	.enum_mbus_code = max9286_enum_mbus_code,
> +	.get_fmt	= max9286_get_fmt,
> +	.set_fmt	= max9286_set_fmt,
> +	.get_frame_desc = max9286_get_frame_desc,
> +	.get_routing	= max9286_get_routing,
> +	.set_routing	= max9286_set_routing,
> +};
> +
> +static const struct v4l2_subdev_ops max9286_subdev_ops = {
> +	.video		= &max9286_video_ops,
> +	.pad		= &max9286_pad_ops,
> +};
> +
> +static void max9286_init_format(struct v4l2_mbus_framefmt *fmt)
> +{
> +	fmt->width		= 1280;
> +	fmt->height		= 800;
> +	fmt->code		= MEDIA_BUS_FMT_UYVY8_2X8;
> +	fmt->colorspace		= V4L2_COLORSPACE_SRGB;
> +	fmt->field		= V4L2_FIELD_NONE;
> +	fmt->ycbcr_enc		= V4L2_YCBCR_ENC_DEFAULT;
> +	fmt->quantization	= V4L2_QUANTIZATION_DEFAULT;
> +	fmt->xfer_func		= V4L2_XFER_FUNC_DEFAULT;
> +}
> +
> +static int max9286_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *format;
> +	unsigned int i;
> +
> +	for (i = 0; i < MAX9286_N_SINKS; i++) {
> +		format = v4l2_subdev_get_try_format(subdev, fh->pad, i);
> +		max9286_init_format(format);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops max9286_subdev_internal_ops = {
> +	.open = max9286_open,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Probe/Remove
> + */
> +
> +static int max9286_setup(struct max9286_device *dev)
> +{
> +	/*
> +	 * Link ordering values for all enabled links combinations. Orders must
> +	 * be assigned sequentially from 0 to the number of enabled links
> +	 * without leaving any hole for disabled links. We thus assign orders to
> +	 * enabled links first, and use the remaining order values for disabled
> +	 * links are all links must have a different order value;
> +	 */
> +	static const u8 link_order[] = {
> +		(3 << 6) | (2 << 4) | (1 << 2) | (0 << 0), /* xxxx */
> +		(3 << 6) | (2 << 4) | (1 << 2) | (0 << 0), /* xxx0 */
> +		(3 << 6) | (2 << 4) | (0 << 2) | (1 << 0), /* xx0x */
> +		(3 << 6) | (2 << 4) | (1 << 2) | (0 << 0), /* xx10 */
> +		(3 << 6) | (0 << 4) | (2 << 2) | (1 << 0), /* x0xx */
> +		(3 << 6) | (1 << 4) | (2 << 2) | (0 << 0), /* x1x0 */
> +		(3 << 6) | (1 << 4) | (0 << 2) | (2 << 0), /* x10x */
> +		(3 << 6) | (1 << 4) | (1 << 2) | (0 << 0), /* x210 */
> +		(0 << 6) | (3 << 4) | (2 << 2) | (1 << 0), /* 0xxx */
> +		(1 << 6) | (3 << 4) | (2 << 2) | (0 << 0), /* 1xx0 */
> +		(1 << 6) | (3 << 4) | (0 << 2) | (2 << 0), /* 1x0x */
> +		(2 << 6) | (3 << 4) | (1 << 2) | (0 << 0), /* 2x10 */
> +		(1 << 6) | (0 << 4) | (3 << 2) | (2 << 0), /* 10xx */
> +		(2 << 6) | (1 << 4) | (3 << 2) | (0 << 0), /* 21x0 */
> +		(2 << 6) | (1 << 4) | (0 << 2) | (3 << 0), /* 210x */
> +		(3 << 6) | (2 << 4) | (1 << 2) | (0 << 0), /* 3210 */
> +	};
> +
> +	/*
> +	 * Set the I2C bus speed.
> +	 *
> +	 * Enable I2C Local Acknowledge during the probe sequences of the camera
> +	 * only. This should be disabled after the mux is initialised.
> +	 */
> +	max9286_configure_i2c(dev, true);
> +
> +	/*
> +	 * Reverse channel setup.
> +	 *
> +	 * - Enable custom reverse channel configuration (through register 0x3f)
> +	 *   and set the first pulse length to 35 clock cycles.
> +	 * - Increase the reverse channel amplitude to 170mV to accommodate the
> +	 *   high threshold enabled by the serializer driver.
> +	 */
> +	max9286_write(dev, 0x3f, MAX9286_EN_REV_CFG | MAX9286_REV_FLEN(35));
> +	max9286_write(dev, 0x3b, MAX9286_REV_TRF(1) | MAX9286_REV_AMP(70) |
> +		      MAX9286_REV_AMP_X);
> +
> +	/*
> +	 * Enable GMSL links, mask unused ones and autodetect link
> +	 * used as CSI clock source.
> +	 */
> +	max9286_write(dev, 0x00, MAX9286_MSTLINKSEL_AUTO | dev->route_mask);
> +	max9286_write(dev, 0x0b, link_order[dev->route_mask]);
> +	max9286_write(dev, 0x69, (0xf & ~dev->route_mask));
> +
> +	/*
> +	 * Video format setup:
> +	 * Disable CSI output, VC is set accordingly to Link number.
> +	 */
> +	max9286_write(dev, 0x15, MAX9286_VCTYPE | MAX9286_0X15_RESV);
> +
> +	/* Enable CSI-2 Lane D0-D3 only, DBL mode, YUV422 8-bit. */
> +	max9286_write(dev, 0x12, MAX9286_CSIDBL	| MAX9286_DBL |
> +		      MAX9286_CSILANECNT(dev->csi2_data_lanes) |
> +		      MAX9286_DATATYPE_YUV422_8BIT);
> +
> +	/* Automatic: FRAMESYNC taken from the slowest Link. */
> +	max9286_write(dev, 0x01, MAX9286_FSYNCMODE_INT_HIZ |
> +		      MAX9286_FSYNCMETH_AUTO);
> +
> +	/* Enable HS/VS encoding, use D14/15 for HS/VS, invert VS. */
> +	max9286_write(dev, 0x0c, MAX9286_HVEN | MAX9286_INVVS |
> +		      MAX9286_HVSRC_D14);
> +
> +	/*
> +	 * Wait for 2ms to allow the link to resynchronize after the
> +	 * configuration change.
> +	 */
> +	usleep_range(2000, 5000);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id max9286_dt_ids[] = {
> +	{ .compatible = "maxim,max9286" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, max9286_dt_ids);
> +
> +static int max9286_init(struct device *dev, void *data)
> +{
> +	struct max9286_device *max9286;
> +	struct i2c_client *client;
> +	struct device_node *ep;
> +	unsigned int i;
> +	int ret;
> +
> +	/* Skip non-max9286 devices. */
> +	if (!dev->of_node || !of_match_node(max9286_dt_ids, dev->of_node))
> +		return 0;
> +
> +	client = to_i2c_client(dev);
> +	max9286 = i2c_get_clientdata(client);
> +
> +	/* Enable the bus power. */
> +	ret = regulator_enable(max9286->regulator);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "Unable to turn PoC on\n");
> +		return ret;
> +	}
> +
> +	max9286->poc_enabled = true;
> +
> +	ret = max9286_setup(max9286);
> +	if (ret) {
> +		dev_err(dev, "Unable to setup max9286\n");
> +		goto err_regulator;
> +	}
> +
> +	v4l2_i2c_subdev_init(&max9286->sd, client, &max9286_subdev_ops);
> +	max9286->sd.internal_ops = &max9286_subdev_internal_ops;
> +	max9286->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	v4l2_ctrl_handler_init(&max9286->ctrls, 1);
> +	/*
> +	 * FIXME: Compute the real pixel rate. The 50 MP/s value comes from the
> +	 * hardcoded frequency in the BSP CSI-2 receiver driver.
> +	 */
> +	v4l2_ctrl_new_std(&max9286->ctrls, NULL, V4L2_CID_PIXEL_RATE,
> +			  50000000, 50000000, 1, 50000000);
> +	max9286->sd.ctrl_handler = &max9286->ctrls;
> +	ret = max9286->ctrls.error;
> +	if (ret)
> +		goto err_regulator;
> +
> +	max9286->sd.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> +
> +	max9286->pads[MAX9286_SRC_PAD].flags = MEDIA_PAD_FL_SOURCE;
> +	for (i = 0; i < MAX9286_SRC_PAD; i++)
> +		max9286->pads[i].flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_pads_init(&max9286->sd.entity, MAX9286_N_PADS,
> +				     max9286->pads);
> +	if (ret)
> +		goto err_regulator;
> +
> +	ep = of_graph_get_endpoint_by_regs(dev->of_node, MAX9286_SRC_PAD, -1);
> +	if (!ep) {
> +		dev_err(dev, "Unable to retrieve endpoint on \"port@4\"\n");
> +		ret = -ENOENT;
> +		goto err_regulator;
> +	}
> +	max9286->sd.fwnode = of_fwnode_handle(ep);
> +
> +	ret = v4l2_async_register_subdev(&max9286->sd);
> +	if (ret < 0) {
> +		dev_err(dev, "Unable to register subdevice\n");
> +		goto err_put_node;
> +	}
> +
> +	ret = max9286_i2c_mux_init(max9286);
> +	if (ret) {
> +		dev_err(dev, "Unable to initialize I2C multiplexer\n");
> +		goto err_subdev_unregister;
> +	}
> +
> +	/*
> +	 * Re-configure I2C with local acknowledge disabled after cameras
> +	 * have probed.
> +	 */
> +	max9286_configure_i2c(max9286, false);
> +
> +	/* Leave the mux channels disabled until they are selected. */
> +	max9286_i2c_mux_close(max9286);
> +
> +	return 0;
> +
> +err_subdev_unregister:
> +	v4l2_async_unregister_subdev(&max9286->sd);
> +	max9286_i2c_mux_close(max9286);
> +err_put_node:
> +	of_node_put(ep);
> +err_regulator:
> +	regulator_disable(max9286->regulator);
> +	max9286->poc_enabled = false;
> +
> +	return ret;
> +}
> +
> +static int max9286_is_bound(struct device *dev, void *data)
> +{
> +	struct device *this = data;
> +	int ret;
> +
> +	if (dev == this)
> +		return 0;
> +
> +	/* Skip non-max9286 devices. */
> +	if (!dev->of_node || !of_match_node(max9286_dt_ids, dev->of_node))
> +		return 0;
> +
> +	ret = device_is_bound(dev);
> +	if (!ret)
> +		return -EPROBE_DEFER;
> +
> +	return 0;
> +}
> +
> +static struct device_node *max9286_get_i2c_by_id(struct device_node *parent,
> +						 u32 id)
> +{
> +	struct device_node *child;
> +
> +	for_each_child_of_node(parent, child) {
> +		u32 i2c_id = 0;
> +
> +		if (of_node_cmp(child->name, "i2c") != 0)
> +			continue;
> +		of_property_read_u32(child, "reg", &i2c_id);
> +		if (id == i2c_id)
> +			return child;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int max9286_check_i2c_bus_by_id(struct device *dev, int id)
> +{
> +	struct device_node *i2c_np;
> +
> +	i2c_np = max9286_get_i2c_by_id(dev->of_node, id);
> +	if (!i2c_np) {
> +		dev_err(dev, "Failed to find corresponding i2c@%u\n", id);
> +		return -ENODEV;
> +	}
> +
> +	if (!of_device_is_available(i2c_np)) {
> +		dev_dbg(dev, "Skipping port %u with disabled I2C bus\n", id);
> +		of_node_put(i2c_np);
> +		return -ENODEV;
> +	}
> +
> +	of_node_put(i2c_np);
> +
> +	return 0;
> +}
> +
> +static void max9286_cleanup_dt(struct max9286_device *max9286)
> +{
> +	struct max9286_source *source;
> +
> +	/*
> +	 * Not strictly part of the DT, but the notifier is registered during
> +	 * max9286_parse_dt(), and the notifier holds references to the fwnodes
> +	 * thus the cleanup is here to mirror the registration.
> +	 */
> +	v4l2_async_notifier_unregister(&max9286->notifier);
> +
> +	for_each_source(max9286, source) {
> +		fwnode_handle_put(source->fwnode);
> +		source->fwnode = NULL;
> +	}
> +}
> +
> +static int max9286_parse_dt(struct max9286_device *max9286)
> +{
> +	struct device *dev = &max9286->client->dev;
> +	struct device_node *ep_np = NULL;
> +	int ret;
> +
> +	v4l2_async_notifier_init(&max9286->notifier);
> +
> +	for_each_endpoint_of_node(dev->of_node, ep_np) {
> +		struct max9286_source *source;
> +		struct of_endpoint ep;
> +
> +		of_graph_parse_endpoint(ep_np, &ep);
> +		dev_dbg(dev, "Endpoint %pOF on port %d",
> +			ep.local_node, ep.port);
> +
> +		if (ep.port > MAX9286_NUM_GMSL) {
> +			dev_err(dev, "Invalid endpoint %s on port %d",
> +				of_node_full_name(ep.local_node),
> +				ep.port);
> +
> +			continue;
> +		}
> +
> +		/* For the source endpoint just parse the bus configuration. */
> +		if (ep.port == MAX9286_SRC_PAD) {
> +			struct v4l2_fwnode_endpoint vep;
> +			int ret;
> +
> +			ret = v4l2_fwnode_endpoint_alloc_parse(
> +					of_fwnode_handle(ep_np), &vep);
> +			if (ret)
> +				return ret;
> +
> +			if (vep.bus_type != V4L2_MBUS_CSI2_DPHY) {
> +				dev_err(dev,
> +					"Media bus %u type not supported\n",
> +					vep.bus_type);
> +				v4l2_fwnode_endpoint_free(&vep);
> +				return -EINVAL;
> +			}
> +
> +			max9286->csi2_data_lanes =
> +				vep.bus.mipi_csi2.num_data_lanes;
> +			v4l2_fwnode_endpoint_free(&vep);
> +
> +			continue;
> +		}
> +
> +		/* Skip if the corresponding GMSL link is unavailable. */
> +		if (max9286_check_i2c_bus_by_id(dev, ep.port))
> +			continue;
> +
> +		if (max9286->sources[ep.port].fwnode) {
> +			dev_err(dev,
> +				"Multiple port endpoints are not supported: %d",
> +				ep.port);
> +
> +			continue;
> +		}
> +
> +		source = &max9286->sources[ep.port];
> +		source->fwnode = fwnode_graph_get_remote_endpoint(
> +						of_fwnode_handle(ep_np));
> +		if (!source->fwnode) {
> +			dev_err(dev,
> +				"Endpoint %pOF has no remote endpoint connection\n",
> +				ep.local_node);
> +
> +			continue;
> +		}
> +
> +		source->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		source->asd.match.fwnode = source->fwnode;
> +
> +		ret = v4l2_async_notifier_add_subdev(&max9286->notifier,
> +						     &source->asd);
> +		if (ret) /* TODO: Cleanup notifier! */
> +			return ret;
> +
> +		max9286->source_mask |= BIT(ep.port);
> +		max9286->nsources++;
> +	}
> +
> +	/* Do not register the subdev notifier if there are no devices. */
> +	if (!max9286->nsources)
> +		return 0;
> +
> +	max9286->route_mask = max9286->source_mask;
> +	max9286->notifier.ops = &max9286_notify_ops;
> +
> +	return v4l2_async_subdev_notifier_register(&max9286->sd,
> +						   &max9286->notifier);
> +}
> +
> +static int max9286_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *did)
> +{
> +	struct max9286_device *dev;
> +	unsigned int i;
> +	int ret;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	dev->client = client;
> +	i2c_set_clientdata(client, dev);
> +
> +	for (i = 0; i < MAX9286_N_SINKS; i++)
> +		max9286_init_format(&dev->fmt[i]);
> +
> +	ret = max9286_parse_dt(dev);
> +	if (ret)
> +		return ret;
> +
> +	dev->regulator = regulator_get(&client->dev, "poc");
> +	if (IS_ERR(dev->regulator)) {
> +		if (PTR_ERR(dev->regulator) != -EPROBE_DEFER)
> +			dev_err(&client->dev,
> +				"Unable to get PoC regulator (%ld)\n",
> +				PTR_ERR(dev->regulator));
> +		ret = PTR_ERR(dev->regulator);
> +		goto err_free;
> +	}
> +
> +	/*
> +	 * We can have multiple MAX9286 instances on the same physical I2C
> +	 * bus, and I2C children behind ports of separate MAX9286 instances
> +	 * having the same I2C address. As the MAX9286 starts by default with
> +	 * all ports enabled, we need to disable all ports on all MAX9286
> +	 * instances before proceeding to further initialize the devices and
> +	 * instantiate children.
> +	 *
> +	 * Start by just disabling all channels on the current device. Then,
> +	 * if all other MAX9286 on the parent bus have been probed, proceed
> +	 * to initialize them all, including the current one.
> +	 */
> +	max9286_i2c_mux_close(dev);
> +
> +	/*
> +	 * The MAX9286 initialises with auto-acknowledge enabled by default.
> +	 * This means that if multiple MAX9286 devices are connected to an I2C
> +	 * bus, another MAX9286 could ack I2C transfers meant for a device on
> +	 * the other side of the GMSL links for this MAX9286 (such as a
> +	 * MAX9271). To prevent that disable auto-acknowledge early on; it
> +	 * will be enabled later as needed.
> +	 */
> +	max9286_configure_i2c(dev, false);
> +
> +	ret = device_for_each_child(client->dev.parent, &client->dev,
> +				    max9286_is_bound);
> +	if (ret)
> +		return 0;
> +
> +	dev_dbg(&client->dev,
> +		"All max9286 probed: start initialization sequence\n");
> +	ret = device_for_each_child(client->dev.parent, NULL,
> +				    max9286_init);
> +	if (ret < 0)
> +		goto err_regulator;
> +
> +	/* Leave the mux channels disabled until they are selected. */
> +	max9286_i2c_mux_close(dev);
> +
> +	return 0;
> +
> +err_regulator:
> +	regulator_put(dev->regulator);
> +	max9286_i2c_mux_close(dev);
> +	max9286_configure_i2c(dev, false);
> +err_free:
> +	max9286_cleanup_dt(dev);
> +	kfree(dev);
> +
> +	return ret;
> +}
> +
> +static int max9286_remove(struct i2c_client *client)
> +{
> +	struct max9286_device *dev = i2c_get_clientdata(client);
> +
> +	i2c_mux_del_adapters(dev->mux);
> +
> +	fwnode_handle_put(dev->sd.fwnode);
> +	v4l2_async_unregister_subdev(&dev->sd);
> +
> +	if (dev->poc_enabled)
> +		regulator_disable(dev->regulator);
> +	regulator_put(dev->regulator);
> +
> +	max9286_cleanup_dt(dev);
> +	kfree(dev);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max9286_id[] = {
> +	{ "max9286", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max9286_id);
> +
> +static struct i2c_driver max9286_i2c_driver = {
> +	.driver	= {
> +		.name		= "max9286",
> +		.of_match_table	= of_match_ptr(max9286_dt_ids),
> +	},
> +	.probe		= max9286_probe,
> +	.remove		= max9286_remove,
> +	.id_table	= max9286_id,
> +};
> +
> +module_i2c_driver(max9286_i2c_driver);
> +
> +MODULE_DESCRIPTION("Maxim MAX9286 GMSL Deserializer Driver");
> +MODULE_AUTHOR("Vladimir Barinov");
> +MODULE_LICENSE("GPL");
> 
