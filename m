Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:14391 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932972AbcKNQLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 11:11:45 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>
CC: Chris Paterson <Chris.Paterson2@renesas.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 5/5] media: platform: rcar_drif: Add DRIF support
Date: Mon, 14 Nov 2016 16:11:31 +0000
Message-ID: <SG2PR06MB10387A7CF83A13E480EB478BC3BC0@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1478706284-59134-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <9b772894-f6ef-d5ad-4601-735f2321ce0c@xs4all.nl>
In-Reply-To: <9b772894-f6ef-d5ad-4601-735f2321ce0c@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review comments.

> Subject: Re: [PATCH 5/5] media: platform: rcar_drif: Add DRIF support
>=20
> On 11/09/2016 04:44 PM, Ramesh Shanmugasundaram wrote:
> > This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3
> SoCs.
> > The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF
> > device represents a channel and each channel can have one or two
> > sub-channels respectively depending on the target board.
> >
> > DRIF supports only Rx functionality. It receives samples from a RF
> > frontend tuner chip it is interfaced with. The combination of DRIF and
> > the tuner device, which is registered as a sub-device, determines the
> > receive sample rate and format.
> >
> > In order to be compliant as a V4L2 SDR device, DRIF needs to bind with
> > the tuner device, which can be provided by a third party vendor. DRIF
> > acts as a slave device and the tuner device acts as a master
> > transmitting the samples. The driver allows asynchronous binding of a
> > tuner device that is registered as a v4l2 sub-device. The driver can
> > learn about the tuner it is interfaced with based on port endpoint
> > properties of the device in device tree. The V4L2 SDR device inherits
> > the controls exposed by the tuner device.
> >
> > The device can also be configured to use either one or both of the
> > data pins at runtime based on the master (tuner) configuration.
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com>
> > ---
> >  .../devicetree/bindings/media/renesas,drif.txt     |  136 ++
> >  drivers/media/platform/Kconfig                     |   25 +
> >  drivers/media/platform/Makefile                    |    1 +
> >  drivers/media/platform/rcar_drif.c                 | 1574
> ++++++++++++++++++++
> >  4 files changed, 1736 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/renesas,drif.txt
> >  create mode 100644 drivers/media/platform/rcar_drif.c
> >
> > diff --git a/Documentation/devicetree/bindings/media/renesas,drif.txt
> > b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > new file mode 100644
> > index 0000000..d65368a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/renesas,drif.txt
> > @@ -0,0 +1,136 @@
> > +Renesas R-Car Gen3 Digital Radio Interface controller (DRIF)
> > +------------------------------------------------------------
> > +
> > +R-Car Gen3 DRIF is a serial slave device. It interfaces with a master
> > +device as shown below
> > +
> > ++---------------------+                +---------------------+
> > +|                     |-----SCK------->|CLK                  |
> > +|       Master        |-----SS-------->|SYNC  DRIFn (slave)  |
> > +|                     |-----SD0------->|D0                   |
> > +|                     |-----SD1------->|D1                   |
> > ++---------------------+                +---------------------+
> > +
> > +Each DRIF channel (drifn) consists of two sub-channels (drifn0 &
> drifn1).
> > +The sub-channels are like two individual channels in itself that
> > +share the common CLK & SYNC. Each sub-channel has it's own dedicated
> > +resources like irq, dma channels, address space & clock.
> > +
> > +The device tree model represents the channel and each of it's
> > +sub-channel as a separate node. The parent channel ties the
> > +sub-channels together with their phandles.
> > +
> > +Required properties of a sub-channel:
> > +-------------------------------------
> > +- compatible: "renesas,r8a7795-drif" if DRIF controller is a part of
> R8A7795 SoC.
> > +	      "renesas,rcar-gen3-drif" for a generic R-Car Gen3 compatible
> device.
> > +	      When compatible with the generic version, nodes must list the
> > +	      SoC-specific version corresponding to the platform first
> > +	      followed by the generic version.
> > +- reg: offset and length of that sub-channel.
> > +- interrupts: associated with that sub-channel.
> > +- clocks: phandle and clock specifier of that sub-channel.
> > +- clock-names: clock input name string: "fck".
> > +- dmas: phandles to the DMA channel of that sub-channel.
> > +- dma-names: names of the DMA channel: "rx".
> > +
> > +Optional properties of a sub-channel:
> > +-------------------------------------
> > +- power-domains: phandle to the respective power domain.
> > +
> > +Required properties of a channel:
> > +---------------------------------
> > +- pinctrl-0: pin control group to be used for this channel.
> > +- pinctrl-names: must be "default".
> > +- sub-channels : phandles to the two sub-channels.
> > +
> > +Optional properties of a channel:
> > +---------------------------------
> > +- port: child port node of a channel that defines the local and remote
> > +        endpoints. The remote endpoint is assumed to be a tuner
> subdevice
> > +	endpoint.
> > +- renesas,syncmd       : sync mode
> > +			 0 (Frame start sync pulse mode. 1-bit width pulse
> > +			    indicates start of a frame)
> > +			 1 (L/R sync or I2S mode) (default)
> > +- renesas,lsb-first    : empty property indicates lsb bit is received
> first.
> > +			 When not defined msb bit is received first (default)
> > +- renesas,syncac-pol-high  : empty property indicates sync signal
> polarity.
> > +			 When defined, active high or high->low sync signal.
> > +			 When not defined, active low or low->high sync signal
> > +			 (default)
> > +- renesas,dtdl         : delay between sync signal and start of
> reception.
> > +			 Must contain one of the following values:
> > +			 0   (no bit delay)
> > +			 50  (0.5-clock-cycle delay)
> > +			 100 (1-clock-cycle delay) (default)
> > +			 150 (1.5-clock-cycle delay)
> > +			 200 (2-clock-cycle delay)
> > +- renesas,syncdl       : delay between end of reception and sync signa=
l
> edge.
> > +			 Must contain one of the following values:
> > +			 0   (no bit delay) (default)
> > +			 50  (0.5-clock-cycle delay)
> > +			 100 (1-clock-cycle delay)
> > +			 150 (1.5-clock-cycle delay)
> > +			 200 (2-clock-cycle delay)
> > +			 300 (3-clock-cycle delay)
> > +
> > +Example
> > +--------
> > +
> > +SoC common dtsi file
> > +
> > +		drif00: rif@e6f40000 {
> > +			compatible =3D "renesas,r8a7795-drif",
> > +				     "renesas,rcar-gen3-drif";
> > +			reg =3D <0 0xe6f40000 0 0x64>;
> > +			interrupts =3D <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
> > +			clocks =3D <&cpg CPG_MOD 515>;
> > +			clock-names =3D "fck";
> > +			dmas =3D <&dmac1 0x20>, <&dmac2 0x20>;
> > +			dma-names =3D "rx", "rx";
> > +			power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > +			status =3D "disabled";
> > +		};
> > +
> > +		drif01: rif@e6f50000 {
> > +			compatible =3D "renesas,r8a7795-drif",
> > +				     "renesas,rcar-gen3-drif";
> > +			reg =3D <0 0xe6f50000 0 0x64>;
> > +			interrupts =3D <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > +			clocks =3D <&cpg CPG_MOD 514>;
> > +			clock-names =3D "fck";
> > +			dmas =3D <&dmac1 0x22>, <&dmac2 0x22>;
> > +			dma-names =3D "rx", "rx";
> > +			power-domains =3D <&sysc R8A7795_PD_ALWAYS_ON>;
> > +			status =3D "disabled";
> > +		};
> > +
> > +		drif0: rif@0 {
> > +			compatible =3D "renesas,r8a7795-drif",
> > +				     "renesas,rcar-gen3-drif";
> > +			sub-channels =3D <&drif00>, <&drif01>;
> > +			status =3D "disabled";
> > +		};
> > +
> > +Board specific dts file
> > +
> > +&drif00 {
> > +	status =3D "okay";
> > +};
> > +
> > +&drif01 {
> > +	status =3D "okay";
> > +};
> > +
> > +&drif0 {
> > +	pinctrl-0 =3D <&drif0_pins>;
> > +	pinctrl-names =3D "default";
> > +	renesas,syncac-pol-high;
> > +	status =3D "okay";
> > +	port {
> > +		drif0_ep: endpoint {
> > +		     remote-endpoint =3D <&tuner_subdev_ep>;
> > +		};
> > +	};
> > +};
> > diff --git a/drivers/media/platform/Kconfig
> > b/drivers/media/platform/Kconfig index 754edbf1..0ae83a8 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -393,3 +393,28 @@ menuconfig DVB_PLATFORM_DRIVERS  if
> > DVB_PLATFORM_DRIVERS  source
> > "drivers/media/platform/sti/c8sectpfe/Kconfig"
> >  endif #DVB_PLATFORM_DRIVERS
> > +
> > +menuconfig SDR_PLATFORM_DRIVERS
> > +	bool "SDR platform devices"
> > +	depends on MEDIA_SDR_SUPPORT
> > +	default n
> > +	---help---
> > +	  Say Y here to enable support for platform-specific SDR Drivers.
> > +
> > +if SDR_PLATFORM_DRIVERS
> > +
> > +config VIDEO_RCAR_DRIF
> > +	tristate "Renesas Digitial Radio Interface (DRIF)"
> > +	depends on VIDEO_V4L2 && HAS_DMA
> > +	depends on ARCH_RENESAS
> > +	select VIDEOBUF2_VMALLOC
> > +	---help---
> > +	  Say Y if you want to enable R-Car Gen3 DRIF support. DRIF is
> Digital
> > +	  Radio Interface that interfaces with an RF front end chip. It is a
> > +	  receiver of digital data which uses DMA to transfer received data
> to
> > +	  a configured location for an application to use.
> > +
> > +	  To compile this driver as a module, choose M here; the module
> > +	  will be called rcar_drif.
> > +
> > +endif # SDR_PLATFORM_DRIVERS
> > diff --git a/drivers/media/platform/Makefile
> > b/drivers/media/platform/Makefile index f842933..49ce238 100644
> > --- a/drivers/media/platform/Makefile
> > +++ b/drivers/media/platform/Makefile
> > @@ -49,6 +49,7 @@ obj-$(CONFIG_SOC_CAMERA)		+=3D soc_camera/
> >
> >  obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+=3D rcar-fcp.o
> >  obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+=3D rcar_jpu.o
> > +obj-$(CONFIG_VIDEO_RCAR_DRIF)		+=3D rcar_drif.o
> >  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+=3D vsp1/
> >
> >  obj-y	+=3D omap/
> > diff --git a/drivers/media/platform/rcar_drif.c
> > b/drivers/media/platform/rcar_drif.c
> > new file mode 100644
> > index 0000000..34dc282
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar_drif.c
> > @@ -0,0 +1,1574 @@
>=20
> <snip>
>=20
> +#define for_each_rcar_drif_subdev(sd, tmp, ch)				\
> +	list_for_each_entry_safe(sd, tmp, &ch->v4l2_dev.subdevs, list)
> +
>=20
> Please don't use this. media/v4l2-device.h has a bunch of similar
> functions for this. Use those instead.

