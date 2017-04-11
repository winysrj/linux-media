Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36952 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdDKWXt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 18:23:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert+renesas@glider.be,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 7/7] media: platform: rcar_drif: Add DRIF support
Date: Wed, 12 Apr 2017 01:24:39 +0300
Message-ID: <2330193.GrgnD4vKf8@avalon>
In-Reply-To: <1486479757-32128-8-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1486479757-32128-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1486479757-32128-8-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Tuesday 07 Feb 2017 15:02:37 Ramesh Shanmugasundaram wrote:
> This patch adds Digital Radio Interface (DRIF) support to R-Car Gen3 =
SoCs.
> The driver exposes each instance of DRIF as a V4L2 SDR device. A DRIF=

> device represents a channel and each channel can have one or two
> sub-channels respectively depending on the target board.
>=20
> DRIF supports only Rx functionality. It receives samples from a RF
> frontend tuner chip it is interfaced with. The combination of DRIF an=
d the
> tuner device, which is registered as a sub-device, determines the rec=
eive
> sample rate and format.
>=20
> In order to be compliant as a V4L2 SDR device, DRIF needs to bind wit=
h
> the tuner device, which can be provided by a third party vendor. DRIF=
 acts
> as a slave device and the tuner device acts as a master transmitting =
the
> samples. The driver allows asynchronous binding of a tuner device tha=
t
> is registered as a v4l2 sub-device. The driver can learn about the tu=
ner
> it is interfaced with based on port endpoint properties of the device=
 in
> device tree. The V4L2 SDR device inherits the controls exposed by the=

> tuner device.
>=20
> The device can also be configured to use either one or both of the da=
ta
> pins at runtime based on the master (tuner) configuration.
>=20
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com>
> ---
>  drivers/media/platform/Kconfig     |   25 +
>  drivers/media/platform/Makefile    |    1 +
>  drivers/media/platform/rcar_drif.c | 1534 ++++++++++++++++++++++++++=
+++++++
>  3 files changed, 1560 insertions(+)
>  create mode 100644 drivers/media/platform/rcar_drif.c

[snip]

> diff --git a/drivers/media/platform/rcar_drif.c
> b/drivers/media/platform/rcar_drif.c new file mode 100644
> index 0000000..88950e3
> --- /dev/null
> +++ b/drivers/media/platform/rcar_drif.c
> @@ -0,0 +1,1534 @@

[snip]

> +/*
> + * The R-Car DRIF is a receive only MSIOF like controller with an
> + * external master device driving the SCK. It receives data into a F=
IFO,
> + * then this driver uses the SYS-DMAC engine to move the data from
> + * the device to memory.
> + *
> + * Each DRIF channel DRIFx (as per datasheet) contains two internal
> + * channels DRIFx0 & DRIFx1 within itself with each having its own
> resources
> + * like module clk, register set, irq and dma. These internal channe=
ls
> share
> + * common CLK & SYNC from master. The two data pins D0 & D1 shall be=

> + * considered to represent the two internal channels. This internal =
split
> + * is not visible to the master device.
> + *
> + * Depending on the master device, a DRIF channel can use
> + *  (1) both internal channels (D0 & D1) to receive data in parallel=
 (or)
> + *  (2) one internal channel (D0 or D1) to receive data
> + *
> + * The primary design goal of this controller is to act as Digitial =
Radio

s/Digitial/Digital/

> + * Interface that receives digital samples from a tuner device. Henc=
e the
> + * driver exposes the device as a V4L2 SDR device. In order to quali=
fy as
> + * a V4L2 SDR device, it should possess tuner interface as mandated =
by the
> + * framework. This driver expects a tuner driver (sub-device) to bin=
d
> + * asynchronously with this device and the combined drivers shall ex=
pose
> + * a V4L2 compliant SDR device. The DRIF driver is independent of th=
e
> + * tuner vendor.
> + *
> + * The DRIF h/w can support I2S mode and Frame start synchronization=
 pulse
> mode.
> + * This driver is tested for I2S mode only because of the availabili=
ty of
> + * suitable master devices. Hence, not all configurable options of D=
RIF h/w
> + * like lsb/msb first, syncdl, dtdl etc. are exposed via DT and I2S
> defaults
> + * are used. These can be exposed later if needed after testing.
> + */

[snip]

> +#define to_rcar_drif_buf_pair(sdr, ch_num,
> idx)=09(sdr->ch[!(ch_num)]->buf[idx])

You should enclose both sdr and idx in parenthesis, as they can be=20
expressions.

> +
> +#define for_each_rcar_drif_channel(ch, ch_mask)=09=09=09\
> +=09for_each_set_bit(ch, ch_mask, RCAR_DRIF_MAX_CHANNEL)
> +
> +static const unsigned int num_hwbufs =3D 32;

Is there a specific reason to make this a static const instead of a #de=
fine ?

