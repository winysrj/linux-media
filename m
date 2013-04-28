Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35599 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3D1TAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 15:00:54 -0400
Received: by mail-la0-f54.google.com with SMTP id fm20so480923lab.27
        for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 12:00:52 -0700 (PDT)
Message-ID: <517D7195.1020301@cogentembedded.com>
Date: Sun, 28 Apr 2013 22:59:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: mchehab@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v2 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
References: <201304200231.31802.sergei.shtylyov@cogentembedded.com> <Pine.LNX.4.64.1304201201370.10520@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1304201201370.10520@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 25-04-2013 18:20, Guennadi Liakhovetski wrote:

> Hi Sergei

> Thanks for the patch.

    It's a collective work, my role has been the least one, mostly a reviewer. :-)

>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>> Add Renesas R-Car VIN (Video In) V4L2 driver.

>> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.

>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> [Sergei: removed deprecated IRQF_DISABLED flag.]
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

>> Index: renesas/drivers/media/platform/soc_camera/rcar_vin.c
>> ===================================================================
>> --- /dev/null
>> +++ renesas/drivers/media/platform/soc_camera/rcar_vin.c
>> @@ -0,0 +1,1784 @@
[...]
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/platform_data/camera-rcar.h>
>> +
>> +#include <media/videobuf2-dma-contig.h>
>> +#include <media/soc_camera.h>
>> +#include <media/soc_mediabus.h>

> I always suggest to sort headers alphabetically, then it is easier to
> avoid duplicates and adding new ones goes to "random" places in the list,
> instead of piling up at the bottom, reducing the chance of a merge
> conflict.

    OK, fair enough.

> I also strongly suspent some #include <media/v4l2-*.h> headers are missing
> above.

    Hm, I wonder which. I'm certainly not V4L2 expert...

[...]
>> +#define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM ? \
>> +					 true : false)

> simpler:

> +#define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)

    Yes, I should have said the same to Vladimir.

>> +
>> +struct rcar_vin_buffer {
>> +	struct vb2_buffer		vb;
>> +	struct list_head		list;
>> +};
>> +
>> +#define to_buf_list(vb2_buffer)		(&(container_of((vb2_buffer), \
>> +						struct rcar_vin_buffer, \
>> +						vb))->list)

> parenthesis around container_of() above don't make much sense. You can
> just drop them:

> +#define to_buf_list(vb2_buffer)		(&container_of((vb2_buffer), \
> +						struct rcar_vin_buffer, \
> +						vb)->list)

    OK.


>> +struct rcar_vin_cam {
[...]
>> +	enum v4l2_mbus_pixelcode	code;

> You don't use the "code" field.

    Will remove, thanks.

>> +/*
>> + * .queue_setup() is called to check whether the driver can accept the
>> + *		  requested number of buffers and to fill in plane sizes
>> + *		  for the current frame format if required
>> + */
>> +static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
>> +				   const struct v4l2_format *fmt,
>> +				   unsigned int *count,
>> +				   unsigned int *num_planes,
>> +				   unsigned int sizes[], void *alloc_ctxs[])
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	s32 bytes_per_line;
>> +	unsigned int height;
>> +
>> +	if (fmt) {
>> +		const struct soc_camera_format_xlate *xlate;
>> +
>> +		xlate = soc_camera_xlate_by_fourcc(icd,
>> +						   fmt->fmt.pix.pixelformat);
>> +		if (!xlate)
>> +			return -EINVAL;
>> +		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
>> +							 xlate->host_fmt);
>> +		height = fmt->fmt.pix.height;
>> +	} else {
>> +		/* Called from VIDIOC_REQBUFS or in compatibility mode */
>> +		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						icd->current_fmt->host_fmt);
>> +		height = icd->user_height;

> In this case icd->sizeimage already contains the correct value.

>> +	}
>> +	if (bytes_per_line < 0)
>> +		return bytes_per_line;
>> +
>> +	sizes[0] = bytes_per_line * height;

> This isn't right for planar formats, like NV16. Please, use
> soc_mbus_image_size(). See the CEU driver for an example.

    OK, will look...

