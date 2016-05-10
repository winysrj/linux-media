Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42972 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbcEJMBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 08:01:24 -0400
Subject: Re: [RFC PATCH 2/3] omap4: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
CC: <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <5731CD8E.8090509@ti.com>
Date: Tue, 10 May 2016 15:01:18 +0300
MIME-Version: 1.0
In-Reply-To: <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="mI4DSxKKRcJdtltDkcgLuO9eWBJx2NNpv"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--mI4DSxKKRcJdtltDkcgLuO9eWBJx2NNpv
Content-Type: multipart/mixed; boundary="cp9j6WTloud3HHQiaOF764mbqj2ivFfpC"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <5731CD8E.8090509@ti.com>
Subject: Re: [RFC PATCH 2/3] omap4: add CEC support
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>

--cp9j6WTloud3HHQiaOF764mbqj2ivFfpC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On 29/04/16 12:39, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  arch/arm/boot/dts/omap4-panda-a4.dts   |   2 +-
>  arch/arm/boot/dts/omap4-panda-es.dts   |   2 +-
>  arch/arm/boot/dts/omap4.dtsi           |   5 +-
>  drivers/gpu/drm/omapdrm/dss/Kconfig    |   8 +
>  drivers/gpu/drm/omapdrm/dss/Makefile   |   3 +
>  drivers/gpu/drm/omapdrm/dss/hdmi.h     |  62 ++++++-
>  drivers/gpu/drm/omapdrm/dss/hdmi4.c    |  39 +++-
>  drivers/gpu/drm/omapdrm/dss/hdmi_cec.c | 329 +++++++++++++++++++++++++=
++++++++
>  8 files changed, 441 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi_cec.c

First, thanks for working on this! It's really nice if we get CEC working=
=2E

Are you planning to continue working on this patch, or is this a
proof-of-concept, and you want to move on to other things? I'm fine with
both, the patch looks quite good and I'm sure I can continue from here
if you want.

Also, what's the status of the general CEC support, will these patches
work on v4.7?

> diff --git a/arch/arm/boot/dts/omap4-panda-a4.dts b/arch/arm/boot/dts/o=
map4-panda-a4.dts
> index 78d3631..f0c1020 100644
> --- a/arch/arm/boot/dts/omap4-panda-a4.dts
> +++ b/arch/arm/boot/dts/omap4-panda-a4.dts
> @@ -13,7 +13,7 @@
>  /* Pandaboard Rev A4+ have external pullups on SCL & SDA */
>  &dss_hdmi_pins {
>  	pinctrl-single,pins =3D <
> -		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_ce=
c */
> +		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)	/* hdmi_cec.hdmi_cec */

Looks fine as we discussed, but these need to be split to separate patch
(with explanation, of course =3D).