> +/* Debug */
> +static unsigned int debug;
> +module_param(debug, uint, 0644);
> +MODULE_PARM_DESC(debug, "activate debug info");
> +
> +#define rdrif_dbg(level, sdr, fmt, arg...)=09=09=09=09\
> +=09v4l2_dbg(level, debug, &sdr->v4l2_dev, fmt, ## arg)
> +
> +#define rdrif_err(sdr, fmt, arg...)=09=09=09=09=09\
> +=09dev_err(sdr->v4l2_dev.dev, fmt, ## arg)
> +
> +/* Stream formats */
> +struct rcar_drif_format {
> +=09u32=09pixelformat;
> +=09u32=09buffersize;
> +=09u32=09wdlen;
> +=09u32=09num_ch;
> +};
> +
> +/* Format descriptions for capture */
> +static const struct rcar_drif_format formats[] =3D {
> +=09{
> +=09=09.pixelformat=09=3D V4L2_SDR_FMT_PCU16BE,
> +=09=09.buffersize=09=3D RCAR_SDR_BUFFER_SIZE,
> +=09=09.wdlen=09=09=3D 16,
> +=09=09.num_ch=09=3D 2,

How about aligning the =3D as in the other lines ?

num_ch is always set to 2. Should we remove it for now, and add it back=
 later=20
when we'll support single-channel formats ? I think we should avoid car=
rying=20
dead code.

> +=09},
> +=09{
> +=09=09.pixelformat=09=3D V4L2_SDR_FMT_PCU18BE,
> +=09=09.buffersize=09=3D RCAR_SDR_BUFFER_SIZE,
> +=09=09.wdlen=09=09=3D 18,
> +=09=09.num_ch=09=3D 2,
> +=09},
> +=09{
> +=09=09.pixelformat=09=3D V4L2_SDR_FMT_PCU20BE,
> +=09=09.buffersize=09=3D RCAR_SDR_BUFFER_SIZE,
> +=09=09.wdlen=09=09=3D 20,
> +=09=09.num_ch=09=3D 2,
> +=09},
> +};
> +
> +static const unsigned int NUM_FORMATS =3D ARRAY_SIZE(formats);

Same question here, can't this be a define ? I think I'd even avoid=20
NUM_FORMATS completely and use ARRAY_SIZE(formats) directly in the code=
, to=20
make the boundary check more explicit when iterating over the array.

> +
> +/* Buffer for a received frame from one or both internal channels */=

> +struct rcar_drif_frame_buf {
> +=09/* Common v4l buffer stuff -- must be first */
> +=09struct vb2_v4l2_buffer vb;
> +=09struct list_head list;
> +};
> +
> +struct rcar_drif_async_subdev {
> +=09struct v4l2_subdev *sd;
> +=09struct v4l2_async_subdev asd;
> +};
> +
> +/* DMA buffer */
> +struct rcar_drif_hwbuf {
> +=09void *addr;=09=09=09/* CPU-side address */
> +=09unsigned int status;=09=09/* Buffer status flags */
> +};
> +
> +/* Internal channel */
> +struct rcar_drif {
> +=09struct rcar_drif_sdr *sdr;=09/* Group device */
> +=09struct platform_device *pdev;=09/* Channel's pdev */
> +=09void __iomem *base;=09=09/* Base register address */
> +=09resource_size_t start;=09=09/* I/O resource offset */
> +=09struct dma_chan *dmach;=09=09/* Reserved DMA channel */
> +=09struct clk *clkp;=09=09/* Module clock */
> +=09struct rcar_drif_hwbuf *buf[RCAR_DRIF_MAX_NUM_HWBUFS]; /* H/W buf=
s */
> +=09dma_addr_t dma_handle;=09=09/* Handle for all bufs */
> +=09unsigned int num;=09=09/* Channel number */
> +=09bool acting_sdr;=09=09/* Channel acting as SDR device */
> +};
> +
> +/* DRIF V4L2 SDR */
> +struct rcar_drif_sdr {
> +=09struct device *dev;=09=09/* Platform device */
> +=09struct video_device *vdev;=09/* V4L2 SDR device */
> +=09struct v4l2_device v4l2_dev;=09/* V4L2 device */
> +
> +=09/* Videobuf2 queue and queued buffers list */
> +=09struct vb2_queue vb_queue;
> +=09struct list_head queued_bufs;
> +=09spinlock_t queued_bufs_lock;=09/* Protects queued_bufs */
> +
> +=09struct mutex v4l2_mutex;=09/* To serialize ioctls */
> +=09struct mutex vb_queue_mutex;=09/* To serialize streaming ioctls *=
/
> +=09struct v4l2_ctrl_handler ctrl_hdl;=09/* SDR control handler */
> +=09struct v4l2_async_notifier notifier;=09/* For subdev (tuner) */
> +
> +=09/* Current V4L2 SDR format array index */
> +=09unsigned int fmt_idx;

Instead of storing the index I would store a pointer to the correspondi=
ng=20
rcar_drif_format, looking up information about the current format will =
then be=20
easier.

> +
> +=09/* Device tree SYNC properties */
> +=09u32 mdr1;
> +
> +=09/* Internals */
> +=09struct rcar_drif *ch[RCAR_DRIF_MAX_CHANNEL]; /* DRIFx0,1 */
> +=09unsigned long hw_ch_mask;=09/* Enabled channels per DT */
> +=09unsigned long cur_ch_mask;=09/* Used channels for an SDR FMT */
> +=09u32 num_hw_ch;=09=09=09/* Num of DT enabled channels */
> +=09u32 num_cur_ch;=09=09=09/* Num of used channels */
> +=09u32 hwbuf_size;=09=09=09/* Each DMA buffer size */
> +=09u32 produced;=09=09=09/* Buffers produced by sdr dev */
> +};
> +
> +/* Allocate buffer context */
> +static int rcar_drif_alloc_bufctxt(struct rcar_drif_sdr *sdr)
> +{
> +=09struct rcar_drif_hwbuf *bufctx;
> +=09unsigned int i, idx;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09bufctx =3D kcalloc(num_hwbufs, sizeof(*bufctx), GFP_KERNEL);

How about embedding the buffer contexts in the rcar_drif structure inst=
ead of=20
just storing pointers there ? The rcar_drif_hwbuf structure is pretty s=
mall,=20
it won't make a big difference, and will simplify the code.

> +=09=09if (!bufctx)
> +=09=09=09return -ENOMEM;
> +
> +=09=09for (idx =3D 0; idx < num_hwbufs; idx++)
> +=09=09=09sdr->ch[i]->buf[idx] =3D bufctx + idx;
> +=09}
> +=09return 0;
> +}

[snip]

> +/* Release DMA channel */
> +static void rcar_drif_release_dmachannel(struct rcar_drif_sdr *sdr)

I would name the function rcar_drif_release_dma_channels as it handles =
all=20
channels. Same for rcar_drif_alloc_dma_channels.

> +{
> +=09unsigned int i;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask)
> +=09=09if (sdr->ch[i]->dmach) {
> +=09=09=09dma_release_channel(sdr->ch[i]->dmach);
> +=09=09=09sdr->ch[i]->dmach =3D NULL;
> +=09=09}
> +}
> +
> +/* Allocate DMA channel */
> +static int rcar_drif_alloc_dmachannel(struct rcar_drif_sdr *sdr)
> +{
> +=09struct dma_slave_config dma_cfg;
> +=09unsigned int i;
> +=09int ret =3D -ENODEV;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09struct rcar_drif *ch =3D sdr->ch[i];
> +
> +=09=09ch->dmach =3D dma_request_slave_channel(&ch->pdev->dev, "rx");=

> +=09=09if (!ch->dmach) {
> +=09=09=09rdrif_err(sdr, "ch%u: dma channel req failed\n", i);
> +=09=09=09goto dmach_error;
> +=09=09}
> +
> +=09=09/* Configure slave */
> +=09=09memset(&dma_cfg, 0, sizeof(dma_cfg));
> +=09=09dma_cfg.src_addr =3D (phys_addr_t)(ch->start +=20
RCAR_DRIF_SIRFDR);
> +=09=09dma_cfg.dst_addr =3D 0;

This isn't needed as you memset the whole structure to 0.

> +=09=09dma_cfg.src_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
> +=09=09ret =3D dmaengine_slave_config(ch->dmach, &dma_cfg);
> +=09=09if (ret) {
> +=09=09=09rdrif_err(sdr, "ch%u: dma slave config failed\n", i);
> +=09=09=09goto dmach_error;
> +=09=09}
> +=09}
> +=09return 0;
> +
> +dmach_error:
> +=09rcar_drif_release_dmachannel(sdr);
> +=09return ret;
> +}

[snip]

> +/* Set MDR defaults */
> +static inline void rcar_drif_set_mdr1(struct rcar_drif_sdr *sdr)
> +{
> +=09unsigned int i;
> +
> +=09/* Set defaults for enabled internal channels */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09/* Refer MSIOF section in manual for this register setting */
> +=09=09writel(RCAR_DRIF_SITMDR1_PCON,
> +=09=09       sdr->ch[i]->base + RCAR_DRIF_SITMDR1);

I would create a rcar_drif_write(struct rcar_drif *ch, u32 offset, u32 =
data)=20
function, the code will become clearer. Same for the read operation.

> +=09=09/* Setup MDR1 value */
> +=09=09writel(sdr->mdr1, sdr->ch[i]->base + RCAR_DRIF_SIRMDR1);
> +
> +=09=09rdrif_dbg(2, sdr, "ch%u: mdr1 =3D 0x%08x",
> +=09=09=09  i, readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR1));

Once you've debugged the driver I'm not sure those debugging statements=
 are=20
still needed.