>> +	alloc_ctxs[0] = priv->alloc_ctx;
>> +
>> +	if (!vq->num_buffers)
>> +		priv->sequence = 0;
>> +
>> +	if (!*count)
>> +		*count = 2;
>> +	priv->vb_count = *count;
>> +
>> +	*num_planes = 1;
>> +
>> +	/* Number of hardware slots */
>> +	if (priv->vb_count > MAX_BUFFER_NUM)
>> +		priv->nr_hw_slots = MAX_BUFFER_NUM;
>> +	else
>> +		priv->nr_hw_slots = 1;

> Is this really correct: with up to 3 buffers only one HW slot is used?

    Probably not.

>> +static void rcar_vin_setup(struct rcar_vin_priv *priv)
>> +{
>> +	struct soc_camera_device *icd = priv->icd;
>> +	struct rcar_vin_cam *cam = icd->host_priv;
>> +	u32 vnmc, dmr, interrupts;
>> +	int progressive = 0, input_is_yuv = 0, output_is_yuv = 0;

> All these variables can be bool.

    OK.

>> +	switch (priv->field) {
[...]
>> +	case V4L2_FIELD_NONE:
>> +		if (is_continuous_transfer(priv)) {
>> +			vnmc = VNMC_IM_ODD_EVEN;
>> +			progressive = 1;
>> +		} else
>> +			vnmc = VNMC_IM_ODD;

> Doesn't checkpatch.pl produce a warning / error for missing braces above?
> If it doesn't I won't either :-)

    No, it doesn't. But it's certainly a CodingStyle violation which I should 
have noticed...

>> +		break;
>> +	default:
>> +		vnmc = VNMC_IM_ODD;
>> +		break;
>> +	}
>> +
>> +	/* input interface */
>> +	switch (icd->current_fmt->code) {
>> +	case V4L2_MBUS_FMT_YUYV8_1X16:
>> +		/* BT.601/BT.1358 16bit YCbCr422 */
>> +		vnmc |= VNMC_INF_YUV16;
>> +		input_is_yuv = 1;
>> +		break;
>> +	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +		input_is_yuv = 1;
>> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
>> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
>> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;

> Let's clarify this. By BT.656 you mean embedded synchronisation patterns,
> right? In that case HSYNC and VSYNC signals aren't used.

    Probably so, at least I know for sure HSYNC/VSYNC aren't used.

> But in your
> .set_bus_param() method you only support V4L2_MBUS_PARALLEL and not
> V4L2_MBUS_BT656. And what do you call BT601? A bus with sync signals used?

    Yeah, judging from the manual, HSYNC, VSYNC, FIELD are used in BT.601.

[...]
>> +	/* output format */
>> +	switch (icd->current_fmt->host_fmt->fourcc) {
>> +	case V4L2_PIX_FMT_NV16:
>> +		iowrite32(((cam->width * cam->height) + 0x7f) & ~0x7f,
>> +			  priv->base + VNUVAOF_REG);

> Superfluous parenthesis around multiplication.

    OK, will remove.

[...]
>> +	default:
>> +		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
>> +			 icd->current_fmt->host_fmt->fourcc);
>> +		dmr = ioread32(priv->base + VNDMR_REG);
>> +		vnmc = ioread32(priv->base + VNMC_REG);

> Strange, you cannot actually get here - the driver doesn't support
> pass-through, still, you issue a warning but attempt to continue?

    Well, the driver seems to try to support pass-thru, however it shouldn't
as it's only supported on R-Car E1 IIRC.

[...]
>> +static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	unsigned long size;
>> +	unsigned long flags;
>> +	int bytes_per_line;
>> +
>> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>> +						 icd->current_fmt->host_fmt);
>> +	if (bytes_per_line < 0)
>> +		goto error;
>> +
>> +	size = icd->user_height * bytes_per_line;

> Again - this multiplication isn't good enough.

    OK.

>> +
>> +	if (vb2_plane_size(vb, 0) < size) {
>> +		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
>> +			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
>> +		goto error;
>> +	}
>> +
>> +	vb2_set_plane_payload(vb, 0, size);
>> +
>> +	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
>> +		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>> +
>> +	spin_lock_irqsave(&priv->lock, flags);

> Saving IRQ flags doesn't hurt, but I don't think this function can be
> called with interrupts disabled.

    OK, maybe we'll change to spin_lock_irq()...

