Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40643 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1KRAIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 19:08:25 -0500
Received: by bke11 with SMTP id 11so2742603bke.19
        for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 16:08:24 -0800 (PST)
Message-ID: <4EC5A1F4.1050909@gmail.com>
Date: Fri, 18 Nov 2011 01:08:20 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v3][media] Exynos4 JPEG codec v4l2 driver
References: <1321522871-9222-1-git-send-email-andrzej.p@samsung.com> <4EC5410C.6050407@samsung.com>
In-Reply-To: <4EC5410C.6050407@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 11/17/2011 06:14 PM, Tomasz Stanislawski wrote:
> Hi Andrzej,
> 
> Please take a look on some comments below. You have done a great work, thanks for using selection API.
> 
> On 11/17/2011 10:41 AM, Andrzej Pietrasiewicz wrote:
>> Add driver for the JPEG codec IP block available in Samsung Exynos SoC series.
>>
>> The driver is implemented as a V4L2 mem-to-mem device. It exposes two video
>> nodes to user space, one for the encoding part, and one for the decoding part.
>>
>> Signed-off-by: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> Reviewed-by: Sakari Ailus<sakari.ailus@iki.fi>
>> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> ---
...
>> + ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
>> + if (IS_ERR_OR_NULL(ctx->m2m_ctx)) {
>> + int err = PTR_ERR(ctx->m2m_ctx);
> 
> According to condition above ctx->m2m_ctx may be NULL. After PTR_ERR it will
> be converted to 0 confusing V4L2 framework that open succeeded.

As I explained below (at other occurrences of IS_ERR_OR_NULL() macro) v4l2_m2m_ctx_init() 
returns only ERR_PTR() in case of an error. Thus the IS_ERR_OR_NULL above needs only
to be replaced with IS_ERR.

...
>> +/*
>> + * ============================================================================
>> + * video ioctl operations
>> + * ============================================================================
>> + */
>> +
>> +static int get_byte(struct s5p_jpeg_buffer *buf)
>> +{
>> + if (buf->curr>= buf->size)
> 
> space before >= is needed. Did checkpatch detect it?

I usually don't bother commenting on that sort of issues, especially before 
applying the patch and checking what the result is. And in this case the patch
is correct, it only seems not to be shown correctly by MUA.  

...
>> +static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
>> + struct s5p_jpeg_ctx *ctx, int q_type)
>> +{
>> + struct v4l2_pix_format *pix =&f->fmt.pix;
>> +
>> + if (pix->field == V4L2_FIELD_ANY)
>> + pix->field = V4L2_FIELD_NONE;
>> + else if (pix->field != V4L2_FIELD_NONE)
>> + return -EINVAL;
>> +
>> + /* V4L2 specification suggests the driver corrects the format struct
>> + * if any of the dimensions is unsupported */
>> + if (q_type == MEM2MEM_OUTPUT)
>> + jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
>> + S5P_JPEG_MAX_WIDTH, 0,
>> + &pix->height, S5P_JPEG_MIN_HEIGHT,
>> + S5P_JPEG_MAX_HEIGHT, 0);
>> + else
>> + jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
>> + S5P_JPEG_MAX_WIDTH, fmt->h_align,
>> + &pix->height, S5P_JPEG_MIN_HEIGHT,
>> + S5P_JPEG_MAX_HEIGHT, fmt->v_align);
>> +
>> + if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
>> + if (pix->sizeimage<= 0)
>> + return -EINVAL;

I guess the expected behaviour is to adjust sizeimage to some sane value,
rather than to error out. For example based on pixel width, height and 
the image quality.