> +=09}
> +}
> +
> +/* Extract bitlen and wdcnt from given word length */
> +static int rcar_drif_convert_wdlen(struct rcar_drif_sdr *sdr,
> +=09=09=09=09   u32 wdlen, u32 *bitlen, u32 *wdcnt)
> +{
> +=09unsigned int i, nr_wds;
> +
> +=09/* FIFO register size is 32 bits */
> +=09for (i =3D 0; i < 32; i++) {
> +=09=09nr_wds =3D wdlen % (32 - i);
> +=09=09if (nr_wds =3D=3D 0) {
> +=09=09=09*bitlen =3D 32 - i;
> +=09=09=09*wdcnt =3D wdlen / *bitlen;

Can't you store the bitlen and wdcnt values in the rcar_drif_format str=
ucture=20
instead of recomputing them every time ?

> +=09=09=09break;
> +=09=09}
> +=09}
> +
> +=09/* Sanity check range */
> +=09if (i =3D=3D 32 || !(*bitlen >=3D 8 && *bitlen <=3D 32) ||
> +=09    !(*wdcnt >=3D 1 && *wdcnt <=3D 64)) {
> +=09=09rdrif_err(sdr, "invalid wdlen %u configured\n", wdlen);
> +=09=09return -EINVAL;

You shouldn't have invalid wdlen values in the driver. I would remove t=
his=20
check as it makes error handling in the caller more complex.

> +=09}
> +
> +=09return 0;
> +}
> +
> +/* Set DRIF receive format */
> +static int rcar_drif_set_format(struct rcar_drif_sdr *sdr)
> +{
> +=09u32 bitlen, wdcnt, wdlen;
> +=09unsigned int i;
> +=09int ret =3D -EINVAL;
> +
> +=09wdlen =3D formats[sdr->fmt_idx].wdlen;
> +=09rdrif_dbg(2, sdr, "setfmt: idx %u, wdlen %u, num_ch %u\n",
> +=09=09  sdr->fmt_idx, wdlen, formats[sdr->fmt_idx].num_ch);
> +
> +=09/* Sanity check */
> +=09if (formats[sdr->fmt_idx].num_ch > sdr->num_cur_ch) {
> +=09=09rdrif_err(sdr, "fmt idx %u current ch %u mismatch\n",
> +=09=09=09  sdr->fmt_idx, sdr->num_cur_ch);
> +=09=09return ret;

This should never happen, it should be caught at set format time.

> +=09}
> +
> +=09/* Get bitlen & wdcnt from wdlen */
> +=09ret =3D rcar_drif_convert_wdlen(sdr, wdlen, &bitlen, &wdcnt);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Setup group, bitlen & wdcnt */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09u32 mdr;
> +
> +=09=09/* Two groups */
> +=09=09mdr =3D RCAR_DRIF_MDR_GRPCNT(2) | RCAR_DRIF_MDR_BITLEN(bitlen)=
 |
> +=09=09       RCAR_DRIF_MDR_WDCNT(wdcnt);
> +=09=09writel(mdr, sdr->ch[i]->base + RCAR_DRIF_SIRMDR2);
> +
> +=09=09mdr =3D RCAR_DRIF_MDR_BITLEN(bitlen) |=20
RCAR_DRIF_MDR_WDCNT(wdcnt);
> +=09=09writel(mdr, sdr->ch[i]->base + RCAR_DRIF_SIRMDR3);
> +
> +=09=09rdrif_dbg(2, sdr, "ch%u: new mdr[2,3] =3D 0x%08x, 0x%08x\n",
> +=09=09=09  i, readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR2),
> +=09=09=09  readl(sdr->ch[i]->base + RCAR_DRIF_SIRMDR3));
> +=09}
> +=09return ret;
> +}
> +
> +/* Release DMA buffers */
> +static void rcar_drif_release_buf(struct rcar_drif_sdr *sdr)
> +{
> +=09unsigned int i;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09struct rcar_drif *ch =3D sdr->ch[i];
> +
> +=09=09/* First entry contains the dma buf ptr */
> +=09=09if (ch->buf[0] && ch->buf[0]->addr) {
> +=09=09=09dma_free_coherent(&ch->pdev->dev,
> +=09=09=09=09=09  sdr->hwbuf_size * num_hwbufs,
> +=09=09=09=09=09  ch->buf[0]->addr, ch->dma_handle);
> +=09=09=09ch->buf[0]->addr =3D NULL;
> +=09=09}
> +=09}
> +}
> +
> +/* Request DMA buffers */
> +static int rcar_drif_request_buf(struct rcar_drif_sdr *sdr)
> +{
> +=09int ret =3D -ENOMEM;
> +=09unsigned int i, j;
> +=09void *addr;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09struct rcar_drif *ch =3D sdr->ch[i];
> +
> +=09=09/* Allocate DMA buffers */
> +=09=09addr =3D dma_alloc_coherent(&ch->pdev->dev,
> +=09=09=09=09=09  sdr->hwbuf_size * num_hwbufs,
> +=09=09=09=09=09  &ch->dma_handle, GFP_KERNEL);
> +=09=09if (!addr) {
> +=09=09=09rdrif_err(sdr,
> +=09=09=09"ch%u: dma alloc failed. num_hwbufs %u size %u\n",
> +=09=09=09i, num_hwbufs, sdr->hwbuf_size);
> +=09=09=09goto alloc_error;
> +=09=09}
> +
> +=09=09/* Split the chunk and populate bufctxt */
> +=09=09for (j =3D 0; j < num_hwbufs; j++) {
> +=09=09=09ch->buf[j]->addr =3D addr + (j * sdr->hwbuf_size);
> +=09=09=09ch->buf[j]->status =3D 0;
> +=09=09}
> +=09}
> +
> +=09return 0;
> +
> +alloc_error:
> +=09return ret;
> +}
> +
> +/* Setup vb_queue minimum buffer requirements */
> +static int rcar_drif_queue_setup(struct vb2_queue *vq,
> +=09=09=09unsigned int *num_buffers, unsigned int *num_planes,
> +=09=09=09unsigned int sizes[], struct device *alloc_devs[])
> +{
> +=09struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vq);
> +
> +=09/* Need at least 16 buffers */
> +=09if (vq->num_buffers + *num_buffers < 16)
> +=09=09*num_buffers =3D 16 - vq->num_buffers;
> +
> +=09*num_planes =3D 1;
> +=09sizes[0] =3D PAGE_ALIGN(formats[sdr->fmt_idx].buffersize);
> +
> +=09rdrif_dbg(2, sdr, "num_bufs %d sizes[0] %d\n", *num_buffers,=20
sizes[0]);
> +=09return 0;
> +}
> +
> +/* Enqueue buffer */
> +static void rcar_drif_buf_queue(struct vb2_buffer *vb)
> +{
> +=09struct vb2_v4l2_buffer *vbuf =3D to_vb2_v4l2_buffer(vb);
> +=09struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vb->vb2_queue);
> +=09struct rcar_drif_frame_buf *fbuf =3D
> +=09=09=09container_of(vbuf, struct rcar_drif_frame_buf, vb);
> +=09unsigned long flags;
> +
> +=09rdrif_dbg(2, sdr, "buf_queue idx %u\n", vb->index);
> +=09spin_lock_irqsave(&sdr->queued_bufs_lock, flags);
> +=09list_add_tail(&fbuf->list, &sdr->queued_bufs);
> +=09spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags);
> +}
> +
> +/* Get a frame buf from list */
> +static struct rcar_drif_frame_buf *
> +rcar_drif_get_fbuf(struct rcar_drif_sdr *sdr)
> +{
> +=09struct rcar_drif_frame_buf *fbuf;
> +=09unsigned long flags;
> +
> +=09spin_lock_irqsave(&sdr->queued_bufs_lock, flags);
> +=09fbuf =3D list_first_entry_or_null(&sdr->queued_bufs, struct
> +=09=09=09=09=09rcar_drif_frame_buf, list);
> +=09if (!fbuf) {
> +=09=09/*
> +=09=09 * App is late in enqueing buffers. Samples lost & there will
> +=09=09 * be a gap in sequence number when app recovers
> +=09=09 */
> +=09=09rdrif_dbg(1, sdr, "\napp late: prod %u\n", sdr->produced);
> +=09=09sdr->produced++; /* Increment the produced count anyway */
> +=09=09spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags);
> +=09=09return NULL;
> +=09}
> +=09list_del(&fbuf->list);
> +=09spin_unlock_irqrestore(&sdr->queued_bufs_lock, flags);
> +
> +=09return fbuf;
> +}
> +
> +static inline bool rcar_drif_buf_pairs_done(struct rcar_drif_hwbuf *=
buf1,
> +=09=09=09=09=09    struct rcar_drif_hwbuf *buf2)
> +{
> +=09return (buf1->status & buf2->status & RCAR_DRIF_BUF_DONE);
> +}
> +
> +/* Channel DMA complete */
> +static void rcar_drif_channel_complete(struct rcar_drif *ch, u32 idx=
)
> +{
> +=09u32 str;
> +
> +=09ch->buf[idx]->status |=3D RCAR_DRIF_BUF_DONE;
> +
> +=09/* Check for DRIF errors */
> +=09str =3D readl(ch->base + RCAR_DRIF_SISTR);
> +=09if (unlikely(str & RCAR_DRIF_RFOVF)) {
> +=09=09/* Writing the same clears it */
> +=09=09writel(str, ch->base + RCAR_DRIF_SISTR);
> +
> +=09=09/* Overflow: some samples are lost */
> +=09=09ch->buf[idx]->status |=3D RCAR_DRIF_BUF_OVERFLOW;
> +=09}
> +}
> +
> +/* Deliver buffer to user */
> +static void rcar_drif_deliver_buf(struct rcar_drif *ch)
> +{
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +=09u32 idx =3D sdr->produced % num_hwbufs;
> +=09struct rcar_drif_frame_buf *fbuf;
> +=09bool overflow =3D false;
> +
> +=09rcar_drif_channel_complete(ch, idx);
> +
> +=09if (sdr->num_cur_ch =3D=3D RCAR_DRIF_MAX_CHANNEL) {
> +=09=09struct rcar_drif_hwbuf *bufi, *bufq;
> +
> +=09=09if (ch->num) {
> +=09=09=09bufi =3D to_rcar_drif_buf_pair(sdr, ch->num, idx);
> +=09=09=09bufq =3D ch->buf[idx];
> +=09=09} else {
> +=09=09=09bufi =3D ch->buf[idx];
> +=09=09=09bufq =3D to_rcar_drif_buf_pair(sdr, ch->num, idx);
> +=09=09}
> +
> +=09=09/* Check if both DMA buffers are done */
> +=09=09if (!rcar_drif_buf_pairs_done(bufi, bufq))
> +=09=09=09return;
> +
> +=09=09/* Clear buf done status */
> +=09=09bufi->status &=3D ~RCAR_DRIF_BUF_DONE;
> +=09=09bufq->status &=3D ~RCAR_DRIF_BUF_DONE;
> +
> +=09=09/* Get fbuf */
> +=09=09fbuf =3D rcar_drif_get_fbuf(sdr);
> +=09=09if (!fbuf)
> +=09=09=09return;
> +
> +=09=09memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0),
> +=09=09       bufi->addr, sdr->hwbuf_size);
> +=09=09memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0) + sdr-
>hwbuf_size,
> +=09=09       bufq->addr, sdr->hwbuf_size);