>  		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
>  		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
>  		>;
> diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/o=
map4-panda-es.dts
> index 119f8e6..940fe4f 100644
> --- a/arch/arm/boot/dts/omap4-panda-es.dts
> +++ b/arch/arm/boot/dts/omap4-panda-es.dts
> @@ -34,7 +34,7 @@
>  /* PandaboardES has external pullups on SCL & SDA */
>  &dss_hdmi_pins {
>  	pinctrl-single,pins =3D <
> -		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_ce=
c */
> +		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
>  		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
>  		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
>  		>;
> diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dts=
i
> index 2bd9c83..1bb490f 100644
> --- a/arch/arm/boot/dts/omap4.dtsi
> +++ b/arch/arm/boot/dts/omap4.dtsi
> @@ -1006,8 +1006,9 @@
>  				reg =3D <0x58006000 0x200>,
>  				      <0x58006200 0x100>,
>  				      <0x58006300 0x100>,
> -				      <0x58006400 0x1000>;
> -				reg-names =3D "wp", "pll", "phy", "core";
> +				      <0x58006400 0x900>,
> +				      <0x58006D00 0x100>;
> +				reg-names =3D "wp", "pll", "phy", "core", "cec";

"core" contains four blocks, all of which are currently included there
in the "core" space. I'm not sure why they weren't split up properly
when the driver was written, but I think we should either keep the core
as one big block, or split it up to those four sections, instead of just
separating the CEC block.

>  				interrupts =3D <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
>  				status =3D "disabled";
>  				ti,hwmods =3D "dss_hdmi";
> diff --git a/drivers/gpu/drm/omapdrm/dss/Kconfig b/drivers/gpu/drm/omap=
drm/dss/Kconfig
> index d1fa730..69638e9 100644
> --- a/drivers/gpu/drm/omapdrm/dss/Kconfig
> +++ b/drivers/gpu/drm/omapdrm/dss/Kconfig
> @@ -71,9 +71,17 @@ config OMAP4_DSS_HDMI
>  	bool "HDMI support for OMAP4"
>          default y
>  	select OMAP2_DSS_HDMI_COMMON
> +	select MEDIA_CEC_EDID

Hmm, what's in MEDIA_CEC_EDID, why does OMAP4 HDMI need to select that?

>  	help
>  	  HDMI support for OMAP4 based SoCs.
> =20
> +config OMAP2_DSS_HDMI_CEC

This should probably be OMAP2_DSS_HDMI4_CEC or such, as it's only for
OMAP4 HDMI. Or, following the omap4 hdmi's config name,
"OMAP4_DSS_HDMI_CEC".

> +	bool "Enable HDMI CEC support for OMAP4"
> +	depends on OMAP4_DSS_HDMI && MEDIA_CEC
> +	default y
> +	---help---
> +	  When selected the HDMI transmitter will support the CEC feature.
> +
>  config OMAP5_DSS_HDMI
>  	bool "HDMI support for OMAP5"
>  	default n
> diff --git a/drivers/gpu/drm/omapdrm/dss/Makefile b/drivers/gpu/drm/oma=
pdrm/dss/Makefile
> index b651ec9..37eb597 100644
> --- a/drivers/gpu/drm/omapdrm/dss/Makefile
> +++ b/drivers/gpu/drm/omapdrm/dss/Makefile
> @@ -10,6 +10,9 @@ omapdss-$(CONFIG_OMAP2_DSS_SDI) +=3D sdi.o
>  omapdss-$(CONFIG_OMAP2_DSS_DSI) +=3D dsi.o
>  omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) +=3D hdmi_common.o hdmi_wp.o h=
dmi_pll.o \
>  	hdmi_phy.o
> +ifeq ($(CONFIG_OMAP2_DSS_HDMI_CEC),y)
> +  omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) +=3D hdmi_cec.o
> +endif

The file should be hdmi4_cec.o, as it's for omap4. And why the ifeq?
Isn't just

omapdss-$(OMAP4_DSS_HDMI_CEC) +=3D hdmi4_cec.o

enough?

>  omapdss-$(CONFIG_OMAP4_DSS_HDMI) +=3D hdmi4.o hdmi4_core.o
>  omapdss-$(CONFIG_OMAP5_DSS_HDMI) +=3D hdmi5.o hdmi5_core.o
>  ccflags-$(CONFIG_OMAP2_DSS_DEBUG) +=3D -DDEBUG
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi.h b/drivers/gpu/drm/omapd=
rm/dss/hdmi.h
> index 53616b0..7cf8a91 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi.h
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi.h
> @@ -24,6 +24,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/hdmi.h>
>  #include <video/omapdss.h>
> +#include <media/cec.h>
> =20
>  #include "dss.h"
> =20
> @@ -83,6 +84,31 @@
>  #define HDMI_TXPHY_PAD_CFG_CTRL			0xC
>  #define HDMI_TXPHY_BIST_CONTROL			0x1C
> =20
> +/* HDMI CEC */
> +#define HDMI_CEC_DEV_ID                         0x0
> +#define HDMI_CEC_SPEC                           0x4
> +#define HDMI_CEC_DBG_3                          0x1C
> +#define HDMI_CEC_TX_INIT                        0x20
> +#define HDMI_CEC_TX_DEST                        0x24
> +#define HDMI_CEC_SETUP                          0x38
> +#define HDMI_CEC_TX_COMMAND                     0x3C
> +#define HDMI_CEC_TX_OPERAND                     0x40
> +#define HDMI_CEC_TRANSMIT_DATA                  0x7C
> +#define HDMI_CEC_CA_7_0                         0x88
> +#define HDMI_CEC_CA_15_8                        0x8C
> +#define HDMI_CEC_INT_STATUS_0                   0x98
> +#define HDMI_CEC_INT_STATUS_1                   0x9C
> +#define HDMI_CEC_INT_ENABLE_0                   0x90
> +#define HDMI_CEC_INT_ENABLE_1                   0x94
> +#define HDMI_CEC_RX_CONTROL                     0xB0
> +#define HDMI_CEC_RX_COUNT                       0xB4
> +#define HDMI_CEC_RX_CMD_HEADER                  0xB8
> +#define HDMI_CEC_RX_COMMAND                     0xBC
> +#define HDMI_CEC_RX_OPERAND                     0xC0
> +
> +#define HDMI_CEC_TX_FIFO_INT_MASK		0x64
> +#define HDMI_CEC_RETRANSMIT_CNT_INT_MASK	0x2