[...]
>> +static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>> +{
>> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	unsigned int i;
>> +	unsigned long flags;
>> +	int buf_in_use = 0;
>> +
>> +	spin_lock_irqsave(&priv->lock, flags);

> Ditto

    OK...

[...]
>> +	if (buf_in_use) {
>> +		while (priv->state != STOPPED) {
>> +
>> +			/* issue stop if running */
>> +			if (priv->state == RUNNING)
>> +				rcar_vin_request_capture_stop(priv);
>> +
>> +			/* wait until capturing has been stopped */
>> +			if (priv->state == STOPPING) {
>> +				priv->request_to_stop = true;
>> +				spin_unlock_irqrestore(&priv->lock, flags);
>> +				wait_for_completion(&priv->capture_stop);
>> +				spin_lock_irqsave(&priv->lock, flags);
>> +			}
>> +		}
>> +		/*
>> +		 * Capturing has now stopped. The buffer we have been asked
>> +		 * to release could be any of the current buffers in use, so
>> +		 * release all buffers that are in use by HW
>> +		 */
>> +		for (i = 0; i < MAX_BUFFER_NUM; i++) {
>> +			if (priv->queue_buf[i]) {
>> +				vb2_buffer_done(priv->queue_buf[i],
>> +					VB2_BUF_STATE_ERROR);
>> +				priv->queue_buf[i] = NULL;
>> +			}
>> +		}
>> +	} else if (to_buf_list(vb)->next)

> Don't think ->next can ever be NULL - you initialise the list head in your
> .buf_init().

    OK, we'll remove the check.

>> +		list_del_init(to_buf_list(vb));
>> +
>> +	spin_unlock_irqrestore(&priv->lock, flags);
>> +}
>> +
>> +static int rcar_vin_videobuf_init(struct vb2_buffer *vb)
>> +{
>> +	INIT_LIST_HEAD(to_buf_list(vb));
>> +	return 0;
>> +}

[...]

>> +static void rcar_vin_remove_device(struct soc_camera_device *icd)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	struct vb2_buffer *vb;
>> +	int i;
>> +
>> +	BUG_ON(icd != priv->icd);

> We're trying to avoid any unjustified use of BUG*() macros. Please, just
> print a warning and return here.

    OK.

>> +
>> +	/* disable capture, disable interrupts */
>> +	iowrite32(ioread32(priv->base + VNMC_REG) & ~VNMC_ME,
>> +		  priv->base + VNMC_REG);
>> +	iowrite32(0, priv->base + VNIE_REG);
>> +
>> +	priv->state = STOPPED;
>> +	priv->request_to_stop = false;
>> +
>> +	/* make sure active buffer is cancelled */
>> +	spin_lock_irq(&priv->lock);
>> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
>> +		vb = priv->queue_buf[i];
>> +		if (vb) {
>> +			list_del_init(to_buf_list(vb));
>> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);

> Wondering, whether it's safe to call vb2_buffer_done() with interrupts
> disabled. It calls the queue .finish() method, with a comment "sync
> buffers," which to me indicates, that that might sleep. Yes, other drivers
> do that too, so, we can keep it until it explodes...

>> +			vb = NULL;

> The last line is redundant.

    OK.

>> +		}
>> +	}
>> +	spin_unlock_irq(&priv->lock);
>> +
>> +	pm_runtime_put_sync(ici->v4l2_dev.dev);

> Do you really need the _sync version above?

    I'm not runtime PM expert, to be honest...

>> +static u16 calc_scale(unsigned int src, unsigned int *dst)
>> +{
>> +	u16 scale;
>> +
>> +	if (src == *dst)
>> +		return 0;
>> +
>> +	scale = (src * 4096 / *dst) & ~7;
>> +
>> +	while (scale > 4096 && size_dst(src, scale) < *dst)
>> +		scale -= 8;
>> +
>> +	*dst = size_dst(src, scale);
>> +
>> +	return scale;

> return value of this function is unused by the caller. Generally, your use
> of these two functions is different than on CEU, you might want to get rid
> of them completely.

    OK, we'll see what we can do about this...

>> +}
>> +
>> +/* rect is guaranteed to not exceed the scaled camera rectangle */
>> +static int rcar_vin_set_rect(struct soc_camera_device *icd)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_cam *cam = icd->host_priv;
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	unsigned int left_offset, top_offset;
>> +	unsigned char dsize;
>> +	struct v4l2_rect *cam_subrect = &cam->subrect;
>> +
>> +	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
>> +		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
>> +
>> +	left_offset = cam->vin_left;
>> +	top_offset = cam->vin_top;
>> +
>> +	dsize = priv->data_through ? true : false;

