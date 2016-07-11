Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37297 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcGKSAS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 14:00:18 -0400
Message-ID: <1468260005.14217.14.camel@ndufresne.ca>
Subject: Re: [PATCH v2 2/3] [media] hva: multi-format video encoder V4L2
 driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: kernel@stlinux.com,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>
Date: Mon, 11 Jul 2016 14:00:05 -0400
In-Reply-To: <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
	 <1468250057-16395-3-git-send-email-jean-christophe.trotin@st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gVS0VaV5HzoQ2+Y1nG2g"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-gVS0VaV5HzoQ2+Y1nG2g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 11 juillet 2016 =C3=A0 17:14 +0200, Jean-Christophe Trotin a =C3=
=A9crit=C2=A0:
> This patch adds V4L2 HVA (Hardware Video Accelerator) video encoder
> driver for STMicroelectronics SoC. It uses the V4L2 mem2mem framework.
>=20
> This patch only contains the core parts of the driver:
> - the V4L2 interface with the userland (hva-v4l2.c)
> - the hardware services (hva-hw.c)
> - the memory management utilities (hva-mem.c)
>=20
> This patch doesn't include the support of specific codec (e.g. H.264)
> video encoding: this support is part of subsequent patches.
>=20
> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> ---
> =C2=A0drivers/media/platform/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A014 +
> =C2=A0drivers/media/platform/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A0=C2=A01 +
> =C2=A0drivers/media/platform/sti/hva/Makefile=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0=C2=A0=C2=A02 +
> =C2=A0drivers/media/platform/sti/hva/hva-hw.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0534 ++++++++++++
> =C2=A0drivers/media/platform/sti/hva/hva-hw.h=C2=A0=C2=A0=C2=A0|=C2=A0=C2=
=A0=C2=A042 +
> =C2=A0drivers/media/platform/sti/hva/hva-mem.c=C2=A0=C2=A0|=C2=A0=C2=A0=
=C2=A060 ++
> =C2=A0drivers/media/platform/sti/hva/hva-mem.h=C2=A0=C2=A0|=C2=A0=C2=A0=
=C2=A036 +
> =C2=A0drivers/media/platform/sti/hva/hva-v4l2.c | 1299 ++++++++++++++++++=
+++++++++++
> =C2=A0drivers/media/platform/sti/hva/hva.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A0284 +++++++
> =C2=A09 files changed, 2272 insertions(+)
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/Makefile
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
> =C2=A0create mode 100644 drivers/media/platform/sti/hva/hva.h
>=20
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kcon=
fig
> index 382f393..182d63f 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -227,6 +227,20 @@ config VIDEO_STI_BDISP
> =C2=A0	help
> =C2=A0	=C2=A0=C2=A0This v4l2 mem2mem driver is a 2D blitter for STMicroel=
ectronics SoC.
> =C2=A0
> +config VIDEO_STI_HVA
> +	tristate "STMicroelectronics STiH41x HVA multi-format video encoder V4L=
2 driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on ARCH_STI || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	=C2=A0=C2=A0This V4L2 driver enables HVA multi-format video encoder of
> +	=C2=A0=C2=A0STMicroelectronics SoC STiH41x series, allowing hardware en=
coding of raw
> +	=C2=A0=C2=A0uncompressed formats in various compressed video bitstreams=
 format.
> +
> +	=C2=A0=C2=A0To compile this driver as a module, choose M here:
> +	=C2=A0=C2=A0the module will be called hva.
> +
> =C2=A0config VIDEO_SH_VEU
> =C2=A0	tristate "SuperH VEU mem2mem video processing driver"
> =C2=A0	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Mak=
efile
> index 99cf315..784dcd4 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -36,6 +36,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+=3D s5p-g2d/
> =C2=A0obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+=3D exynos-gsc/
> =C2=A0
> =C2=A0obj-$(CONFIG_VIDEO_STI_BDISP)		+=3D sti/bdisp/
> +obj-$(CONFIG_VIDEO_STI_HVA)		+=3D sti/hva/
> =C2=A0obj-$(CONFIG_DVB_C8SECTPFE)		+=3D sti/c8sectpfe/
> =C2=A0
> =C2=A0obj-$(CONFIG_BLACKFIN)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0+=3D blackfi=
n/
> diff --git a/drivers/media/platform/sti/hva/Makefile b/drivers/media/plat=
form/sti/hva/Makefile
> new file mode 100644
> index 0000000..7022a33
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_VIDEO_STI_HVA) :=3D hva.o
> +hva-y :=3D hva-v4l2.o hva-hw.o hva-mem.o
> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/plat=
form/sti/hva/hva-hw.c
> new file mode 100644
> index 0000000..fa293c7
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> @@ -0,0 +1,534 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +
> +#include "hva.h"
> +#include "hva-hw.h"
> +
> +/* HVA register offsets */
> +#define HVA_HIF_REG_RST=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0100U
> +#define HVA_HIF_REG_RST_ACK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0104U
> +#define HVA_HIF_REG_MIF_CFG=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0108U
> +#define HVA_HIF_REG_HEC_MIF_CFG=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A00x010CU
> +#define HVA_HIF_REG_CFL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0110U
> +#define HVA_HIF_FIFO_CMD=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0114U
> +#define HVA_HIF_FIFO_STS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0118U
> +#define HVA_HIF_REG_SFL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x011CU
> +#define HVA_HIF_REG_IT_ACK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0120U
> +#define HVA_HIF_REG_ERR_IT_ACK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A00x0124U
> +#define HVA_HIF_REG_LMI_ERR=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0128U
> +#define HVA_HIF_REG_EMI_ERR=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x012CU
> +#define HVA_HIF_REG_HEC_MIF_ERR=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A00x0130U
> +#define HVA_HIF_REG_HEC_STS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0134U
> +#define HVA_HIF_REG_HVC_STS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0138U
> +#define HVA_HIF_REG_HJE_STS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x013CU
> +#define HVA_HIF_REG_CNT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0140U
> +#define HVA_HIF_REG_HEC_CHKSYN_DIS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x=
0144U
> +#define HVA_HIF_REG_CLK_GATING=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A00x0148U
> +#define HVA_HIF_REG_VERSION=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x014CU
> +#define HVA_HIF_REG_BSM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0150U
> +
> +/* define value for version id register (HVA_HIF_REG_VERSION) */
> +#define VERSION_ID_MASK	0x0000FFFF
> +
> +/* define values for BSM register (HVA_HIF_REG_BSM) */
> +#define BSM_CFG_VAL1	0x0003F000
> +#define BSM_CFG_VAL2	0x003F0000
> +
> +/* define values for memory interface register (HVA_HIF_REG_MIF_CFG) */
> +#define MIF_CFG_VAL1	0x04460446
> +#define MIF_CFG_VAL2	0x04460806
> +#define MIF_CFG_VAL3	0x00000000
> +
> +/* define value for HEC memory interface register (HVA_HIF_REG_MIF_CFG) =
*/
> +#define HEC_MIF_CFG_VAL	0x000000C4
> +
> +/*=C2=A0=C2=A0Bits definition for clock gating register (HVA_HIF_REG_CLK=
_GATING) */
> +#define CLK_GATING_HVC	BIT(0)
> +#define CLK_GATING_HEC	BIT(1)
> +#define CLK_GATING_HJE	BIT(2)
> +
> +/* fix hva clock rate */
> +#define CLK_RATE		300000000
> +
> +/* fix delay for pmruntime */
> +#define AUTOSUSPEND_DELAY_MS	3
> +
> +/**
> + * hw encode error values
> + * NO_ERROR: Success, Task OK
> + * H264_BITSTREAM_OVERSIZE: VECH264 Bitstream size > bitstream buffer
> + * H264_FRAME_SKIPPED: VECH264 Frame skipped (refers to CPB Buffer Size)
> + * H264_SLICE_LIMIT_SIZE: VECH264 MB > slice limit size
> + * H264_MAX_SLICE_NUMBER: VECH264 max slice number reached
> + * H264_SLICE_READY: VECH264 Slice ready
> + * TASK_LIST_FULL: HVA/FPC task list full
> +		=C2=A0=C2=A0=C2=A0(discard latest transform command)
> + * UNKNOWN_COMMAND: Transform command not known by HVA/FPC
> + * WRONG_CODEC_OR_RESOLUTION: Wrong Codec or Resolution Selection
> + * NO_INT_COMPLETION: Time-out on interrupt completion
> + * LMI_ERR: Local Memory Interface Error
> + * EMI_ERR: External Memory Interface Error
> + * HECMI_ERR: HEC Memory Interface Error
> + */
> +enum hva_hw_error {
> +	NO_ERROR =3D 0x0,
> +	H264_BITSTREAM_OVERSIZE =3D 0x2,
> +	H264_FRAME_SKIPPED =3D 0x4,
> +	H264_SLICE_LIMIT_SIZE =3D 0x5,
> +	H264_MAX_SLICE_NUMBER =3D 0x7,
> +	H264_SLICE_READY =3D 0x8,
> +	TASK_LIST_FULL =3D 0xF0,
> +	UNKNOWN_COMMAND =3D 0xF1,
> +	WRONG_CODEC_OR_RESOLUTION =3D 0xF4,
> +	NO_INT_COMPLETION =3D 0x100,
> +	LMI_ERR =3D 0x101,
> +	EMI_ERR =3D 0x102,
> +	HECMI_ERR =3D 0x103,
> +};
> +
> +static irqreturn_t hva_hw_its_interrupt(int irq, void *data)
> +{
> +	struct hva_dev *hva =3D data;
> +
> +	/* read status registers */
> +	hva->sts_reg =3D readl_relaxed(hva->regs + HVA_HIF_FIFO_STS);
> +	hva->sfl_reg =3D readl_relaxed(hva->regs + HVA_HIF_REG_SFL);
> +
> +	/* acknowledge interruption */
> +	writel_relaxed(0x1, hva->regs + HVA_HIF_REG_IT_ACK);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t hva_hw_its_irq_thread(int irq, void *arg)
> +{
> +	struct hva_dev *hva =3D arg;
> +	struct device *dev =3D hva_to_dev(hva);
> +	u32 status =3D hva->sts_reg & 0xFF;
> +	u8 ctx_id =3D 0;
> +	struct hva_ctx *ctx =3D NULL;
> +
> +	dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: status: 0x%02x fifo l=
evel: 0x%02x\n",
> +		HVA_PREFIX, __func__, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
> +
> +	/*
> +	=C2=A0* status: task_id[31:16] client_id[15:8] status[7:0]
> +	=C2=A0* the context identifier is retrieved from the client identifier
> +	=C2=A0*/
> +	ctx_id =3D (hva->sts_reg & 0xFF00) >> 8;
> +	if (ctx_id >=3D HVA_MAX_INSTANCES) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: bad context identifi=
er: %d\n",
> +			ctx->name, __func__, ctx_id);
> +		ctx->hw_err =3D true;
> +		goto out;
> +	}
> +
> +	ctx =3D hva->instances[ctx_id];
> +
> +	switch (status) {
> +	case NO_ERROR:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: no error\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D false;
> +		break;
> +	case H264_SLICE_READY:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: h264 slice ready\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D false;
> +		break;
> +	case H264_FRAME_SKIPPED:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: h264 frame skipped\n=
",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D false;
> +		break;
> +	case H264_BITSTREAM_OVERSIZE:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s:h264 bitstream oversi=
ze\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	case H264_SLICE_LIMIT_SIZE:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: h264 slice limit siz=
e is reached\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	case H264_MAX_SLICE_NUMBER:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: h264 max slice numbe=
r is reached\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	case TASK_LIST_FULL:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s:task list full\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	case UNKNOWN_COMMAND:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: command not known\n"=
,
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	case WRONG_CODEC_OR_RESOLUTION:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: wrong codec or resol=
ution\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	default:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: status not recognize=
d\n",
> +			ctx->name, __func__);
> +		ctx->hw_err =3D true;
> +		break;
> +	}
> +out:
> +	complete(&hva->interrupt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t hva_hw_err_interrupt(int irq, void *data)
> +{
> +	struct hva_dev *hva =3D data;
> +
> +	/* read status registers */
> +	hva->sts_reg =3D readl_relaxed(hva->regs + HVA_HIF_FIFO_STS);
> +	hva->sfl_reg =3D readl_relaxed(hva->regs + HVA_HIF_REG_SFL);
> +
> +	/* read error registers */
> +	hva->lmi_err_reg =3D readl_relaxed(hva->regs + HVA_HIF_REG_LMI_ERR);
> +	hva->emi_err_reg =3D readl_relaxed(hva->regs + HVA_HIF_REG_EMI_ERR);
> +	hva->hec_mif_err_reg =3D readl_relaxed(hva->regs +
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_HIF_REG_HEC_MIF_ERR);
> +
> +	/* acknowledge interruption */
> +	writel_relaxed(0x1, hva->regs + HVA_HIF_REG_IT_ACK);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t hva_hw_err_irq_thread(int irq, void *arg)
> +{
> +	struct hva_dev *hva =3D arg;
> +	struct device *dev =3D hva_to_dev(hva);
> +	u8 ctx_id =3D 0;
> +	struct hva_ctx *ctx;
> +
> +	dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0status: 0x%02x fifo level=
: 0x%02x\n",
> +		HVA_PREFIX, hva->sts_reg & 0xFF, hva->sfl_reg & 0xF);
> +
> +	/*
> +	=C2=A0* status: task_id[31:16] client_id[15:8] status[7:0]
> +	=C2=A0* the context identifier is retrieved from the client identifier
> +	=C2=A0*/
> +	ctx_id =3D (hva->sts_reg & 0xFF00) >> 8;
> +	if (ctx_id >=3D HVA_MAX_INSTANCES) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bad context identifier: =
%d\n", HVA_PREFIX,
> +			ctx_id);
> +		goto out;
> +	}
> +
> +	ctx =3D hva->instances[ctx_id];
> +
> +	if (hva->lmi_err_reg) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0local memory interface e=
rror: 0x%08x\n",
> +			ctx->name, hva->lmi_err_reg);
> +		ctx->hw_err =3D true;
> +	}
> +
> +	if (hva->lmi_err_reg) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0external memory interfac=
e error: 0x%08x\n",
> +			ctx->name, hva->emi_err_reg);
> +		ctx->hw_err =3D true;
> +	}
> +
> +	if (hva->hec_mif_err_reg) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hec memory interface err=
or: 0x%08x\n",
> +			ctx->name, hva->hec_mif_err_reg);
> +		ctx->hw_err =3D true;
> +	}
> +out:
> +	complete(&hva->interrupt);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static unsigned long int hva_hw_get_ip_version(struct hva_dev *hva)
> +{
> +	struct device *dev =3D hva_to_dev(hva);
> +	unsigned long int version;
> +
> +	if (pm_runtime_get_sync(dev) < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get pm_runtime=
\n", HVA_PREFIX);
> +		mutex_unlock(&hva->protect_mutex);
> +		return -EFAULT;
> +	}
> +
> +	version =3D readl_relaxed(hva->regs + HVA_HIF_REG_VERSION) &
> +				VERSION_ID_MASK;
> +
> +	pm_runtime_put_autosuspend(dev);
> +
> +	switch (version) {
> +	case HVA_VERSION_V400:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0IP hardware version 0x%l=
x\n",
> +			HVA_PREFIX, version);
> +		break;
> +	default:
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unknown IP hardware vers=
ion 0x%lx\n",
> +			HVA_PREFIX, version);
> +		version =3D HVA_VERSION_UNKNOWN;
> +		break;
> +	}
> +
> +	return version;
> +}
> +
> +int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *regs;
> +	struct resource *esram;
> +	int ret;
> +
> +	WARN_ON(!hva);
> +
> +	/* get memory for registers */
> +	regs =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	hva->regs =3D devm_ioremap_resource(dev, regs);
> +	if (IS_ERR_OR_NULL(hva->regs)) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get regs\n", H=
VA_PREFIX);
> +		return PTR_ERR(hva->regs);
> +	}
> +
> +	/* get memory for esram */
> +	esram =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (IS_ERR_OR_NULL(esram)) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get esram\n", =
HVA_PREFIX);
> +		return PTR_ERR(esram);
> +	}
> +	hva->esram_addr =3D esram->start;
> +	hva->esram_size =3D esram->end - esram->start + 1;
> +
> +	dev_info(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0esram reserved for addre=
ss: 0x%x size:%d\n",
> +		=C2=A0HVA_PREFIX, hva->esram_addr, hva->esram_size);
> +
> +	/* get clock resource */
> +	hva->clk =3D devm_clk_get(dev, "clk_hva");
> +	if (IS_ERR(hva->clk)) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get clock\n", =
HVA_PREFIX);
> +		return PTR_ERR(hva->clk);
> +	}
> +
> +	ret =3D clk_prepare(hva->clk);
> +	if (ret < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to prepare clock\=
n", HVA_PREFIX);
> +		hva->clk =3D ERR_PTR(-EINVAL);
> +		return ret;
> +	}
> +
> +	/* get status interruption resource */
> +	ret=C2=A0=C2=A0=3D platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get status IRQ=
\n", HVA_PREFIX);
> +		goto err_clk;
> +	}
> +	hva->irq_its =3D ret;
> +
> +	ret =3D devm_request_threaded_irq(dev, hva->irq_its, hva_hw_its_interru=
pt,
> +					hva_hw_its_irq_thread,
> +					IRQF_ONESHOT,
> +					"hva_its_irq", hva);
> +	if (ret) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to install status=
 IRQ 0x%x\n",