Thanks. Agreed.

>=20
> <snip>
>=20
> > +static int rcar_drif_querycap(struct file *file, void *fh,
> > +			      struct v4l2_capability *cap) {
> > +	struct rcar_drif_chan *ch =3D video_drvdata(file);
> > +
> > +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> > +	strlcpy(cap->card, ch->vdev.name, sizeof(cap->card));
> > +	cap->device_caps =3D V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
> > +				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> > +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>=20
> Set device_caps in struct video_device and drop it here.
>=20
> The core will fill in cap->device_caps and cap->capabilities for you.

Agreed.

>=20
> > +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> > +		 ch->vdev.name);
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_set_default_format(struct rcar_drif_chan *ch) {
> > +	unsigned int i;
> > +
> > +	for (i =3D 0; i < NUM_FORMATS; i++) {
> > +		/* Find any matching fmt and set it as default */
> > +		if (ch->num_hw_schans =3D=3D formats[i].num_schans) {
> > +			ch->fmt_idx =3D i;
> > +			ch->cur_schans_mask =3D ch->hw_schans_mask;
> > +			ch->num_cur_schans =3D ch->num_hw_schans;
> > +			dev_dbg(ch->dev, "default fmt[%u]: mask %lu num %u\n",
> > +				i, ch->cur_schans_mask, ch->num_cur_schans);
> > +			return 0;
> > +		}
> > +	}
> > +	dev_err(ch->dev, "no matching sdr fmt found\n");
> > +	return -EINVAL;
> > +}
> > +
> > +static int rcar_drif_enum_fmt_sdr_cap(struct file *file, void *priv,
> > +				      struct v4l2_fmtdesc *f)
> > +{
> > +	if (f->index >=3D NUM_FORMATS)
> > +		return -EINVAL;
> > +
> > +	strlcpy(f->description, formats[f->index].name,
> > +sizeof(f->description));
>=20
> Drop this. The core fills that in for you.
>=20

Agreed.

> > +	f->pixelformat =3D formats[f->index].pixelformat;
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,
> > +				   struct v4l2_format *f)
> > +{
> > +	struct rcar_drif_chan *ch =3D video_drvdata(file);
> > +
> > +	f->fmt.sdr.pixelformat =3D formats[ch->fmt_idx].pixelformat;
> > +	f->fmt.sdr.buffersize =3D formats[ch->fmt_idx].buffersize;
> > +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> > +	return 0;
> > +}
> > +

