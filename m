Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35846 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdAPVXc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 16:23:32 -0500
Received: by mail-pg0-f66.google.com with SMTP id 75so6142498pgf.3
        for <linux-media@vger.kernel.org>; Mon, 16 Jan 2017 13:23:32 -0800 (PST)
Subject: Re: [PATCH v3 17/24] media: imx: Add CSI subdev driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-18-git-send-email-steve_longerbeam@mentor.com>
 <1484578988.8415.160.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <fa368f78-42f6-6f2f-0761-1f775eb5d707@gmail.com>
Date: Mon, 16 Jan 2017 13:15:27 -0800
MIME-Version: 1.0
In-Reply-To: <1484578988.8415.160.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/16/2017 07:03 AM, Philipp Zabel wrote:
> On Fri, 2017-01-06 at 18:11 -0800, Steve Longerbeam wrote:
>> This is a media entity subdevice for the i.MX Camera
>> Serial Interface module.
> s/Serial/Sensor/

done.

>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>   drivers/staging/media/imx/Kconfig   |  13 +
>>   drivers/staging/media/imx/Makefile  |   2 +
>>   drivers/staging/media/imx/imx-csi.c | 644 ++++++++++++++++++++++++++++++++++++
>>   3 files changed, 659 insertions(+)
>>   create mode 100644 drivers/staging/media/imx/imx-csi.c
>>
>> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
>> index bfde58d..ce2d2c8 100644
>> --- a/drivers/staging/media/imx/Kconfig
>> +++ b/drivers/staging/media/imx/Kconfig
>> @@ -6,3 +6,16 @@ config VIDEO_IMX_MEDIA
>>   	  Say yes here to enable support for video4linux media controller
>>   	  driver for the i.MX5/6 SOC.
>>   
>> +if VIDEO_IMX_MEDIA
>> +menu "i.MX5/6 Media Sub devices"
>> +
>> +config VIDEO_IMX_CAMERA
> s/CAMERA/CSI/ ?

done.

>> +	tristate "i.MX5/6 Camera driver"
> i.MX5/6 Camera Sensor Interface driver

done.

>
>> +
>> +struct csi_priv {
>> +	struct device *dev;
>> +	struct ipu_soc *ipu;
>> +	struct imx_media_dev *md;
>> +	struct v4l2_subdev sd;
>> +	struct media_pad pad[CSI_NUM_PADS];
>> +	struct v4l2_mbus_framefmt format_mbus[CSI_NUM_PADS];
>> +	struct v4l2_mbus_config sensor_mbus_cfg;
>> +	struct v4l2_rect crop;
>> +	struct ipu_csi *csi;
>> +	int csi_id;
>> +	int input_pad;
>> +	int output_pad;
>> +	bool power_on;  /* power is on */
>> +	bool stream_on; /* streaming is on */
>> +
>> +	/* the sink for the captured frames */
>> +	struct v4l2_subdev *sink_sd;
>> +	enum ipu_csi_dest dest;
>> +	struct v4l2_subdev *src_sd;
> src_sd is not used except that its presence marks an enabled input link.
> -> could be changed to bool.

For now I prefer to keep it a pointer to the src/sink subdevs.
At some point the CSI may have some reason to know the
identity of the source.

>
>> +	struct v4l2_ctrl_handler ctrl_hdlr;
>> +	struct imx_media_fim *fim;
>> +
>> +	/* the attached sensor at stream on */
>> +	struct imx_media_subdev *sensor;
>> +};
>> +
>> +static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
>> +{
>> +	return container_of(sdev, struct csi_priv, sd);
>> +}
>> +
>> +/* Update the CSI whole sensor and active windows */
>> +static int csi_setup(struct csi_priv *priv)
>> +{
>> +	struct v4l2_mbus_framefmt infmt;
>> +
>> +	ipu_csi_set_window(priv->csi, &priv->crop);
>> +
>> +	/*
>> +	 * the ipu-csi doesn't understand ALTERNATE, but it only
>> +	 * needs to know whether the stream is interlaced, so set
>> +	 * to INTERLACED if infmt field is ALTERNATE.
>> +	 */
>> +	infmt = priv->format_mbus[priv->input_pad];
>> +	if (infmt.field == V4L2_FIELD_ALTERNATE)
>> +		infmt.field = V4L2_FIELD_INTERLACED;
> That should be SEQ_TB/BT depending on video standard.

fixed.

>> +
>> +static int csi_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>> +	int ret = 0;
>> +
>> +	if (!priv->src_sd || !priv->sink_sd)
>> +		return -EPIPE;
>> +
>> +	v4l2_info(sd, "stream %s\n", enable ? "ON" : "OFF");
> These could be silenced a bit.

yeah, I think it is time for that. I've silenced all the
v4l2_info()'s for stream on/off, power on/off, as well
as some others.

>
>> +static int csi_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>> +	int ret = 0;
>> +
>> +	v4l2_info(sd, "power %s\n", on ? "ON" : "OFF");
>> +
>> +	if (priv->fim && on != priv->power_on)
>> +		ret = imx_media_fim_set_power(priv->fim, on);
>> +
>> +	if (!ret)
>> +		priv->power_on = on;
>> +	return ret;
>> +}
> Is this called multiple times? I'd expect a poweron during open and a
> poweroff during close, so no need for priv->power_on.