> dsize is used below as a shift, so, it cannot be boolean (besides it is
> declared "unsigned char" above).

    Yes, I should have looked closer at this code...

> data_through is set only for RGB32. Do
> you really need the field, cannot you just check for that single format?

    I'm afraid this field is only valid for R-Car E1 SoC whcih we don't really 
support yet...

>> +	/* Set Start/End Pixel/Line Pre-Clip */
>> +	iowrite32(left_offset << dsize, priv->base + VNSPPRC_REG);
>> +	iowrite32((left_offset + cam->width - 1) << dsize,
>> +		  priv->base + VNEPPRC_REG);

> Do you have to shift for all 32-bit formats, not only for RGB32? I
> understand this is related to the fact, that you don't support
> pass-through...

    At least the manual says to program an even number to VnSPPrC...

[...]
>> +	/* Set Start/End Pixel/Line Post-Clip */
>> +	iowrite32(0, priv->base + VNSPPOC_REG);
>> +	iowrite32(0, priv->base + VNSLPOC_REG);
>> +	iowrite32((cam_subrect->width - 1) << dsize, priv->base + VNEPPOC_REG);

> ditto

    Let's defer it to Vladimir, hopefully he'll be able to reply next week...

[...]
>> +	iowrite32((cam->width + 0xf) & ~0xf, priv->base + VNIS_REG);

> ALIGN(cam->width, 0x10)

    OK.

>> +static void capture_stop_preserve(struct rcar_vin_priv *priv, u32 *vnmc)
>> +{
>> +	*vnmc = ioread32(priv->base + VNMC_REG);
>> +	/* module disable */
>> +	iowrite32(*vnmc & ~VNMC_ME, priv->base + VNMC_REG);
>> +}
>> +
>> +static void capture_restore(struct rcar_vin_priv *priv, u32 vnmc)
>> +{
>> +	unsigned long timeout = jiffies + 10 * HZ;
>> +
>> +	if (!(vnmc & ~VNMC_ME))
>> +		/* Nothing to restore */
>> +		return;

> And you don't have to wait for a frame end?

    If the module wasn't active, there's probably no point... however, let's
defer it to Vladimir.

>> +	/*
>> +	 * Wait until the end of the current frame. It can take a long time,
>> +	 * but if it has been aborted by a MRST1 reset, it should exit sooner.
>> +	 */
>> +	while ((ioread32(priv->base + VNMS_REG) & VNMS_AV) &&
>> +		time_before(jiffies, timeout))
>> +		msleep(1);
>> +
>> +	if (time_after(jiffies, timeout)) {
>> +		dev_err(priv->ici.v4l2_dev.dev,
>> +			"Timeout waiting for frame end! Interface problem?\n");
>> +		return;
>> +	}
>> +
>> +	iowrite32(vnmc, priv->base + VNMC_REG);
>> +}

[...]

