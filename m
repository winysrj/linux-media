Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:39849 "EHLO
        relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753855AbdDRRNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:13:01 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v3 7/7] media: platform: rcar_drif: Add DRIF support
Date: Tue, 18 Apr 2017 17:12:53 +0000
Message-ID: <HK2PR06MB05455CF06BBECC1AB4477971C3190@HK2PR06MB0545.apcprd06.prod.outlook.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1486479757-32128-8-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <2330193.GrgnD4vKf8@avalon>
In-Reply-To: <2330193.GrgnD4vKf8@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Many thanks for your time & the review comments. I have agreed to most of t=
he comments and a few need further discussion. Could you please take a look=
 at those?

> On Tuesday 07 Feb 2017 15:02:37 Ramesh Shanmugasundaram wrote:
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
> >  drivers/media/platform/Kconfig     |   25 +
> >  drivers/media/platform/Makefile    |    1 +
> >  drivers/media/platform/rcar_drif.c | 1534
> > +++++++++++++++++++++++++++++++++
> >  3 files changed, 1560 insertions(+)
> >  create mode 100644 drivers/media/platform/rcar_drif.c
>=20
> [snip]
>=20
> > diff --git a/drivers/media/platform/rcar_drif.c
> > b/drivers/media/platform/rcar_drif.c new file mode 100644 index
> > 0000000..88950e3
> > --- /dev/null
> > +++ b/drivers/media/platform/rcar_drif.c
> > @@ -0,0 +1,1534 @@
>=20
> [snip]
>=20
> > +/*
> > + * The R-Car DRIF is a receive only MSIOF like controller with an
> > + * external master device driving the SCK. It receives data into a
> > +FIFO,
> > + * then this driver uses the SYS-DMAC engine to move the data from
> > + * the device to memory.
> > + *
> > + * Each DRIF channel DRIFx (as per datasheet) contains two internal
> > + * channels DRIFx0 & DRIFx1 within itself with each having its own
> > resources
> > + * like module clk, register set, irq and dma. These internal
> > + channels
> > share
> > + * common CLK & SYNC from master. The two data pins D0 & D1 shall be
> > + * considered to represent the two internal channels. This internal
> > + split
> > + * is not visible to the master device.
> > + *
> > + * Depending on the master device, a DRIF channel can use
> > + *  (1) both internal channels (D0 & D1) to receive data in parallel
> > + (or)
> > + *  (2) one internal channel (D0 or D1) to receive data
> > + *
> > + * The primary design goal of this controller is to act as Digitial
> > + Radio
>=20
> s/Digitial/Digital/

Agreed

>=20
> > + * Interface that receives digital samples from a tuner device. Hence
> > + the
> > + * driver exposes the device as a V4L2 SDR device. In order to
> > + qualify as
> > + * a V4L2 SDR device, it should possess tuner interface as mandated
> > + by the
> > + * framework. This driver expects a tuner driver (sub-device) to bind
> > + * asynchronously with this device and the combined drivers shall
> > + expose
> > + * a V4L2 compliant SDR device. The DRIF driver is independent of the
> > + * tuner vendor.
> > + *
> > + * The DRIF h/w can support I2S mode and Frame start synchronization
> > + pulse
> > mode.
> > + * This driver is tested for I2S mode only because of the
> > + availability of
> > + * suitable master devices. Hence, not all configurable options of
> > + DRIF h/w
> > + * like lsb/msb first, syncdl, dtdl etc. are exposed via DT and I2S
> > defaults
> > + * are used. These can be exposed later if needed after testing.
> > + */
>=20
> [snip]
>=20
> > +#define to_rcar_drif_buf_pair(sdr, ch_num,
> > idx)	(sdr->ch[!(ch_num)]->buf[idx])
>=20
> You should enclose both sdr and idx in parenthesis, as they can be
> expressions.

Agreed.

>=20
> > +
> > +#define for_each_rcar_drif_channel(ch, ch_mask)			\
> > +	for_each_set_bit(ch, ch_mask, RCAR_DRIF_MAX_CHANNEL)
> > +
> > +static const unsigned int num_hwbufs =3D 32;
>=20
> Is there a specific reason to make this a static const instead of a
> #define ?

Just style only. The #define needs a RCAR_DRIF_ prefix and I used this valu=
e in few places. The #define makes the statements longer.