Ouch ! That's a high data rate memcpy that can be avoided. Why don't yo=
u DMA=20
directly to the vb2 buffers ? You will need to use videobuf2-dma-contig=
=20
instead of videobuf2-vmalloc, but apart from that there should be no is=
sue.

> +=09=09if ((bufi->status | bufq->status) & RCAR_DRIF_BUF_OVERFLOW) {
> +=09=09=09overflow =3D true;
> +=09=09=09/* Clear the flag in status */
> +=09=09=09bufi->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> +=09=09=09bufq->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> +=09=09}
> +=09} else {
> +=09=09struct rcar_drif_hwbuf *bufiq;
> +
> +=09=09/* Get fbuf */
> +=09=09fbuf =3D rcar_drif_get_fbuf(sdr);
> +=09=09if (!fbuf)
> +=09=09=09return;
> +
> +=09=09bufiq =3D ch->buf[idx];
> +
> +=09=09memcpy(vb2_plane_vaddr(&fbuf->vb.vb2_buf, 0),
> +=09=09       bufiq->addr, sdr->hwbuf_size);
> +
> +=09=09if (bufiq->status & RCAR_DRIF_BUF_OVERFLOW) {
> +=09=09=09overflow =3D true;
> +=09=09=09/* Clear the flag in status */
> +=09=09=09bufiq->status &=3D ~RCAR_DRIF_BUF_OVERFLOW;
> +=09=09}
> +=09}
> +
> +=09rdrif_dbg(2, sdr, "ch%u: prod %u\n", ch->num, sdr->produced);
> +
> +=09fbuf->vb.field =3D V4L2_FIELD_NONE;
> +=09fbuf->vb.sequence =3D sdr->produced++;
> +=09fbuf->vb.vb2_buf.timestamp =3D ktime_get_ns();
> +=09vb2_set_plane_payload(&fbuf->vb.vb2_buf, 0,
> +=09=09=09      formats[sdr->fmt_idx].buffersize);
> +
> +=09/* Set error state on overflow */
> +=09if (overflow)
> +=09=09vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +=09else
> +=09=09vb2_buffer_done(&fbuf->vb.vb2_buf, VB2_BUF_STATE_DONE);

Maybe

=09vb2_buffer_done(&fbuf->vb.vb2_buf,
=09=09=09overflow ? VB2_BUF_STATE_ERROR: VB2_BUF_STATE_DONE);