>> +static int rcar_vin_try_bus_param(struct soc_camera_device *icd,
>> +				  unsigned char buswidth)
>> +{
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
>> +	int ret;
>> +
>> +	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
>> +	if (ret == -ENOIOCTLCMD)
>> +		return 0;
>> +	else if (ret)
>> +		return ret;
>> +
>> +	/* check is there common mbus flags */
>> +	ret = soc_mbus_config_compatible(&cfg, VIN_MBUS_FLAGS);
>> +	if (ret)
>> +		return 0;
>> +
>> +	dev_warn(icd->parent,
>> +		"MBUS flags incompatible: camera 0x%x, host 0x%x\n",
>> +		 cfg.flags, VIN_MBUS_FLAGS);
>> +
>> +	return -EINVAL;

> You could check the buswidth too

    OK.

>> +static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
>> +	{
>> +		.fourcc			= V4L2_PIX_FMT_NV16,
>> +		.name			= "NV16",
>> +		.bits_per_sample	= 16,
>> +		.packing		= SOC_MBUS_PACKING_NONE,
>> +		.order			= SOC_MBUS_ORDER_LE,

> Please, add an explicit .layout field to all these. Especially for planar
> formats like this one, it is important to set the .layout field correctly.

    OK.

>> +	},
>> +	{
>> +		.fourcc			= V4L2_PIX_FMT_YUYV,
>> +		.name			= "YUYV",
>> +		.bits_per_sample	= 16,
>> +		.packing		= SOC_MBUS_PACKING_NONE,
>> +		.order			= SOC_MBUS_ORDER_LE,

> This conversion block is identical to the respective one in
> soc_mediabus.c, which suggests to me, that no conversion is taking place
> here. Then this mode should be usable for generic 8- or 16-bit
> pass-through?

    Let's defer this question to Vladimir.

[...]

>> +static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>> +				struct soc_camera_format_xlate *xlate)
>> +{
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	struct device *dev = icd->parent;
>> +	int ret, k, n;
>> +	int formats = 0;
>> +	struct rcar_vin_cam *cam;
>> +	enum v4l2_mbus_pixelcode code;
>> +	const struct soc_mbus_pixelfmt *fmt;
>> +
>> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
>> +	if (ret < 0)
>> +		return 0;
>> +
>> +	fmt = soc_mbus_get_fmtdesc(code);
>> +	if (!fmt) {
>> +		dev_err(icd->parent,
>> +			"Invalid format code #%u: %d\n", idx, code);
>> +		return -EINVAL;

> return 0, just skip an unsupported code.

    OK.

[...]
>> +	switch (code) {
>> +	case V4L2_MBUS_FMT_YUYV8_1X16:
>> +	case V4L2_MBUS_FMT_YUYV8_2X8:
>> +		if (cam->extra_fmt)
>> +			break;
>> +
>> +		/* Add all our formats that can be generated by VIN */
>> +		cam->extra_fmt = rcar_vin_formats;
>> +
>> +		n = ARRAY_SIZE(rcar_vin_formats);
>> +		formats += n;
>> +		for (k = 0; xlate && k < n; k++, xlate++) {
>> +			xlate->host_fmt = &rcar_vin_formats[k];
>> +			xlate->code = code;
>> +			dev_dbg(dev, "Providing format %s using code %d\n",
>> +				rcar_vin_formats[k].name, code);
>> +		}
>> +		break;
>> +	default:
>> +		return 0;

> The above tells me, that VIN (or at least this driver) can only capture
> YUYV8 either over an 8- or a 16-bit bus. Isn't it possible to provide a
> pass-through mode?

    10/12-bit bus is also possible in UYUV format and 20/24-bit bus in 10/12 
bits (Y) + 10/12 bits (CbCr) format on R-Car H1 VIN0/1. Not all VIN interfaces 
are created equal in capabilities even within one SoC... VIN2 indeed only 
supports 8 or 16 bits, and VIN3 only supports 8-bit bus.

>> +static void rcar_vin_put_formats(struct soc_camera_device *icd)
>> +{
>> +	kfree(icd->host_priv);
>> +	icd->host_priv = NULL;
>> +}
>> +
>> +/* Check if any dimension of r1 is smaller than respective one of r2 */
>> +static bool is_smaller(struct v4l2_rect *r1, struct v4l2_rect *r2)

> cropping functions have been updated to use "const" in one of their
> arguments, please, update, or switch to using exported helper functions.

> Here begins the section, which is really identical (modulo name-changes)
> to the one in the sh-mobile-ceu-camera driver. Please, consider using
> functions, extracted by
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820

    Could you send these patches to us privately, since we're not sudbscribed 
to linux-media and the archived patches are mangled (I didn't find the way to 
get the original mail from either gmane.org or mail-archive.org)?

> instead of reimplementing. Note, that there can be some incompatibilities
> with your kernel version, since those patches are based on my latest
> snapshot, which includes clock, async, and relevant soc-camera changes.

    Hm...

[...]

>> +/* Similar to set_crop multistage iterative algorithm */
>> +static int rcar_vin_set_fmt(struct soc_camera_device *icd,
>> +			    struct v4l2_format *f)
>> +{
>> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +	struct rcar_vin_priv *priv = ici->priv;
>> +	struct rcar_vin_cam *cam = icd->host_priv;
>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>> +	struct v4l2_mbus_framefmt mf;
>> +	struct device *dev = icd->parent;
>> +	__u32 pixfmt = pix->pixelformat;
>> +	const struct soc_camera_format_xlate *xlate;
>> +	unsigned int vin_sub_width = 0, vin_sub_height = 0;
>> +	u16 scale_v, scale_h;
>> +	int ret;
>> +	bool can_scale;
>> +	bool data_through;

> What exactly does data_through mean? I thought it meant a pass-through
> mode, but it is set to true for a YUYV->RGB32 conversion, which isn't
> pass-through obviously.

    Maybe it's just bset incorrectly. As I said, data through should only be 
supported on R-Car E1 IIRC.

[...]
>> +	data_through = pixfmt == V4L2_PIX_FMT_RGB32;

> What is "data_through" and why is RGB32 so special?

    DIIK, to be honest. :-)

>> +	can_scale = !data_through && pixfmt != V4L2_PIX_FMT_NV16;

> VIN can scale _everything_ except NV16 and RGB32?

    I don't know what NV16 is, to be honest. As for RGB32, it's only the 
output format and I don't see any scaling limitation for it in the R-Car M1 
manual, at least at the first sight. Only 10/12/20/24-bit YCrCb-422 input 
formats can't be scaled.

> I would rather use a
> positive test - check, that the requested format _is_ one of those, that
> VIN can scale.

    OK, we'll look into this...

>> +	if (can_scale) {
>> +		/* Scale pix->{width x height} down to width x height */
>> +		scale_h = calc_scale(vin_sub_width, &pix->width);
>> +		scale_v = calc_scale(vin_sub_height, &pix->height);

> scales are calculated but never used. If scaling isn't supported, a few
> places can be simplified.

    OK...

[...]

>> +	cam->code = xlate->code;

    Indeed, the 'code' field seems write-only...

[...]
>> +static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>> +			    struct v4l2_format *f)
>> +{
>> +	const struct soc_camera_format_xlate *xlate;
>> +	struct v4l2_pix_format *pix = &f->fmt.pix;
>> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>> +	struct v4l2_mbus_framefmt mf;
>> +	__u32 pixfmt = pix->pixelformat;
>> +	int width, height;
>> +	int ret;
>> +
>> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
>> +	if (!xlate) {
>> +		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
>> +		return -EINVAL;

> Don't fail here, pick up a default format.

    OK.

>> +	}
>> +
>> +	/* FIXME: calculate using depth and bus width */
>> +	v4l_bound_align_image(&pix->width, 2, VIN_MAX_WIDTH, 1,
>> +			      &pix->height, 4, VIN_MAX_HEIGHT, 2, 0);
>> +
>> +	width = pix->width;
>> +	height = pix->height;
>> +
>> +	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
>> +	if ((int)pix->bytesperline < 0)
>> +		return pix->bytesperline;
>> +	pix->sizeimage = height * pix->bytesperline;

> Just set both to 0, soc_camera.c will do the default for you.

    OK...

[...]

>> +static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
>> +				   struct soc_camera_device *icd)
>> +{
>> +	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	vq->io_modes = VB2_MMAP | VB2_USERPTR;
>> +	vq->drv_priv = icd;
>> +	vq->ops = &rcar_vin_vb2_ops;
>> +	vq->mem_ops = &vb2_dma_contig_memops;
>> +	vq->buf_struct_size = sizeof(struct rcar_vin_buffer);

> Please, add

> 	vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

    OK.

[...]

>> +static int rcar_vin_probe(struct platform_device *pdev)
>> +{
[...]
>> +	pm_suspend_ignore_children(&pdev->dev, true);
>> +	pm_runtime_enable(&pdev->dev);
>> +	pm_runtime_resume(&pdev->dev);

> Maybe just a pm_runtime_enable() would be enough.

    Maybe but I'm no runtime PM expert...

[...]

    Could I ask you to please cut out the parts of the patch you're not 
replying to? Else I have to do it anyway...

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

WBR, Sergei