>=20
> > +/* Debug */
> > +static unsigned int debug;
> > +module_param(debug, uint, 0644);
> > +MODULE_PARM_DESC(debug, "activate debug info");
> > +
> > +#define rdrif_dbg(level, sdr, fmt, arg...)				\
> > +	v4l2_dbg(level, debug, &sdr->v4l2_dev, fmt, ## arg)
> > +
> > +#define rdrif_err(sdr, fmt, arg...)					\
> > +	dev_err(sdr->v4l2_dev.dev, fmt, ## arg)
> > +
> > +/* Stream formats */
> > +struct rcar_drif_format {
> > +	u32	pixelformat;
> > +	u32	buffersize;
> > +	u32	wdlen;
> > +	u32	num_ch;
> > +};
> > +
> > +/* Format descriptions for capture */ static const struct
> > +rcar_drif_format formats[] =3D {
> > +	{
> > +		.pixelformat	=3D V4L2_SDR_FMT_PCU16BE,
> > +		.buffersize	=3D RCAR_SDR_BUFFER_SIZE,
> > +		.wdlen		=3D 16,
> > +		.num_ch	=3D 2,
>=20
> How about aligning the =3D as in the other lines ?

Agreed

>=20
> num_ch is always set to 2. Should we remove it for now, and add it back
> later when we'll support single-channel formats ? I think we should avoid
> carrying dead code.

Actually single channel support is tested internally. If single & dual chan=
nels are already supported any future change will be just adding the new SD=
R format only, which could be relatively trivial for this driver. To add ne=
w SDR formats today I need to enable appropriate format in the tuner code t=
oo, which could be done later on a need basis by us or others.

>=20
> > +	},
> > +	{
> > +		.pixelformat	=3D V4L2_SDR_FMT_PCU18BE,
> > +		.buffersize	=3D RCAR_SDR_BUFFER_SIZE,
> > +		.wdlen		=3D 18,
> > +		.num_ch	=3D 2,
> > +	},
> > +	{
> > +		.pixelformat	=3D V4L2_SDR_FMT_PCU20BE,
> > +		.buffersize	=3D RCAR_SDR_BUFFER_SIZE,
> > +		.wdlen		=3D 20,
> > +		.num_ch	=3D 2,
> > +	},
> > +};
> > +
> > +static const unsigned int NUM_FORMATS =3D ARRAY_SIZE(formats);
>=20
> Same question here, can't this be a define ? I think I'd even avoid
> NUM_FORMATS completely and use ARRAY_SIZE(formats) directly in the code,
> to make the boundary check more explicit when iterating over the array.

Agreed.

>=20
> > +
> > +/* Buffer for a received frame from one or both internal channels */
> > +struct rcar_drif_frame_buf {
> > +	/* Common v4l buffer stuff -- must be first */
> > +	struct vb2_v4l2_buffer vb;
> > +	struct list_head list;
> > +};
> > +
> > +struct rcar_drif_async_subdev {
> > +	struct v4l2_subdev *sd;
> > +	struct v4l2_async_subdev asd;
> > +};
> > +
> > +/* DMA buffer */
> > +struct rcar_drif_hwbuf {
> > +	void *addr;			/* CPU-side address */
> > +	unsigned int status;		/* Buffer status flags */
> > +};
> > +
> > +/* Internal channel */
> > +struct rcar_drif {
> > +	struct rcar_drif_sdr *sdr;	/* Group device */
> > +	struct platform_device *pdev;	/* Channel's pdev */
> > +	void __iomem *base;		/* Base register address */
> > +	resource_size_t start;		/* I/O resource offset */
> > +	struct dma_chan *dmach;		/* Reserved DMA channel */
> > +	struct clk *clkp;		/* Module clock */
> > +	struct rcar_drif_hwbuf *buf[RCAR_DRIF_MAX_NUM_HWBUFS]; /* H/W bufs
> */
> > +	dma_addr_t dma_handle;		/* Handle for all bufs */
> > +	unsigned int num;		/* Channel number */
> > +	bool acting_sdr;		/* Channel acting as SDR device */
> > +};
> > +
> > +/* DRIF V4L2 SDR */
> > +struct rcar_drif_sdr {
> > +	struct device *dev;		/* Platform device */
> > +	struct video_device *vdev;	/* V4L2 SDR device */
> > +	struct v4l2_device v4l2_dev;	/* V4L2 device */
> > +
> > +	/* Videobuf2 queue and queued buffers list */
> > +	struct vb2_queue vb_queue;
> > +	struct list_head queued_bufs;
> > +	spinlock_t queued_bufs_lock;	/* Protects queued_bufs */
> > +
> > +	struct mutex v4l2_mutex;	/* To serialize ioctls */
> > +	struct mutex vb_queue_mutex;	/* To serialize streaming ioctls */
> > +	struct v4l2_ctrl_handler ctrl_hdl;	/* SDR control handler */
> > +	struct v4l2_async_notifier notifier;	/* For subdev (tuner) */
> > +
> > +	/* Current V4L2 SDR format array index */
> > +	unsigned int fmt_idx;
>=20
> Instead of storing the index I would store a pointer to the corresponding
> rcar_drif_format, looking up information about the current format will
> then be easier.
>=20

Agreed

> > +
> > +	/* Device tree SYNC properties */
> > +	u32 mdr1;
> > +
> > +	/* Internals */
> > +	struct rcar_drif *ch[RCAR_DRIF_MAX_CHANNEL]; /* DRIFx0,1 */
> > +	unsigned long hw_ch_mask;	/* Enabled channels per DT */
> > +	unsigned long cur_ch_mask;	/* Used channels for an SDR FMT */
> > +	u32 num_hw_ch;			/* Num of DT enabled channels */
> > +	u32 num_cur_ch;			/* Num of used channels */
> > +	u32 hwbuf_size;			/* Each DMA buffer size */
> > +	u32 produced;			/* Buffers produced by sdr dev */
> > +};
> > +
> > +/* Allocate buffer context */
> > +static int rcar_drif_alloc_bufctxt(struct rcar_drif_sdr *sdr) {
> > +	struct rcar_drif_hwbuf *bufctx;
> > +	unsigned int i, idx;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		bufctx =3D kcalloc(num_hwbufs, sizeof(*bufctx), GFP_KERNEL);
>=20
> How about embedding the buffer contexts in the rcar_drif structure instea=
d
> of just storing pointers there ? The rcar_drif_hwbuf structure is pretty
> small, it won't make a big difference, and will simplify the code.

Agreed

>=20
> > +		if (!bufctx)
> > +			return -ENOMEM;
> > +
> > +		for (idx =3D 0; idx < num_hwbufs; idx++)
> > +			sdr->ch[i]->buf[idx] =3D bufctx + idx;
> > +	}
> > +	return 0;
> > +}
>=20
> [snip]
>=20
> > +/* Release DMA channel */
> > +static void rcar_drif_release_dmachannel(struct rcar_drif_sdr *sdr)
>=20
> I would name the function rcar_drif_release_dma_channels as it handles al=
l
> channels. Same for rcar_drif_alloc_dma_channels.

Agreed.

>=20
> > +{
> > +	unsigned int i;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask)
> > +		if (sdr->ch[i]->dmach) {
> > +			dma_release_channel(sdr->ch[i]->dmach);
> > +			sdr->ch[i]->dmach =3D NULL;
> > +		}
> > +}
> > +
> > +/* Allocate DMA channel */
> > +static int rcar_drif_alloc_dmachannel(struct rcar_drif_sdr *sdr) {
> > +	struct dma_slave_config dma_cfg;
> > +	unsigned int i;
> > +	int ret =3D -ENODEV;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		struct rcar_drif *ch =3D sdr->ch[i];
> > +
> > +		ch->dmach =3D dma_request_slave_channel(&ch->pdev->dev, "rx");
> > +		if (!ch->dmach) {
> > +			rdrif_err(sdr, "ch%u: dma channel req failed\n", i);
> > +			goto dmach_error;
> > +		}
> > +
> > +		/* Configure slave */
> > +		memset(&dma_cfg, 0, sizeof(dma_cfg));
> > +		dma_cfg.src_addr =3D (phys_addr_t)(ch->start +
> RCAR_DRIF_SIRFDR);
> > +		dma_cfg.dst_addr =3D 0;
>=20
> This isn't needed as you memset the whole structure to 0.

Agreed

>=20
> > +		dma_cfg.src_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
> > +		ret =3D dmaengine_slave_config(ch->dmach, &dma_cfg);
> > +		if (ret) {
> > +			rdrif_err(sdr, "ch%u: dma slave config failed\n", i);
> > +			goto dmach_error;
> > +		}
> > +	}
> > +	return 0;
> > +
> > +dmach_error:
> > +	rcar_drif_release_dmachannel(sdr);
> > +	return ret;
> > +}
>=20
> [snip]
>=20
> > +/* Set MDR defaults */
> > +static inline void rcar_drif_set_mdr1(struct rcar_drif_sdr *sdr) {
> > +	unsigned int i;
> > +
> > +	/* Set defaults for enabled internal channels */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		/* Refer MSIOF section in manual for this register setting */
> > +		writel(RCAR_DRIF_SITMDR1_PCON,
> > +		       sdr->ch[i]->base + RCAR_DRIF_SITMDR1);
>=20
> I would create a rcar_drif_write(struct rcar_drif *ch, u32 offset, u32
> data) function, the code will become clearer. Same for the read operation=
.

Agreed

>=20
> > +		/* Setup MDR1 value */
> > +		writel(sdr->mdr1, sdr->ch[i]->base + RCAR_DRIF_SIRMDR1);
> > +
> > +		rdrif_dbg(2, sdr, "ch%u: mdr1 =3D 0x%08x",
> > +			  i, readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR1));
>=20
> Once you've debugged the driver I'm not sure those debugging statements
> are still needed.