[snip]

> > +/* Parse sub-devs (tuner) to find a matching device */ static int
> > +rcar_drif_parse_subdevs(struct device *dev,
> > +				   struct v4l2_async_notifier *notifier) {
> > +	struct device_node *node =3D NULL;
> > +
> > +	notifier->subdevs =3D devm_kzalloc(dev, sizeof(*notifier->subdevs),
> > +					 GFP_KERNEL);
> > +	if (!notifier->subdevs)
> > +		return -ENOMEM;
> > +
> > +	node =3D of_graph_get_next_endpoint(dev->of_node, node);
>=20
> Do:
>=20
> 	if (!node)
> 		return 0;
>=20
> And the remainder can be shifted one tab to the left.

Agreed.

>=20
> > +	if (node) {
> > +		struct rcar_drif_async_subdev *rsd;
> > +
> > +		rsd =3D devm_kzalloc(dev, sizeof(*rsd), GFP_KERNEL);
> > +		if (!rsd) {
> > +			of_node_put(node);
> > +			return -ENOMEM;
> > +		}
> > +
> > +		notifier->subdevs[notifier->num_subdevs] =3D &rsd->asd;
> > +		rsd->asd.match.of.node =3D
> of_graph_get_remote_port_parent(node);
> > +		of_node_put(node);
> > +		if (!rsd->asd.match.of.node) {
> > +			dev_warn(dev, "bad remote port parent\n");
> > +			return -EINVAL;
> > +		}
> > +
> > +		rsd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
> > +		notifier->num_subdevs++;
> > +	}
> > +	return 0;
> > +}
> > +
> > +/* SIRMDR1 configuration */
> > +static int rcar_drif_validate_syncmd(struct rcar_drif_chan *ch, u32
> > +val) {
> > +	if (val > 1) {
> > +		dev_err(ch->dev, "invalid syncmd %u using L/R mode\n", val);
> > +		return -EINVAL;
> > +	}
> > +
> > +	ch->mdr1 &=3D ~(3 << 28);	/* Clear current settings */
> > +	if (val =3D=3D 0)
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_SYNCMD_FRAME;
> > +	else
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_SYNCMD_LR;
> > +	return 0;
> > +}
> > +
> > +/* Get the dtdl or syncdl bits as in MSIOF */ static u32
> > +rcar_drif_get_dtdl_or_syncdl_bits(u32 dtdl_or_syncdl) {
> > +	/*
> > +	 * DTDL/SYNCDL bit	: dtdl/syncdl
> > +	 * b'000		: 0
> > +	 * b'001		: 100
> > +	 * b'010		: 200
> > +	 * b'011 (SYNCDL only)	: 300
> > +	 * b'101		: 50
> > +	 * b'110		: 150
> > +	 */
> > +	if (dtdl_or_syncdl % 100)
> > +		return dtdl_or_syncdl / 100 + 5;
> > +	else
>=20
> Line can be dropped.

Agreed.

>=20
> > +		return dtdl_or_syncdl / 100;
> > +}
> > +
> > +static int rcar_drif_validate_dtdl_syncdl(struct rcar_drif_chan *ch)
> > +{
> > +	struct device_node *np =3D ch->dev->of_node;
> > +	u32 dtdl =3D 100, syncdl =3D 0;
> > +
> > +	ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_DTDL_1 | RCAR_DRIF_SIRMDR1_SYNCDL_0;
> > +	of_property_read_u32(np, "renesas,dtdl", &dtdl);
> > +	of_property_read_u32(np, "renesas,syncdl", &syncdl);
> > +
> > +	/* Sanity checks */
> > +	if (dtdl > 200 || syncdl > 300) {
> > +		dev_err(ch->dev, "invalid dtdl %u/syncdl %u\n", dtdl, syncdl);
> > +		return -EINVAL;
> > +	}
> > +	if ((dtdl + syncdl) % 100) {
> > +		dev_err(ch->dev, "sum of dtdl %u & syncdl %u not OK\n",
> > +			dtdl, syncdl);
> > +		return -EINVAL;
> > +	}
> > +	ch->mdr1 &=3D ~(7 << 20) & ~(7 << 16);	/* Clear current settings
> */
> > +	ch->mdr1 |=3D rcar_drif_get_dtdl_or_syncdl_bits(dtdl) << 20;
> > +	ch->mdr1 |=3D rcar_drif_get_dtdl_or_syncdl_bits(syncdl) << 16;
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_parse_properties(struct rcar_drif_chan *ch) {
> > +	struct device_node *np =3D ch->dev->of_node;
> > +	u32 syncmd;
> > +	int ret;
> > +
> > +	/* Set the defaults and check for overrides */
> > +	ch->mdr1 =3D RCAR_DRIF_SIRMDR1_SYNCMD_LR;
> > +	if (!of_property_read_u32(np, "renesas,syncmd", &syncmd)) {
> > +		ret =3D rcar_drif_validate_syncmd(ch, syncmd);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (of_find_property(np, "renesas,lsb-first", NULL))
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_LSB_FIRST;
> > +	else
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_MSB_FIRST;
> > +
> > +	if (of_find_property(np, "renesas,syncac-pol-high", NULL))
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_SYNCAC_POL_HIGH;
> > +	else
> > +		ch->mdr1 |=3D RCAR_DRIF_SIRMDR1_SYNCAC_POL_LOW;
> > +
> > +	return rcar_drif_validate_dtdl_syncdl(ch);
> > +}
> > +
> > +static u32 rcar_drif_enum_sub_channels(struct platform_device *pdev,
> > +					struct platform_device *s_pdev[]) {
> > +	struct device_node *s_np;
> > +	u32 hw_schans_mask =3D 0;
> > +	unsigned int i;
> > +
> > +	for (i =3D 0; i < RCAR_DRIF_MAX_SUBCHANS; i++) {
> > +		s_np =3D of_parse_phandle(pdev->dev.of_node, "sub-channels", i);
> > +		if (s_np && of_device_is_available(s_np)) {
> > +			s_pdev[i] =3D of_find_device_by_node(s_np);
> > +			if (s_pdev[i]) {
> > +				hw_schans_mask |=3D BIT(i);
> > +				dev_dbg(&s_pdev[i]->dev, "schan%u ok\n", i);
> > +			}
> > +		}
> > +	}
> > +	return hw_schans_mask;
> > +}
> > +
> > +static int rcar_drif_probe(struct platform_device *pdev) {
> > +	struct platform_device *s_pdev[RCAR_DRIF_MAX_SUBCHANS];
> > +	unsigned long hw_schans_mask;
> > +	struct rcar_drif_chan *ch;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	/*
> > +	 * Sub-channel resources are managed by the parent channel instance.
> > +	 * The sub-channel instance helps only in registering with power
> domain
> > +	 * to aid in run-time pm support
> > +	 */
> > +	if (!of_find_property(pdev->dev.of_node, "sub-channels", NULL))
> > +		return 0;
> > +
> > +	/* Parent channel instance */
> > +	hw_schans_mask =3D rcar_drif_enum_sub_channels(pdev, s_pdev);
> > +	if (!hw_schans_mask) {
> > +		dev_err(&pdev->dev, "no sub-channels enabled\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +
> > +	/* Reserve memory for driver structure */
> > +	ch =3D devm_kzalloc(&pdev->dev, sizeof(*ch), GFP_KERNEL);
> > +	if (!ch) {
> > +		ret =3D PTR_ERR(ch);
> > +		dev_err(&pdev->dev, "failed alloc drif context\n");
> > +		return ret;
> > +	}
> > +	ch->dev =3D &pdev->dev;
> > +
> > +	/* Parse device tree optional properties */
> > +	ret =3D rcar_drif_parse_properties(ch);
> > +	if (ret)
> > +		return ret;
> > +
> > +	dev_dbg(ch->dev, "parsed mdr1 0x%08x\n", ch->mdr1);
> > +
> > +	/* Setup enabled sub-channels */
> > +	for_each_rcar_drif_subchannel(i, &hw_schans_mask) {
> > +		struct clk *clkp;
> > +		struct resource	*res;
> > +		void __iomem *base;
> > +
> > +		/* Peripheral clock */
> > +		clkp =3D devm_clk_get(&s_pdev[i]->dev, "fck");
> > +		if (IS_ERR(clkp)) {
> > +			ret =3D PTR_ERR(clkp);
> > +			dev_err(&s_pdev[i]->dev, "clk get failed (%d)\n", ret);
> > +			return ret;
> > +		}
> > +
> > +		/* Register map */
> > +		res =3D platform_get_resource(s_pdev[i], IORESOURCE_MEM, 0);
> > +		base =3D devm_ioremap_resource(&s_pdev[i]->dev, res);
> > +		if (IS_ERR(base)) {
> > +			ret =3D PTR_ERR(base);
> > +			dev_err(&s_pdev[i]->dev, "ioremap failed (%d)\n", ret);
> > +			return ret;
> > +		}
> > +
> > +		/* Reserve memory for enabled sub-channel */
> > +		ch->sch[i] =3D devm_kzalloc(&pdev->dev, sizeof(*ch->sch[i]),
> > +					  GFP_KERNEL);
> > +		if (!ch->sch[i]) {
> > +			ret =3D PTR_ERR(ch);
> > +			dev_err(&s_pdev[i]->dev, "failed alloc sub-channel\n");
> > +			return ret;
> > +		}
> > +		ch->sch[i]->pdev =3D s_pdev[i];
> > +		ch->sch[i]->clkp =3D clkp;
> > +		ch->sch[i]->base =3D base;
> > +		ch->sch[i]->num =3D i;
> > +		ch->sch[i]->start =3D res->start;
> > +		ch->sch[i]->parent =3D ch;
> > +		ch->num_hw_schans++;
> > +	}
> > +	ch->hw_schans_mask =3D hw_schans_mask;
> > +
> > +	/* Validate any supported format for enabled sub-channels */
> > +	ret =3D rcar_drif_set_default_format(ch);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Set defaults */
> > +	ch->num_hwbufs =3D RCAR_DRIF_DEFAULT_NUM_HWBUFS;
> > +	ch->hwbuf_size =3D RCAR_DRIF_DEFAULT_HWBUF_SIZE;
> > +
> > +	mutex_init(&ch->v4l2_mutex);
> > +	mutex_init(&ch->vb_queue_mutex);
> > +	spin_lock_init(&ch->queued_bufs_lock);
> > +	INIT_LIST_HEAD(&ch->queued_bufs);
> > +
> > +	/* Init videobuf2 queue structure */
> > +	ch->vb_queue.type =3D V4L2_BUF_TYPE_SDR_CAPTURE;
> > +	ch->vb_queue.io_modes =3D VB2_READ | VB2_MMAP | VB2_DMABUF;
> > +	ch->vb_queue.drv_priv =3D ch;
> > +	ch->vb_queue.buf_struct_size =3D sizeof(struct rcar_drif_frame_buf);
> > +	ch->vb_queue.ops =3D &rcar_drif_vb2_ops;
> > +	ch->vb_queue.mem_ops =3D &vb2_vmalloc_memops;
> > +	ch->vb_queue.timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +
> > +	/* Init videobuf2 queue */
> > +	ret =3D vb2_queue_init(&ch->vb_queue);
> > +	if (ret) {
> > +		dev_err(ch->dev, "could not initialize vb2 queue\n");
> > +		return ret;
> > +	}
> > +
> > +	/* Init video_device structure */
> > +	ch->vdev =3D rcar_drif_vdev;
>=20
> Don't embed video_device, use video_device_alloc instead. A lot of driver=
s
> embed this, but it turns out not to be a good idea. So new drivers should
> use video_device_alloc.

Agreed.=20

Thanks,
Ramesh
