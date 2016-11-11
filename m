Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45472 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755503AbcKKNjO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 08:39:14 -0500
Subject: Re: [PATCH 5/5] media: platform: rcar_drif: Add DRIF support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, crope@iki.fi
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9b772894-f6ef-d5ad-4601-735f2321ce0c@xs4all.nl>
Date: Fri, 11 Nov 2016 14:38:40 +0100
MIME-Version: 1.0
In-Reply-To: <1478706284-59134-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/2016 04:44 PM, Ramesh Shanmugasundaram wrote:
> This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3 SoCs.
> The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF
> device represents a channel and each channel can have one or two
> sub-channels respectively depending on the target board.
> 
> DRIF supports only Rx functionality. It receives samples from a RF
> frontend tuner chip it is interfaced with. The combination of DRIF and the
> tuner device, which is registered as a sub-device, determines the receive
> sample rate and format.
> 
> In order to be compliant as a V4L2 SDR device, DRIF needs to bind with
> the tuner device, which can be provided by a third party vendor. DRIF acts
> as a slave device and the tuner device acts as a master transmitting the
> samples. The driver allows asynchronous binding of a tuner device that
> is registered as a v4l2 sub-device. The driver can learn about the tuner
> it is interfaced with based on port endpoint properties of the device in
> device tree. The V4L2 SDR device inherits the controls exposed by the
> tuner device.
> 
> The device can also be configured to use either one or both of the data
> pins at runtime based on the master (tuner) configuration.
> 
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  .../devicetree/bindings/media/renesas,drif.txt     |  136 ++
>  drivers/media/platform/Kconfig                     |   25 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/rcar_drif.c                 | 1574 ++++++++++++++++++++
>  4 files changed, 1736 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,drif.txt
>  create mode 100644 drivers/media/platform/rcar_drif.c
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt b/Documentation/devicetree/bindings/media/renesas,drif.txt
> new file mode 100644
> index 0000000..d65368a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> @@ -0,0 +1,136 @@
> +Renesas R-Car Gen3 Digital Radio Interface controller (DRIF)
> +------------------------------------------------------------
> +
> +R-Car Gen3 DRIF is a serial slave device. It interfaces with a master
> +device as shown below
> +
> ++---------------------+                +---------------------+
> +|                     |-----SCK------->|CLK                  |
> +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> +|                     |-----SD0------->|D0                   |
> +|                     |-----SD1------->|D1                   |
> ++---------------------+                +---------------------+
> +
> +Each DRIF channel (drifn) consists of two sub-channels (drifn0 & drifn1).
> +The sub-channels are like two individual channels in itself that share the
> +common CLK & SYNC. Each sub-channel has it's own dedicated resources like
> +irq, dma channels, address space & clock.
> +
> +The device tree model represents the channel and each of it's sub-channel
> +as a separate node. The parent channel ties the sub-channels together with
> +their phandles.
> +
> +Required properties of a sub-channel:
> +-------------------------------------
> +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of R8A7795 SoC.
> +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible device.
> +	      When compatible with the generic version, nodes must list the
> +	      SoC-specific version corresponding to the platform first
> +	      followed by the generic version.
> +- reg: offset and length of that sub-channel.
> +- interrupts: associated with that sub-channel.
> +- clocks: phandle and clock specifier of that sub-channel.
> +- clock-names: clock input name string: "fck".
> +- dmas: phandles to the DMA channel of that sub-channel.
> +- dma-names: names of the DMA channel: "rx".
> +
> +Optional properties of a sub-channel:
> +-------------------------------------
> +- power-domains: phandle to the respective power domain.
> +
> +Required properties of a channel:
> +---------------------------------
> +- pinctrl-0: pin control group to be used for this channel.
> +- pinctrl-names: must be "default".
> +- sub-channels : phandles to the two sub-channels.
> +
> +Optional properties of a channel:
> +---------------------------------
> +- port: child port node of a channel that defines the local and remote
> +        endpoints. The remote endpoint is assumed to be a tuner subdevice
> +	endpoint.
> +- renesas,syncmd       : sync mode
> +			 0 (Frame start sync pulse mode. 1-bit width pulse
> +			    indicates start of a frame)
> +			 1 (L/R sync or I2S mode) (default)
> +- renesas,lsb-first    : empty property indicates lsb bit is received first.
> +			 When not defined msb bit is received first (default)
> +- renesas,syncac-pol-high  : empty property indicates sync signal polarity.
> +			 When defined, active high or high->low sync signal.
> +			 When not defined, active low or low->high sync signal
> +			 (default)
> +- renesas,dtdl         : delay between sync signal and start of reception.
> +			 Must contain one of the following values:
> +			 0   (no bit delay)
> +			 50  (0.5-clock-cycle delay)
> +			 100 (1-clock-cycle delay) (default)
> +			 150 (1.5-clock-cycle delay)
> +			 200 (2-clock-cycle delay)
> +- renesas,syncdl       : delay between end of reception and sync signal edge.
> +			 Must contain one of the following values:
> +			 0   (no bit delay) (default)
> +			 50  (0.5-clock-cycle delay)
> +			 100 (1-clock-cycle delay)
> +			 150 (1.5-clock-cycle delay)
> +			 200 (2-clock-cycle delay)
> +			 300 (3-clock-cycle delay)
> +
> +Example
> +--------
> +
> +SoC common dtsi file
> +
> +		drif00: rif@e6f40000 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			reg = <0 0xe6f40000 0 0x64>;
> +			interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 515>;
> +			clock-names = "fck";
> +			dmas = <&dmac1 0x20>, <&dmac2 0x20>;
> +			dma-names = "rx", "rx";
> +			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> +			status = "disabled";
> +		};
> +
> +		drif01: rif@e6f50000 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			reg = <0 0xe6f50000 0 0x64>;
> +			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&cpg CPG_MOD 514>;
> +			clock-names = "fck";
> +			dmas = <&dmac1 0x22>, <&dmac2 0x22>;
> +			dma-names = "rx", "rx";
> +			power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
> +			status = "disabled";
> +		};
> +
> +		drif0: rif@0 {
> +			compatible = "renesas,r8a7795-drif",
> +				     "renesas,rcar-gen3-drif";
> +			sub-channels = <&drif00>, <&drif01>;
> +			status = "disabled";
> +		};
> +
> +Board specific dts file
> +
> +&drif00 {
> +	status = "okay";
> +};
> +
> +&drif01 {
> +	status = "okay";
> +};
> +
> +&drif0 {
> +	pinctrl-0 = <&drif0_pins>;
> +	pinctrl-names = "default";
> +	renesas,syncac-pol-high;
> +	status = "okay";
> +	port {
> +		drif0_ep: endpoint {
> +		     remote-endpoint = <&tuner_subdev_ep>;
> +		};
> +	};
> +};
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 754edbf1..0ae83a8 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -393,3 +393,28 @@ menuconfig DVB_PLATFORM_DRIVERS
>  if DVB_PLATFORM_DRIVERS
>  source "drivers/media/platform/sti/c8sectpfe/Kconfig"
>  endif #DVB_PLATFORM_DRIVERS
> +
> +menuconfig SDR_PLATFORM_DRIVERS
> +	bool "SDR platform devices"
> +	depends on MEDIA_SDR_SUPPORT
> +	default n
> +	---help---
> +	  Say Y here to enable support for platform-specific SDR Drivers.
> +
> +if SDR_PLATFORM_DRIVERS
> +
> +config VIDEO_RCAR_DRIF
> +	tristate "Renesas Digitial Radio Interface (DRIF)"
> +	depends on VIDEO_V4L2 && HAS_DMA
> +	depends on ARCH_RENESAS
> +	select VIDEOBUF2_VMALLOC
> +	---help---
> +	  Say Y if you want to enable R-Car Gen3 DRIF support. DRIF is Digital
> +	  Radio Interface that interfaces with an RF front end chip. It is a
> +	  receiver of digital data which uses DMA to transfer received data to
> +	  a configured location for an application to use.
> +
> +	  To compile this driver as a module, choose M here; the module
> +	  will be called rcar_drif.
> +
> +endif # SDR_PLATFORM_DRIVERS
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index f842933..49ce238 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -49,6 +49,7 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
>  
>  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
>  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
> +obj-$(CONFIG_VIDEO_RCAR_DRIF)		+= rcar_drif.o
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
>  obj-y	+= omap/
> diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
> new file mode 100644
> index 0000000..34dc282
> --- /dev/null
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -0,0 +1,1574 @@