I would like to keep this statement please. This single register print woul=
d clarify if a user selected DT options and this could be enabled at runtim=
e on a deployed board.
=20
>=20
> > +	}
> > +}
> > +
> > +/* Extract bitlen and wdcnt from given word length */ static int
> > +rcar_drif_convert_wdlen(struct rcar_drif_sdr *sdr,
> > +				   u32 wdlen, u32 *bitlen, u32 *wdcnt) {
> > +	unsigned int i, nr_wds;
> > +
> > +	/* FIFO register size is 32 bits */
> > +	for (i =3D 0; i < 32; i++) {
> > +		nr_wds =3D wdlen % (32 - i);
> > +		if (nr_wds =3D=3D 0) {
> > +			*bitlen =3D 32 - i;
> > +			*wdcnt =3D wdlen / *bitlen;
>=20
> Can't you store the bitlen and wdcnt values in the rcar_drif_format
> structure instead of recomputing them every time ?

Agreed

>=20
> > +			break;
> > +		}
> > +	}
> > +
> > +	/* Sanity check range */
> > +	if (i =3D=3D 32 || !(*bitlen >=3D 8 && *bitlen <=3D 32) ||
> > +	    !(*wdcnt >=3D 1 && *wdcnt <=3D 64)) {
> > +		rdrif_err(sdr, "invalid wdlen %u configured\n", wdlen);
> > +		return -EINVAL;
>=20
> You shouldn't have invalid wdlen values in the driver. I would remove thi=
s
> check as it makes error handling in the caller more complex.

Agreed

>=20
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/* Set DRIF receive format */
> > +static int rcar_drif_set_format(struct rcar_drif_sdr *sdr) {
> > +	u32 bitlen, wdcnt, wdlen;
> > +	unsigned int i;
> > +	int ret =3D -EINVAL;
> > +
> > +	wdlen =3D formats[sdr->fmt_idx].wdlen;
> > +	rdrif_dbg(2, sdr, "setfmt: idx %u, wdlen %u, num_ch %u\n",
> > +		  sdr->fmt_idx, wdlen, formats[sdr->fmt_idx].num_ch);
> > +
> > +	/* Sanity check */
> > +	if (formats[sdr->fmt_idx].num_ch > sdr->num_cur_ch) {
> > +		rdrif_err(sdr, "fmt idx %u current ch %u mismatch\n",
> > +			  sdr->fmt_idx, sdr->num_cur_ch);
> > +		return ret;
>=20
> This should never happen, it should be caught at set format time.

But, this is the set format function?

>=20
> > +	}
> > +
> > +	/* Get bitlen & wdcnt from wdlen */
> > +	ret =3D rcar_drif_convert_wdlen(sdr, wdlen, &bitlen, &wdcnt);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Setup group, bitlen & wdcnt */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		u32 mdr;
> > +
> > +		/* Two groups */
> > +		mdr =3D RCAR_DRIF_MDR_GRPCNT(2) | RCAR_DRIF_MDR_BITLEN(bitlen) |
> > +		       RCAR_DRIF_MDR_WDCNT(wdcnt);
> > +		writel(mdr, sdr->ch[i]->base + RCAR_DRIF_SIRMDR2);
> > +
> > +		mdr =3D RCAR_DRIF_MDR_BITLEN(bitlen) |
> RCAR_DRIF_MDR_WDCNT(wdcnt);
> > +		writel(mdr, sdr->ch[i]->base + RCAR_DRIF_SIRMDR3);
> > +
> > +		rdrif_dbg(2, sdr, "ch%u: new mdr[2,3] =3D 0x%08x, 0x%08x\n",
> > +			  i, readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR2),
> > +			  readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR3));
> > +	}
> > +	return ret;
> > +}
> > +
> > +/* Release DMA buffers */
> > +static void rcar_drif_release_buf(struct rcar_drif_sdr *sdr) {
> > +	unsigned int i;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		struct rcar_drif *ch =3D sdr->ch[i];
> > +
> > +		/* First entry contains the dma buf ptr */
> > +		if (ch->buf[0] && ch->buf[0]->addr) {
> > +			dma_free_coherent(&ch->pdev->dev,
> > +					  sdr->hwbuf_size * num_hwbufs,
> > +					  ch->buf[0]->addr, ch->dma_handle);
> > +			ch->buf[0]->addr =3D NULL;
> > +		}
> > +	}
> > +}
> > +
> > +/* Request DMA buffers */
> > +static int rcar_drif_request_buf(struct rcar_drif_sdr *sdr) {
> > +	int ret =3D -ENOMEM;
> > +	unsigned int i, j;
> > +	void *addr;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		struct rcar_drif *ch =3D sdr->ch[i];
> > +
> > +		/* Allocate DMA buffers */
> > +		addr =3D dma_alloc_coherent(&ch->pdev->dev,
> > +					  sdr->hwbuf_size * num_hwbufs,
> > +					  &ch->dma_handle, GFP_KERNEL);
> > +		if (!addr) {
> > +			rdrif_err(sdr,
> > +			"ch%u: dma alloc failed. num_hwbufs %u size %u\n",
> > +			i, num_hwbufs, sdr->hwbuf_size);
> > +			goto alloc_error;
> > +		}
> > +
> > +		/* Split the chunk and populate bufctxt */
> > +		for (j =3D 0; j < num_hwbufs; j++) {
> > +			ch->buf[j]->addr =3D addr + (j * sdr->hwbuf_size);
> > +			ch->buf[j]->status =3D 0;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +
> > +alloc_error:
> > +	return ret;
> > +}
> > +
> > +/* Setup vb_queue minimum buffer requirements */ static int
> > +rcar_drif_queue_setup(struct vb2_queue *vq,
> > +			unsigned int *num_buffers, unsigned int *num_planes,
> > +			unsigned int sizes[], struct device *alloc_devs[]) {
> > +	struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vq);
> > +
> > +	/* Need at least 16 buffers */
> > +	if (vq->num_buffers + *num_buffers < 16)
> > +		*num_buffers =3D 16 - vq->num_buffers;
> > +
> > +	*num_planes =3D 1;
> > +	sizes[0] =3D PAGE_ALIGN(formats[sdr->fmt_idx].buffersize);
> > +
> > +	rdrif_dbg(2, sdr, "num_bufs %d sizes[0] %d\n", *num_buffers,
> sizes[0]);
> > +	return 0;
> > +}
> > +
> > +/* Enqueue buffer */
> > +static void rcar_drif_buf_queue(struct vb2_buffer *vb) {
> > +	struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> > +	struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vb->vb2_queue);
> > +	struct rcar_drif_frame_buf *fbuf =3D
> > +			container_of(vbuf, struct rcar_drif_frame_buf, vb);
> > +	unsigned long flags;
> > +
> > +	rdrif_dbg(2, sdr, "buf_queue idx %u\n", vb->index);
> > +	spin_lock_irqsave(&sdr->queued_bufs_lock, flags);
> > +	list_add_tail(&fbuf->list, &sdr->queued_bufs);
> > +	spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags); }
> > +
> > +/* Get a frame buf from list */
> > +static struct rcar_drif_frame_buf *
> > +rcar_drif_get_fbuf(struct rcar_drif_sdr *sdr) {
> > +	struct rcar_drif_frame_buf *fbuf;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&sdr->queued_bufs_lock, flags);
> > +	fbuf =3D list_first_entry_or_null(&sdr->queued_bufs, struct
> > +					rcar_drif_frame_buf, list);
> > +	if (!fbuf) {
> > +		/*
> > +		 * App is late in enqueing buffers. Samples lost & there will
> > +		 * be a gap in sequence number when app recovers
> > +		 */
> > +		rdrif_dbg(1, sdr, "\napp late: prod %u\n", sdr->produced);
> > +		sdr->produced++; /* Increment the produced count anyway */
> > +		spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags);
> > +		return NULL;
> > +	}
> > +	list_del(&fbuf->list);
> > +	spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags);
> > +
> > +	return fbuf;
> > +}
> > +
> > +static inline bool rcar_drif_buf_pairs_done(struct rcar_drif_hwbuf
> *buf1,
> > +					    struct rcar_drif_hwbuf *buf2) {
> > +	return (buf1->status & buf2->status & RCAR_DRIF_BUF_DONE); }
> > +
> > +/* Channel DMA complete */
> > +static void rcar_drif_channel_complete(struct rcar_drif *ch, u32 idx)
> > +{
> > +	u32 str;
> > +
> > +	ch->buf[idx]->status |=3D RCAR_DRIF_BUF_DONE;
> > +
> > +	/* Check for DRIF errors */
> > +	str =3D readl(ch->base + RCAR_DRIF_SISTR);
> > +	if (unlikely(str & RCAR_DRIF_RFOVF)) {
> > +		/* Writing the same clears it */
> > +		writel(str, ch->base + RCAR_DRIF_SISTR);
> > +
> > +		/* Overflow: some samples are lost */
> > +		ch->buf[idx]->status |=3D RCAR_DRIF_BUF_OVERFLOW;
> > +	}
> > +}
> > +
> > +/* Deliver buffer to user */
> > +static void rcar_drif_deliver_buf(struct rcar_drif *ch) {
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +	u32 idx =3D sdr->produced % num_hwbufs;
> > +	struct rcar_drif_frame_buf *fbuf;
> > +	bool overflow =3D false;
> > +
> > +	rcar_drif_channel_complete(ch, idx);
> > +
> > +	if (sdr->num_cur_ch =3D=3D RCAR_DRIF_MAX_CHANNEL) {
> > +		struct rcar_drif_hwbuf *bufi, *bufq;
> > +
> > +		if (ch->num) {
> > +			bufi =3D to_rcar_drif_buf_pair(sdr, ch->num, idx);
> > +			bufq =3D ch->buf[idx];
> > +		} else {
> > +			bufi =3D ch->buf[idx];
> > +			bufq =3D to_rcar_drif_buf_pair(sdr, ch->num, idx);
> > +		}
> > +
> > +		/* Check if both DMA buffers are done */
> > +		if (!rcar_drif_buf_pairs_done(bufi, bufq))
> > +			return;
> > +
> > +		/* Clear buf done status */
> > +		bufi->status &=3D ~RCAR_DRIF_BUF_DONE;
> > +		bufq->status &=3D ~RCAR_DRIF_BUF_DONE;
> > +
> > +		/* Get fbuf */
> > +		fbuf =3D rcar_drif_get_fbuf(sdr);
> > +		if (!fbuf)
> > +			return;
> > +
> > +		memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0),
> > +		       bufi->addr, sdr->hwbuf_size);
> > +		memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0) + sdr-
> >hwbuf_size,
> > +		       bufq->addr, sdr->hwbuf_size);
>=20
> Ouch ! That's a high data rate memcpy that can be avoided. Why don't you
> DMA directly to the vb2 buffers ? You will need to use videobuf2-dma-
> contig instead of videobuf2-vmalloc, but apart from that there should be
> no issue.