> +			HVA_PREFIX, hva->irq_its);
> +		goto err_clk;
> +	}
> +	disable_irq(hva->irq_its);
> +
> +	/* get error interruption resource */
> +	ret =3D platform_get_irq(pdev, 1);
> +	if (ret < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get error IRQ\=
n", HVA_PREFIX);
> +		goto err_clk;
> +	}
> +	hva->irq_err =3D ret;
> +
> +	ret =3D devm_request_threaded_irq(dev, hva->irq_err, hva_hw_err_interru=
pt,
> +					hva_hw_err_irq_thread,
> +					IRQF_ONESHOT,
> +					"hva_err_irq", hva);
> +	if (ret) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to install error =
IRQ 0x%x\n",
> +			HVA_PREFIX, hva->irq_err);
> +		goto err_clk;
> +	}
> +	disable_irq(hva->irq_err);
> +
> +	/* initialise protection mutex */
> +	mutex_init(&hva->protect_mutex);
> +
> +	/* initialise completion signal */
> +	init_completion(&hva->interrupt);
> +
> +	/* initialise runtime power management */
> +	pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY_MS);
> +	pm_runtime_use_autosuspend(dev);
> +	pm_runtime_set_suspended(dev);
> +	pm_runtime_enable(dev);
> +
> +	ret =3D pm_runtime_get_sync(dev);
> +	if (ret < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to set PM\n", HVA=
_PREFIX);
> +		goto err_clk;
> +	}
> +
> +	/* check IP hardware version */
> +	hva->ip_version =3D hva_hw_get_ip_version(hva);
> +
> +	if (hva->ip_version =3D=3D HVA_VERSION_UNKNOWN) {
> +		ret =3D -EINVAL;
> +		goto err_pm;
> +	}
> +
> +	dev_info(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0found hva device (versio=
n 0x%lx)\n", HVA_PREFIX,
> +		=C2=A0hva->ip_version);
> +
> +	return 0;
> +
> +err_pm:
> +	pm_runtime_put(dev);
> +err_clk:
> +	if (hva->clk)
> +		clk_unprepare(hva->clk);
> +
> +	return ret;
> +}
> +
> +void hva_hw_remove(struct hva_dev *hva)
> +{
> +	struct device *dev =3D hva_to_dev(hva);
> +
> +	disable_irq(hva->irq_its);
> +	disable_irq(hva->irq_err);
> +
> +	pm_runtime_put_autosuspend(dev);
> +	pm_runtime_disable(dev);
> +}
> +
> +int hva_hw_runtime_suspend(struct device *dev)
> +{
> +	struct hva_dev *hva =3D dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(hva->clk);
> +
> +	return 0;
> +}
> +
> +int hva_hw_runtime_resume(struct device *dev)
> +{
> +	struct hva_dev *hva =3D dev_get_drvdata(dev);
> +
> +	if (clk_prepare_enable(hva->clk)) {
> +		dev_err(hva->dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to prepare h=
va clk\n",
> +			HVA_PREFIX);
> +		return -EINVAL;
> +	}
> +
> +	if (clk_set_rate(hva->clk, CLK_RATE)) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to set clock freq=
uency\n",
> +			HVA_PREFIX);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> +			struct hva_buffer *task)
> +{
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +	struct device *dev =3D hva_to_dev(hva);
> +	u8 client_id =3D ctx->id;
> +	int ret;
> +	u32 reg =3D 0;
> +
> +	mutex_lock(&hva->protect_mutex);
> +
> +	/* enable irqs */
> +	enable_irq(hva->irq_its);
> +	enable_irq(hva->irq_err);
> +
> +	if (pm_runtime_get_sync(dev) < 0) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0failed to get pm_runtime=
\n", ctx->name);
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	reg =3D readl_relaxed(hva->regs + HVA_HIF_REG_CLK_GATING);
> +	switch (cmd) {
> +	case H264_ENC:
> +		reg |=3D CLK_GATING_HVC;
> +		break;
> +	default:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unknown command 0x%x\n",=
 ctx->name, cmd);
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +	writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
> +
> +	dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: write configuration r=
egisters\n", ctx->name,
> +		__func__);
> +
> +	/* byte swap config */
> +	writel_relaxed(BSM_CFG_VAL1, hva->regs + HVA_HIF_REG_BSM);
> +
> +	/* define Max Opcode Size and Max Message Size for LMI and EMI */
> +	writel_relaxed(MIF_CFG_VAL3, hva->regs + HVA_HIF_REG_MIF_CFG);
> +	writel_relaxed(HEC_MIF_CFG_VAL, hva->regs + HVA_HIF_REG_HEC_MIF_CFG);
> +
> +	/*
> +	=C2=A0* command FIFO: task_id[31:16] client_id[15:8] command_type[7:0]
> +	=C2=A0* the context identifier is provided as client identifier to the
> +	=C2=A0* hardware, and is retrieved in the interrupt functions from the
> +	=C2=A0* status register
> +	=C2=A0*/
> +	dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: send task (cmd: %d, t=
ask_desc: %pad)\n",
> +		ctx->name, __func__, cmd + (client_id << 8), &task->paddr);
> +	writel_relaxed(cmd + (client_id << 8), hva->regs + HVA_HIF_FIFO_CMD);
> +	writel_relaxed(task->paddr, hva->regs + HVA_HIF_FIFO_CMD);
> +
> +	if (!wait_for_completion_timeout(&hva->interrupt,
> +					=C2=A0msecs_to_jiffies(2000))) {
> +		dev_err(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0%s: time out on completi=
on\n", ctx->name,
> +			__func__);
> +		ret =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	/* get encoding status */
> +	ret =3D ctx->hw_err ? -EFAULT : 0;
> +
> +out:
> +	disable_irq(hva->irq_its);
> +	disable_irq(hva->irq_err);
> +
> +	switch (cmd) {
> +	case H264_ENC:
> +		reg &=3D ~CLK_GATING_HVC;
> +		writel_relaxed(reg, hva->regs + HVA_HIF_REG_CLK_GATING);
> +		break;
> +	default:
> +		dev_dbg(dev, "%s=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unknown command 0x%x\n",=
 ctx->name, cmd);
> +	}
> +
> +	pm_runtime_put_autosuspend(dev);
> +	mutex_unlock(&hva->protect_mutex);
> +
> +	return ret;
> +}
> diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/plat=
form/sti/hva/hva-hw.h
> new file mode 100644
> index 0000000..efb45b9
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-hw.h
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef HVA_HW_H
> +#define HVA_HW_H
> +
> +#include "hva-mem.h"
> +
> +/* HVA Versions */
> +#define HVA_VERSION_UNKNOWN=C2=A0=C2=A0=C2=A0=C2=A00x000
> +#define HVA_VERSION_V400=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x400
> +
> +/* HVA command types */
> +enum hva_hw_cmd_type {
> +	/* RESERVED =3D 0x00 */
> +	/* RESERVED =3D 0x01 */
> +	H264_ENC =3D 0x02,
> +	/* RESERVED =3D 0x03 */
> +	/* RESERVED =3D 0x04 */
> +	/* RESERVED =3D 0x05 */
> +	/* RESERVED =3D 0x06 */
> +	/* RESERVED =3D 0x07 */
> +	REMOVE_CLIENT =3D 0x08,
> +	FREEZE_CLIENT =3D 0x09,
> +	START_CLIENT =3D 0x0A,
> +	FREEZE_ALL =3D 0x0B,
> +	START_ALL =3D 0x0C,
> +	REMOVE_ALL =3D 0x0D
> +};
> +
> +int hva_hw_probe(struct platform_device *pdev, struct hva_dev *hva);
> +void hva_hw_remove(struct hva_dev *hva);
> +int hva_hw_runtime_suspend(struct device *dev);
> +int hva_hw_runtime_resume(struct device *dev);
> +int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> +			struct hva_buffer *task);
> +
> +#endif /* HVA_HW_H */
> diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/pla=
tform/sti/hva/hva-mem.c
> new file mode 100644
> index 0000000..759c873
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-mem.c
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#include "hva.h"
> +#include "hva-mem.h"
> +
> +int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
> +		=C2=A0=C2=A0struct hva_buffer **buf)
> +{
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct hva_buffer *b;
> +	dma_addr_t paddr;
> +	void *base;
> +	DEFINE_DMA_ATTRS(attrs);
> +
> +	b =3D devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &attrs);
> +	base =3D dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA, &attr=
s);
> +	if (!base) {
> +		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=3D%d)\n",
> +			ctx->name, __func__, name, size);
> +		devm_kfree(dev, b);
> +		return -ENOMEM;
> +	}
> +
> +	b->size =3D size;
> +	b->paddr =3D paddr;
> +	b->vaddr =3D base;
> +	b->attrs =3D attrs;
> +	b->name =3D name;
> +
> +	dev_dbg(dev,
> +		"%s allocate %d bytes of HW memory @(virt=3D%p, phy=3D%pad): %s\n",
> +		ctx->name, size, b->vaddr, &b->paddr, b->name);
> +
> +	/* return=C2=A0=C2=A0hva buffer to user */
> +	*buf =3D b;
> +
> +	return 0;
> +}
> +
> +void hva_mem_free(struct hva_ctx *ctx, struct hva_buffer *buf)
> +{
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	dev_dbg(dev,
> +		"%s free %d bytes of HW memory @(virt=3D%p, phy=3D%pad): %s\n",
> +		ctx->name, buf->size, buf->vaddr, &buf->paddr, buf->name);
> +
> +	dma_free_attrs(dev, buf->size, buf->vaddr, buf->paddr, &buf->attrs);
> +
> +	devm_kfree(dev, buf);
> +}
> diff --git a/drivers/media/platform/sti/hva/hva-mem.h b/drivers/media/pla=
tform/sti/hva/hva-mem.h
> new file mode 100644
> index 0000000..e8a3f7e
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-mem.h
> @@ -0,0 +1,36 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef HVA_MEM_H
> +#define HVA_MEM_H
> +
> +/**
> + * struct hva_buffer - hva buffer
> + *
> + * @name:=C2=A0=C2=A0name of requester
> + * @attrs: dma attributes
> + * @paddr: physical address (for hardware)
> + * @vaddr: virtual address (kernel can read/write)
> + * @size:=C2=A0=C2=A0size of buffer
> + */
> +struct hva_buffer {
> +	const char		*name;
> +	struct dma_attrs	attrs;
> +	dma_addr_t		paddr;
> +	void			*vaddr;
> +	u32			size;
> +};
> +
> +int hva_mem_alloc(struct hva_ctx *ctx,
> +		=C2=A0=C2=A0__u32 size,
> +		=C2=A0=C2=A0const char *name,
> +		=C2=A0=C2=A0struct hva_buffer **buf);
> +
> +void hva_mem_free(struct hva_ctx *ctx,
> +		=C2=A0=C2=A0struct hva_buffer *buf);
> +
> +#endif /* HVA_MEM_H */
> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/pl=
atform/sti/hva/hva-v4l2.c
> new file mode 100644
> index 0000000..bacc9ff
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
> @@ -0,0 +1,1299 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +
> +#include "hva.h"
> +#include "hva-hw.h"
> +
> +#define HVA_NAME "hva"
> +
> +#define MIN_FRAMES	1
> +#define MIN_STREAMS	1
> +
> +#define HVA_MIN_WIDTH	32
> +#define HVA_MAX_WIDTH	1920
> +#define HVA_MIN_HEIGHT	32
> +#define HVA_MAX_HEIGHT	1920
> +
> +/* HVA requires a 16x16 pixels alignment for frames */
> +#define HVA_WIDTH_ALIGNMENT	16
> +#define HVA_HEIGHT_ALIGNMENT	16
> +
> +#define DEFAULT_WIDTH		HVA_MIN_WIDTH
> +#define	DEFAULT_HEIGHT		HVA_MIN_HEIGHT
> +#define DEFAULT_FRAME_NUM	1
> +#define DEFAULT_FRAME_DEN	30
> +
> +#define to_type_str(type) (type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT ? \
> +			=C2=A0=C2=A0=C2=A0"frame" : "stream")
> +
> +#define fh_to_ctx(f)=C2=A0=C2=A0=C2=A0=C2=A0(container_of(f, struct hva_=
ctx, fh))
> +
> +/* registry of available encoders */
> +const struct hva_enc *hva_encoders[] =3D {
> +};
> +
> +static inline int frame_size(u32 w, u32 h, u32 fmt)
> +{
> +	switch (fmt) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		return (w * h * 3) / 2;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static inline int frame_stride(u32 w, u32 fmt)
> +{
> +	switch (fmt) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		return w;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static inline int frame_alignment(u32 fmt)
> +{
> +	switch (fmt) {
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		/* multiple of 2 */
> +		return 2;
> +	default:
> +		return 1;
> +	}
> +}
> +
> +static inline int estimated_stream_size(u32 w, u32 h)
> +{
> +	/*
> +	=C2=A0* HVA only encodes in YUV420 format, whatever the frame format.
> +	=C2=A0* A compression ratio of 2 is assumed: thus, the maximum size
> +	=C2=A0* of a stream is estimated to ((width x height x 3 / 2) / 2)
> +	=C2=A0*/
> +	return (w * h * 3) / 4;
> +}
> +
> +static void set_default_params(struct hva_ctx *ctx)
> +{
> +	struct hva_frameinfo *frameinfo =3D &ctx->frameinfo;
> +	struct hva_streaminfo *streaminfo =3D &ctx->streaminfo;
> +
> +	frameinfo->pixelformat =3D V4L2_PIX_FMT_NV12;
> +	frameinfo->width =3D DEFAULT_WIDTH;
> +	frameinfo->height =3D DEFAULT_HEIGHT;
> +	frameinfo->aligned_width =3D DEFAULT_WIDTH;
> +	frameinfo->aligned_height =3D DEFAULT_HEIGHT;
> +	frameinfo->size =3D frame_size(frameinfo->aligned_width,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frameinfo->aligned_height,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frameinfo->pixelformat);
> +
> +	streaminfo->streamformat =3D V4L2_PIX_FMT_H264;
> +	streaminfo->width =3D DEFAULT_WIDTH;
> +	streaminfo->height =3D DEFAULT_HEIGHT;
> +
> +	ctx->max_stream_size =3D estimated_stream_size(streaminfo->width,
> +						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0streaminfo->height);
> +}
> +
> +static const struct hva_enc *hva_find_encoder(struct hva_ctx *ctx,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32 pixelformat,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32 streamformat)
> +{
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +	const struct hva_enc *enc;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < hva->nb_of_encoders; i++) {
> +		enc =3D hva->encoders[i];
> +		if ((enc->pixelformat =3D=3D pixelformat) &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0(enc->streamformat =3D=3D streamformat))
> +			return enc;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void register_format(u32 format, u32 formats[], u32 *nb_of_format=
s)
> +{
> +	u32 i;
> +	bool found =3D false;
> +
> +	for (i =3D 0; i < *nb_of_formats; i++) {
> +		if (format =3D=3D formats[i]) {
> +			found =3D true;
> +			break;
> +		}
> +	}
> +
> +	if (!found)
> +		formats[(*nb_of_formats)++] =3D format;
> +}
> +
> +static void register_formats(struct hva_dev *hva)
> +{
> +	unsigned int i;
> +
> +	for (i =3D 0; i < hva->nb_of_encoders; i++) {
> +		register_format(hva->encoders[i]->pixelformat,
> +				hva->pixelformats,
> +				&hva->nb_of_pixelformats);
> +
> +		register_format(hva->encoders[i]->streamformat,
> +				hva->streamformats,
> +				&hva->nb_of_streamformats);
> +	}
> +}
> +
> +static void register_encoders(struct hva_dev *hva)
> +{
> +	struct device *dev =3D hva_to_dev(hva);
> +	unsigned int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(hva_encoders); i++) {
> +		if (hva->nb_of_encoders >=3D HVA_MAX_ENCODERS) {
> +			dev_dbg(dev,
> +				"%s failed to register encoder (%d maximum reached)\n",
> +				hva_encoders[i]->name, HVA_MAX_ENCODERS);
> +			return;
> +		}
> +
> +		hva->encoders[hva->nb_of_encoders++] =3D hva_encoders[i];
> +		dev_info(dev, "%s encoder registered\n", hva_encoders[i]->name);
> +	}
> +}
> +
> +static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
> +			=C2=A0=C2=A0=C2=A0=C2=A0u32 pixelformat, struct hva_enc **penc)
> +{
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct hva_enc *enc;
> +	unsigned int i;
> +	int ret;
> +	bool found =3D false;
> +
> +	/* find an encoder which can deal with these formats */
> +	for (i =3D 0; i < hva->nb_of_encoders; i++) {
> +		enc =3D (struct hva_enc *)hva->encoders[i];
> +		if ((enc->streamformat =3D=3D streamformat) &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0(enc->pixelformat =3D=3D pixelformat)) {
> +			found =3D true;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		dev_err(dev, "%s no encoder found matching %4.4s =3D> %4.4s\n",
> +			ctx->name, (char *)&pixelformat, (char *)&streamformat);
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(dev, "%s one encoder matching %4.4s =3D> %4.4s\n",
> +		ctx->name, (char *)&pixelformat, (char *)&streamformat);
> +
> +	/* update instance name */
> +	snprintf(ctx->name, sizeof(ctx->name), "[%3d:%4.4s]",
> +		=C2=A0hva->instance_id, (char *)&streamformat);
> +
> +	/* open encoder instance */
> +	ret =3D enc->open(ctx);
> +	if (ret) {
> +		dev_err(dev, "%s failed to open encoder instance (%d)\n",
> +			ctx->name, ret);
> +		return ret;
> +	}
> +
> +	dev_dbg(dev, "%s %s encoder opened\n", ctx->name, enc->name);
> +
> +	*penc =3D enc;
> +
> +	return ret;
> +}
> +
> +/*
> + * V4L2 ioctl operations
> + */
> +
> +static int hva_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +
> +	strlcpy(cap->driver, hva->pdev->name, sizeof(cap->driver));
> +	strlcpy(cap->card, hva->pdev->name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +		=C2=A0HVA_NAME);
> +
> +	cap->device_caps =3D V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
> +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int hva_enum_fmt_stream(struct file *file, void *priv,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct v4l2_fmtdesc *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +
> +	if (unlikely(f->index >=3D hva->nb_of_streamformats))
> +		return -EINVAL;
> +
> +	f->pixelformat =3D hva->streamformats[f->index];
> +	snprintf(f->description, sizeof(f->description), "%4.4s",
> +		=C2=A0(char *)&f->pixelformat);
> +	f->flags =3D V4L2_FMT_FLAG_COMPRESSED;
> +
> +	return 0;
> +}
> +
> +static int hva_enum_fmt_frame(struct file *file, void *priv,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct v4l2_fmtdesc *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +
> +	if (unlikely(f->index >=3D hva->nb_of_pixelformats))
> +		return -EINVAL;
> +
> +	f->pixelformat =3D hva->pixelformats[f->index];
> +	snprintf(f->description, sizeof(f->description), "%4.4s",
> +		=C2=A0(char *)&f->pixelformat);
> +
> +	return 0;
> +}
> +
> +static int hva_g_fmt_stream(struct file *file, void *fh, struct v4l2_for=
mat *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct hva_streaminfo *streaminfo =3D &ctx->streaminfo;
> +
> +	f->fmt.pix.width =3D streaminfo->width;
> +	f->fmt.pix.height =3D streaminfo->height;
> +	f->fmt.pix.field =3D V4L2_FIELD_NONE;
> +	f->fmt.pix.colorspace =3D V4L2_COLORSPACE_SMPTE170M;

Hard coding this is not great.Ideally the colorimetry (if not modified) sho=
uld be copied from OUTPUT to CAPTURE, you may also set this to=C2=A0V4L2_CO=
LORSPACE_DEFAULT.

> +	f->fmt.pix.pixelformat =3D streaminfo->streamformat;
> +	f->fmt.pix.bytesperline =3D 0;
> +	f->fmt.pix.sizeimage =3D ctx->max_stream_size;
> +
> +	dev_dbg(dev, "%s V4L2 G_FMT (CAPTURE): %dx%d fmt:%.4s size:%d\n",
> +		ctx->name, f->fmt.pix.width, f->fmt.pix.height,
> +		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
> +	return 0;
> +}
> +
> +static int hva_g_fmt_frame(struct file *file, void *fh, struct v4l2_form=
at *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct hva_frameinfo *frameinfo =3D &ctx->frameinfo;
> +
> +	f->fmt.pix.width =3D frameinfo->width;
> +	f->fmt.pix.height =3D frameinfo->height;
> +	f->fmt.pix.field =3D V4L2_FIELD_NONE;
> +	f->fmt.pix.colorspace =3D V4L2_COLORSPACE_SMPTE170M;
> +	f->fmt.pix.pixelformat =3D frameinfo->pixelformat;
> +	f->fmt.pix.bytesperline =3D frame_stride(frameinfo->aligned_width,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frameinfo->pixelformat);
> +	f->fmt.pix.sizeimage =3D frameinfo->size;
> +
> +	dev_dbg(dev, "%s V4L2 G_FMT (OUTPUT): %dx%d fmt:%.4s size:%d\n",
> +		ctx->name, f->fmt.pix.width, f->fmt.pix.height,
> +		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
> +
> +	return 0;
> +}
> +
> +static int hva_try_fmt_stream(struct file *file, void *priv,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct v4l2_format *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct v4l2_pix_format *pix =3D &f->fmt.pix;
> +	u32 streamformat =3D pix->pixelformat;
> +	const struct hva_enc *enc;
> +	u32 width, height;
> +	u32 stream_size;
> +
> +	enc =3D hva_find_encoder(ctx, ctx->frameinfo.pixelformat, streamformat)=
;
> +	if (!enc) {
> +		dev_dbg(dev,
> +			"%s V4L2 TRY_FMT (CAPTURE): unsupported format %.4s\n",
> +			ctx->name, (char *)&pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	width =3D pix->width;
> +	height =3D pix->height;
> +	if (ctx->flags & HVA_FLAG_FRAMEINFO) {
> +		/*
> +		=C2=A0* if the frame resolution is already fixed, only allow the
> +		=C2=A0* same stream resolution
> +		=C2=A0*/
> +		pix->width =3D ctx->frameinfo.width;
> +		pix->height =3D ctx->frameinfo.height;
> +		if ((pix->width !=3D width) || (pix->height !=3D height))
> +			dev_dbg(dev,
> +				"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit=
 frame resolution\n",
> +				ctx->name, width, height,
> +				pix->width, pix->height);
> +	} else {
> +		/* adjust width & height */
> +		v4l_bound_align_image(&pix->width,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_MIN_WIDTH, enc->max_width,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&pix->height,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_MIN_HEIGHT, enc->max_height,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00);
> +
> +		if ((pix->width !=3D width) || (pix->height !=3D height))
> +			dev_dbg(dev,
> +				"%s V4L2 TRY_FMT (CAPTURE): resolution updated %dx%d -> %dx%d to fit=
 min/max/alignment\n",
> +				ctx->name, width, height,
> +				pix->width, pix->height);
> +	}
> +
> +	stream_size =3D estimated_stream_size(pix->width, pix->height);
> +	if (pix->sizeimage < stream_size)
> +		pix->sizeimage =3D stream_size;
> +
> +	pix->bytesperline =3D 0;
> +	pix->colorspace =3D V4L2_COLORSPACE_SMPTE170M;
> +	pix->field =3D V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int hva_try_fmt_frame(struct file *file, void *priv,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct v4l2_format *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct v4l2_pix_format *pix =3D &f->fmt.pix;
> +	u32 pixelformat =3D pix->pixelformat;
> +	const struct hva_enc *enc;
> +	u32 width, height;
> +
> +	enc =3D hva_find_encoder(ctx, pixelformat, ctx->streaminfo.streamformat=
);
> +	if (!enc) {
> +		dev_dbg(dev,
> +			"%s V4L2 TRY_FMT (OUTPUT): unsupported format %.4s\n",
> +			ctx->name, (char *)&pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	/* adjust width & height */
> +	width =3D pix->width;
> +	height =3D pix->height;
> +	v4l_bound_align_image(&pix->width,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_MIN_WIDTH, HVA_MAX_WIDTH,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frame_alignment(pixelformat) - 1,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&pix->height,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_MIN_HEIGHT, HVA_MAX_HEIGHT,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frame_alignment(pixelformat) - 1,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00);
> +
> +	if ((pix->width !=3D width) || (pix->height !=3D height))
> +		dev_dbg(dev,
> +			"%s V4L2 TRY_FMT (OUTPUT): resolution updated %dx%d -> %dx%d to fit m=
in/max/alignment\n",
> +			ctx->name, width, height, pix->width, pix->height);
> +
> +	width =3D ALIGN(pix->width, HVA_WIDTH_ALIGNMENT);
> +	height =3D ALIGN(pix->height, HVA_HEIGHT_ALIGNMENT);
> +
> +	pix->bytesperline =3D frame_stride(width, pixelformat);
> +	pix->sizeimage =3D frame_size(width, height, pixelformat);
> +	pix->colorspace =3D V4L2_COLORSPACE_SMPTE170M;
> +	pix->field =3D V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int hva_s_fmt_stream(struct file *file, void *fh, struct v4l2_for=
mat *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct vb2_queue *vq;
> +	int ret;
> +
> +	dev_dbg(dev, "%s V4L2 S_FMT (CAPTURE): %dx%d fmt:%.4s size:%d\n",
> +		ctx->name, f->fmt.pix.width, f->fmt.pix.height,
> +		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
> +
> +	ret =3D hva_try_fmt_stream(file, fh, f);
> +	if (ret) {
> +		dev_dbg(dev, "%s V4L2 S_FMT (CAPTURE): unsupported format %.4s\n",
> +			ctx->name, (char *)&f->fmt.pix.pixelformat);
> +		return ret;
> +	}
> +
> +	vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq)) {
> +		dev_dbg(dev, "%s V4L2 S_FMT (CAPTURE): queue busy\n",
> +			ctx->name);
> +		return -EBUSY;
> +	}
> +
> +	ctx->max_stream_size =3D f->fmt.pix.sizeimage;
> +	ctx->streaminfo.width =3D f->fmt.pix.width;
> +	ctx->streaminfo.height =3D f->fmt.pix.height;
> +	ctx->streaminfo.streamformat =3D f->fmt.pix.pixelformat;
> +	ctx->flags |=3D HVA_FLAG_STREAMINFO;
> +
> +	return 0;
> +}
> +
> +static int hva_s_fmt_frame(struct file *file, void *fh, struct v4l2_form=
at *f)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct v4l2_pix_format *pix =3D &f->fmt.pix;
> +	struct vb2_queue *vq;
> +	int ret;
> +
> +	dev_dbg(dev, "%s V4L2 S_FMT (OUTPUT): %dx%d fmt %.4s size %d\n",
> +		ctx->name, f->fmt.pix.width, f->fmt.pix.height,
> +		(u8 *)&f->fmt.pix.pixelformat, f->fmt.pix.sizeimage);
> +
> +	ret =3D hva_try_fmt_frame(file, fh, f);
> +	if (ret) {
> +		dev_dbg(dev, "%s V4L2 S_FMT (OUTPUT): unsupported format %.4s\n",
> +			ctx->name, (char *)&f->fmt.pix.pixelformat);
> +		return ret;
> +	}
> +
> +	vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_streaming(vq)) {
> +		dev_dbg(dev, "%s V4L2 S_FMT (OUTPUT): queue busy\n", ctx->name);
> +		return -EBUSY;
> +	}
> +
> +	ctx->frameinfo.aligned_width =3D ALIGN(pix->width, HVA_WIDTH_ALIGNMENT)=
;
> +	ctx->frameinfo.aligned_height =3D ALIGN(pix->height,
> +					=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HVA_HEIGHT_ALIGNMENT);
> +
> +	ctx->frameinfo.size =3D pix->sizeimage;
> +	ctx->frameinfo.pixelformat =3D pix->pixelformat;
> +	ctx->frameinfo.width =3D pix->width;
> +	ctx->frameinfo.height =3D pix->height;
> +	ctx->flags |=3D HVA_FLAG_FRAMEINFO;
> +
> +	return 0;
> +}
> +
> +static int hva_s_parm(struct file *file, void *fh, struct v4l2_streampar=
m *sp)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct v4l2_fract *time_per_frame =3D &ctx->ctrls.time_per_frame;
> +
> +	time_per_frame->numerator =3D sp->parm.capture.timeperframe.numerator;
> +	time_per_frame->denominator =3D
> +		sp->parm.capture.timeperframe.denominator;
> +
> +	dev_dbg(dev, "%s set parameters %d/%d\n", ctx->name,
> +		time_per_frame->numerator, time_per_frame->denominator);
> +
> +	return 0;
> +}
> +
> +static int hva_g_parm(struct file *file, void *fh, struct v4l2_streampar=
m *sp)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct v4l2_fract *time_per_frame =3D &ctx->ctrls.time_per_frame;
> +
> +	sp->parm.capture.timeperframe.numerator =3D time_per_frame->numerator;
> +	sp->parm.capture.timeperframe.denominator =3D
> +		time_per_frame->denominator;
> +
> +	dev_dbg(dev, "%s get parameters %d/%d\n", ctx->name,
> +		time_per_frame->numerator, time_per_frame->denominator);
> +
> +	return 0;
> +}
> +
> +static int hva_qbuf(struct file *file, void *priv, struct v4l2_buffer *b=
uf)
> +{
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	if (buf->type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		/*
> +		=C2=A0* depending on the targeted compressed video format, the
> +		=C2=A0* capture buffer might contain headers (e.g. H.264 SPS/PPS)
> +		=C2=A0* filled in by the driver client; the size of these data is
> +		=C2=A0* copied from the bytesused field of the V4L2 buffer in the
> +		=C2=A0* payload field of the hva stream buffer
> +		=C2=A0*/
> +		struct vb2_queue *vq;
> +		struct hva_stream *stream;
> +
> +		vq =3D v4l2_m2m_get_vq(ctx->fh.m2m_ctx, buf->type);
> +
> +		if (buf->index >=3D vq->num_buffers) {
> +			dev_dbg(dev, "%s buffer index %d out of range (%d)\n",
> +				ctx->name, buf->index, vq->num_buffers);
> +			return -EINVAL;
> +		}
> +
> +		stream =3D (struct hva_stream *)vq->bufs[buf->index];
> +		stream->bytesused =3D buf->bytesused;
> +	}
> +
> +	return v4l2_m2m_qbuf(file, ctx->fh.m2m_ctx, buf);
> +}
> +
> +/* V4L2 ioctl ops */
> +static const struct v4l2_ioctl_ops hva_ioctl_ops =3D {
> +	.vidioc_querycap		=3D hva_querycap,
> +	.vidioc_enum_fmt_vid_cap	=3D hva_enum_fmt_stream,
> +	.vidioc_enum_fmt_vid_out	=3D hva_enum_fmt_frame,
> +	.vidioc_g_fmt_vid_cap		=3D hva_g_fmt_stream,
> +	.vidioc_g_fmt_vid_out		=3D hva_g_fmt_frame,
> +	.vidioc_try_fmt_vid_cap		=3D hva_try_fmt_stream,
> +	.vidioc_try_fmt_vid_out		=3D hva_try_fmt_frame,
> +	.vidioc_s_fmt_vid_cap		=3D hva_s_fmt_stream,
> +	.vidioc_s_fmt_vid_out		=3D hva_s_fmt_frame,
> +	.vidioc_g_parm			=3D hva_g_parm,
> +	.vidioc_s_parm			=3D hva_s_parm,
> +	.vidioc_reqbufs			=3D v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_create_bufs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_querybuf		=3D v4l2_m2m_ioctl_querybuf,
> +	.vidioc_expbuf			=3D v4l2_m2m_ioctl_expbuf,
> +	.vidioc_qbuf			=3D hva_qbuf,
> +	.vidioc_dqbuf			=3D v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon		=3D v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		=3D v4l2_m2m_ioctl_streamoff,
> +	.vidioc_subscribe_event		=3D v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	=3D v4l2_event_unsubscribe,
> +};
> +
> +/*
> + * V4L2 control operations
> + */
> +
> +static int hva_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct hva_ctx *ctx =3D container_of(ctrl->handler, struct hva_ctx,
> +					=C2=A0=C2=A0=C2=A0ctrl_handler);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	dev_dbg(dev, "%s S_CTRL: id =3D %d, val =3D %d\n", ctx->name,
> +		ctrl->id, ctrl->val);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
> +		ctx->ctrls.bitrate_mode =3D ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		ctx->ctrls.gop_size =3D ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +		ctx->ctrls.bitrate =3D ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_ASPECT:
> +		ctx->ctrls.aspect =3D ctrl->val;
> +		break;
> +	default:
> +		dev_dbg(dev, "%s S_CTRL: invalid control (id =3D %d)\n",
> +			ctx->name, ctrl->id);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* V4L2 control ops */
> +static const struct v4l2_ctrl_ops hva_ctrl_ops =3D {
> +	.s_ctrl =3D hva_s_ctrl,
> +};
> +
> +static int hva_ctrls_setup(struct hva_ctx *ctx)
> +{
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	u64 mask;
> +
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
> +
> +	v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_CID_MPEG_VIDEO_BITRATE=
_MODE,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_MPEG_VIDEO_BITRATE_MOD=
E_CBR,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_MPEG_VIDEO_BITRATE_MOD=
E_CBR);
> +
> +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
> +			=C2=A0=C2=A0V4L2_CID_MPEG_VIDEO_GOP_SIZE,
> +			=C2=A0=C2=A01, 60, 1, 16);
> +
> +	v4l2_ctrl_new_std(&ctx->ctrl_handler, &hva_ctrl_ops,
> +			=C2=A0=C2=A0V4L2_CID_MPEG_VIDEO_BITRATE,
> +			=C2=A0=C2=A01, 50000, 1, 20000);
> +
> +	mask =3D ~(1 << V4L2_MPEG_VIDEO_ASPECT_1x1);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &hva_ctrl_ops,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_CID_MPEG_VIDEO_ASPECT,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_MPEG_VIDEO_ASPECT_1x1,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mask,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2_MPEG_VIDEO_ASPECT_1x1)=
;
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err =3D ctx->ctrl_handler.error;
> +
> +		dev_dbg(dev, "%s controls setup failed (%d)\n",
> +			ctx->name, err);
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		return err;
> +	}
> +
> +	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> +
> +	/* set default time per frame */
> +	ctx->ctrls.time_per_frame.numerator =3D DEFAULT_FRAME_NUM;
> +	ctx->ctrls.time_per_frame.denominator =3D DEFAULT_FRAME_DEN;
> +
> +	return 0;
> +}
> +
> +/*
> + * mem-to-mem operations
> + */
> +
> +static void hva_run_work(struct work_struct *work)
> +{
> +	struct hva_ctx *ctx =3D container_of(work, struct hva_ctx, run_work);
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +	const struct hva_enc *enc =3D ctx->enc;
> +	struct hva_frame *frame;
> +	struct hva_stream *stream;
> +	int ret;
> +
> +	/* protect instance against reentrancy */
> +	mutex_lock(&ctx->lock);
> +
> +	src_buf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +	dst_buf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +	frame =3D to_hva_frame(src_buf);
> +	stream =3D to_hva_stream(dst_buf);
> +	frame->vbuf.sequence =3D ctx->frame_num++;
> +
> +	ret =3D enc->encode(ctx, frame, stream);
> +
> +	if (ret) {
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +	} else {
> +		/* propagate frame timestamp */
> +		dst_buf->vb2_buf.timestamp =3D src_buf->vb2_buf.timestamp;
> +		dst_buf->field =3D V4L2_FIELD_NONE;
> +		dst_buf->sequence =3D ctx->stream_num - 1;
> +
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +	}
> +
> +	mutex_unlock(&ctx->lock);
> +
> +	v4l2_m2m_job_finish(ctx->hva_dev->m2m_dev, ctx->fh.m2m_ctx);
> +}
> +
> +static void hva_device_run(void *priv)
> +{
> +	struct hva_ctx *ctx =3D priv;
> +	struct hva_dev *hva =3D ctx_to_hdev(ctx);
> +
> +	queue_work(hva->work_queue, &ctx->run_work);
> +}
> +
> +static void hva_job_abort(void *priv)
> +{
> +	struct hva_ctx *ctx =3D priv;
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	dev_dbg(dev, "%s aborting job\n", ctx->name);
> +
> +	ctx->aborting =3D true;
> +}
> +
> +static int hva_job_ready(void *priv)
> +{
> +	struct hva_ctx *ctx =3D priv;
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx)) {
> +		dev_dbg(dev, "%s job not ready: no frame buffers\n",
> +			ctx->name);
> +		return 0;
> +	}
> +
> +	if (!v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx)) {
> +		dev_dbg(dev, "%s job not ready: no stream buffers\n",
> +			ctx->name);
> +		return 0;
> +	}
> +
> +	if (ctx->aborting) {
> +		dev_dbg(dev, "%s job not ready: aborting\n", ctx->name);
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +/* mem-to-mem ops */
> +static const struct v4l2_m2m_ops hva_m2m_ops =3D {
> +	.device_run	=3D hva_device_run,
> +	.job_abort	=3D hva_job_abort,
> +	.job_ready	=3D hva_job_ready,
> +};
> +
> +/*
> + * VB2 queue operations
> + */
> +
> +static int hva_queue_setup(struct vb2_queue *vq,
> +			=C2=A0=C2=A0=C2=A0unsigned int *num_buffers, unsigned int *num_planes=
,
> +			=C2=A0=C2=A0=C2=A0unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct hva_ctx *ctx =3D vb2_get_drv_priv(vq);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	unsigned int size;
> +
> +	dev_dbg(dev, "%s %s queue setup: num_buffers %d\n", ctx->name,
> +		to_type_str(vq->type), *num_buffers);
> +
> +	size =3D vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT ?
> +		ctx->frameinfo.size : ctx->max_stream_size;
> +
> +	alloc_ctxs[0] =3D ctx->hva_dev->alloc_ctx;
> +
> +	if (*num_planes)
> +		return sizes[0] < size ? -EINVAL : 0;
> +
> +	/* only one plane supported */
> +	*num_planes =3D 1;
> +	sizes[0] =3D size;
> +
> +	return 0;
> +}
> +
> +static int hva_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct hva_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> +
> +	if (vb->vb2_queue->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		struct hva_frame *frame =3D to_hva_frame(vbuf);
> +
> +		if (vbuf->field =3D=3D V4L2_FIELD_ANY)
> +			vbuf->field =3D V4L2_FIELD_NONE;
> +		if (vbuf->field !=3D V4L2_FIELD_NONE) {
> +			dev_dbg(dev,
> +				"%s frame[%d] prepare: %d field not supported\n",
> +				ctx->name, vb->index, vbuf->field);
> +			return -EINVAL;
> +		}
> +
> +		if (!frame->prepared) {
> +			/* get memory addresses */
> +			frame->vaddr =3D vb2_plane_vaddr(&vbuf->vb2_buf, 0);
> +			frame->paddr =3D vb2_dma_contig_plane_dma_addr(
> +					&vbuf->vb2_buf, 0);
> +			frame->info =3D ctx->frameinfo;
> +			frame->prepared =3D true;
> +
> +			dev_dbg(dev,
> +				"%s frame[%d] prepared; virt=3D%p, phy=3D%pad\n",
> +				ctx->name, vb->index,
> +				frame->vaddr, &frame->paddr);
> +		}
> +	} else {
> +		struct hva_stream *stream =3D to_hva_stream(vbuf);
> +
> +		if (!stream->prepared) {
> +			/* get memory addresses */
> +			stream->vaddr =3D vb2_plane_vaddr(&vbuf->vb2_buf, 0);
> +			stream->paddr =3D vb2_dma_contig_plane_dma_addr(
> +					&vbuf->vb2_buf, 0);
> +			stream->size =3D vb2_plane_size(&vbuf->vb2_buf, 0);
> +			stream->prepared =3D true;
> +
> +			dev_dbg(dev,
> +				"%s stream[%d] prepared; virt=3D%p, phy=3D%pad\n",
> +				ctx->name, vb->index,
> +				stream->vaddr, &stream->paddr);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void hva_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct hva_ctx *ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> +
> +	if (ctx->fh.m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> +}
> +
> +static int hva_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct hva_ctx *ctx =3D vb2_get_drv_priv(vq);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	int ret =3D 0;
> +
> +	dev_dbg(dev, "%s %s start streaming\n", ctx->name,
> +		to_type_str(vq->type));
> +
> +	/* open encoder when both start_streaming have been called */
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
> +		if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->cap_q_ctx.q))
> +			return 0;
> +	} else {
> +		if (!vb2_start_streaming_called(&ctx->fh.m2m_ctx->out_q_ctx.q))
> +			return 0;
> +	}
> +
> +	if (!ctx->enc)
> +		ret =3D hva_open_encoder(ctx,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctx->streaminfo.streamform=
at,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctx->frameinfo.pixelformat=
,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&ctx->enc);
> +
> +	return ret;
> +}
> +
> +static void hva_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct hva_ctx *ctx =3D vb2_get_drv_priv(vq);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +	const struct hva_enc *enc =3D ctx->enc;
> +	struct vb2_v4l2_buffer *vbuf;
> +
> +	dev_dbg(dev, "%s %s stop streaming\n", ctx->name,
> +		to_type_str(vq->type));
> +
> +	if (vq->type =3D=3D V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		/* return of all pending buffers to vb2 (in error state) */
> +		ctx->frame_num =3D 0;
> +		while ((vbuf =3D v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +	} else {
> +		/* return of all pending buffers to vb2 (in error state) */
> +		ctx->stream_num =3D 0;
> +		while ((vbuf =3D v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	if ((V4L2_TYPE_IS_OUTPUT(vq->type) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_=
ctx.q)) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0(!V4L2_TYPE_IS_OUTPUT(vq->type) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_=
ctx.q))) {
> +		dev_dbg(dev, "%s %s out=3D%d cap=3D%d\n",
> +			ctx->name, to_type_str(vq->type),
> +			vb2_is_streaming(&ctx->fh.m2m_ctx->out_q_ctx.q),
> +			vb2_is_streaming(&ctx->fh.m2m_ctx->cap_q_ctx.q));
> +		return;
> +	}
> +
> +	/* close encoder when both stop_streaming have been called */
> +	if (enc) {
> +		dev_dbg(dev, "%s %s encoder closed\n", ctx->name, enc->name);
> +		enc->close(ctx);
> +		ctx->enc =3D NULL;
> +	}
> +
> +	ctx->aborting =3D false;
> +}
> +
> +/* VB2 queue ops */
> +static const struct vb2_ops hva_qops =3D {
> +	.queue_setup		=3D hva_queue_setup,
> +	.buf_prepare		=3D hva_buf_prepare,
> +	.buf_queue		=3D hva_buf_queue,
> +	.start_streaming	=3D hva_start_streaming,
> +	.stop_streaming		=3D hva_stop_streaming,
> +	.wait_prepare		=3D vb2_ops_wait_prepare,
> +	.wait_finish		=3D vb2_ops_wait_finish,
> +};
> +
> +/*
> + * V4L2 file operations
> + */
> +
> +static int queue_init(struct hva_ctx *ctx, struct vb2_queue *vq)
> +{
> +	vq->io_modes =3D VB2_MMAP | VB2_DMABUF;
> +	vq->drv_priv =3D ctx;
> +	vq->ops =3D &hva_qops;
> +	vq->mem_ops =3D &vb2_dma_contig_memops;
> +	vq->timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	vq->lock =3D &ctx->hva_dev->lock;
> +
> +	return vb2_queue_init(vq);
> +}
> +
> +static int hva_queue_init(void *priv, struct vb2_queue *src_vq,
> +			=C2=A0=C2=A0struct vb2_queue *dst_vq)
> +{
> +	struct hva_ctx *ctx =3D priv;
> +	int ret;
> +
> +	src_vq->type =3D V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->buf_struct_size =3D sizeof(struct hva_frame);
> +	src_vq->min_buffers_needed =3D MIN_FRAMES;
> +
> +	ret =3D queue_init(ctx, src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->buf_struct_size =3D sizeof(struct hva_stream);
> +	dst_vq->min_buffers_needed =3D MIN_STREAMS;
> +
> +	return queue_init(ctx, dst_vq);
> +}
> +
> +static int hva_open(struct file *file)
> +{
> +	struct hva_dev *hva =3D video_drvdata(file);
> +	struct device *dev =3D hva_to_dev(hva);
> +	struct hva_ctx *ctx;
> +	int ret;
> +	unsigned int i;
> +	bool found =3D false;
> +
> +	ctx =3D kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +	ctx->hva_dev =3D hva;
> +
> +	mutex_lock(&hva->lock);
> +
> +	/* store the instance context in the instances array */
> +	for (i =3D 0; i < HVA_MAX_INSTANCES; i++) {
> +		if (!hva->instances[i]) {
> +			hva->instances[i] =3D ctx;
> +			/* save the context identifier in the context */
> +			ctx->id =3D i;
> +			found =3D true;
> +			break;
> +		}
> +	}
> +
> +	if (!found) {
> +		dev_err(dev, "%s [x:x] maximum instances reached\n",
> +			HVA_PREFIX);
> +		ret =3D -ENOMEM;
> +		goto mem_ctx;
> +	}
> +
> +	INIT_WORK(&ctx->run_work, hva_run_work);
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data =3D &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	ret =3D hva_ctrls_setup(ctx);
> +	if (ret) {
> +		dev_err(dev, "%s [x:x] failed to setup controls\n",
> +			HVA_PREFIX);
> +		goto err_fh;
> +	}
> +	ctx->fh.ctrl_handler =3D &ctx->ctrl_handler;
> +
> +	mutex_init(&ctx->lock);
> +
> +	ctx->fh.m2m_ctx =3D v4l2_m2m_ctx_init(hva->m2m_dev, ctx,
> +					=C2=A0=C2=A0=C2=A0=C2=A0&hva_queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret =3D PTR_ERR(ctx->fh.m2m_ctx);
> +		dev_err(dev, "%s [x:x] failed to initialize m2m context (%d)\n",
> +			HVA_PREFIX, ret);
> +		goto err_ctrls;
> +	}
> +
> +	/* set the instance name */
> +	hva->instance_id++;
> +	snprintf(ctx->name, sizeof(ctx->name), "[%3d:----]",
> +		=C2=A0hva->instance_id);
> +
> +	hva->nb_of_instances++;
> +
> +	mutex_unlock(&hva->lock);
> +
> +	/* default parameters for frame and stream */
> +	set_default_params(ctx);
> +
> +	dev_info(dev, "%s encoder instance created (id %d)\n",
> +		=C2=A0ctx->name, ctx->id);
> +
> +	return 0;
> +
> +err_ctrls:
> +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +err_fh:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	hva->instances[ctx->id] =3D NULL;
> +mem_ctx:
> +	kfree(ctx);
> +	mutex_unlock(&hva->lock);
> +out:
> +	return ret;
> +}
> +
> +static int hva_release(struct file *file)
> +{
> +	struct hva_dev *hva =3D video_drvdata(file);
> +	struct hva_ctx *ctx =3D fh_to_ctx(file->private_data);
> +	struct device *dev =3D ctx_to_dev(ctx);
> +
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +
> +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +
> +	mutex_lock(&hva->lock);
> +
> +	/* clear instance context in instances array */
> +	hva->instances[ctx->id] =3D NULL;
> +
> +	hva->nb_of_instances--;
> +
> +	mutex_unlock(&hva->lock);
> +
> +	dev_info(dev, "%s encoder instance released (id %d)\n",
> +		=C2=A0ctx->name, ctx->id);
> +
> +	kfree(ctx);
> +
> +	return 0;
> +}
> +
> +/* V4L2 file ops */
> +static const struct v4l2_file_operations hva_fops =3D {
> +	.owner			=3D THIS_MODULE,
> +	.open			=3D hva_open,
> +	.release		=3D hva_release,
> +	.unlocked_ioctl		=3D video_ioctl2,
> +	.mmap			=3D v4l2_m2m_fop_mmap,
> +	.poll			=3D v4l2_m2m_fop_poll,
> +};
> +
> +/*
> + * Platform device operations
> + */
> +
> +static int hva_register_device(struct hva_dev *hva)
> +{
> +	int ret;
> +	struct video_device *vdev;
> +	struct device *dev;
> +
> +	if (!hva)
> +		return -ENODEV;
> +	dev =3D hva_to_dev(hva);
> +
> +	hva->m2m_dev =3D v4l2_m2m_init(&hva_m2m_ops);
> +	if (IS_ERR(hva->m2m_dev)) {
> +		dev_err(dev, "%s %s failed to initialize v4l2-m2m device\n",
> +			HVA_PREFIX, HVA_NAME);
> +		ret =3D PTR_ERR(hva->m2m_dev);
> +		goto err;
> +	}
> +
> +	vdev =3D video_device_alloc();
> +	if (!vdev) {
> +		dev_err(dev, "%s %s failed to allocate video device\n",
> +			HVA_PREFIX, HVA_NAME);
> +		ret =3D -ENOMEM;
> +		goto err_m2m_release;
> +	}
> +
> +	vdev->fops =3D &hva_fops;
> +	vdev->ioctl_ops =3D &hva_ioctl_ops;
> +	vdev->release =3D video_device_release;
> +	vdev->lock =3D &hva->lock;
> +	vdev->vfl_dir =3D VFL_DIR_M2M;
> +	vdev->v4l2_dev =3D &hva->v4l2_dev;
> +	snprintf(vdev->name, sizeof(vdev->name), "%s", HVA_NAME);
> +
> +	ret =3D video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(dev, "%s %s failed to register video device\n",
> +			HVA_PREFIX, HVA_NAME);
> +		goto err_vdev_release;
> +	}
> +
> +	hva->vdev =3D vdev;
> +	video_set_drvdata(vdev, hva);
> +	return 0;
> +
> +err_vdev_release:
> +	video_device_release(vdev);
> +err_m2m_release:
> +	v4l2_m2m_release(hva->m2m_dev);
> +err:
> +	return ret;
> +}
> +
> +static void hva_unregister_device(struct hva_dev *hva)
> +{
> +	if (!hva)
> +		return;
> +
> +	if (hva->m2m_dev)
> +		v4l2_m2m_release(hva->m2m_dev);
> +
> +	video_unregister_device(hva->vdev);
> +}
> +
> +static int hva_probe(struct platform_device *pdev)
> +{
> +	struct hva_dev *hva;
> +	struct device *dev =3D &pdev->dev;
> +	int ret;
> +
> +	hva =3D devm_kzalloc(dev, sizeof(*hva), GFP_KERNEL);
> +	if (!hva) {
> +		ret =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	hva->dev =3D dev;
> +	hva->pdev =3D pdev;
> +	platform_set_drvdata(pdev, hva);
> +
> +	mutex_init(&hva->lock);
> +
> +	/* probe hardware */
> +	ret =3D hva_hw_probe(pdev, hva);
> +	if (ret)
> +		goto err;
> +
> +	/* register all available encoders */
> +	register_encoders(hva);
> +
> +	/* register all supported formats */
> +	register_formats(hva);
> +
> +	/* register on V4L2 */
> +	ret =3D v4l2_device_register(dev, &hva->v4l2_dev);
> +	if (ret) {
> +		dev_err(dev, "%s %s failed to register V4L2 device\n",
> +			HVA_PREFIX, HVA_NAME);
> +		goto err_hw;
> +	}
> +
> +	/* continuous memory allocator */
> +	hva->alloc_ctx =3D vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(hva->alloc_ctx)) {
> +		ret =3D PTR_ERR(hva->alloc_ctx);
> +		goto err_v4l2;
> +	}
> +
> +	hva->work_queue =3D create_workqueue(HVA_NAME);
> +	if (!hva->work_queue) {
> +		dev_err(dev, "%s %s failed to allocate work queue\n",
> +			HVA_PREFIX, HVA_NAME);
> +		ret =3D -ENOMEM;
> +		goto err_vb2_dma;
> +	}
> +
> +	/* register device */
> +	ret =3D hva_register_device(hva);
> +	if (ret)
> +		goto err_work_queue;
> +
> +	dev_info(dev, "%s %s registered as /dev/video%d\n", HVA_PREFIX,
> +		=C2=A0HVA_NAME, hva->vdev->num);
> +
> +	return 0;
> +
> +err_work_queue:
> +	destroy_workqueue(hva->work_queue);
> +err_vb2_dma:
> +	vb2_dma_contig_cleanup_ctx(hva->alloc_ctx);
> +err_v4l2:
> +	v4l2_device_unregister(&hva->v4l2_dev);
> +err_hw:
> +	hva_hw_remove(hva);
> +err:
> +	return ret;
> +}
> +
> +static int hva_remove(struct platform_device *pdev)
> +{
> +	struct hva_dev *hva =3D platform_get_drvdata(pdev);
> +	struct device *dev =3D hva_to_dev(hva);
> +
> +	hva_unregister_device(hva);
> +
> +	destroy_workqueue(hva->work_queue);
> +
> +	vb2_dma_contig_cleanup_ctx(hva->alloc_ctx);
> +
> +	hva_hw_remove(hva);
> +
> +	v4l2_device_unregister(&hva->v4l2_dev);
> +
> +	dev_info(dev, "%s %s removed\n", HVA_PREFIX, pdev->name);
> +
> +	return 0;
> +}
> +
> +/* PM ops */
> +static const struct dev_pm_ops hva_pm_ops =3D {
> +	.runtime_suspend	=3D hva_hw_runtime_suspend,
> +	.runtime_resume		=3D hva_hw_runtime_resume,
> +};
> +
> +static const struct of_device_id hva_match_types[] =3D {
> +	{
> +	=C2=A0.compatible =3D "st,sti-hva",
> +	},
> +	{ /* end node */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, hva_match_types);
> +
> +struct platform_driver hva_driver =3D {
> +	.probe=C2=A0=C2=A0=3D hva_probe,
> +	.remove =3D hva_remove,
> +	.driver =3D {
> +		.name=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=3D HVA_NAME,
> +		.owner=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D =
THIS_MODULE,
> +		.of_match_table =3D hva_match_types,
> +		.pm=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=3D &hva_pm_ops,
> +		},
> +};
> +
> +module_platform_driver(hva_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Yannick Fertre <yannick.fertre@st.com>");
> +MODULE_DESCRIPTION("HVA video encoder V4L2 driver");
> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platfor=
m/sti/hva/hva.h
> new file mode 100644
> index 0000000..9a1b503b
> --- /dev/null
> +++ b/drivers/media/platform/sti/hva/hva.h
> @@ -0,0 +1,284 @@
> +/*
> + * Copyright (C) STMicroelectronics SA 2015
> + * Authors: Yannick Fertre <yannick.fertre@st.com>
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Hugues Fru=
chet <hugues.fruchet@st.com>
> + * License terms:=C2=A0=C2=A0GNU General Public License (GPL), version 2
> + */
> +
> +#ifndef HVA_H
> +#define HVA_H
> +
> +#include=20
> +#include=20
> +#include=20
> +#include=20
> +
> +#define fh_to_ctx(f)=C2=A0=C2=A0=C2=A0=C2=A0(container_of(f, struct hva_=
ctx, fh))
> +
> +#define hva_to_dev(h)=C2=A0=C2=A0=C2=A0(h->dev)
> +
> +#define ctx_to_dev(c)=C2=A0=C2=A0=C2=A0(c->hva_dev->dev)
> +
> +#define ctx_to_hdev(c)=C2=A0=C2=A0(c->hva_dev)
> +
> +#define HVA_PREFIX "[---:----]"
> +
> +/**
> + * struct hva_frameinfo - information about hva frame
> + *
> + * @pixelformat:=C2=A0=C2=A0=C2=A0=C2=A0fourcc code for uncompressed vid=
eo format
> + * @width:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wi=
dth of frame
> + * @height:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0height =
of frame
> + * @aligned_width:=C2=A0=C2=A0width of frame (with encoder alignment con=
straint)
> + * @aligned_height: height of frame (with encoder alignment constraint)
> + * @size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0maximum size in bytes required for data
> +*/
> +struct hva_frameinfo {
> +	u32	pixelformat;
> +	u32	width;
> +	u32	height;
> +	u32	aligned_width;
> +	u32	aligned_height;
> +	u32	size;
> +};
> +
> +/**
> + * struct hva_streaminfo - information about hva stream
> + *
> + * @streamformat: fourcc code of compressed video format (H.264...)
> + * @width:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0width of strea=
m
> + * @height:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0height of stream
> + * @profile:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0profile string
> + * @level:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0level string
> + */
> +struct hva_streaminfo {
> +	u32	streamformat;
> +	u32	width;
> +	u32	height;
> +	u8	profile[32];
> +	u8	level[32];
> +};
> +
> +/**
> + * struct hva_controls - hva controls set
> + *
> + * @time_per_frame: time per frame in seconds
> + * @bitrate_mode:=C2=A0=C2=A0=C2=A0bitrate mode (constant bitrate or var=
iable bitrate)
> + * @gop_size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0groupe of picture=
 size
> + * @bitrate:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bitrate (in =
kbps)
> + * @aspect:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0video a=
spect
> + */
> +struct hva_controls {
> +	struct v4l2_fract			time_per_frame;
> +	enum v4l2_mpeg_video_bitrate_mode	bitrate_mode;
> +	u32					gop_size;
> +	u32					bitrate;
> +	enum v4l2_mpeg_video_aspect		aspect;
> +};
> +
> +/**
> + * struct hva_frame - hva frame buffer (output)
> + *
> + * @vbuf:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0video buffer information for V4L2
> + * @list:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2 m2m list that the frame belo=
ngs to
> + * @info:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frame information (width, height,=
 format, alignment...)
> + * @paddr:=C2=A0=C2=A0=C2=A0=C2=A0physical address (for hardware)
> + * @vaddr:=C2=A0=C2=A0=C2=A0=C2=A0virtual address (kernel can read/write=
)
> + * @prepared: true if vaddr/paddr are resolved
> + */
> +struct hva_frame {
> +	struct vb2_v4l2_buffer	vbuf;
> +	struct list_head	list;
> +	struct hva_frameinfo	info;
> +	dma_addr_t		paddr;
> +	void			*vaddr;
> +	bool			prepared;
> +};
> +
> +/*
> + * to_hva_frame() - cast struct vb2_v4l2_buffer * to struct hva_frame *
> + */
> +#define to_hva_frame(vb) \
> +	container_of(vb, struct hva_frame, vbuf)
> +
> +/**
> + * struct hva_stream - hva stream buffer (capture)
> + *
> + * @v4l2:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0video buffer informat=
ion for V4L2
> + * @list:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0V4L2 m2m list that th=
e frame belongs to
> + * @paddr:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0physical address (for hard=
ware)
> + * @vaddr:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0virtual address (kernel ca=
n read/write)
> + * @prepared:=C2=A0=C2=A0=C2=A0true if vaddr/paddr are resolved
> + * @size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0size of the buffer in=
 bytes
> + * @bytesused:=C2=A0=C2=A0number of bytes occupied by data in the buffer
> + */
> +struct hva_stream {
> +	struct vb2_v4l2_buffer	vbuf;
> +	struct list_head	list;
> +	dma_addr_t		paddr;
> +	void			*vaddr;
> +	int			prepared;
> +	unsigned int		size;
> +	unsigned int		bytesused;
> +};
> +
> +/*
> + * to_hva_stream() - cast struct vb2_v4l2_buffer * to struct hva_stream =
*
> + */
> +#define to_hva_stream(vb) \
> +	container_of(vb, struct hva_stream, vbuf)
> +
> +struct hva_dev;
> +struct hva_enc;
> +
> +/**
> + * struct hva_ctx - context of hva instance
> + *
> + * @hva_dev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0the de=
vice that this instance is associated with
> + * @fh:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0V4L2 file handle
> + * @ctrl_handler:=C2=A0=C2=A0=C2=A0=C2=A0V4L2 controls handler
> + * @ctrls:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0hva controls set
> + * @id:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0instance identifier
> + * @aborting:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0true if cur=
rent job aborted
> + * @name:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0instance name (debug purpose)
> + * @run_work:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0encode work
> + * @lock:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0mutex used to lock access of this context
> + * @flags:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0validity of streaminfo and frameinfo fields
> + * @frame_num:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frame number
> + * @stream_num:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0stream number
> + * @max_stream_size: maximum size in bytes required for stream data
> + * @streaminfo:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0stream properties
> + * @frameinfo:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0frame properties
> + * @enc:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0current encoder
> + * @priv:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0private codec data for this instance, allocated
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0by encoder @open time
> + * @hw_err:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0t=
rue if hardware error detected
> + */
> +struct hva_ctx {
> +	struct hva_dev		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*hva_de=
v;
> +	struct v4l2_fh			fh;
> +	struct v4l2_ctrl_handler	ctrl_handler;
> +	struct hva_controls		ctrls;
> +	u8				id;
> +	bool				aborting;
> +	char				name[100];
> +	struct work_struct		run_work;
> +	/* mutex protecting this data structure */
> +	struct mutex			lock;
> +	u32				flags;
> +	u32				frame_num;
> +	u32				stream_num;
> +	u32				max_stream_size;
> +	struct hva_streaminfo		streaminfo;
> +	struct hva_frameinfo		frameinfo;
> +	struct hva_enc			*enc;
> +	void				*priv;
> +	bool				hw_err;
> +};
> +
> +#define HVA_FLAG_STREAMINFO	0x0001
> +#define HVA_FLAG_FRAMEINFO	0x0002
> +
> +#define HVA_MAX_INSTANCES	16
> +#define HVA_MAX_ENCODERS	10
> +#define HVA_MAX_FORMATS		HVA_MAX_ENCODERS
> +
> +/**
> + * struct hva_dev - abstraction for hva entity
> + *
> + * @v4l2_dev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0V4L2 device
> + * @vdev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0video device
> + * @pdev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0platform device
> + * @dev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0device
> + * @lock:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex used for critical sections & V4L2 op=
s
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0serial=
ization
> + * @m2m_dev:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0memory-to-memory V4L2 device informatio
> + * @alloc_ctx:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0videobuf2 memory allocator context
> + * @instances:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0opened instances
> + * @nb_of_instances:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0number of opened insta=
nces
> + * @instance_id:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ro=
lling counter identifying an instance (debug purpose)
> + * @regs:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0register io memory access
> + * @esram_addr:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0esram address
> + * @esram_size:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0esram size
> + * @clk:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hva clock
> + * @irq_its:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0status interruption
> + * @irq_err:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0error interruption
> + * @work_queue:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0work queue to handle the encode jobs
> + * @protect_mutex:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex used t=
o lock access of hardware
> + * @interrupt:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0completion interrupt
> + * @ip_version:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0IP hardware version
> + * @encoders:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0registered encoders
> + * @nb_of_encoders:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0number of registe=
red encoders
> + * @pixelformats:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0support=
ed uncompressed video formats
> + * @nb_of_pixelformats:=C2=A0=C2=A0number of supported umcompressed vide=
o formats
> + * @streamformats:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0supported co=
mpressed video formats
> + * @nb_of_streamformats: number of supported compressed video formats
> + * @sfl_reg:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0status fifo level register value
> + * @sts_reg:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0status register value
> + * @lmi_err_reg:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0lo=
cal memory interface error register value
> + * @emi_err_reg:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ex=
ternal memory interface error register value
> + * @hec_mif_err_reg:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HEC memory interface e=
rror register value
> + */
> +struct hva_dev {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vdev;
> +	struct platform_device	*pdev;
> +	struct device		*dev;
> +	/* mutex protecting vb2_queue structure */
> +	struct mutex		lock;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	struct vb2_alloc_ctx	*alloc_ctx;
> +	struct hva_ctx		*instances[HVA_MAX_INSTANCES];
> +	unsigned int		nb_of_instances;
> +	unsigned int		instance_id;
> +	void __iomem		*regs;
> +	u32			esram_addr;
> +	u32			esram_size;
> +	struct clk		*clk;
> +	int			irq_its;
> +	int			irq_err;
> +	struct workqueue_struct *work_queue;
> +	/* mutex protecting hardware access */
> +	struct mutex		protect_mutex;
> +	struct completion	interrupt;
> +	unsigned long int	ip_version;
> +	const struct hva_enc	*encoders[HVA_MAX_ENCODERS];
> +	u32			nb_of_encoders;
> +	u32			pixelformats[HVA_MAX_FORMATS];
> +	u32			nb_of_pixelformats;
> +	u32			streamformats[HVA_MAX_FORMATS];
> +	u32			nb_of_streamformats;
> +	u32			sfl_reg;
> +	u32			sts_reg;
> +	u32			lmi_err_reg;
> +	u32			emi_err_reg;
> +	u32			hec_mif_err_reg;
> +};
> +
> +/**
> + * struct hva_enc - hva encoder
> + *
> + * @name:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0encoder n=
ame
> + * @streamformat: fourcc code for compressed video format (H.264...)
> + * @pixelformat:=C2=A0=C2=A0fourcc code for uncompressed video format
> + * @max_width:=C2=A0=C2=A0=C2=A0=C2=A0maximum width of frame for this en=
coder
> + * @max_height:=C2=A0=C2=A0=C2=A0maximum height of frame for this encode=
r
> + * @open:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0open enco=
der
> + * @close:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0close encoder
> + * @encode:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0encode a frame (str=
uct hva_frame) in a stream
> + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0(struct hva_stream)
> + */
> +
> +struct hva_enc {
> +	const char	*name;
> +	u32		streamformat;
> +	u32		pixelformat;
> +	u32		max_width;
> +	u32		max_height;
> +	int		(*open)(struct hva_ctx *ctx);
> +	int		(*close)(struct hva_ctx *ctx);
> +	int		(*encode)(struct hva_ctx *ctx, struct hva_frame *frame,
> +				=C2=A0=C2=A0struct hva_stream *stream);
> +};
> +
> +#endif /* HVA_H */
--=-gVS0VaV5HzoQ2+Y1nG2g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAleD3qsACgkQcVMCLawGqBypegCgllsg75B5ZRt4x4Qv3KZQ56Qw
yowAn0XQtHuetwYWAJzmL/PpHE11ki06
=oKuC
-----END PGP SIGNATURE-----

--=-gVS0VaV5HzoQ2+Y1nG2g--