>> + pix->bytesperline = 0;
>> + } else {
>> + pix->bytesperline = (pix->width * fmt->depth)>> 3;
> [as above]
>> + pix->sizeimage = pix->height * pix->bytesperline;
>> + }
>> +
>> + return 0;
>> +}
>> +
...
>> +/*
>> + * ============================================================================
>> + * mem2mem callbacks
>> + * ============================================================================
>> + */
>> +
>> +static void s5p_jpeg_device_run(void *priv)
>> +{
>> + struct s5p_jpeg_ctx *ctx = priv;
>> + struct s5p_jpeg *jpeg = ctx->jpeg;
>> + struct vb2_buffer *src_buf, *dst_buf;
>> + unsigned long src_addr, dst_addr;
>> +
>> + src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
>> + dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> + src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
>> + dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
>> +
>> + pm_runtime_get_sync(jpeg->dev);
> 
> The function above may fail. It should be checked here.
> How does this device go back to power off state?
> 
> Maybe you should move the power-on code to start_stream callback present in struct vb2_ops. 

Indeed, it might be worth to move this pm_runtime_get_sync() and pm_runtime_put() out from the 
interrupt handler to the start/stop_streaming callbacks. Nevertheless the current approach is
pretty correct, except that currently there is no way to return an error from the device_run()
callback. It will probably be needed anyway for the per frame clock gating.

We may need some improvements in the v4l2-mem2mem framework to enable flexible power/clock 
gating at the drivers.    

For now moving pm_runtime calls to the start/stop_streaming callbacks sounds like a good idea.

> This part of code you only trigger JPEG processing by HW. I mean just jpeg_start(jpeg->regs)
> is needed here.

No, don't forget this function may be called by multiple processes, each having it's own
device context. So full register configuration is needed here, in order to (re)apply the
setup of each user process. An improvement could be to keep track of the passed 'priv' 
pointer and skipping register writes if it is same in subsequent device_run calls. You would
also need to monitor the device's power state, since after the device is powered down/up full
configuration is also needed. 

> 
>> +
>> + jpeg_reset(jpeg->regs);
>> + jpeg_poweron(jpeg->regs);
>> + jpeg_proc_mode(jpeg->regs, ctx->mode);
>> + if (ctx->mode == S5P_JPEG_ENCODE) {
>> + if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565X)
>> + jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
>> + else
>> + jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
>> + if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
>> + jpeg_subsampling_mode(jpeg->regs,
>> + S5P_JPEG_SUBSAMPLING_422);
>> + else
>> + jpeg_subsampling_mode(jpeg->regs,
>> + S5P_JPEG_SUBSAMPLING_420);
>> + jpeg_dri(jpeg->regs, 0);
>> + jpeg_x(jpeg->regs, ctx->out_q.w);
>> + jpeg_y(jpeg->regs, ctx->out_q.h);
>> + jpeg_imgadr(jpeg->regs, src_addr);
>> + jpeg_jpgadr(jpeg->regs, dst_addr);
>> +
>> + /* ultimately comes from sizeimage from userspace */
>> + jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
>> +
>> + /* JPEG RGB to YCbCr conversion matrix */
>> + jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
>> + jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
>> + jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
>> + jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
>> + jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
>> + jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
>> + jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
>> + jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
>> + jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
>> +
>> + /*
>> + * JPEG IP allows storing 4 quantization tables
>> + * We fill table 0 for luma and table 1 for chroma
>> + */
>> + jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
>> + jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
>> + /* use table 0 for Y */
>> + jpeg_qtbl(jpeg->regs, 1, 0);
>> + /* use table 1 for Cb and Cr*/
>> + jpeg_qtbl(jpeg->regs, 2, 1);
>> + jpeg_qtbl(jpeg->regs, 3, 1);
>> +
>> + /* Y, Cb, Cr use Huffman table 0 */
>> + jpeg_htbl_ac(jpeg->regs, 1);
>> + jpeg_htbl_dc(jpeg->regs, 1);
>> + jpeg_htbl_ac(jpeg->regs, 2);
>> + jpeg_htbl_dc(jpeg->regs, 2);
>> + jpeg_htbl_ac(jpeg->regs, 3);
>> + jpeg_htbl_dc(jpeg->regs, 3);
>> + } else {
>> + jpeg_rst_int_enable(jpeg->regs, true);
>> + jpeg_data_num_int_enable(jpeg->regs, true);
>> + jpeg_final_mcu_num_int_enable(jpeg->regs, true);
>> + jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
>> + jpeg_jpgadr(jpeg->regs, src_addr);
>> + jpeg_imgadr(jpeg->regs, dst_addr);
>> + }
>> + jpeg_start(jpeg->regs);
>> +}
>> +
...
>> +static int queue_init(void *priv, struct vb2_queue *src_vq,
>> + struct vb2_queue *dst_vq)
>> +{
>> + struct s5p_jpeg_ctx *ctx = priv;
>> + int ret;
>> +
>> + memset(src_vq, 0, sizeof(*src_vq));
>> + src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> + src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>> + src_vq->drv_priv = ctx;
>> + src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> + src_vq->ops =&s5p_jpeg_qops;
>> + src_vq->mem_ops =&vb2_dma_contig_memops;
>> +
>> + ret = vb2_queue_init(src_vq);
>> + if (ret)
>> + return ret;
>> +
>> + memset(dst_vq, 0, sizeof(*dst_vq));
>> + dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> + dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>> + dst_vq->drv_priv = ctx;
>> + dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> + dst_vq->ops =&s5p_jpeg_qops;
>> + dst_vq->mem_ops =&vb2_dma_contig_memops;
>> +
>> + return vb2_queue_init(dst_vq);
> 
> if vb2_queue_init(dst_vq) fails then resources allocated by vb2_queue_init(src_vq) are lost.

I don't think there are any resources allocated by vb2_queue_init(). And it is the driver that
allocates and frees vb2_queue data structures.

> 
>> +}
>> +
>> +/*
>> + * ============================================================================
>> + * ISR
>> + * ============================================================================
>> + */
>> +
>> +static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
>> +{
>> + struct s5p_jpeg *jpeg = dev_id;
>> + struct s5p_jpeg_ctx *curr_ctx;
>> + struct vb2_buffer *src_buf, *dst_buf;
>> + unsigned long payload_size = 0;
>> + enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
>> + bool enc_jpeg_too_large = false;
>> + bool timer_elapsed = false;
>> + bool op_completed = false;
>> +
>> + curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
>> +
>> + src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
>> + dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
>> +
>> + if (curr_ctx->mode == S5P_JPEG_ENCODE)
>> + enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
>> + timer_elapsed = jpeg_timer_stat(jpeg->regs);
>> + op_completed = jpeg_result_stat_ok(jpeg->regs);
>> + if (curr_ctx->mode == S5P_JPEG_DECODE)
>> + op_completed = op_completed&& jpeg_stream_stat_ok(jpeg->regs);
>> +
>> + if (enc_jpeg_too_large) {
>> + state = VB2_BUF_STATE_ERROR;
>> + jpeg_clear_enc_stream_stat(jpeg->regs);
>> + } else if (timer_elapsed) {
>> + state = VB2_BUF_STATE_ERROR;
>> + jpeg_clear_timer_stat(jpeg->regs);
>> + } else if (!op_completed) {
>> + state = VB2_BUF_STATE_ERROR;
>> + } else {
>> + payload_size = jpeg_compressed_size(jpeg->regs);
>> + }
>> +
>> + v4l2_m2m_buf_done(src_buf, state);
>> + if (curr_ctx->mode == S5P_JPEG_ENCODE)
>> + vb2_set_plane_payload(dst_buf, 0, payload_size);
>> + v4l2_m2m_buf_done(dst_buf, state);
>> + v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
>> +
>> + jpeg_clear_int(jpeg->regs);
>> +
> 
> You should move pm_runtime_put to stop_streaming callback.
> 
>> + pm_runtime_put(jpeg->dev);

It's perfectly valid like this too. In this way the H/W is activated only when it is
really needed. Optionally pm_runtime_put_autosupend and friends could be used instead 
here, giving the user more control on the runtime PM policy.

But due to the trouble with the device_run() using stop_streaming callback indeed 
seems reasonable.

>> +
>> + return IRQ_HANDLED;
>> +}
>> +
>> +/*
>> + * ============================================================================
>> + * Driver basic infrastructure
>> + * ============================================================================
>> + */
>> +
>> +static int s5p_jpeg_probe(struct platform_device *pdev)
>> +{
>> + struct s5p_jpeg *jpeg;
>> + struct resource *res;
>> + int ret;
>> +
>> + /* JPEG IP abstraction struct */
>> + jpeg = kzalloc(sizeof(struct s5p_jpeg), GFP_KERNEL);
>> + if (!jpeg) {
>> + dev_err(&pdev->dev, "no memory for state\n");
>> + return -ENOMEM;
>> + }
>> + mutex_init(&jpeg->lock);
>> + jpeg->dev =&pdev->dev;
>> +
>> + /* memory-mapped registers */
>> + res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> + if (!res) {
>> + dev_err(&pdev->dev, "cannot find IO resource\n");
>> + ret = -ENOENT;
>> + goto jpeg_alloc_rollback;
>> + }
>> +
>> + jpeg->ioarea = request_mem_region(res->start, resource_size(res),
>> + pdev->name);
>> + if (!jpeg->ioarea) {
>> + dev_err(&pdev->dev, "cannot request IO\n");
>> + ret = -ENXIO;
>> + goto jpeg_alloc_rollback;
>> + }
>> +
>> + jpeg->regs = ioremap(res->start, resource_size(res));
>> + if (!jpeg->regs) {
>> + dev_err(&pdev->dev, "cannot map IO\n");
>> + ret = -ENXIO;
>> + goto mem_region_rollback;
>> + }
>> +
>> + dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
>> + jpeg->regs, jpeg->ioarea, res);
>> +
>> + /* interrupt service routine registration */
>> + jpeg->irq = ret = platform_get_irq(pdev, 0);
>> + if (ret<= 0) {
> 
> value 0 is a valid irq, isn't is?
> 
>> + dev_err(&pdev->dev, "cannot find IRQ\n");
>> + goto ioremap_rollback;
>> + }
>> +
>> + ret = request_irq(jpeg->irq, s5p_jpeg_irq, 0,
>> + dev_name(&pdev->dev), jpeg);
>> +
>> + if (ret) {
>> + dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpeg->irq);
>> + goto ioremap_rollback;
>> + }
>> +
>> + /* clocks */
>> + jpeg->clk = clk_get(&pdev->dev, "jpeg");
>> + if (IS_ERR_OR_NULL(jpeg->clk)) {
>> + dev_err(&pdev->dev, "cannot get clock\n");
>> + ret = -ENOENT;
>> + goto request_irq_rollback;
>> + }
>> + dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
>> + clk_enable(jpeg->clk);
>> +
>> + /* v4l2 device */
>> + ret = v4l2_device_register(&pdev->dev,&jpeg->v4l2_dev);
>> + if (ret) {
>> + dev_err(&pdev->dev, "Failed to register v4l2 device\n");
>> + goto clk_get_rollback;
>> + }
>> +
>> + /* JPEG encoder /dev/videoX node */
>> + jpeg->vfd_encoder = video_device_alloc();
>> + if (!jpeg->vfd_encoder) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
>> + ret = -ENOMEM;
>> + goto device_register_rollback;
>> + }
>> + strlcpy(jpeg->vfd_encoder->name, S5P_JPEG_M2M_NAME,
>> + sizeof(jpeg->vfd_encoder->name));
>> + jpeg->vfd_encoder->fops =&s5p_jpeg_fops;
>> + jpeg->vfd_encoder->ioctl_ops =&s5p_jpeg_ioctl_ops;
>> + jpeg->vfd_encoder->minor = -1;
>> + jpeg->vfd_encoder->release = video_device_release;
>> + jpeg->vfd_encoder->lock =&jpeg->lock;
>> + jpeg->vfd_encoder->v4l2_dev =&jpeg->v4l2_dev;
>> +
>> + ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
>> + if (ret) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
>> + goto enc_vdev_alloc_rollback;
>> + }
>> +
>> + video_set_drvdata(jpeg->vfd_encoder, jpeg);
>> + v4l2_info(&jpeg->v4l2_dev,
>> + "encoder device registered as /dev/video%d\n",
>> + jpeg->vfd_encoder->num);
>> +
>> + /* JPEG decoder /dev/videoX node */
>> + jpeg->vfd_decoder = video_device_alloc();
>> + if (!jpeg->vfd_decoder) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
>> + ret = -ENOMEM;
>> + goto enc_vdev_register_rollback;
>> + }
>> + strlcpy(jpeg->vfd_decoder->name, S5P_JPEG_M2M_NAME,
>> + sizeof(jpeg->vfd_decoder->name));
>> + jpeg->vfd_decoder->fops =&s5p_jpeg_fops;
>> + jpeg->vfd_decoder->ioctl_ops =&s5p_jpeg_ioctl_ops;
>> + jpeg->vfd_decoder->minor = -1;
>> + jpeg->vfd_decoder->release = video_device_release;
>> + jpeg->vfd_decoder->lock =&jpeg->lock;
>> + jpeg->vfd_decoder->v4l2_dev =&jpeg->v4l2_dev;
>> +
>> + ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
>> + if (ret) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
>> + goto dec_vdev_alloc_rollback;
>> + }
>> +
>> + video_set_drvdata(jpeg->vfd_decoder, jpeg);
>> + v4l2_info(&jpeg->v4l2_dev,
>> + "decoder device registered as /dev/video%d\n",
>> + jpeg->vfd_decoder->num);
>> +
>> + /* mem2mem device */
>> + jpeg->m2m_dev = v4l2_m2m_init(&s5p_jpeg_m2m_ops);
>> + if (IS_ERR_OR_NULL(jpeg->m2m_dev)) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
>> + ret = PTR_ERR(jpeg->m2m_dev);
> 
> 0 is returned if jpeg->m2m_dev is NULL.