Yes. We thought about this issue and considered this approach as a trade-of=
f to avoid DRIF overflow issue. Overflow happens DMAC fails to consume from=
 DRIF FIFO on time (i.e.) when user app is busy processing samples and fail=
s to queue buffers to DMAC. After an overflow, the device needs to reset (s=
treaming stop/restart sequence). With cyclic DMA, we de-coupled the h/w and=
 user buffers to avoid a costly device reset when user app is busy or not s=
cheduled. Some samples will be lost but that is identified with the sequenc=
e numbers and the action/policy can be left to the user. Are you OK with th=
is please?

>=20
> > +		if ((bufi->status | bufq->status) & RCAR_DRIF_BUF_OVERFLOW) {
> > +			overflow =3D true;
> > +			/* Clear the flag in status */
> > +			bufi->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> > +			bufq->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> > +		}
> > +	} else {
> > +		struct rcar_drif_hwbuf *bufiq;
> > +
> > +		/* Get fbuf */
> > +		fbuf =3D rcar_drif_get_fbuf(sdr);
> > +		if (!fbuf)
> > +			return;
> > +
> > +		bufiq =3D ch->buf[idx];
> > +
> > +		memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0),
> > +		       bufiq->addr, sdr->hwbuf_size);
> > +
> > +		if (bufiq->status & RCAR_DRIF_BUF_OVERFLOW) {
> > +			overflow =3D true;
> > +			/* Clear the flag in status */
> > +			bufiq->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> > +		}
> > +	}
> > +
> > +	rdrif_dbg(2, sdr, "ch%u: prod %u\n", ch->num, sdr->produced);
> > +
> > +	fbuf->vb.field =3D V4L2_FIELD_NONE;
> > +	fbuf->vb.sequence =3D sdr->produced++;
> > +	fbuf->vb.vb2_buf.timestamp =3D ktime_get_ns();
> > +	vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
> > +			      formats[sdr->fmt_idx].buffersize);
> > +
> > +	/* Set error state on overflow */
> > +	if (overflow)
> > +		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> > +	else
> > +		vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);
>=20
> Maybe
>=20
> 	vb2_buffer_done(&fbuf->vb.vb2_buf,
> 			overflow ? VB2_BUF_STATE_ERROR: VB2_BUF_STATE_DONE);

Agreed