> +}
> +
> +/* DMA callback for each stage */
> +static void rcar_drif_dma_complete(void *dma_async_param)
> +{
> +=09struct rcar_drif *ch =3D dma_async_param;
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +
> +=09mutex_lock(&sdr->vb_queue_mutex);

Isn't the complete callback potentially called in interrupt context ? I=
 know=20
the rcar-dmac driver uses a threaded interrupt handler for that, but is=
 that a=20
guarantee of the DMA engine API ?

> +
> +=09/* DMA can be terminated while the callback was waiting on lock *=
/
> +=09if (!vb2_is_streaming(&sdr->vb_queue))

Can it ? The streaming flag is cleared after the stop_streaming operati=
on is=20
called, which will terminate all DMA transfers synchronously.

> +=09=09goto stopped;
> +
> +=09rcar_drif_deliver_buf(ch);
> +stopped:
> +=09mutex_unlock(&sdr->vb_queue_mutex);
> +}
> +
> +static int rcar_drif_qbuf(struct rcar_drif *ch)
> +{
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +=09dma_addr_t addr =3D ch->dma_handle;
> +=09struct dma_async_tx_descriptor *rxd;
> +=09dma_cookie_t cookie;
> +=09int ret =3D -EIO;
> +
> +=09/* Setup cyclic DMA with given buffers */
> +=09rxd =3D dmaengine_prep_dma_cyclic(ch->dmach, addr,
> +=09=09=09=09=09sdr->hwbuf_size * num_hwbufs,
> +=09=09=09=09=09sdr->hwbuf_size, DMA_DEV_TO_MEM,
> +=09=09=09=09=09DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +=09if (!rxd) {
> +=09=09rdrif_err(sdr, "ch%u: prep dma cyclic failed\n", ch->num);
> +=09=09return ret;
> +=09}
> +
> +=09/* Submit descriptor */
> +=09rxd->callback =3D rcar_drif_dma_complete;
> +=09rxd->callback_param =3D ch;
> +=09cookie =3D dmaengine_submit(rxd);
> +=09if (dma_submit_error(cookie)) {
> +=09=09rdrif_err(sdr, "ch%u: dma submit failed\n", ch->num);
> +=09=09return ret;
> +=09}
> +
> +=09dma_async_issue_pending(ch->dmach);
> +=09return 0;
> +}
> +
> +/* Enable reception */
> +static int rcar_drif_enable_rx(struct rcar_drif_sdr *sdr)
> +{
> +=09unsigned int i;
> +=09u32 ctr;
> +=09int ret;
> +
> +=09/*
> +=09 * When both internal channels are enabled, they can be synchroni=
zed
> +=09 * only by the master
> +=09 */
> +
> +=09/* Enable receive */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ctr =3D readl(sdr->ch[i]->base + RCAR_DRIF_SICTR);
> +=09=09ctr |=3D (RCAR_DRIF_SICTR_RX_RISING_EDGE |
> +=09=09=09 RCAR_DRIF_SICTR_RX_EN);
> +=09=09writel(ctr, sdr->ch[i]->base + RCAR_DRIF_SICTR);
> +=09}
> +
> +=09/* Check receive enabled */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ret =3D readl_poll_timeout(sdr->ch[i]->base + RCAR_DRIF_SICTR,=

> +=09=09=09=09=09 ctr, ctr & RCAR_DRIF_SICTR_RX_EN,
> +=09=09=09=09=09 2, 500000);

A 2=B5s sleep for a 500ms total timeout seems very low to me, that will=
 stress=20
the CPU. Same comment for the other locations where you use=20
readl_poll_timeout.

How long does the channel typically take to get enabled ?

> +=09=09if (ret) {
> +=09=09=09rdrif_err(sdr, "ch%u: rx en failed. ctr 0x%08x\n",
> +=09=09=09=09  i, readl(sdr->ch[i]->base +=20
RCAR_DRIF_SICTR));
> +=09=09=09break;
> +=09=09}
> +=09}
> +=09return ret;
> +}
> +
> +/* Disable reception */
> +static void rcar_drif_disable_rx(struct rcar_drif_sdr *sdr)
> +{
> +=09unsigned int i;
> +=09u32 ctr;
> +=09int ret;
> +
> +=09/* Disable receive */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ctr =3D readl(sdr->ch[i]->base + RCAR_DRIF_SICTR);
> +=09=09ctr &=3D ~RCAR_DRIF_SICTR_RX_EN;
> +=09=09writel(ctr, sdr->ch[i]->base + RCAR_DRIF_SICTR);
> +=09}
> +
> +=09/* Check receive disabled */
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ret =3D readl_poll_timeout(sdr->ch[i]->base + RCAR_DRIF_SICTR,=

> +=09=09=09=09=09 ctr, !(ctr & RCAR_DRIF_SICTR_RX_EN),
> +=09=09=09=09=09 2, 500000);

How long does the channel typically take to get disabled ?

> +=09=09if (ret)
> +=09=09=09dev_warn(&sdr->vdev->dev,
> +=09=09=09"ch%u: failed to disable rx. ctr 0x%08x\n",
> +=09=09=09i, readl(sdr->ch[i]->base + RCAR_DRIF_SICTR));
> +=09}
> +}
> +
> +/* Start channel */
> +static int rcar_drif_start_channel(struct rcar_drif *ch)
> +{
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +=09u32 ctr, str;
> +=09int ret;
> +
> +=09/* Reset receive */
> +=09writel(RCAR_DRIF_SICTR_RESET, ch->base + RCAR_DRIF_SICTR);
> +=09ret =3D readl_poll_timeout(ch->base + RCAR_DRIF_SICTR,
> +=09=09=09=09=09 ctr, !(ctr & RCAR_DRIF_SICTR_RESET),

The alignment is weird.

> +=09=09=09=09=09 2, 500000);
> +=09if (ret) {
> +=09=09rdrif_err(sdr, "ch%u: failed to reset rx. ctr 0x%08x\n",
> +=09=09=09  ch->num, readl(ch->base + RCAR_DRIF_SICTR));
> +=09=09return ret;
> +=09}
> +
> +=09/* Queue buffers for DMA */
> +=09ret =3D rcar_drif_qbuf(ch);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09/* Clear status register flags */
> +=09str =3D RCAR_DRIF_RFFUL | RCAR_DRIF_REOF | RCAR_DRIF_RFSERR |
> +=09=09RCAR_DRIF_RFUDF | RCAR_DRIF_RFOVF;
> +=09writel(str, ch->base + RCAR_DRIF_SISTR);
> +
> +=09/* Enable DMA receive interrupt */
> +=09writel(0x00009000, ch->base + RCAR_DRIF_SIIER);
> +
> +=09return ret;
> +}
> +
> +/* Start receive operation */
> +static int rcar_drif_start(struct rcar_drif_sdr *sdr)
> +{
> +=09unsigned int i;
> +=09int ret;
> +
> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ret =3D rcar_drif_start_channel(sdr->ch[i]);
> +=09=09if (ret)
> +=09=09=09goto start_error;
> +=09}
> +
> +=09sdr->produced =3D 0;
> +=09ret =3D rcar_drif_enable_rx(sdr);
> +start_error:

Don't you need to stop the channels that were successfully started if a=
n error=20
occurs ?

> +=09return ret;
> +}
> +
> +/* Stop channel */
> +static void rcar_drif_stop_channel(struct rcar_drif *ch)
> +{
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +=09int ret, retries =3D 3;
> +
> +=09/* Disable DMA receive interrupt */
> +=09writel(0x00000000, ch->base + RCAR_DRIF_SIIER);
> +
> +=09do {
> +=09=09/* Terminate all DMA transfers */
> +=09=09ret =3D dmaengine_terminate_sync(ch->dmach);
> +=09=09if (!ret)
> +=09=09=09break;
> +=09=09rdrif_dbg(2, sdr, "stop retry\n");
> +=09} while (--retries);

Why do you need to retry the terminate operation, why does it fail ?

> +=09WARN_ON(!retries);
> +}

[snip]

> +/* Start streaming */
> +static int rcar_drif_start_streaming(struct vb2_queue *vq, unsigned =
int
> count)
> +{
> +=09struct rcar_drif_sdr *sdr =3D vb2_get_drv_priv(vq);
> +=09unsigned int i, j;
> +=09int ret;
> +
> +=09mutex_lock(&sdr->v4l2_mutex);

I'm surprised, aren't the start_streaming and stop_streaming operations=
 called=20
with the video device lock held already by the v4l2-ioctl layer ? I thi=
nk they=20
should be, if they're not there's probably a bug somewhere.

> +=09for_each_rcar_drif_channel(i, &sdr->cur_ch_mask) {
> +=09=09ret =3D clk_prepare_enable(sdr->ch[i]->clkp);
> +=09=09if (ret)
> +=09=09=09goto start_error;
> +=09}
> +
> +=09/* Set default MDRx settings */
> +=09rcar_drif_set_mdr1(sdr);
> +
> +=09/* Set new format */
> +=09ret =3D rcar_drif_set_format(sdr);
> +=09if (ret)
> +=09=09goto start_error;
> +
> +=09if (sdr->num_cur_ch =3D=3D RCAR_DRIF_MAX_CHANNEL)
> +=09=09sdr->hwbuf_size =3D
> +=09=09formats[sdr->fmt_idx].buffersize / RCAR_DRIF_MAX_CHANNEL;
> +=09else
> +=09=09sdr->hwbuf_size =3D formats[sdr->fmt_idx].buffersize;
> +
> +=09rdrif_dbg(1, sdr, "num_hwbufs %u, hwbuf_size %u\n",
> +=09=09num_hwbufs, sdr->hwbuf_size);
> +
> +=09/* Alloc DMA channel */
> +=09ret =3D rcar_drif_alloc_dmachannel(sdr);
> +=09if (ret)
> +=09=09goto start_error;
> +
> +=09/* Alloc buf context */
> +=09ret =3D rcar_drif_alloc_bufctxt(sdr);
> +=09if (ret)
> +=09=09goto start_error;
> +
> +=09/* Request buffers */
> +=09ret =3D rcar_drif_request_buf(sdr);
> +=09if (ret)
> +=09=09goto start_error;
> +
> +=09/* Start Rx */
> +=09ret =3D rcar_drif_start(sdr);
> +=09if (ret)
> +=09=09goto start_error;
> +
> +=09mutex_unlock(&sdr->v4l2_mutex);
> +=09rdrif_dbg(1, sdr, "started\n");
> +=09return ret;
> +
> +start_error:

As there's a single error label I would call this "error". Up to you.

> +=09rcar_drif_release_queued_bufs(sdr, VB2_BUF_STATE_QUEUED);
> +=09rcar_drif_release_buf(sdr);
> +=09rcar_drif_release_bufctxt(sdr);
> +=09rcar_drif_release_dmachannel(sdr);
> +=09for (j =3D 0; j < i; j++)
> +=09=09clk_disable_unprepare(sdr->ch[j]->clkp);
> +
> +=09mutex_unlock(&sdr->v4l2_mutex);
> +=09return ret;
> +}

