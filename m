Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35806 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbaFKP1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 11:27:08 -0400
Message-ID: <1402500426.4107.227.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 39/43] media: Add new camera interface driver for i.MX6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Date: Wed, 11 Jun 2014 17:27:06 +0200
In-Reply-To: <1402178205-22697-40-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-40-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> This is a V4L2 camera interface driver for i.MX6. See
> Documentation/video4linux/mx6_camera.txt.

The CSI and ICs part are not i.MX6 specific. The only difference between
i.MX5 and i.MX6DL (besides register offsets and some minor changes) are
external to the IPU: the input multiplexers and the MIPI CSI-2 support.

Can you split the mipi-csi2 driver into a separate patch?

> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> ---
>  Documentation/video4linux/mx6_camera.txt         |  188 ++
>  drivers/staging/media/Kconfig                    |    2 +
>  drivers/staging/media/Makefile                   |    1 +
>  drivers/staging/media/imx6/Kconfig               |   25 +
>  drivers/staging/media/imx6/Makefile              |    1 +
>  drivers/staging/media/imx6/capture/Kconfig       |   11 +
>  drivers/staging/media/imx6/capture/Makefile      |    4 +
>  drivers/staging/media/imx6/capture/mipi-csi2.c   |  322 ++++
>  drivers/staging/media/imx6/capture/mx6-camif.c   | 2235 ++++++++++++++++++++++
>  drivers/staging/media/imx6/capture/mx6-camif.h   |  197 ++

>  drivers/staging/media/imx6/capture/mx6-encode.c  |  775 ++++++++
>  drivers/staging/media/imx6/capture/mx6-preview.c |  748 ++++++++

Except for the v4l2_controls, these two drivers are nearly the same. The
same is true for the encoder/preview helper functions in mx6-camif.c.

To me it seems that it would be better to handle the IC as its own
v4l2_subdev supporting the encoder and preview roles, use the media
controller API to handle the connections between CSI/SMFC/IC, and have a
single CSI v4l2_subdev for each CSI instead of duplicating the same code
with minor differences.

[...]
> +static void __mx6csi2_enable(struct mx6csi2_dev *csi2, bool enable)
> +{
> +	if (enable) {
> +		mx6csi2_write(csi2, 0xffffffff, CSI2_PHY_SHUTDOWNZ);
> +		mx6csi2_write(csi2, 0xffffffff, CSI2_DPHY_RSTZ);
> +		mx6csi2_write(csi2, 0xffffffff, CSI2_RESETN);

I know the Freescale does this, but according to the documentation only
the LSB is the reset/shutdown bit. Doesn't writing 0x1 work here?

> +	} else {
> +		mx6csi2_write(csi2, 0x0, CSI2_PHY_SHUTDOWNZ);
> +		mx6csi2_write(csi2, 0x0, CSI2_DPHY_RSTZ);
> +		mx6csi2_write(csi2, 0x0, CSI2_RESETN);
> +	}
> +}
> +
> +static void mx6csi2_reset(struct mx6csi2_dev *csi2)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&csi2->lock, flags);
> +
> +	__mx6csi2_enable(csi2, false);
> +
> +	mx6csi2_write(csi2, 0x00000001, CSI2_PHY_TST_CTRL0);
> +	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL1);
> +	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	mx6csi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	mx6csi2_write(csi2, 0x00010044, CSI2_PHY_TST_CTRL1);
> +	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);
> +	mx6csi2_write(csi2, 0x00000014, CSI2_PHY_TST_CTRL1);
> +	mx6csi2_write(csi2, 0x00000002, CSI2_PHY_TST_CTRL0);
> +	mx6csi2_write(csi2, 0x00000000, CSI2_PHY_TST_CTRL0);

A comment documenting that this writes 0x14 to D-PHY register 0x44 using
the 8-bit test interface would be nice. Even nicer would be to know what
this actually does, but I don't have the D-PHY documentation.

Or how about
#define PHY_CTRL0_TESTCLR            BIT(0)
#define PHY_CTRL0_TESTCLK            BIT(1)
#define PHY_CTRL1_TESTEN             BIT(16)