It is actually called multiple times. The s_power subdev callbacks are
made every time there is a new link established, in the imx-media core's
link_notify(), in order to re-establish power to the active subdevs in the
new pipeline.

This might change after I look into using v4l2_pipeline_pm_use().

>
>> +static int csi_link_setup(struct media_entity *entity,
>> +			  const struct media_pad *local,
>> +			  const struct media_pad *remote, u32 flags)
>> +{
>> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
>> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>> +	struct v4l2_subdev *remote_sd;
>> +
>> +	dev_dbg(priv->dev, "link setup %s -> %s", remote->entity->name,
>> +		local->entity->name);
>> +
>> +	remote_sd = media_entity_to_v4l2_subdev(remote->entity);
>> +
>> +	if (local->flags & MEDIA_PAD_FL_SINK) {
>> +		if (flags & MEDIA_LNK_FL_ENABLED) {
>> +			if (priv->src_sd)
>> +				return -EBUSY;
>> +			priv->src_sd = remote_sd;
>> +		} else {
>> +			priv->src_sd = NULL;
>> +		}
>> +
>> +		return 0;
>> +	}
>> +
>> +	if (flags & MEDIA_LNK_FL_ENABLED) {
>> +		if (priv->sink_sd)
>> +			return -EBUSY;
>> +		priv->sink_sd = remote_sd;
>> +	} else {
>> +		priv->sink_sd = NULL;
>> +		return 0;
>> +	}
>> +
>> +	/* set CSI destination */
>> +	switch (remote_sd->grp_id) {
>> +	case IMX_MEDIA_GRP_ID_SMFC0:
>> +	case IMX_MEDIA_GRP_ID_SMFC1:
>> +	case IMX_MEDIA_GRP_ID_SMFC2:
>> +	case IMX_MEDIA_GRP_ID_SMFC3:
> With removal of the SMFC entities, CSI0 could be fixed to SMFC0 and CSI1
> to the SMFC2 channel.

right, I'll do that.

>
> [...]
>> +static int csi_set_fmt(struct v4l2_subdev *sd,
>> +		       struct v4l2_subdev_pad_config *cfg,
>> +		       struct v4l2_subdev_format *sdformat)
>> +{
>> +	struct csi_priv *priv = v4l2_get_subdevdata(sd);
>> +	struct v4l2_mbus_framefmt *infmt, *outfmt;
>> +	struct v4l2_rect crop;
>> +	int ret;
>> +
>> +	if (sdformat->pad >= CSI_NUM_PADS)
>> +		return -EINVAL;
>> +
>> +	if (priv->stream_on)
>> +		return -EBUSY;
>> +
>> +	infmt = &priv->format_mbus[priv->input_pad];
>> +	outfmt = &priv->format_mbus[priv->output_pad];
>> +
>> +	if (sdformat->pad == priv->output_pad) {
>> +		sdformat->format.code = infmt->code;
>> +		sdformat->format.field = infmt->field;
>> +		crop.left = priv->crop.left;
>> +		crop.top = priv->crop.top;
>> +		crop.width = sdformat->format.width;
>> +		crop.height = sdformat->format.height;
>> +		ret = csi_try_crop(priv, &crop);
>> +		if (ret)
>> +			return ret;
>> +		sdformat->format.width = crop.width;
>> +		sdformat->format.height = crop.height;
>> +	}
>> +
>> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> Should there be some limitations on the format here?

done, I've added call to v4l_bound_align_image(), passing
it the min/max frame sizes. CSI's sensor/active frame size
register fields are 12 bits, so max is 4096 for both width and
height.


Steve