The point is that v4l2_m2m_init() returns valid pointer or an ERR_PTR() value.
Thus jpeg->m2m_dev is never NULL, and ret is never 0 in case of an error.
I would just change "IS_ERR_OR_NULL(jpeg->m2m_dev)" to "IS_ERR(jpeg->m2m_dev)".


> 
>> + goto dec_vdev_register_rollback;
>> + }
>> +
>> + jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
>> + if (IS_ERR_OR_NULL(jpeg->alloc_ctx)) {
>> + v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
>> + ret = PTR_ERR(jpeg->alloc_ctx);
> [as above]

vb2_dma_contig_init_ctx() also returns only ERR_PTR() in case of an error.

>> + goto m2m_init_rollback;
>> + }
>> +
>> + /* final statements& power management */
>> + platform_set_drvdata(pdev, jpeg);
>> +
> 
> You should call function pm_runtime_set_active only if you are absolutely sure
> that device power is on. It may not be true in this case.
> 
>> + pm_runtime_set_active(&pdev->dev);
>> + pm_runtime_enable(&pdev->dev);
>> +
>> + v4l2_info(&jpeg->v4l2_dev, "Samsung S5P JPEG codec\n");
>> +
>> + return 0;
>> +
>> +m2m_init_rollback:
>> + v4l2_m2m_release(jpeg->m2m_dev);
>> +
>> +dec_vdev_register_rollback:
>> + video_unregister_device(jpeg->vfd_decoder);
>> +
>> +dec_vdev_alloc_rollback:
>> + video_device_release(jpeg->vfd_decoder);
>> +
>> +enc_vdev_register_rollback:
>> + video_unregister_device(jpeg->vfd_encoder);
>> +
>> +enc_vdev_alloc_rollback:
>> + video_device_release(jpeg->vfd_encoder);
>> +
>> +device_register_rollback:
>> + v4l2_device_unregister(&jpeg->v4l2_dev);
>> +
>> +clk_get_rollback:
>> + clk_disable(jpeg->clk);
>> + clk_put(jpeg->clk);
>> +
>> +request_irq_rollback:
>> + free_irq(jpeg->irq, jpeg);
>> +
>> +ioremap_rollback:
>> + iounmap(jpeg->regs);
>> +
>> +mem_region_rollback:
>> + release_resource(jpeg->ioarea);
>> + release_mem_region(jpeg->ioarea->start, resource_size(jpeg->ioarea));
>> +
>> +jpeg_alloc_rollback:
>> + kfree(jpeg);
>> + return ret;
>> +}
>> +
...
>> +static inline void jpeg_clear_int(void __iomem *regs)
>> +{
>> + unsigned long reg;
>> +
>> + reg = readl(regs + S5P_JPGINTST);
>> + writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
>> + reg = readl(regs + S5P_JPGOPR);
> 
> reg goes to Data Haven.

I suspect the H/W requires this register read sequence in order to clear 
the internal interrupt pending bits. Not sure how far the compiler optimizes 
such code though.

> 
>> +}
>> +
>> +static inline int jpeg_compressed_size(void __iomem *regs)
>> +{
>> + unsigned long jpeg_size = 0;
>> +
>> + jpeg_size |= (readl(regs + S5P_JPGCNT_U)& 0xff)<< 16;
>> + jpeg_size |= (readl(regs + S5P_JPGCNT_M)& 0xff)<< 8;
>> + jpeg_size |= (readl(regs + S5P_JPGCNT_L)& 0xff);
> 
> Use readb here and in many cases above.

The register addresses are 4-byte aligned and the IP block is for various ARM 
architectures. I would suggest keeping the code as is, unless we are certain
what order of gain and what trouble such a change could bring. 

> 
>> +
>> + return (int)jpeg_size;
>> +}
>> +
>> +#endif /* JPEG_HW_H_ */
>> diff --git a/drivers/media/video/s5p-jpeg/jpeg-regs.h b/drivers/media/video/s5p-jpeg/jpeg-regs.h
>> new file mode 100644
>> index 0000000..91f4dd5
>> --- /dev/null
>> +++ b/drivers/media/video/s5p-jpeg/jpeg-regs.h
>> @@ -0,0 +1,170 @@
>> +/* linux/drivers/media/video/s5p-jpeg/jpeg-regs.h
...
>> +/* JPEG interrupt setting register */
>> +#define S5P_JPGINTSE 0x34
>> +#define S5P_RSTm_INT_EN_MASK (0x1<< 7)
>> +#define S5P_RSTm_INT_EN (0x1<< 7)
> 
> Macro S5P_RSTm_INT_EN_MASK is not needed. Try to use only macro-flags that have non-zero values.
> Bit checking like:
> if (val & S5P_RSTm_INT_EN)
> 
> if much easier to read than:
> if ((val & S5P_RSTm_INT_EN_MASK) == S5P_RSTm_INT_EN)

and these are two completely different things. I would say it is up to the author
to decide about nitpicks like this.

> 
> Same thing happens for bit-setting.


--
Regards,
Sylwester