<snip>

+#define for_each_rcar_drif_subdev(sd, tmp, ch)				\
+	list_for_each_entry_safe(sd, tmp, &ch->v4l2_dev.subdevs, list)
+

Please don't use this. media/v4l2-device.h has a bunch of similar functions
for this. Use those instead.

<snip>

> +static int rcar_drif_querycap(struct file *file, void *fh,
> +			      struct v4l2_capability *cap)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, ch->vdev.name, sizeof(cap->card));
> +	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
> +				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Set device_caps in struct video_device and drop it here.

The core will fill in cap->device_caps and cap->capabilities for you.

> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		 ch->vdev.name);
> +	return 0;
> +}
> +
> +static int rcar_drif_set_default_format(struct rcar_drif_chan *ch)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		/* Find any matching fmt and set it as default */
> +		if (ch->num_hw_schans == formats[i].num_schans) {
> +			ch->fmt_idx = i;
> +			ch->cur_schans_mask = ch->hw_schans_mask;
> +			ch->num_cur_schans = ch->num_hw_schans;
> +			dev_dbg(ch->dev, "default fmt[%u]: mask %lu num %u\n",
> +				i, ch->cur_schans_mask, ch->num_cur_schans);
> +			return 0;
> +		}
> +	}
> +	dev_err(ch->dev, "no matching sdr fmt found\n");
> +	return -EINVAL;
> +}
> +
> +static int rcar_drif_enum_fmt_sdr_cap(struct file *file, void *priv,
> +				      struct v4l2_fmtdesc *f)
> +{
> +	if (f->index >= NUM_FORMATS)
> +		return -EINVAL;
> +
> +	strlcpy(f->description, formats[f->index].name, sizeof(f->description));

Drop this. The core fills that in for you.

> +	f->pixelformat = formats[f->index].pixelformat;
> +	return 0;
> +}
> +
> +static int rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,
> +				   struct v4l2_format *f)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +
> +	f->fmt.sdr.pixelformat = formats[ch->fmt_idx].pixelformat;
> +	f->fmt.sdr.buffersize = formats[ch->fmt_idx].buffersize;
> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> +	return 0;
> +}
> +
> +static int rcar_drif_s_fmt_sdr_cap(struct file *file, void *priv,
> +				   struct v4l2_format *f)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct vb2_queue *q = &ch->vb_queue;
> +	unsigned int i;
> +
> +	if (vb2_is_busy(q))
> +		return -EBUSY;
> +
> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
> +			ch->fmt_idx  = i;
> +			f->fmt.sdr.buffersize = formats[i].buffersize;
> +
> +			/*
> +			 * If a format demands one sub-channel only out of two
> +			 * enabled sub-channels then pick the 0th sub-channel
> +			 */
> +			if (formats[i].num_schans < ch->num_hw_schans) {
> +				ch->cur_schans_mask = BIT(0);	/* Enable D0 */
> +				ch->num_cur_schans = formats[i].num_schans;
> +			} else {
> +				ch->cur_schans_mask = ch->hw_schans_mask;
> +				ch->num_cur_schans = ch->num_hw_schans;
> +			}
> +
> +			rdrif_dbg(1, ch, "cur: idx %u mask %lu num %u\n",
> +				  i, ch->cur_schans_mask, ch->num_cur_schans);
> +			return 0;
> +		}
> +	}
> +
> +	if (rcar_drif_set_default_format(ch))
> +		return -EINVAL;
> +
> +	f->fmt.sdr.pixelformat = formats[ch->fmt_idx].pixelformat;
> +	f->fmt.sdr.buffersize = formats[ch->fmt_idx].buffersize;
> +	return 0;
> +}
> +
> +static int rcar_drif_try_fmt_sdr_cap(struct file *file, void *priv,
> +				     struct v4l2_format *f)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	unsigned int i;
> +
> +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
> +			f->fmt.sdr.buffersize = formats[i].buffersize;
> +			return 0;
> +		}
> +	}
> +
> +	f->fmt.sdr.pixelformat = formats[ch->fmt_idx].pixelformat;
> +	f->fmt.sdr.buffersize = formats[ch->fmt_idx].buffersize;
> +	return 0;
> +}
> +
> +/* Tuner subdev ioctls */
> +static int rcar_drif_enum_freq_bands(struct file *file, void *priv,
> +				     struct v4l2_frequency_band *band)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret = 0;
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_subdev_call(sd, tuner, enum_freq_bands, band);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static int rcar_drif_g_frequency(struct file *file, void *priv,
> +				 struct v4l2_frequency *f)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret = 0;
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_subdev_call(sd, tuner, g_frequency, f);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static int rcar_drif_s_frequency(struct file *file, void *priv,
> +				 const struct v4l2_frequency *f)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret = 0;
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_subdev_call(sd, tuner, s_frequency, f);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static int rcar_drif_g_tuner(struct file *file, void *priv,
> +			     struct v4l2_tuner *vt)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret = 0;
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_subdev_call(sd, tuner, g_tuner, vt);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static int rcar_drif_s_tuner(struct file *file, void *priv,
> +			     const struct v4l2_tuner *vt)
> +{
> +	struct rcar_drif_chan *ch = video_drvdata(file);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret = 0;
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_subdev_call(sd, tuner, s_tuner, vt);
> +		if (ret)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static const struct v4l2_ioctl_ops rcar_drif_ioctl_ops = {
> +	.vidioc_querycap          = rcar_drif_querycap,
> +
> +	.vidioc_enum_fmt_sdr_cap  = rcar_drif_enum_fmt_sdr_cap,
> +	.vidioc_g_fmt_sdr_cap     = rcar_drif_g_fmt_sdr_cap,
> +	.vidioc_s_fmt_sdr_cap     = rcar_drif_s_fmt_sdr_cap,
> +	.vidioc_try_fmt_sdr_cap   = rcar_drif_try_fmt_sdr_cap,
> +
> +	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf       = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf          = vb2_ioctl_querybuf,
> +	.vidioc_qbuf              = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
> +
> +	.vidioc_streamon          = vb2_ioctl_streamon,
> +	.vidioc_streamoff         = vb2_ioctl_streamoff,
> +
> +	.vidioc_s_frequency       = rcar_drif_s_frequency,
> +	.vidioc_g_frequency       = rcar_drif_g_frequency,
> +	.vidioc_s_tuner		  = rcar_drif_s_tuner,
> +	.vidioc_g_tuner		  = rcar_drif_g_tuner,
> +	.vidioc_enum_freq_bands   = rcar_drif_enum_freq_bands,
> +	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +	.vidioc_log_status        = v4l2_ctrl_log_status,
> +};
> +
> +static const struct v4l2_file_operations rcar_drif_fops = {
> +	.owner                    = THIS_MODULE,
> +	.open                     = v4l2_fh_open,
> +	.release                  = vb2_fop_release,
> +	.read                     = vb2_fop_read,
> +	.poll                     = vb2_fop_poll,
> +	.mmap                     = vb2_fop_mmap,
> +	.unlocked_ioctl           = video_ioctl2,
> +};
> +
> +static struct video_device rcar_drif_vdev = {
> +	.name                     = "R-Car DRIF",
> +	.release                  = video_device_release_empty,
> +	.fops                     = &rcar_drif_fops,
> +	.ioctl_ops                = &rcar_drif_ioctl_ops,
> +};
> +
> +static int rcar_drif_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct rcar_drif_chan *ch =
> +		container_of(notifier, struct rcar_drif_chan, notifier);
> +
> +	/* Nothing to do at this point */
> +	rdrif_dbg(2, ch, "bound asd: %s\n", asd->match.of.node->name);
> +	return 0;
> +}
> +
> +/* Sub-device registered notification callback */
> +static int rcar_drif_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct rcar_drif_chan *ch =
> +		container_of(notifier, struct rcar_drif_chan, notifier);
> +	struct v4l2_subdev *sd, *tmp;
> +	int ret;
> +
> +	v4l2_ctrl_handler_init(&ch->ctrl_hdl, 10);
> +	ch->v4l2_dev.ctrl_handler = &ch->ctrl_hdl;
> +
> +	ret = v4l2_device_register_subdev_nodes(&ch->v4l2_dev);
> +	if (ret) {
> +		rdrif_err(ch, "failed register subdev nodes ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	for_each_rcar_drif_subdev(sd, tmp, ch) {
> +		ret = v4l2_ctrl_add_handler(ch->v4l2_dev.ctrl_handler,
> +					    sd->ctrl_handler, NULL);
> +		if (ret) {
> +			rdrif_err(ch, "failed ctrl add hdlr ret %d\n", ret);
> +			return ret;
> +		}
> +	}
> +	rdrif_dbg(2, ch, "notify complete\n");
> +	return 0;
> +}
> +
> +/* Parse sub-devs (tuner) to find a matching device */
> +static int rcar_drif_parse_subdevs(struct device *dev,
> +				   struct v4l2_async_notifier *notifier)
> +{
> +	struct device_node *node = NULL;
> +
> +	notifier->subdevs = devm_kzalloc(dev, sizeof(*notifier->subdevs),
> +					 GFP_KERNEL);
> +	if (!notifier->subdevs)
> +		return -ENOMEM;
> +
> +	node = of_graph_get_next_endpoint(dev->of_node, node);

Do:

	if (!node)
		return 0;

And the remainder can be shifted one tab to the left.

> +	if (node) {
> +		struct rcar_drif_async_subdev *rsd;
> +
> +		rsd = devm_kzalloc(dev, sizeof(*rsd), GFP_KERNEL);
> +		if (!rsd) {
> +			of_node_put(node);
> +			return -ENOMEM;
> +		}
> +
> +		notifier->subdevs[notifier->num_subdevs] = &rsd->asd;
> +		rsd->asd.match.of.node = of_graph_get_remote_port_parent(node);
> +		of_node_put(node);
> +		if (!rsd->asd.match.of.node) {
> +			dev_warn(dev, "bad remote port parent\n");
> +			return -EINVAL;
> +		}
> +
> +		rsd->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		notifier->num_subdevs++;
> +	}
> +	return 0;
> +}
> +
> +/* SIRMDR1 configuration */
> +static int rcar_drif_validate_syncmd(struct rcar_drif_chan *ch, u32 val)
> +{
> +	if (val > 1) {
> +		dev_err(ch->dev, "invalid syncmd %u using L/R mode\n", val);
> +		return -EINVAL;
> +	}
> +
> +	ch->mdr1 &= ~(3 << 28);	/* Clear current settings */
> +	if (val == 0)
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_SYNCMD_FRAME;
> +	else
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_SYNCMD_LR;
> +	return 0;
> +}
> +
> +/* Get the dtdl or syncdl bits as in MSIOF */
> +static u32 rcar_drif_get_dtdl_or_syncdl_bits(u32 dtdl_or_syncdl)
> +{
> +	/*
> +	 * DTDL/SYNCDL bit	: dtdl/syncdl
> +	 * b'000		: 0
> +	 * b'001		: 100
> +	 * b'010		: 200
> +	 * b'011 (SYNCDL only)	: 300
> +	 * b'101		: 50
> +	 * b'110		: 150
> +	 */
> +	if (dtdl_or_syncdl % 100)
> +		return dtdl_or_syncdl / 100 + 5;
> +	else

Line can be dropped.

> +		return dtdl_or_syncdl / 100;
> +}
> +
> +static int rcar_drif_validate_dtdl_syncdl(struct rcar_drif_chan *ch)
> +{
> +	struct device_node *np = ch->dev->of_node;
> +	u32 dtdl = 100, syncdl = 0;
> +
> +	ch->mdr1 |= RCAR_DRIF_SIRMDR1_DTDL_1 | RCAR_DRIF_SIRMDR1_SYNCDL_0;
> +	of_property_read_u32(np, "renesas,dtdl", &dtdl);
> +	of_property_read_u32(np, "renesas,syncdl", &syncdl);
> +
> +	/* Sanity checks */
> +	if (dtdl > 200 || syncdl > 300) {
> +		dev_err(ch->dev, "invalid dtdl %u/syncdl %u\n", dtdl, syncdl);
> +		return -EINVAL;
> +	}
> +	if ((dtdl + syncdl) % 100) {
> +		dev_err(ch->dev, "sum of dtdl %u & syncdl %u not OK\n",
> +			dtdl, syncdl);
> +		return -EINVAL;
> +	}
> +	ch->mdr1 &= ~(7 << 20) & ~(7 << 16);	/* Clear current settings */
> +	ch->mdr1 |= rcar_drif_get_dtdl_or_syncdl_bits(dtdl) << 20;
> +	ch->mdr1 |= rcar_drif_get_dtdl_or_syncdl_bits(syncdl) << 16;
> +	return 0;
> +}
> +
> +static int rcar_drif_parse_properties(struct rcar_drif_chan *ch)
> +{
> +	struct device_node *np = ch->dev->of_node;
> +	u32 syncmd;
> +	int ret;
> +
> +	/* Set the defaults and check for overrides */
> +	ch->mdr1 = RCAR_DRIF_SIRMDR1_SYNCMD_LR;
> +	if (!of_property_read_u32(np, "renesas,syncmd", &syncmd)) {
> +		ret = rcar_drif_validate_syncmd(ch, syncmd);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (of_find_property(np, "renesas,lsb-first", NULL))
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_LSB_FIRST;
> +	else
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_MSB_FIRST;
> +
> +	if (of_find_property(np, "renesas,syncac-pol-high", NULL))
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_SYNCAC_POL_HIGH;
> +	else
> +		ch->mdr1 |= RCAR_DRIF_SIRMDR1_SYNCAC_POL_LOW;
> +
> +	return rcar_drif_validate_dtdl_syncdl(ch);
> +}
> +
> +static u32 rcar_drif_enum_sub_channels(struct platform_device *pdev,
> +					struct platform_device *s_pdev[])
> +{
> +	struct device_node *s_np;
> +	u32 hw_schans_mask = 0;
> +	unsigned int i;
> +
> +	for (i = 0; i < RCAR_DRIF_MAX_SUBCHANS; i++) {
> +		s_np = of_parse_phandle(pdev->dev.of_node, "sub-channels", i);
> +		if (s_np && of_device_is_available(s_np)) {
> +			s_pdev[i] = of_find_device_by_node(s_np);
> +			if (s_pdev[i]) {
> +				hw_schans_mask |= BIT(i);
> +				dev_dbg(&s_pdev[i]->dev, "schan%u ok\n", i);
> +			}
> +		}
> +	}
> +	return hw_schans_mask;
> +}
> +
> +static int rcar_drif_probe(struct platform_device *pdev)
> +{
> +	struct platform_device *s_pdev[RCAR_DRIF_MAX_SUBCHANS];
> +	unsigned long hw_schans_mask;
> +	struct rcar_drif_chan *ch;
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * Sub-channel resources are managed by the parent channel instance.
> +	 * The sub-channel instance helps only in registering with power domain
> +	 * to aid in run-time pm support
> +	 */
> +	if (!of_find_property(pdev->dev.of_node, "sub-channels", NULL))
> +		return 0;
> +
> +	/* Parent channel instance */
> +	hw_schans_mask = rcar_drif_enum_sub_channels(pdev, s_pdev);
> +	if (!hw_schans_mask) {
> +		dev_err(&pdev->dev, "no sub-channels enabled\n");
> +		return -ENODEV;
> +	}
> +
> +
> +	/* Reserve memory for driver structure */
> +	ch = devm_kzalloc(&pdev->dev, sizeof(*ch), GFP_KERNEL);
> +	if (!ch) {
> +		ret = PTR_ERR(ch);
> +		dev_err(&pdev->dev, "failed alloc drif context\n");
> +		return ret;
> +	}
> +	ch->dev = &pdev->dev;
> +
> +	/* Parse device tree optional properties */
> +	ret = rcar_drif_parse_properties(ch);
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(ch->dev, "parsed mdr1 0x%08x\n", ch->mdr1);
> +
> +	/* Setup enabled sub-channels */
> +	for_each_rcar_drif_subchannel(i, &hw_schans_mask) {
> +		struct clk *clkp;
> +		struct resource	*res;
> +		void __iomem *base;
> +
> +		/* Peripheral clock */
> +		clkp = devm_clk_get(&s_pdev[i]->dev, "fck");
> +		if (IS_ERR(clkp)) {
> +			ret = PTR_ERR(clkp);
> +			dev_err(&s_pdev[i]->dev, "clk get failed (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		/* Register map */
> +		res = platform_get_resource(s_pdev[i], IORESOURCE_MEM, 0);
> +		base = devm_ioremap_resource(&s_pdev[i]->dev, res);
> +		if (IS_ERR(base)) {
> +			ret = PTR_ERR(base);
> +			dev_err(&s_pdev[i]->dev, "ioremap failed (%d)\n", ret);
> +			return ret;
> +		}
> +
> +		/* Reserve memory for enabled sub-channel */
> +		ch->sch[i] = devm_kzalloc(&pdev->dev, sizeof(*ch->sch[i]),
> +					  GFP_KERNEL);
> +		if (!ch->sch[i]) {
> +			ret = PTR_ERR(ch);
> +			dev_err(&s_pdev[i]->dev, "failed alloc sub-channel\n");
> +			return ret;
> +		}
> +		ch->sch[i]->pdev = s_pdev[i];
> +		ch->sch[i]->clkp = clkp;
> +		ch->sch[i]->base = base;
> +		ch->sch[i]->num = i;
> +		ch->sch[i]->start = res->start;
> +		ch->sch[i]->parent = ch;
> +		ch->num_hw_schans++;
> +	}
> +	ch->hw_schans_mask = hw_schans_mask;
> +
> +	/* Validate any supported format for enabled sub-channels */
> +	ret = rcar_drif_set_default_format(ch);
> +	if (ret)
> +		return ret;
> +
> +	/* Set defaults */
> +	ch->num_hwbufs = RCAR_DRIF_DEFAULT_NUM_HWBUFS;
> +	ch->hwbuf_size = RCAR_DRIF_DEFAULT_HWBUF_SIZE;
> +
> +	mutex_init(&ch->v4l2_mutex);
> +	mutex_init(&ch->vb_queue_mutex);
> +	spin_lock_init(&ch->queued_bufs_lock);
> +	INIT_LIST_HEAD(&ch->queued_bufs);
> +
> +	/* Init videobuf2 queue structure */
> +	ch->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> +	ch->vb_queue.io_modes = VB2_READ | VB2_MMAP | VB2_DMABUF;
> +	ch->vb_queue.drv_priv = ch;
> +	ch->vb_queue.buf_struct_size = sizeof(struct rcar_drif_frame_buf);
> +	ch->vb_queue.ops = &rcar_drif_vb2_ops;
> +	ch->vb_queue.mem_ops = &vb2_vmalloc_memops;
> +	ch->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +
> +	/* Init videobuf2 queue */
> +	ret = vb2_queue_init(&ch->vb_queue);
> +	if (ret) {
> +		dev_err(ch->dev, "could not initialize vb2 queue\n");
> +		return ret;
> +	}
> +
> +	/* Init video_device structure */
> +	ch->vdev = rcar_drif_vdev;

Don't embed video_device, use video_device_alloc instead. A lot of drivers
embed this, but it turns out not to be a good idea. So new drivers should
use video_device_alloc.

> +	ch->vdev.lock = &ch->v4l2_mutex;
> +	ch->vdev.queue = &ch->vb_queue;
> +	ch->vdev.queue->lock = &ch->vb_queue_mutex;
> +	ch->vdev.ctrl_handler = &ch->ctrl_hdl;
> +	video_set_drvdata(&ch->vdev, ch);
> +
> +	/* Register the v4l2_device */
> +	ret = v4l2_device_register(&pdev->dev, &ch->v4l2_dev);
> +	if (ret) {
> +		dev_err(ch->dev, "failed v4l2_device_register. ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	ch->vdev.v4l2_dev = &ch->v4l2_dev;
> +
> +	/*
> +	 * Parse subdevs after v4l2_device_register because if the subdev
> +	 * is already probed, bound and complete will be called immediately
> +	 */
> +	ret = rcar_drif_parse_subdevs(&pdev->dev, &ch->notifier);
> +	if (ret)
> +		goto err_unreg_v4l2;
> +
> +	ch->notifier.bound = rcar_drif_notify_bound;
> +	ch->notifier.complete = rcar_drif_notify_complete;
> +
> +	/* Register notifier */
> +	ret = v4l2_async_notifier_register(&ch->v4l2_dev, &ch->notifier);
> +	if (ret < 0) {
> +		dev_err(ch->dev, "notifier registration failed\n");
> +		goto err_unreg_v4l2;
> +	}
> +
> +	/* Register SDR device */
> +	ret = video_register_device(&ch->vdev, VFL_TYPE_SDR, -1);
> +	if (ret) {
> +		dev_err(ch->dev, "failed video_register_device. ret %d\n", ret);
> +		goto err_unreg_notif;
> +	}
> +
> +	platform_set_drvdata(pdev, ch);
> +	dev_notice(ch->dev, "probed\n");
> +	return 0;
> +
> +err_unreg_notif:
> +	v4l2_async_notifier_unregister(&ch->notifier);
> +err_unreg_v4l2:
> +	v4l2_device_unregister(&ch->v4l2_dev);
> +	return ret;
> +}
> +
> +static int rcar_drif_remove(struct platform_device *pdev)
> +{
> +	struct rcar_drif_chan *ch = platform_get_drvdata(pdev);
> +
> +	if (!ch)
> +		return 0;
> +
> +	/* Parent channel instance */
> +	ch = platform_get_drvdata(pdev);
> +	v4l2_ctrl_handler_free(ch->v4l2_dev.ctrl_handler);
> +	v4l2_async_notifier_unregister(&ch->notifier);
> +	v4l2_device_unregister(&ch->v4l2_dev);
> +	video_unregister_device(&ch->vdev);
> +	dev_notice(ch->dev, "removed\n");
> +	return 0;
> +}
> +
> +static int __maybe_unused rcar_drif_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int __maybe_unused rcar_drif_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(rcar_drif_pm_ops, rcar_drif_suspend,
> +			 rcar_drif_resume);
> +
> +static const struct of_device_id rcar_drif_of_table[] = {
> +	{ .compatible = "renesas,rcar-gen3-drif" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, rcar_drif_of_table);
> +
> +#define RCAR_DRIF_DRV_NAME "rcar_drif"
> +static struct platform_driver rcar_drif_driver = {
> +	.driver = {
> +		.name = RCAR_DRIF_DRV_NAME,
> +		.of_match_table = of_match_ptr(rcar_drif_of_table),
> +		.pm = &rcar_drif_pm_ops,
> +		},
> +	.probe = rcar_drif_probe,
> +	.remove = rcar_drif_remove,
> +};
> +
> +module_platform_driver(rcar_drif_driver);
> +
> +MODULE_DESCRIPTION("Renesas R-Car Gen3 DRIF driver");
> +MODULE_ALIAS("platform:" RCAR_DRIF_DRV_NAME);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>");
> 

Regards,

	Hans