>=20
> > +}
> > +
> > +/* DMA callback for each stage */
> > +static void rcar_drif_dma_complete(void *dma_async_param) {
> > +	struct rcar_drif *ch =3D dma_async_param;
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +
> > +	mutex_lock(&sdr->vb_queue_mutex);
>=20
> Isn't the complete callback potentially called in interrupt context ? I
> know the rcar-dmac driver uses a threaded interrupt handler for that, but
> is that a guarantee of the DMA engine API ?
>=20

DMA engine API mentions the callback will be called in tasklet context. Hmm=
... I could convert that into spin_lock_irq() if that's OK.

> > +
> > +	/* DMA can be terminated while the callback was waiting on lock */
> > +	if (!vb2_is_streaming(&sdr->vb_queue))
>=20
> Can it ? The streaming flag is cleared after the stop_streaming operation
> is called, which will terminate all DMA transfers synchronously.

rcar-dmac did not have device_synchronize support, when I started with this=
 patch set. There is a comment in the terminal_all call

1224         /*     =20
1225          * FIXME: No new interrupt can occur now, but the IRQ thread m=
ight still
1226          * be running.
1227          */

Hence, I was a bit paranoid.=20

>=20
> > +		goto stopped;
> > +
> > +	rcar_drif_deliver_buf(ch);
> > +stopped:
> > +	mutex_unlock(&sdr->vb_queue_mutex);
> > +}
> > +
> > +static int rcar_drif_qbuf(struct rcar_drif *ch) {
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +	dma_addr_t addr =3D ch->dma_handle;
> > +	struct dma_async_tx_descriptor *rxd;
> > +	dma_cookie_t cookie;
> > +	int ret =3D -EIO;
> > +
> > +	/* Setup cyclic DMA with given buffers */
> > +	rxd =3D dmaengine_prep_dma_cyclic(ch->dmach, addr,
> > +					sdr->hwbuf_size * num_hwbufs,
> > +					sdr->hwbuf_size, DMA_DEV_TO_MEM,
> > +					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> > +	if (!rxd) {
> > +		rdrif_err(sdr, "ch%u: prep dma cyclic failed\n", ch->num);
> > +		return ret;
> > +	}
> > +
> > +	/* Submit descriptor */
> > +	rxd->callback =3D rcar_drif_dma_complete;
> > +	rxd->callback_param =3D ch;
> > +	cookie =3D dmaengine_submit(rxd);
> > +	if (dma_submit_error(cookie)) {
> > +		rdrif_err(sdr, "ch%u: dma submit failed\n", ch->num);
> > +		return ret;
> > +	}
> > +
> > +	dma_async_issue_pending(ch->dmach);
> > +	return 0;
> > +}
> > +
> > +/* Enable reception */
> > +static int rcar_drif_enable_rx(struct rcar_drif_sdr *sdr) {
> > +	unsigned int i;
> > +	u32 ctr;
> > +	int ret;
> > +
> > +	/*
> > +	 * When both internal channels are enabled, they can be synchronized
> > +	 * only by the master
> > +	 */
> > +
> > +	/* Enable receive */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ctr =3D readl(sdr->ch[i]->base + RCAR_DRIF_SICTR);
> > +		ctr |=3D (RCAR_DRIF_SICTR_RX_RISING_EDGE |
> > +			 RCAR_DRIF_SICTR_RX_EN);
> > +		writel(ctr, sdr->ch[i]->base + RCAR_DRIF_SICTR);
> > +	}
> > +
> > +	/* Check receive enabled */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ret =3D readl_poll_timeout(sdr->ch[i]->base + RCAR_DRIF_SICTR,
> > +					 ctr, ctr & RCAR_DRIF_SICTR_RX_EN,
> > +					 2, 500000);
>=20
> A 2=B5s sleep for a 500ms total timeout seems very low to me, that will
> stress the CPU. Same comment for the other locations where you use
> readl_poll_timeout.
>=20
> How long does the channel typically take to get enabled ?

It takes ~6-7=B5s on my board. The manual did not specify the expected time=
 and I used a worst case of 500ms as this is used in the on/off path only.

Would 7=B5s sleep time be acceptable instead of 2=B5s?=20

>=20
> > +		if (ret) {
> > +			rdrif_err(sdr, "ch%u: rx en failed. ctr 0x%08x\n",
> > +				  i, readl(sdr->ch[i]->base +
> RCAR_DRIF_SICTR));
> > +			break;
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +
> > +/* Disable reception */
> > +static void rcar_drif_disable_rx(struct rcar_drif_sdr *sdr) {
> > +	unsigned int i;
> > +	u32 ctr;
> > +	int ret;
> > +
> > +	/* Disable receive */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ctr =3D readl(sdr->ch[i]->base + RCAR_DRIF_SICTR);
> > +		ctr &=3D ~RCAR_DRIF_SICTR_RX_EN;
> > +		writel(ctr, sdr->ch[i]->base + RCAR_DRIF_SICTR);
> > +	}
> > +
> > +	/* Check receive disabled */
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ret =3D readl_poll_timeout(sdr->ch[i]->base + RCAR_DRIF_SICTR,
> > +					 ctr, !(ctr & RCAR_DRIF_SICTR_RX_EN),
> > +					 2, 500000);
>=20
> How long does the channel typically take to get disabled ?

Same as above comment.

>=20
> > +		if (ret)
> > +			dev_warn(&sdr->vdev->dev,
> > +			"ch%u: failed to disable rx. ctr 0x%08x\n",
> > +			i, readl(sdr->ch[i]->base + RCAR_DRIF_SICTR));
> > +	}
> > +}
> > +
> > +/* Start channel */
> > +static int rcar_drif_start_channel(struct rcar_drif *ch) {
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +	u32 ctr, str;
> > +	int ret;
> > +
> > +	/* Reset receive */
> > +	writel(RCAR_DRIF_SICTR_RESET, ch->base + RCAR_DRIF_SICTR);
> > +	ret =3D readl_poll_timeout(ch->base + RCAR_DRIF_SICTR,
> > +					 ctr, !(ctr & RCAR_DRIF_SICTR_RESET),
>=20
> The alignment is weird.

If I remember correctly, it is a checkpatch warning when I started with the=
 patch set (Last year Oct timeframe).

>=20
> > +					 2, 500000);
> > +	if (ret) {
> > +		rdrif_err(sdr, "ch%u: failed to reset rx. ctr 0x%08x\n",
> > +			  ch->num, readl(ch->base + RCAR_DRIF_SICTR));
> > +		return ret;
> > +	}
> > +
> > +	/* Queue buffers for DMA */
> > +	ret =3D rcar_drif_qbuf(ch);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/* Clear status register flags */
> > +	str =3D RCAR_DRIF_RFFUL | RCAR_DRIF_REOF | RCAR_DRIF_RFSERR |
> > +		RCAR_DRIF_RFUDF | RCAR_DRIF_RFOVF;
> > +	writel(str, ch->base + RCAR_DRIF_SISTR);
> > +
> > +	/* Enable DMA receive interrupt */
> > +	writel(0x00009000, ch->base + RCAR_DRIF_SIIER);
> > +
> > +	return ret;
> > +}
> > +
> > +/* Start receive operation */
> > +static int rcar_drif_start(struct rcar_drif_sdr *sdr) {
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ret =3D rcar_drif_start_channel(sdr->ch[i]);
> > +		if (ret)
> > +			goto start_error;
> > +	}
> > +
> > +	sdr->produced =3D 0;
> > +	ret =3D rcar_drif_enable_rx(sdr);
> > +start_error:
>=20
> Don't you need to stop the channels that were successfully started if an
> error occurs ?

Thank you. I missed this :-(.

>=20
> > +	return ret;
> > +}
> > +
> > +/* Stop channel */
> > +static void rcar_drif_stop_channel(struct rcar_drif *ch) {
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +	int ret, retries =3D 3;
> > +
> > +	/* Disable DMA receive interrupt */
> > +	writel(0x00000000, ch->base + RCAR_DRIF_SIIER);
> > +
> > +	do {
> > +		/* Terminate all DMA transfers */
> > +		ret =3D dmaengine_terminate_sync(ch->dmach);
> > +		if (!ret)
> > +			break;
> > +		rdrif_dbg(2, sdr, "stop retry\n");
> > +	} while (--retries);
>=20
> Why do you need to retry the terminate operation, why does it fail ?

Yes, I think it can be removed. I cannot remember why I added retry here be=
cause rcar-dmac terminate_all always seem to return 0. Last year, there use=
d to be a WARN_ON in rcar-dmac code when channel halt fails (i.e.) it is no=
t guaranteed that all transfers are stopped even after calling dmaengine_te=
rminate_sync(). With the character version of this driver, I used to have a=
 test app to start/stream/stop/restart sequence & hit the WARN_ON in dmac c=
ode sometimes (https://www.spinics.net/lists/linux-renesas-soc/msg04840.htm=
l). I may have added this return value check assuming it is passed on but I=
 cannot see that even in the old code.

So yes, I agree with your comment.

>=20
> > +	WARN_ON(!retries);
> > +}
>=20
> [snip]
>=20
> > +/* Start streaming */
> > +static int rcar_drif_start_streaming(struct vb2_queue *vq, unsigned
> > +int
> > count)
> > +{
> > +	struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vq);
> > +	unsigned int i, j;
> > +	int ret;
> > +
> > +	mutex_lock(&sdr->v4l2_mutex);
>=20
> I'm surprised, aren't the start_streaming and stop_streaming operations
> called with the video device lock held already by the v4l2-ioctl layer ? =
I
> think they should be, if they're not there's probably a bug somewhere.

I did not see it. Please correct me if this is wrong

v4l_streamon
 vb2_ioctl_streamon
  vb2_streamon
   vb2_core_streamon
    vb2_start_streaming
     q->ops->start_streaming =3D> rcar_drif_start_streaming

    =20
>=20
> > +	for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> > +		ret =3D clk_prepare_enable(sdr->ch[i]->clkp);
> > +		if (ret)
> > +			goto start_error;
> > +	}
> > +
> > +	/* Set default MDRx settings */
> > +	rcar_drif_set_mdr1(sdr);
> > +
> > +	/* Set new format */
> > +	ret =3D rcar_drif_set_format(sdr);
> > +	if (ret)
> > +		goto start_error;
> > +
> > +	if (sdr->num_cur_ch =3D=3D RCAR_DRIF_MAX_CHANNEL)
> > +		sdr->hwbuf_size =3D
> > +		formats[sdr->fmt_idx].buffersize / RCAR_DRIF_MAX_CHANNEL;
> > +	else
> > +		sdr->hwbuf_size =3D formats[sdr->fmt_idx].buffersize;
> > +
> > +	rdrif_dbg(1, sdr, "num_hwbufs %u, hwbuf_size %u\n",
> > +		num_hwbufs, sdr->hwbuf_size);
> > +
> > +	/* Alloc DMA channel */
> > +	ret =3D rcar_drif_alloc_dmachannel(sdr);
> > +	if (ret)
> > +		goto start_error;
> > +
> > +	/* Alloc buf context */
> > +	ret =3D rcar_drif_alloc_bufctxt(sdr);
> > +	if (ret)
> > +		goto start_error;
> > +
> > +	/* Request buffers */
> > +	ret =3D rcar_drif_request_buf(sdr);
> > +	if (ret)
> > +		goto start_error;
> > +
> > +	/* Start Rx */
> > +	ret =3D rcar_drif_start(sdr);
> > +	if (ret)
> > +		goto start_error;
> > +
> > +	mutex_unlock(&sdr->v4l2_mutex);
> > +	rdrif_dbg(1, sdr, "started\n");
> > +	return ret;
> > +
> > +start_error:
>=20
> As there's a single error label I would call this "error". Up to you.