hdmi.h is a common header for OMAP5 and OMAP4 hdmi. OMAP4 and 5 have
totally different HDMI IP. However, they have the same wrapper (WP), PHY
and PLL. That's why there are these common files, with common register
offsets. But the CEC is part of OMAP4 HDMI IP, so it's not common.

> +
>  enum hdmi_pll_pwr {
>  	HDMI_PLLPWRCMD_ALLOFF =3D 0,
>  	HDMI_PLLPWRCMD_PLLONLY =3D 1,
> @@ -250,6 +276,12 @@ struct hdmi_phy_data {
>  	u8 lane_polarity[4];
>  };
> =20
> +struct hdmi_cec_data {
> +	void __iomem *base;
> +	struct cec_adapter *adap;
> +	u16 phys_addr;
> +};
> +
>  struct hdmi_core_data {
>  	void __iomem *base;
>  };
> @@ -319,6 +351,33 @@ void hdmi_phy_dump(struct hdmi_phy_data *phy, stru=
ct seq_file *s);
>  int hdmi_phy_init(struct platform_device *pdev, struct hdmi_phy_data *=
phy);
>  int hdmi_phy_parse_lanes(struct hdmi_phy_data *phy, const u32 *lanes);=

> =20
> +/* HDMI CEC funcs */
> +#ifdef CONFIG_OMAP2_DSS_HDMI_CEC
> +void hdmi_cec_set_phys_addr(struct hdmi_cec_data *cec, u16 pa);
> +void hdmi_cec_irq(struct hdmi_cec_data *cec);
> +int hdmi_cec_init(struct platform_device *pdev, struct hdmi_cec_data *=
cec);
> +void hdmi_cec_uninit(struct hdmi_cec_data *cec);
> +#else
> +static inline void hdmi_cec_set_phys_addr(struct hdmi_cec_data *cec, u=
16 pa)
> +{
> +}
> +
> +static inline void hdmi_cec_irq(struct hdmi_cec_data *cec)
> +{
> +}
> +
> +static inline int hdmi_cec_init(struct platform_device *pdev,
> +				struct hdmi_cec_data *cec)
> +{
> +	cec->phys_addr =3D CEC_PHYS_ADDR_INVALID;
> +	return 0;
> +}
> +
> +static inline void hdmi_cec_uninit(struct hdmi_cec_data *cec)
> +{
> +}
> +#endif
> +
>  /* HDMI common funcs */
>  int hdmi_parse_lanes_of(struct platform_device *pdev, struct device_no=
de *ep,
>  	struct hdmi_phy_data *phy);
> @@ -344,6 +403,7 @@ struct omap_hdmi {
>  	struct hdmi_wp_data	wp;
>  	struct hdmi_pll_data	pll;
>  	struct hdmi_phy_data	phy;
> +	struct hdmi_cec_data	cec;
>  	struct hdmi_core_data	core;
> =20
>  	struct hdmi_config cfg;
> @@ -361,7 +421,7 @@ struct omap_hdmi {
>  	bool audio_configured;
>  	struct omap_dss_audio audio_config;
> =20
> -	/* This lock should be taken when booleans bellow are touched. */
> +	/* This lock should be taken when booleans below are touched. */
>  	spinlock_t audio_playing_lock;
>  	bool audio_playing;
>  	bool display_enabled;
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omap=
drm/dss/hdmi4.c
> index f892ae15..47a60bf 100644
> --- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
> @@ -34,6 +34,7 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/component.h>
>  #include <video/omapdss.h>
> +#include <media/cec-edid.h>
>  #include <sound/omap-hdmi-audio.h>
> =20
>  #include "hdmi4_core.h"
> @@ -69,14 +70,15 @@ static void hdmi_runtime_put(void)
> =20
>  static irqreturn_t hdmi_irq_handler(int irq, void *data)
>  {
> -	struct hdmi_wp_data *wp =3D data;
> +	struct omap_hdmi *hdmi =3D data;
> +	struct hdmi_wp_data *wp =3D &hdmi->wp;
>  	u32 irqstatus;
> =20
>  	irqstatus =3D hdmi_wp_get_irqstatus(wp);
>  	hdmi_wp_set_irqstatus(wp, irqstatus);
> =20
>  	if ((irqstatus & HDMI_IRQ_LINK_CONNECT) &&
> -			irqstatus & HDMI_IRQ_LINK_DISCONNECT) {
> +	    (irqstatus & HDMI_IRQ_LINK_DISCONNECT)) {
>  		/*
>  		 * If we get both connect and disconnect interrupts at the same
>  		 * time, turn off the PHY, clear interrupts, and restart, which
> @@ -94,6 +96,13 @@ static irqreturn_t hdmi_irq_handler(int irq, void *d=
ata)
>  	} else if (irqstatus & HDMI_IRQ_LINK_DISCONNECT) {
>  		hdmi_wp_set_phy_pwr(wp, HDMI_PHYPWRCMD_LDOON);
>  	}
> +	if (irqstatus & HDMI_IRQ_CORE) {
> +		u32 intr4 =3D hdmi_read_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4);
> +
> +		hdmi_write_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4, intr4);
> +		if (intr4 & 8)
> +			hdmi_cec_irq(&hdmi->cec);
> +	}
> =20
>  	return IRQ_HANDLED;
>  }
> @@ -213,6 +222,12 @@ static int hdmi_power_on_full(struct omap_dss_devi=
ce *dssdev)
> =20
>  	hdmi4_configure(&hdmi.core, &hdmi.wp, &hdmi.cfg);
> =20
> +	/* Initialize CEC clock divider */
> +	/* CEC needs 2MHz clock hence set the devider to 24 to get
> +	   48/24=3D2MHz clock */
> +	REG_FLD_MOD(hdmi.wp.base, HDMI_WP_CLK, 0x18, 5, 0);
> +	hdmi_cec_set_phys_addr(&hdmi.cec, hdmi.cec.phys_addr);
> +
>  	/* bypass TV gamma table */
>  	dispc_enable_gamma_table(0);
> =20
> @@ -228,7 +243,11 @@ static int hdmi_power_on_full(struct omap_dss_devi=
ce *dssdev)
>  		goto err_vid_enable;
> =20
>  	hdmi_wp_set_irqenable(wp,
> -		HDMI_IRQ_LINK_CONNECT | HDMI_IRQ_LINK_DISCONNECT);
> +		HDMI_IRQ_LINK_CONNECT | HDMI_IRQ_LINK_DISCONNECT |
> +		HDMI_IRQ_CORE);
> +
> +	/* Unmask CEC interrupt */
> +	REG_FLD_MOD(hdmi.core.base, HDMI_CORE_SYS_INTR_UNMASK4, 0x1, 3, 3);
> =20
>  	return 0;
> =20
> @@ -250,6 +269,8 @@ static void hdmi_power_off_full(struct omap_dss_dev=
ice *dssdev)
>  	enum omap_channel channel =3D dssdev->dispc_channel;
> =20
>  	hdmi_wp_clear_irqenable(&hdmi.wp, 0xffffffff);
> +	hdmi.cec.phys_addr =3D CEC_PHYS_ADDR_INVALID;
> +	hdmi_cec_set_phys_addr(&hdmi.cec, hdmi.cec.phys_addr);
> =20
>  	hdmi_wp_video_stop(&hdmi.wp);
> =20
> @@ -488,6 +509,10 @@ static int hdmi_read_edid(struct omap_dss_device *=
dssdev,
>  	}
> =20
>  	r =3D read_edid(edid, len);
> +	if (r >=3D 256)
> +		hdmi.cec.phys_addr =3D cec_get_edid_phys_addr(edid, r, NULL);
> +	else
> +		hdmi.cec.phys_addr =3D CEC_PHYS_ADDR_INVALID;
> =20
>  	if (need_enable)
>  		hdmi_core_disable(dssdev);
> @@ -724,6 +749,10 @@ static int hdmi4_bind(struct device *dev, struct d=
evice *master, void *data)
>  	if (r)
>  		goto err;
> =20
> +	r =3D hdmi_cec_init(pdev, &hdmi.cec);
> +	if (r)
> +		goto err;
> +
>  	irq =3D platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		DSSERR("platform_get_irq failed\n");
> @@ -733,7 +762,7 @@ static int hdmi4_bind(struct device *dev, struct de=
vice *master, void *data)
> =20
>  	r =3D devm_request_threaded_irq(&pdev->dev, irq,
>  			NULL, hdmi_irq_handler,
> -			IRQF_ONESHOT, "OMAP HDMI", &hdmi.wp);
> +			IRQF_ONESHOT, "OMAP HDMI", &hdmi);
>  	if (r) {
>  		DSSERR("HDMI IRQ request failed\n");
>  		goto err;
> @@ -768,6 +797,8 @@ static void hdmi4_unbind(struct device *dev, struct=
 device *master, void *data)
> =20
>  	hdmi_uninit_output(pdev);
> =20
> +	hdmi_cec_uninit(&hdmi.cec);
> +
>  	hdmi_pll_uninit(&hdmi.pll);
> =20
>  	pm_runtime_disable(&pdev->dev);
> diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi_cec.c b/drivers/gpu/drm/o=
mapdrm/dss/hdmi_cec.c
> new file mode 100644
> index 0000000..d4309df
> --- /dev/null
> +++ b/drivers/gpu/drm/omapdrm/dss/hdmi_cec.c
> @@ -0,0 +1,329 @@
> +/*
> + * HDMI CEC
> + *
> + * Based on the CEC code from hdmi_ti_4xxx_ip.c from Android.
> + *
> + * Copyright (C) 2010-2011 Texas Instruments Incorporated - http://www=
=2Eti.com/
> + * Authors: Yong Zhi
> + *	Mythri pk <mythripk@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y it
> + * under the terms of the GNU General Public License version 2 as publ=
ished by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but=
 WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY =
or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public Licen=
se for
> + * more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <video/omapdss.h>
> +
> +#include "dss.h"
> +#include "hdmi.h"
> +
> +#define HDMI_CORE_CEC_RETRY    200
> +
> +void hdmi_cec_transmit_fifo_empty(struct hdmi_cec_data *cec, u32 stat1=
)
> +{
> +	if (stat1 & 2) {
> +		u32 dbg3 =3D hdmi_read_reg(cec->base, HDMI_CEC_DBG_3);

This is a debug register. I haven't looked at how CEC is to be used, but
using a debug register looks a bit suspicious =3D).

 Tomi


--cp9j6WTloud3HHQiaOF764mbqj2ivFfpC--

--mI4DSxKKRcJdtltDkcgLuO9eWBJx2NNpv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXMc2OAAoJEPo9qoy8lh71OB0P/0B/s73hVP/WUJdQ+YmZ1YYj
mJuVtp8cYuJCcPFwOKgNksfkClkpncoHuEuYJAXUjdKGm5z67anwS+p2qiFgqiNn
dGl7u79gpZ8RbWnILXmtKJow6JxURn/tZN1ZvIv26XWyOSkR7XTjLV0akT/iv/Um
X9QHoMbWtgCc1E5EvBJoahJEVrxRqwujIUKEbAXitVf5shwElK4xGYKtOEkWp28O
39paU40hJ1IGmRVK01NMebF1FPBzs1b5espGa4aElZ8YSVL2N0NdfogAdY9Zjk8B
3eaulQtJsUF7Xuyj9Zf4dtk25GwrEu8WR1dvM4BGKd16gfTF3darXy2tbQlHxIXS
HXlmDs3ZzJiVm8uBT/kTX+4DnuLZiq+E1Turv8y+JEsSa6tzNVeealp0Lw72IkxZ
bNlFGAzgoBW+s64hAUdbwLWipNEl5DIny8vnhzyh+65zxcwgvHZcQ4XH9ahvT1lR
m809poCogQxnGNS+76Sje4gHlcO5DK9DdzMhFgSGZR+hhni2+j1LQWuCTmgb0yDd
3HfYMpvEIJdTp/Tjuh0yHXNx5Bs/zkkRyk+vCdp/470bloU1+iLZs0pfG4NYmINF
f8Q9aYJx+YhslKorrpk9Kn3u7653wK2/woKt/Lkk2mb+rRF7yRRPLvTVaq9TKndY
nDuxStfZpfitjKhAdFyH
=LDDP
-----END PGP SIGNATURE-----

--mI4DSxKKRcJdtltDkcgLuO9eWBJx2NNpv--