[snip]

> +/* Vb2 ops */
> +static struct vb2_ops rcar_drif_vb2_ops =3D {

You can make this static const.

> +=09.queue_setup            =3D rcar_drif_queue_setup,
> +=09.buf_queue              =3D rcar_drif_buf_queue,
> +=09.start_streaming        =3D rcar_drif_start_streaming,
> +=09.stop_streaming         =3D rcar_drif_stop_streaming,
> +=09.wait_prepare=09=09=3D vb2_ops_wait_prepare,
> +=09.wait_finish=09=09=3D vb2_ops_wait_finish,
> +};

[snip]

> +static int rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,
> +=09=09=09=09   struct v4l2_format *f)
> +{
> +=09struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> +
> +=09f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> +=09f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;
> +=09memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));

I believe the core ioctl handling code already does this for you. Same =
for the=20
other ioctl handlers in=20

> +=09return 0;
> +}
> +
> +static int rcar_drif_s_fmt_sdr_cap(struct file *file, void *priv,
> +=09=09=09=09   struct v4l2_format *f)
> +{
> +=09struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> +=09struct vb2_queue *q =3D &sdr->vb_queue;
> +=09unsigned int i;
> +
> +=09if (vb2_is_busy(q))
> +=09=09return -EBUSY;
> +
> +=09memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> +=09for (i =3D 0; i < NUM_FORMATS; i++) {
> +=09=09if (formats[i].pixelformat =3D=3D f->fmt.sdr.pixelformat) {

The code would become more readable (at least in my opinion) if you jus=
t added=20
a break here, and moved the code below after the loop. In case the requ=
ested=20
format isn't found (i =3D=3D NUM_FORMATS) you can then set i to 0 and p=
roceed,=20
that will select the first available format as a default.

> +=09=09=09sdr->fmt_idx  =3D i;
> +=09=09=09f->fmt.sdr.buffersize =3D formats[i].buffersize;
> +
> +=09=09=09/*
> +=09=09=09 * If a format demands one channel only out of two
> +=09=09=09 * enabled channels, pick the 0th channel.
> +=09=09=09 */
> +=09=09=09if (formats[i].num_ch < sdr->num_hw_ch) {
> +=09=09=09=09sdr->cur_ch_mask =3D BIT(0);
> +=09=09=09=09sdr->num_cur_ch =3D formats[i].num_ch;
> +=09=09=09} else {
> +=09=09=09=09sdr->cur_ch_mask =3D sdr->hw_ch_mask;
> +=09=09=09=09sdr->num_cur_ch =3D sdr->num_hw_ch;
> +=09=09=09}
> +
> +=09=09=09rdrif_dbg(1, sdr, "cur: idx %u mask %lu num %u\n",
> +=09=09=09=09  i, sdr->cur_ch_mask, sdr->num_cur_ch);
> +=09=09=09return 0;
> +=09=09}
> +=09}
> +
> +=09if (rcar_drif_set_default_format(sdr)) {
> +=09=09rdrif_err(sdr, "cannot set default format\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> +=09f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;
> +=09return 0;
> +}
> +
> +static int rcar_drif_try_fmt_sdr_cap(struct file *file, void *priv,
> +=09=09=09=09     struct v4l2_format *f)
> +{
> +=09struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> +=09unsigned int i;
> +
> +=09memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
> +=09for (i =3D 0; i < NUM_FORMATS; i++) {
> +=09=09if (formats[i].pixelformat =3D=3D f->fmt.sdr.pixelformat) {
> +=09=09=09f->fmt.sdr.buffersize =3D formats[i].buffersize;
> +=09=09=09return 0;
> +=09=09}
> +=09}
> +
> +=09f->fmt.sdr.pixelformat =3D formats[sdr->fmt_idx].pixelformat;
> +=09f->fmt.sdr.buffersize =3D formats[sdr->fmt_idx].buffersize;

The result of the TRY_FMT ioctl should not depend on the currently conf=
igured=20
format. I would return a fixed format (for instance the first one in th=
e=20
formats array) in the default case.

> +=09return 0;
> +}
> +
> +/* Tuner subdev ioctls */
> +static int rcar_drif_enum_freq_bands(struct file *file, void *priv,
> +=09=09=09=09     struct v4l2_frequency_band *band)
> +{
> +=09struct rcar_drif_sdr *sdr =3D video_drvdata(file);
> +=09struct v4l2_subdev *sd;
> +=09int ret =3D 0;
> +
> +=09v4l2_device_for_each_subdev(sd, &sdr->v4l2_dev) {
> +=09=09ret =3D v4l2_subdev_call(sd, tuner, enum_freq_bands, band);

This won't work as-is when you'll have multiple subdevs. As the driver =
only=20
supports a single connected subdev at the moment, I suggest storing a p=
ointer=20
to that subdev in the rcar_drif_sdr structure, and calling operations o=
n that=20
subdev explicitly instead of looping over all subdevs. The comment hold=
s for=20
all other ioctls.

> +=09=09if (ret)
> +=09=09=09break;
> +=09}
> +=09return ret;
> +}

[snip]

> +static int rcar_drif_notify_bound(struct v4l2_async_notifier *notifi=
er,
> +=09=09=09=09   struct v4l2_subdev *subdev,
> +=09=09=09=09   struct v4l2_async_subdev *asd)
> +{
> +=09struct rcar_drif_sdr *sdr =3D
> +=09=09container_of(notifier, struct rcar_drif_sdr, notifier);
> +
> +=09/* Nothing to do at this point */

If there's nothing to do you can just leave the bound callback unimplem=
ented,=20
it's optional.

> +=09rdrif_dbg(2, sdr, "bound asd: %s\n", asd->match.of.node->name);
> +=09return 0;
> +}
> +
> +/* Sub-device registered notification callback */
> +static int rcar_drif_notify_complete(struct v4l2_async_notifier *not=
ifier)
> +{
> +=09struct rcar_drif_sdr *sdr =3D
> +=09=09container_of(notifier, struct rcar_drif_sdr, notifier);
> +=09struct v4l2_subdev *sd;
> +=09int ret;
> +
> +=09sdr->v4l2_dev.ctrl_handler =3D &sdr->ctrl_hdl;
> +
> +=09ret =3D v4l2_device_register_subdev_nodes(&sdr->v4l2_dev);
> +=09if (ret) {
> +=09=09rdrif_err(sdr, "failed register subdev nodes ret %d\n", ret);
> +=09=09return ret;
> +=09}

Do you need to expose subdev nodes to userspace ? Can't everything be h=
andled=20
from the V4L2 SDR node ?

> +=09v4l2_device_for_each_subdev(sd, &sdr->v4l2_dev) {
> +=09=09ret =3D v4l2_ctrl_add_handler(sdr->v4l2_dev.ctrl_handler,
> +=09=09=09=09=09    sd->ctrl_handler, NULL);

Shouldn't you undo this somewhere when unbinding the subdevs ?

> +=09=09if (ret) {
> +=09=09=09rdrif_err(sdr, "failed ctrl add hdlr ret %d\n", ret);
> +=09=09=09return ret;
> +=09=09}
> +=09}
> +=09rdrif_dbg(2, sdr, "notify complete\n");
> +=09return 0;
> +}

[snip]

> +/* Parse sub-devs (tuner) to find a matching device */
> +static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr,
> +=09=09=09=09   struct device *dev)
> +{
> +=09struct v4l2_async_notifier *notifier =3D &sdr->notifier;
> +=09struct rcar_drif_async_subdev *rsd;
> +=09struct device_node *node;
> +
> +=09notifier->subdevs =3D devm_kzalloc(dev, sizeof(*notifier->subdevs=
),
> +=09=09=09=09=09 GFP_KERNEL);
> +=09if (!notifier->subdevs)
> +=09=09return -ENOMEM;
> +
> +=09node =3D of_graph_get_next_endpoint(dev->of_node, NULL);
> +=09if (!node)
> +=09=09return 0;
> +
> +=09rsd =3D devm_kzalloc(dev, sizeof(*rsd), GFP_KERNEL);
> +=09if (!rsd) {
> +=09=09of_node_put(node);

If you move the allocation above of_graph_get_next_endpoint() you won't=
 have=20
to call of_node_put() in the error path.

> +=09=09return -ENOMEM;
> +=09}
> +
> +=09notifier->subdevs[notifier->num_subdevs] =3D &rsd->asd;
> +=09rsd->asd.match.of.node =3D of_graph_get_remote_port_parent(node);=


Aren't you missing an of_node_put() on the returned node ? Or does the =
async=20
framework take care of that ?

> +=09of_node_put(node);
> +=09if (!rsd->asd.match.of.node) {
> +=09=09dev_warn(dev, "bad remote port parent\n");
> +=09=09return -EINVAL;
> +=09}
> +
> +=09rsd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
> +=09notifier->num_subdevs++;
> +
> +=09/* Get the endpoint properties */
> +=09rcar_drif_get_ep_properties(sdr, node);
> +=09return 0;
> +}
> +
> +/* Check if the given device is the primary bond */
> +static bool rcar_drif_primary_bond(struct platform_device *pdev)
> +{
> +=09if (of_find_property(pdev->dev.of_node, "renesas,primary-bond", N=
ULL))
> +=09=09return true;
> +
> +=09return false;

How about

=09return of_property_read_bool(pdev->dev.of_node,
=09=09=09=09     "renesas,primary-bond");

> +}
> +
> +/* Get the bonded platform dev if enabled */
> +static struct platform_device *rcar_drif_enabled_bond(struct
> platform_device *p)
> +{
> +=09struct device_node *np;
> +
> +=09np =3D of_parse_phandle(p->dev.of_node, "renesas,bonding", 0);

The function takes a reference to np, you need to call of_node_put() on=
 it=20
(only if the returned pointer isn't NULL).

> +=09if (np && of_device_is_available(np))
> +=09=09return of_find_device_by_node(np);

of_find_device_by_node() takes a reference to the returned device, you =
need to=20
call device_put() on it when you don't need it anymore.


> +=09return NULL;
> +}
> +
> +/* Proble internal channel */
> +static int rcar_drif_channel_probe(struct platform_device *pdev)
> +{
> +=09struct rcar_drif *ch;
> +=09struct resource=09*res;
> +=09void __iomem *base;
> +=09struct clk *clkp;

Maybe s/clkp/clk/ ?

> +=09int ret;
> +
> +=09/* Peripheral clock */
> +=09clkp =3D devm_clk_get(&pdev->dev, "fck");
> +=09if (IS_ERR(clkp)) {
> +=09=09ret =3D PTR_ERR(clkp);
> +=09=09dev_err(&pdev->dev, "clk get failed (%d)\n", ret);
> +=09=09return ret;
> +=09}

Isn't the clock managed automatically by runtime PM ?

> +=09/* Register map */
> +=09res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +=09base =3D devm_ioremap_resource(&pdev->dev, res);
> +=09if (IS_ERR(base)) {
> +=09=09ret =3D PTR_ERR(base);
> +=09=09dev_err(&pdev->dev, "ioremap failed (%d)\n", ret);
> +=09=09return ret;

devm_ioremap_resource() already prints an error message, you can remove=
 this=20
one.

> +=09}
> +
> +=09/* Reserve memory for enabled channel */
> +=09ch =3D devm_kzalloc(&pdev->dev, sizeof(*ch), GFP_KERNEL);
> +=09if (!ch) {
> +=09=09ret =3D PTR_ERR(ch);
> +=09=09dev_err(&pdev->dev, "failed alloc channel\n");

Memory allocation failures already print error messages, you can remove=
 this=20
one.

> +=09=09return ret;
> +=09}
> +=09ch->pdev =3D pdev;
> +=09ch->clkp =3D clkp;
> +=09ch->base =3D base;
> +=09ch->start =3D res->start;

If you allocated the ch structure first you could set the fields direct=
ly=20
without a need for local variables.

> +=09platform_set_drvdata(pdev, ch);
> +=09return 0;
> +}
> +
> +static int rcar_drif_probe(struct platform_device *pdev)
> +{
> +=09struct rcar_drif *ch, *b_ch =3D NULL;
> +=09struct platform_device *b_pdev;
> +=09struct rcar_drif_sdr *sdr;
> +=09int ret;
> +
> +=09/* Probe internal channel */
> +=09ret =3D rcar_drif_channel_probe(pdev);
> +=09if (ret)
> +=09=09return ret;

I would have done it the other way around, inlining the=20
rcar_drif_channel_probe() function here as that's the common case, and =
moving=20
the V4L2 SDR device initialization code to a different function.

> +=09/* Check if both channels of the bond are enabled */
> +=09b_pdev =3D rcar_drif_enabled_bond(pdev);
> +=09if (b_pdev) {
> +=09=09/* Check if current channel acting as primary-bond */
> +=09=09if (!rcar_drif_primary_bond(pdev)) {
> +=09=09=09dev_notice(&pdev->dev, "probed\n");
> +=09=09=09return 0;
> +=09=09}
> +
> +=09=09/* Check if the other device is probed */
> +=09=09b_ch =3D platform_get_drvdata(b_pdev);
> +=09=09if (!b_ch) {
> +=09=09=09dev_info(&pdev->dev, "defer probe\n");
> +=09=09=09return -EPROBE_DEFER;
> +=09=09}

Isn't this all very racy ? What if the other channel's device is remove=
d while=20
this one is probed ?

> +=09=09/* Set the other channel number */
> +=09=09b_ch->num =3D 1;

Reading data from the other channel's private structure is one thing, b=
ut=20
writing it makes me shiver :-S Could we make it so that 0 is the slave =
and 1=20
the master ? That way you would set ch->num =3D 1 instead of b_ch->num =
=3D 1,=20
keeping all modifications to the private structure local to the device =
being=20
probed.

> +=09}
> +
> +=09/* Channel acting as SDR instance */
> +=09ch =3D platform_get_drvdata(pdev);
> +=09ch->acting_sdr =3D true;
> +
> +=09/* Reserve memory for SDR structure */
> +=09sdr =3D devm_kzalloc(&pdev->dev, sizeof(*sdr), GFP_KERNEL);
> +=09if (!sdr) {
> +=09=09ret =3D PTR_ERR(sdr);
> +=09=09dev_err(&pdev->dev, "failed alloc drif context\n");
> +=09=09return ret;
> +=09}
> +=09sdr->dev =3D &pdev->dev;
> +=09sdr->hw_ch_mask =3D BIT(ch->num);
> +
> +=09/* Establish links between SDR and channel(s) */
> +=09ch->sdr =3D sdr;
> +=09sdr->ch[ch->num] =3D ch;
> +=09if (b_ch) {
> +=09=09sdr->ch[b_ch->num] =3D b_ch;
> +=09=09b_ch->sdr =3D sdr;
> +=09=09sdr->hw_ch_mask |=3D BIT(b_ch->num);
> +=09}
> +=09sdr->num_hw_ch =3D hweight_long(sdr->hw_ch_mask);
> +
> +=09/* Validate any supported format for enabled channels */
> +=09ret =3D rcar_drif_set_default_format(sdr);
> +=09if (ret) {
> +=09=09dev_err(sdr->dev, "failed to set default format\n");
> +=09=09return ret;
> +=09}
> +
> +=09/* Set defaults */
> +=09sdr->hwbuf_size =3D RCAR_DRIF_DEFAULT_HWBUF_SIZE;
> +
> +=09mutex_init(&sdr->v4l2_mutex);
> +=09mutex_init(&sdr->vb_queue_mutex);
> +=09spin_lock_init(&sdr->queued_bufs_lock);
> +=09INIT_LIST_HEAD(&sdr->queued_bufs);
> +
> +=09/* Init videobuf2 queue structure */
> +=09sdr->vb_queue.type =3D V4L2_BUF_TYPE_SDR_CAPTURE;
> +=09sdr->vb_queue.io_modes =3D VB2_READ | VB2_MMAP | VB2_DMABUF;
> +=09sdr->vb_queue.drv_priv =3D sdr;
> +=09sdr->vb_queue.buf_struct_size =3D sizeof(struct rcar_drif_frame_b=
uf);
> +=09sdr->vb_queue.ops =3D &rcar_drif_vb2_ops;
> +=09sdr->vb_queue.mem_ops =3D &vb2_vmalloc_memops;
> +=09sdr->vb_queue.timestamp_flags =3D V4L2_BUF_FLAG_TIMESTAMP_MONOTON=
IC;
> +
> +=09/* Init videobuf2 queue */
> +=09ret =3D vb2_queue_init(&sdr->vb_queue);
> +=09if (ret) {
> +=09=09dev_err(sdr->dev, "could not initialize vb2 queue\n");
> +=09=09return ret;
> +=09}
> +
> +=09/* Register the v4l2_device */
> +=09ret =3D v4l2_device_register(&pdev->dev, &sdr->v4l2_dev);
> +=09if (ret) {
> +=09=09dev_err(sdr->dev, "failed v4l2_device_register (%d)\n", ret);

Maybe "failed to register V4L2 device" to make it a real sentence ? :-)=


> +=09=09return ret;
> +=09}
> +
> +=09/*
> +=09 * Parse subdevs after v4l2_device_register because if the subdev=

> +=09 * is already probed, bound and complete will be called immediate=
ly
> +=09 */
> +=09ret =3D rcar_drif_parse_subdevs(sdr, &pdev->dev);
> +=09if (ret)
> +=09=09goto err_unreg_v4l2;
> +
> +=09sdr->notifier.bound =3D rcar_drif_notify_bound;
> +=09sdr->notifier.complete =3D rcar_drif_notify_complete;
> +
> +=09v4l2_ctrl_handler_init(&sdr->ctrl_hdl, 10);

Possibly a stupid question, why 10, if you don't create any control in =
this=20
driver ?

> +=09/* Register notifier */
> +=09ret =3D v4l2_async_notifier_register(&sdr->v4l2_dev, &sdr->notifi=
er);
> +=09if (ret < 0) {
> +=09=09dev_err(sdr->dev, "notifier registration failed (%d)\n", ret);=

> +=09=09goto err_free_ctrls;
> +=09}
> +
> +=09/* Init video_device structure */
> +=09sdr->vdev =3D video_device_alloc();
> +=09if (!sdr->vdev) {
> +=09=09ret =3D -ENOMEM;
> +=09=09goto err_unreg_notif;
> +=09}
> +=09snprintf(sdr->vdev->name, sizeof(sdr->vdev->name), "R-Car DRIF");=

> +=09sdr->vdev->fops =3D &rcar_drif_fops;
> +=09sdr->vdev->ioctl_ops =3D &rcar_drif_ioctl_ops;
> +=09sdr->vdev->release =3D video_device_release;
> +=09sdr->vdev->lock =3D &sdr->v4l2_mutex;
> +=09sdr->vdev->queue =3D &sdr->vb_queue;
> +=09sdr->vdev->queue->lock =3D &sdr->vb_queue_mutex;
> +=09sdr->vdev->ctrl_handler =3D &sdr->ctrl_hdl;
> +=09sdr->vdev->v4l2_dev =3D &sdr->v4l2_dev;
> +=09sdr->vdev->device_caps =3D V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER =
|
> +=09=09V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> +=09video_set_drvdata(sdr->vdev, sdr);
> +
> +=09/* Register V4L2 SDR device */
> +=09ret =3D video_register_device(sdr->vdev, VFL_TYPE_SDR, -1);
> +=09if (ret) {
> +=09=09dev_err(sdr->dev, "failed video_register_device (%d)\n", ret);=


Same here, "failed to register video device" ?

> +=09=09goto err_unreg_notif;
> +=09}
> +
> +=09dev_notice(sdr->dev, "probed\n");

Do you think this message is really useful ? I believe it would just ad=
d a bit=20
more noise to the kernel log, without any real use.

> +=09return 0;
> +
> +err_unreg_notif:
> +=09video_device_release(sdr->vdev);
> +=09v4l2_async_notifier_unregister(&sdr->notifier);
> +err_free_ctrls:
> +=09v4l2_ctrl_handler_free(&sdr->ctrl_hdl);
> +err_unreg_v4l2:
> +=09v4l2_device_unregister(&sdr->v4l2_dev);
> +=09return ret;
> +}
> +
> +static int rcar_drif_remove(struct platform_device *pdev)
> +{
> +=09struct rcar_drif *ch =3D platform_get_drvdata(pdev);
> +=09struct rcar_drif_sdr *sdr =3D ch->sdr;
> +
> +=09if (!ch->acting_sdr) {

Isn't it possible to check the channel number instead and remove the=20=

acting_sdr field ?

> +=09=09/* Nothing to do */
> +=09=09dev_notice(&pdev->dev, "removed\n");
> +=09=09return 0;
> +=09}
> +
> +=09/* SDR instance */
> +=09v4l2_ctrl_handler_free(sdr->vdev->ctrl_handler);
> +=09v4l2_async_notifier_unregister(&sdr->notifier);
> +=09v4l2_device_unregister(&sdr->v4l2_dev);
> +=09video_unregister_device(sdr->vdev);
> +=09dev_notice(&pdev->dev, "removed\n");

Even more than the probed message, I think this one can go away.

> +=09return 0;
> +}
> +
> +static int __maybe_unused rcar_drif_suspend(struct device *dev)
> +{
> +=09return 0;

Maybe a /* FIXME: Implement suspend/resume support */ ?

> +}
> +
> +static int __maybe_unused rcar_drif_resume(struct device *dev)
> +{
> +=09return 0;

Same here ?

> +}

[snip]

--=20
Regards,

Laurent Pinchart