> +	__mx6csi2_enable(csi2, true);
> +
> +	spin_unlock_irqrestore(&csi2->lock, flags);
> +}
> +
> +static int mx6csi2_dphy_wait(struct mx6csi2_dev *csi2)
> +{
> +	u32 reg;
> +	int i;
> +
> +	/* wait for mipi sensor ready */
> +	for (i = 0; i < 50; i++) {
> +		reg = mx6csi2_read(csi2, CSI2_PHY_STATE);
> +		if (reg != 0x200)
> +			break;
> +		usleep_range(10000, 10001);

This is very specific. I'd use a broader range here.

[...]
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	if (!res || csi2->intr1 < 0 || csi2->intr2 < 0) {
> +		v4l2_err(&csi2->sd, "failed to get platform resources\n");
> +		return -ENODEV;
> +	}
> +
> +	csi2->base = devm_ioremap(&pdev->dev, res->start, PAGE_SIZE);
> +	if (!csi2->base) {
> +		v4l2_err(&csi2->sd, "failed to map CSI-2 registers\n");
> +		return -ENOMEM;
> +	}

This can be shortened with devm_ioremap_resource, which also already
handles the error message.

[...]
> +/*
> + * Turn current sensor power on/off according to power_count.
> + */
> +static int sensor_set_power(struct mx6cam_dev *dev, int on)
> +{
> +	struct mx6cam_endpoint *ep = dev->ep;
> +	struct v4l2_subdev *sd = ep->sd;
> +	int ret;
> +
> +	if (on && ep->power_count++ > 0)
> +		return 0;
> +	else if (!on && (ep->power_count == 0 || --ep->power_count > 0))
> +		return 0;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, on);
> +	return ret != -ENOIOCTLCMD ? ret : 0;
> +}

All of this assumes a single sensor device connected to the CSI
endpoint. If there are further multiplexers, FPGA devices, or other
encoders in the chain, this will only power up the last element.

[...]
> +static int vidioc_g_input(struct file *file, void *priv, unsigned int *index)
> +static int vidioc_s_input(struct file *file, void *priv, unsigned int index)

These also limit the input path to a very simple linear list of options.
Any use case a bit more complicated than single sensors each connected
directly to parallel CSI or MIPI CSI-2 ports can't be described by this.

Granted, the most complicated cases I've seen in the wild so far are
either two cameras and an external multiplexer on the same parallel bus
and a single FPGA with two outputs connected to both CSIs. Still, using
the media controller API here would be much more future proof. Imagine,
for example, eight MIPI CSI-2 cameras connected to a CSI-2 multiplexer
and that connected to the i.MX6 CSI2 input.

> +static int vidioc_querybuf(struct file *file, void *priv,
[...]
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct mx6cam_ctx *ctx = file2ctx(file);
> +	struct vb2_queue *vq = &ctx->dev->buffer_queue;
> +
> +	if (!ctx->io_allowed)
> +		return -EBUSY;
> +
> +	return vb2_qbuf(vq, buf);
> +}

What is up the the io_allowed handling here? If not for that, you could
just use the vb2_ioctl_* helpers for a lot of these.

[...]

> +static unsigned int mx6cam_poll(struct file *file,
> +				 struct poll_table_struct *wait)

vb2_fop_poll

> +static int mx6cam_mmap(struct file *file, struct vm_area_struct *vma)

vb2_fop_mmap

[...]
> +static int mx6cam_add_csi2_receiver(struct mx6cam_dev *dev)
> +{
> +	struct platform_device *pdev;
> +	struct device_node *node;
> +	int ret = -EPROBE_DEFER;
> +
> +	node = of_find_compatible_node(NULL, NULL, "fsl,imx6-mipi-csi2");
> +	if (!node)
> +		return 0;

Why not connect the mipi-csi2 node to the ipu csi input port via OF
graph bindings?

> +/* parse inputs property from v4l2_of_endpoint node */
> +static int mx6cam_parse_inputs(struct mx6cam_dev *dev,
> +			       struct device_node *node,
> +			       int next_input,
> +			       struct mx6cam_endpoint *ep)
> +{
> +	struct mx6cam_sensor_input *epinput = &ep->sensor_input;
> +	int ret, i;
> +
> +	for (i = 0; i < MX6CAM_MAX_INPUTS; i++) {
> +		const char *input_name;
> +		u32 val;
> +
> +		ret = of_property_read_u32_index(node, "inputs", i, &val);
> +		if (ret)
> +			break;
> +
> +		epinput->value[i] = val;
> +
> +		ret = of_property_read_string_index(node, "input-names", i,
> +						    &input_name);
> +		if (!ret)
> +			strncpy(epinput->name[i], input_name,
> +				sizeof(epinput->name[i]));
> +		else
> +			snprintf(epinput->name[i], sizeof(epinput->name[i]),
> +				 "%s-%d", ep->sd->name, i);
> +
> +		val = 0;
> +		ret = of_property_read_u32_index(node, "input-caps", i, &val);
> +		epinput->caps[i] = val;
> +	}
> +
> +	epinput->num = i;
> +
> +	/* if no inputs provided just assume a single input */
> +	if (epinput->num == 0) {
> +		epinput->num = 1;
> +		epinput->caps[0] = 0;
> +		strncpy(epinput->name[0], ep->sd->name,
> +			sizeof(epinput->name[0]));
> +	}
> +
> +	epinput->first = next_input;
> +	epinput->last = next_input + epinput->num - 1;
> +	return epinput->last + 1;
> +}

I don't see why this is necessary when all possible input paths
are already described via the OF graph bindings.

regards
Philipp