Agreed.

>=20
> > +	rcar_drif_release_queued_bufs(sdr, VB2_BUF_STATE_QUEUED);
> > +	rcar_drif_release_buf(sdr);
> > +	rcar_drif_release_bufctxt(sdr);
> > +	rcar_drif_release_dmachannel(sdr);
> > +	for (j =3D 0; j < i; j++)
> > +		clk_disable_unprepare(sdr->ch[j]->clkp);
> > +
> > +	mutex_unlock(&sdr->v4l2_mutex);
> > +	return ret;
> > +}
>=20
> [snip]
>=20
> > +/* Vb2 ops */
> > +static struct vb2_ops rcar_drif_vb2_ops =3D {
>=20
> You can make this static const.

Agreed

>=20
> > +	.queue_setup            =3D rcar_drif_queue_setup,
> > +	.buf_queue              =3D rcar_drif_buf_queue,
> > +	.start_streaming        =3D rcar_drif_start_streaming,
> > +	.stop_streaming         =3D rcar_drif_stop_streaming,
> > +	.wait_prepare		=3D vb2_ops_wait_prepare,
> > +	.wait_finish		=3D vb2_ops_wait_finish,
> > +};
>=20
> [snip]
>=20
> > +static int rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,
> > +				   struct v4l2_format *f)
> > +{
> > +	struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> > +
> > +	f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> > +	f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;
> > +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>=20
> I believe the core ioctl handling code already does this for you. Same fo=
r
> the other ioctl handlers in

Agreed

>=20
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_s_fmt_sdr_cap(struct file *file, void *priv,
> > +				   struct v4l2_format *f)
> > +{
> > +	struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> > +	struct vb2_queue *q =3D &sdr->vb_queue;
> > +	unsigned int i;
> > +
> > +	if (vb2_is_busy(q))
> > +		return -EBUSY;
> > +
> > +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> > +	for (i =3D 0; i < NUM_FORMATS; i++) {
> > +		if (formats[i].pixelformat =3D=3D f->fmt.sdr.pixelformat) {
>=20
> The code would become more readable (at least in my opinion) if you just
> added a break here, and moved the code below after the loop. In case the
> requested format isn't found (i =3D=3D NUM_FORMATS) you can then set i to=
 0
> and proceed, that will select the first available format as a default.

Agreed

>=20
> > +			sdr->fmt_idx  =3D i;
> > +			f->fmt.sdr.buffersize =3D formats[i].buffersize;
> > +
> > +			/*
> > +			 * If a format demands one channel only out of two
> > +			 * enabled channels, pick the 0th channel.
> > +			 */
> > +			if (formats[i].num_ch < sdr->num_hw_ch) {
> > +				sdr->cur_ch_mask =3D BIT(0);
> > +				sdr->num_cur_ch =3D formats[i].num_ch;
> > +			} else {
> > +				sdr->cur_ch_mask =3D sdr->hw_ch_mask;
> > +				sdr->num_cur_ch =3D sdr->num_hw_ch;
> > +			}
> > +
> > +			rdrif_dbg(1, sdr, "cur: idx %u mask %lu num %u\n",
> > +				  i, sdr->cur_ch_mask, sdr->num_cur_ch);
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	if (rcar_drif_set_default_format(sdr)) {
> > +		rdrif_err(sdr, "cannot set default format\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> > +	f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_try_fmt_sdr_cap(struct file *file, void *priv,
> > +				     struct v4l2_format *f)
> > +{
> > +	struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> > +	unsigned int i;
> > +
> > +	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> > +	for (i =3D 0; i < NUM_FORMATS; i++) {
> > +		if (formats[i].pixelformat =3D=3D f->fmt.sdr.pixelformat) {
> > +			f->fmt.sdr.buffersize =3D formats[i].buffersize;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> > +	f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;
>=20
> The result of the TRY_FMT ioctl should not depend on the currently
> configured format. I would return a fixed format (for instance the first
> one in the formats array) in the default case.

Agreed

>=20
> > +	return 0;
> > +}
> > +
> > +/* Tuner subdev ioctls */
> > +static int rcar_drif_enum_freq_bands(struct file *file, void *priv,
> > +				     struct v4l2_frequency_band *band) {
> > +	struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> > +	struct v4l2_subdev *sd;
> > +	int ret =3D 0;
> > +
> > +	v4l2_device_for_each_subdev(sd, &sdr->v4l2_dev) {
> > +		ret =3D v4l2_subdev_call(sd, tuner, enum_freq_bands, band);
>=20
> This won't work as-is when you'll have multiple subdevs. As the driver
> only supports a single connected subdev at the moment, I suggest storing =
a
> pointer to that subdev in the rcar_drif_sdr structure, and calling
> operations on that subdev explicitly instead of looping over all subdevs.
> The comment holds for all other ioctls.

Agreed.

>=20
> > +		if (ret)
> > +			break;
> > +	}
> > +	return ret;
> > +}
>=20
> [snip]
>=20
> > +static int rcar_drif_notify_bound(struct v4l2_async_notifier *notifier=
,
> > +				   struct v4l2_subdev *subdev,
> > +				   struct v4l2_async_subdev *asd) {
> > +	struct rcar_drif_sdr *sdr =3D
> > +		container_of(notifier, struct rcar_drif_sdr, notifier);
> > +
> > +	/* Nothing to do at this point */
>=20
> If there's nothing to do you can just leave the bound callback
> unimplemented, it's optional.

Agreed.

>=20
> > +	rdrif_dbg(2, sdr, "bound asd: %s\n", asd->match.of.node->name);
> > +	return 0;
> > +}
> > +
> > +/* Sub-device registered notification callback */ static int
> > +rcar_drif_notify_complete(struct v4l2_async_notifier *notifier) {
> > +	struct rcar_drif_sdr *sdr =3D
> > +		container_of(notifier, struct rcar_drif_sdr, notifier);
> > +	struct v4l2_subdev *sd;
> > +	int ret;
> > +
> > +	sdr->v4l2_dev.ctrl_handler =3D &sdr->ctrl_hdl;
> > +
> > +	ret =3D v4l2_device_register_subdev_nodes(&sdr->v4l2_dev);
> > +	if (ret) {
> > +		rdrif_err(sdr, "failed register subdev nodes ret %d\n", ret);
> > +		return ret;
> > +	}
>=20
> Do you need to expose subdev nodes to userspace ? Can't everything be
> handled from the V4L2 SDR node ?

As of today, everything can be handled from the V4L2 SDR node with current =
MAX2175 subdev. If the tuner driver is enhanced later, this would help.

>=20
> > +	v4l2_device_for_each_subdev(sd, &sdr->v4l2_dev) {
> > +		ret =3D v4l2_ctrl_add_handler(sdr->v4l2_dev.ctrl_handler,
> > +					    sd->ctrl_handler, NULL);
>=20
> Shouldn't you undo this somewhere when unbinding the subdevs ?



>=20
> > +		if (ret) {
> > +			rdrif_err(sdr, "failed ctrl add hdlr ret %d\n", ret);
> > +			return ret;
> > +		}
> > +	}
> > +	rdrif_dbg(2, sdr, "notify complete\n");
> > +	return 0;
> > +}
>=20
> [snip]
>=20
> > +/* Parse sub-devs (tuner) to find a matching device */ static int
> > +rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr,
> > +				   struct device *dev)
> > +{
> > +	struct v4l2_async_notifier *notifier =3D &sdr->notifier;
> > +	struct rcar_drif_async_subdev *rsd;
> > +	struct device_node *node;
> > +
> > +	notifier->subdevs =3D devm_kzalloc(dev, sizeof(*notifier->subdevs),
> > +					 GFP_KERNEL);
> > +	if (!notifier->subdevs)
> > +		return -ENOMEM;
> > +
> > +	node =3D of_graph_get_next_endpoint(dev->of_node, NULL);
> > +	if (!node)
> > +		return 0;
> > +
> > +	rsd =3D devm_kzalloc(dev, sizeof(*rsd), GFP_KERNEL);
> > +	if (!rsd) {
> > +		of_node_put(node);
>=20
> If you move the allocation above of_graph_get_next_endpoint() you won't
> have to call of_node_put() in the error path.

Agreed

>=20
> > +		return -ENOMEM;
> > +	}
> > +
> > +	notifier->subdevs[notifier->num_subdevs] =3D &rsd->asd;
> > +	rsd->asd.match.of.node =3D of_graph_get_remote_port_parent(node);
>=20
> Aren't you missing an of_node_put() on the returned node ? Or does the
> async framework take care of that ?

You are right. of_node_put() on the returned node is missing. I will add it=
.

>=20
> > +	of_node_put(node);
> > +	if (!rsd->asd.match.of.node) {
> > +		dev_warn(dev, "bad remote port parent\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	rsd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
> > +	notifier->num_subdevs++;
> > +
> > +	/* Get the endpoint properties */
> > +	rcar_drif_get_ep_properties(sdr, node);
> > +	return 0;
> > +}
> > +
> > +/* Check if the given device is the primary bond */ static bool
> > +rcar_drif_primary_bond(struct platform_device *pdev) {
> > +	if (of_find_property(pdev->dev.of_node, "renesas,primary-bond",
> NULL))
> > +		return true;
> > +
> > +	return false;
>=20
> How about
>=20
> 	return of_property_read_bool(pdev->dev.of_node,
> 				     "renesas,primary-bond");

Shall I remove this function itself and just use the property in the "if" c=
ondition please? It's used in one place only. I tend to not touch the bindi=
ngs name/type as we have some sort of agreement after ~4months time :-)
=20
>=20
> > +}
> > +
> > +/* Get the bonded platform dev if enabled */ static struct
> > +platform_device *rcar_drif_enabled_bond(struct
> > platform_device *p)
> > +{
> > +	struct device_node *np;
> > +
> > +	np =3D of_parse_phandle(p->dev.of_node, "renesas,bonding", 0);
>=20
> The function takes a reference to np, you need to call of_node_put() on i=
t
> (only if the returned pointer isn't NULL).

Agreed

>=20
> > +	if (np && of_device_is_available(np))
> > +		return of_find_device_by_node(np);
>=20
> of_find_device_by_node() takes a reference to the returned device, you
> need to call device_put() on it when you don't need it anymore.

Agreed & Thanks again.


>=20
>=20
> > +	return NULL;
> > +}
> > +
> > +/* Proble internal channel */
> > +static int rcar_drif_channel_probe(struct platform_device *pdev)
> > +{
> > +	struct rcar_drif *ch;
> > +	struct resource	*res;
> > +	void __iomem *base;
> > +	struct clk *clkp;
>=20
> Maybe s/clkp/clk/ ?

Agreed

>=20
> > +	int ret;
> > +
> > +	/* Peripheral clock */
> > +	clkp =3D devm_clk_get(&pdev->dev, "fck");
> > +	if (IS_ERR(clkp)) {
> > +		ret =3D PTR_ERR(clkp);
> > +		dev_err(&pdev->dev, "clk get failed (%d)\n", ret);
> > +		return ret;
> > +	}
>=20
> Isn't the clock managed automatically by runtime PM ?

I think the driver need to support runtime PM in order to manage the clock.=
 Otherwise it just gets adds the clk to genpd (_prepare) without enable/dis=
able. I need to double check this.

>=20
> > +	/* Register map */
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	base =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(base)) {
> > +		ret =3D PTR_ERR(base);
> > +		dev_err(&pdev->dev, "ioremap failed (%d)\n", ret);
> > +		return ret;
>=20
> devm_ioremap_resource() already prints an error message, you can remove
> this
> one.

Agreed

>=20
> > +	}
> > +
> > +	/* Reserve memory for enabled channel */
> > +	ch =3D devm_kzalloc(&pdev->dev, sizeof(*ch), GFP_KERNEL);
> > +	if (!ch) {
> > +		ret =3D PTR_ERR(ch);
> > +		dev_err(&pdev->dev, "failed alloc channel\n");
>=20
> Memory allocation failures already print error messages, you can remove
> this
> one.

Agreed.

>=20
> > +		return ret;
> > +	}
> > +	ch->pdev =3D pdev;
> > +	ch->clkp =3D clkp;
> > +	ch->base =3D base;
> > +	ch->start =3D res->start;
>=20
> If you allocated the ch structure first you could set the fields directly
> without a need for local variables.

Agreed.

>=20
> > +	platform_set_drvdata(pdev, ch);
> > +	return 0;
> > +}
> > +
> > +static int rcar_drif_probe(struct platform_device *pdev)
> > +{
> > +	struct rcar_drif *ch, *b_ch =3D NULL;
> > +	struct platform_device *b_pdev;
> > +	struct rcar_drif_sdr *sdr;
> > +	int ret;
> > +
> > +	/* Probe internal channel */
> > +	ret =3D rcar_drif_channel_probe(pdev);
> > +	if (ret)
> > +		return ret;
>=20
> I would have done it the other way around, inlining the
> rcar_drif_channel_probe() function here as that's the common case, and
> moving
> the V4L2 SDR device initialization code to a different function.

Agreed

>=20
> > +	/* Check if both channels of the bond are enabled */
> > +	b_pdev =3D rcar_drif_enabled_bond(pdev);
> > +	if (b_pdev) {
> > +		/* Check if current channel acting as primary-bond */
> > +		if (!rcar_drif_primary_bond(pdev)) {
> > +			dev_notice(&pdev->dev, "probed\n");
> > +			return 0;
> > +		}
> > +
> > +		/* Check if the other device is probed */
> > +		b_ch =3D platform_get_drvdata(b_pdev);
> > +		if (!b_ch) {
> > +			dev_info(&pdev->dev, "defer probe\n");
> > +			return -EPROBE_DEFER;
> > +		}
>=20
> Isn't this all very racy ? What if the other channel's device is removed
> while
> this one is probed ?

OK. Will holding the device_lock(&b_pdev->dev) is sufficient?
>=20
> > +		/* Set the other channel number */
> > +		b_ch->num =3D 1;
>=20
> Reading data from the other channel's private structure is one thing, but
> writing it makes me shiver :-S Could we make it so that 0 is the slave an=
d
> 1
> the master ? That way you would set ch->num =3D 1 instead of b_ch->num =
=3D 1,
> keeping all modifications to the private structure local to the device
> being
> probed.

Agreed.

>=20
> > +	}
> > +
> > +	/* Channel acting as SDR instance */
> > +	ch =3D platform_get_drvdata(pdev);
> > +	ch->acting_sdr =3D true;
> > +
> > +	/* Reserve memory for SDR structure */
> > +	sdr =3D devm_kzalloc(&pdev->dev, sizeof(*sdr), GFP_KERNEL);
> > +	if (!sdr) {
> > +		ret =3D PTR_ERR(sdr);
> > +		dev_err(&pdev->dev, "failed alloc drif context\n");
> > +		return ret;
> > +	}
> > +	sdr->dev =3D &pdev->dev;
> > +	sdr->hw_ch_mask =3D BIT(ch->num);
> > +
> > +	/* Establish links between SDR and channel(s) */
> > +	ch->sdr =3D sdr;
> > +	sdr->ch[ch->num] =3D ch;
> > +	if (b_ch) {
> > +		sdr->ch[b_ch->num] =3D b_ch;
> > +		b_ch->sdr =3D sdr;
> > +		sdr->hw_ch_mask |=3D BIT(b_ch->num);
> > +	}
> > +	sdr->num_hw_ch =3D hweight_long(sdr->hw_ch_mask);
> > +
> > +	/* Validate any supported format for enabled channels */
> > +	ret =3D rcar_drif_set_default_format(sdr);
> > +	if (ret) {
> > +		dev_err(sdr->dev, "failed to set default format\n");
> > +		return ret;
> > +	}
> > +
> > +	/* Set defaults */
> > +	sdr->hwbuf_size =3D RCAR_DRIF_DEFAULT_HWBUF_SIZE;
> > +
> > +	mutex_init(&sdr->v4l2_mutex);
> > +	mutex_init(&sdr->vb_queue_mutex);
> > +	spin_lock_init(&sdr->queued_bufs_lock);
> > +	INIT_LIST_HEAD(&sdr->queued_bufs);
> > +
> > +	/* Init videobuf2 queue structure */
> > +	sdr->vb_queue.type =3D V4L2_BUF_TYPE_SDR_CAPTURE;
> > +	sdr->vb_queue.io_modes =3D VB2_READ | VB2_MMAP | VB2_DMABUF;
> > +	sdr->vb_queue.drv_priv =3D sdr;
> > +	sdr->vb_queue.buf_struct_size =3D sizeof(struct rcar_drif_frame_buf);
> > +	sdr->vb_queue.ops =3D &rcar_drif_vb2_ops;
> > +	sdr->vb_queue.mem_ops =3D &vb2_vmalloc_memops;
> > +	sdr->vb_queue.timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +
> > +	/* Init videobuf2 queue */
> > +	ret =3D vb2_queue_init(&sdr->vb_queue);
> > +	if (ret) {
> > +		dev_err(sdr->dev, "could not initialize vb2 queue\n");
> > +		return ret;
> > +	}
> > +
> > +	/* Register the v4l2_device */
> > +	ret =3D v4l2_device_register(&pdev->dev, &sdr->v4l2_dev);
> > +	if (ret) {
> > +		dev_err(sdr->dev, "failed v4l2_device_register (%d)\n", ret);
>=20
> Maybe "failed to register V4L2 device" to make it a real sentence ? :-)

Agreed

>=20
> > +		return ret;
> > +	}
> > +
> > +	/*
> > +	 * Parse subdevs after v4l2_device_register because if the subdev
> > +	 * is already probed, bound and complete will be called immediately
> > +	 */
> > +	ret =3D rcar_drif_parse_subdevs(sdr, &pdev->dev);
> > +	if (ret)
> > +		goto err_unreg_v4l2;
> > +
> > +	sdr->notifier.bound =3D rcar_drif_notify_bound;
> > +	sdr->notifier.complete =3D rcar_drif_notify_complete;
> > +
> > +	v4l2_ctrl_handler_init(&sdr->ctrl_hdl, 10);
>=20
> Possibly a stupid question, why 10, if you don't create any control in
> this
> driver ?

To accommodate the subdev controls.

>=20
> > +	/* Register notifier */
> > +	ret =3D v4l2_async_notifier_register(&sdr->v4l2_dev, &sdr->notifier);
> > +	if (ret < 0) {
> > +		dev_err(sdr->dev, "notifier registration failed (%d)\n", ret);
> > +		goto err_free_ctrls;
> > +	}
> > +
> > +	/* Init video_device structure */
> > +	sdr->vdev =3D video_device_alloc();
> > +	if (!sdr->vdev) {
> > +		ret =3D -ENOMEM;
> > +		goto err_unreg_notif;
> > +	}
> > +	snprintf(sdr->vdev->name, sizeof(sdr->vdev->name), "R-Car DRIF");
> > +	sdr->vdev->fops =3D &rcar_drif_fops;
> > +	sdr->vdev->ioctl_ops =3D &rcar_drif_ioctl_ops;
> > +	sdr->vdev->release =3D video_device_release;
> > +	sdr->vdev->lock =3D &sdr->v4l2_mutex;
> > +	sdr->vdev->queue =3D &sdr->vb_queue;
> > +	sdr->vdev->queue->lock =3D &sdr->vb_queue_mutex;
> > +	sdr->vdev->ctrl_handler =3D &sdr->ctrl_hdl;
> > +	sdr->vdev->v4l2_dev =3D &sdr->v4l2_dev;
> > +	sdr->vdev->device_caps =3D V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
> > +		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> > +	video_set_drvdata(sdr->vdev, sdr);
> > +
> > +	/* Register V4L2 SDR device */
> > +	ret =3D video_register_device(sdr->vdev, VFL_TYPE_SDR, -1);
> > +	if (ret) {
> > +		dev_err(sdr->dev, "failed video_register_device (%d)\n", ret);
>=20
> Same here, "failed to register video device" ?

Agreed.

>=20
> > +		goto err_unreg_notif;
> > +	}
> > +
> > +	dev_notice(sdr->dev, "probed\n");
>=20
> Do you think this message is really useful ? I believe it would just add =
a
> bit
> more noise to the kernel log, without any real use.

OK. Will remove it.

>=20
> > +	return 0;
> > +
> > +err_unreg_notif:
> > +	video_device_release(sdr->vdev);
> > +	v4l2_async_notifier_unregister(&sdr->notifier);
> > +err_free_ctrls:
> > +	v4l2_ctrl_handler_free(&sdr->ctrl_hdl);
> > +err_unreg_v4l2:
> > +	v4l2_device_unregister(&sdr->v4l2_dev);
> > +	return ret;
> > +}
> > +
> > +static int rcar_drif_remove(struct platform_device *pdev)
> > +{
> > +	struct rcar_drif *ch =3D platform_get_drvdata(pdev);
> > +	struct rcar_drif_sdr *sdr =3D ch->sdr;
> > +
> > +	if (!ch->acting_sdr) {
>=20
> Isn't it possible to check the channel number instead and remove the
> acting_sdr field ?

Agreed.

>=20
> > +		/* Nothing to do */
> > +		dev_notice(&pdev->dev, "removed\n");
> > +		return 0;
> > +	}
> > +
> > +	/* SDR instance */
> > +	v4l2_ctrl_handler_free(sdr->vdev->ctrl_handler);
> > +	v4l2_async_notifier_unregister(&sdr->notifier);
> > +	v4l2_device_unregister(&sdr->v4l2_dev);
> > +	video_unregister_device(sdr->vdev);
> > +	dev_notice(&pdev->dev, "removed\n");
>=20
> Even more than the probed message, I think this one can go away.

Agreed.

>=20
> > +	return 0;
> > +}
> > +
> > +static int __maybe_unused rcar_drif_suspend(struct device *dev)
> > +{
> > +	return 0;
>=20
> Maybe a /* FIXME: Implement suspend/resume support */ ?

Agreed.

>=20
> > +}
> > +
> > +static int __maybe_unused rcar_drif_resume(struct device *dev)
> > +{
> > +	return 0;
>=20
> Same here ?

Agreed.

Thanks,
Ramesh
