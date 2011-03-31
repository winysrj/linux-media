Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:34020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1CaJKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 05:10:44 -0400
Date: Thu, 31 Mar 2011 11:10:35 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [RFC/PATCH v7 3/5] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <007b01cbef3a$f6293b30$e27bb190$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com
Message-id: <001e01cbef83$81ff0840$85fd18c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1299237982-31687-1-git-send-email-k.debski@samsung.com>
 <1299237982-31687-4-git-send-email-k.debski@samsung.com>
 <007b01cbef3a$f6293b30$e27bb190$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> From: Jaeryul Oh [mailto:jaeryul.oh@samsung.com]
> Hi, Kamil

Hi Peter,
 
> I found some mal-functional points.

I have commented below.

> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Kamil Debski
> > Sent: Friday, March 04, 2011 8:26 PM
> > To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> > Cc: m.szyprowski@samsung.com; kyungmin.park@samsung.com;
> > k.debski@samsung.com; jaeryul.oh@samsung.com; kgene.kim@samsung.com
> > Subject: [RFC/PATCH v7 3/5] MFC: Add MFC 5.1 V4L2 driver
> >
> > Multi Format Codec 5.1 is capable of handling a range of video codecs
> > and this driver provides V4L2 interface for video decoding.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/Kconfig                  |    8 +
> >  drivers/media/video/Makefile                 |    1 +
> >  drivers/media/video/s5p-mfc/Makefile         |    3 +
> >  drivers/media/video/s5p-mfc/regs-mfc5.h      |  346 ++++
> >  drivers/media/video/s5p-mfc/s5p_mfc.c        | 2253
> > ++++++++++++++++++++++++++
> >  drivers/media/video/s5p-mfc/s5p_mfc_common.h |  240 +++
> >  drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h  |  182 +++
> >  drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   47 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   92 ++
> >  drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_memory.h |   43 +
> >  drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  913 +++++++++++
> >  drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  142 ++
> >  13 files changed, 4296 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/s5p-mfc/Makefile
> >  create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
> >  create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
> >
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 12fb325..0bdc64d 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -1025,4 +1025,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
> >  	  This is a v4l2 driver for the S5P camera interface
> >  	  (video postprocessor)
> >
> > +config VIDEO_SAMSUNG_S5P_MFC
> > +	tristate "Samsung S5P MFC 5.1 Video Codec"
> > +	depends on VIDEO_V4L2
> > +	select VIDEOBUF2_S5P_IOMMU
> > +	default n
> > +	help
> > +	    MFC 5.1 driver for V4L2.
> > +
> >  endif # V4L_MEM2MEM_DRIVERS
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index fd9488d..4b09ddb 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -164,6 +164,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+=
> > sh_mobile_csi2.o
> >  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> >  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> >  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
> > +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
> >
> >  obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
> >
> > diff --git a/drivers/media/video/s5p-mfc/Makefile
> > b/drivers/media/video/s5p-mfc/Makefile
> > new file mode 100644
> > index 0000000..69b6294
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/Makefile
> > @@ -0,0 +1,3 @@
> > +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
> > +s5p-mfc-y := s5p_mfc.o s5p_mfc_intr.o  s5p_mfc_opr.o
> > +
> > diff --git a/drivers/media/video/s5p-mfc/regs-mfc5.h
> > b/drivers/media/video/s5p-mfc/regs-mfc5.h
> > new file mode 100644
> > index 0000000..eeb6e2e
> > --- /dev/null
> > +++ b/drivers/media/video/s5p-mfc/regs-mfc5.h
> > @@ -0,0 +1,346 @@
> 
> snipping
> 
> > +}
> > +
> > +static inline void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +
> > +	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	s5p_mfc_decode_one_frame(ctx, MFC_DEC_RES_CHANGE);
> > +}
> > +
> > +static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +
> > +	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	s5p_mfc_decode_one_frame(ctx, MFC_DEC_LAST_FRAME);
> > +}
> > +
> 
> You used '0' as a second param.(= buf_addr) in
> s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0)
> This must be a problem, 'cause OFFSETA(buf_addr) is calculated wrongly.
> And I propose that
> why don't you try to check addr condition(necessary cond. of MFC, it should
> be located at
> rear region from base_addr)

This function is called after the last input buffer has been sent to be decoded.
Its purpose is to get the output buffers that were kept in MFC as reference
frames.
At this time there is no useful data in the input buffer and if I understand
correct
it should not be used by MFC firmware, thus I don't see the reason to set its
address. 

Is there something I don't know? Is MFC using this buffer?
When I used MFC with IOMMU I had no page faults at this point of time.

> > +static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	struct s5p_mfc_buf *temp_vb;
> > +	unsigned long flags;
> > +	int dec_arg = MFC_DEC_FRAME;
> > +
> > +	spin_lock_irqsave(&dev->irqlock, flags);
> > +
> > +	/* Frames are being decoded */
> > +	if (list_empty(&ctx->src_queue)) {
> > +		mfc_debug("No src buffers.\n");
> > +		spin_unlock_irqrestore(&dev->irqlock, flags);
> > +		return -EAGAIN;
> > +	}
> > +	/* Get the next source buffer */
> > +	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> > +	mfc_debug("Temp vb: %p\n", temp_vb);
> > +	mfc_debug("Src Addr: %08x\n", s5p_mfc_plane_addr(temp_vb->b, 0));
> > +	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b,
> > 0),
> > +				ctx->consumed_stream, temp_vb->b-
> > >v4l2_planes[0].bytesused);
> > +	spin_unlock_irqrestore(&dev->irqlock, flags);
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
> > +	        mfc_debug("Setting ctx->state to FINISHING\n");
> > +	        ctx->state = MFCINST_DEC_FINISHING;
> > +		dec_arg = MFC_DEC_LAST_FRAME;
> > +	}
> > +	s5p_mfc_decode_one_frame(ctx,
> > +				dec_arg);
> > +
> > +	return 0;
> > +}
> > +
> > +static inline int s5p_mfc_run_get_inst_no(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	int ret;
> > +
> > +	/* Preparing decoding - getting instance number */
> > +	mfc_debug("Getting instance number\n");
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	ret = s5p_mfc_open_inst(ctx);
> > +	if (ret) {
> > +		mfc_err("Failed to create a new instance.\n");
> > +		ctx->state = MFCINST_DEC_ERROR;
> > +	}
> > +	return ret;
> > +}
> > +
> > +static inline int s5p_mfc_run_return_inst(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	int ret;
> > +
> > +	/* Closing decoding instance  */
> > +	mfc_debug("Returning instance number\n");
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	ret = s5p_mfc_return_inst_no(ctx);
> > +	if (ret) {
> > +		mfc_err("Failed to return an instance.\n");
> > +		ctx->state = MFCINST_DEC_ERROR;
> > +		return ret;
> > +	}
> > +	return ret;
> > +}
> > +
> > +static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	unsigned long flags;
> > +	struct s5p_mfc_buf *temp_vb;
> > +
> > +	/* Initializing decoding - parsing header */
> > +	spin_lock_irqsave(&dev->irqlock, flags);
> > +	mfc_debug("Preparing to init decoding.\n");
> > +	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> > +	s5p_mfc_set_dec_desc_buffer(ctx);
> > +	mfc_debug("Header size: %d\n", temp_vb->b-
> > >v4l2_planes[0].bytesused);
> > +	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b,
> > 0),
> > +				0, temp_vb->b->v4l2_planes[0].bytesused);
> > +	spin_unlock_irqrestore(&dev->irqlock, flags);
> > +	dev->curr_ctx = ctx->num;
> > +	mfc_debug("paddr: %08x\n",
> > +			(int)phys_to_virt(s5p_mfc_plane_addr(temp_vb->b,
> 0)));
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	s5p_mfc_init_decode(ctx);
> > +}
> > +
> > +static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +	unsigned long flags;
> > +	struct s5p_mfc_buf *temp_vb;
> > +	int ret;
> > +	/* Header was parsed now starting processing
> > +	 * First set the output frame buffers
> > +	 * s5p_mfc_alloc_dec_buffers(ctx); */
> > +
> > +	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
> > +		mfc_err("It seems that not all destionation buffers were "
> > +			"mmaped.\nMFC requires that all destination are
> mmaped
> > "
> > +			"before starting processing.\n");
> > +		return -EAGAIN;
> > +	}
> > +
> > +	spin_lock_irqsave(&dev->irqlock, flags);
> > +
> > +	if (list_empty(&ctx->src_queue)) {
> > +		mfc_err("Header has been deallocated in the middle of "
> >
> +							"initialization.\n")
> ;
> > +		spin_unlock_irqrestore(&dev->irqlock, flags);
> > +		return -EIO;
> > +	}
> > +
> > +	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
> > +	mfc_debug("Header size: %d\n", temp_vb->b-
> > >v4l2_planes[0].bytesused);
> > +	s5p_mfc_set_dec_stream_buffer(ctx, s5p_mfc_plane_addr(temp_vb->b,
> > 0),
> > +				0, temp_vb->b->v4l2_planes[0].bytesused);
> > +	spin_unlock_irqrestore(&dev->irqlock, flags);
> > +	dev->curr_ctx = ctx->num;
> > +	s5p_mfc_clean_ctx_int_flags(ctx);
> > +	ret = s5p_mfc_set_dec_frame_buffer(ctx);
> > +	if (ret) {
> > +		mfc_err("Failed to alloc frame mem.\n");
> > +		ctx->state = MFCINST_DEC_ERROR;
> > +	}
> > +	return ret;
> > +}
> 
> snipping
> 
> > +/* Set registers for decoding stream buffer */
> > +int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
> > +		  unsigned int start_num_byte, unsigned int buf_size)
> > +{
> > +	struct s5p_mfc_dev *dev = ctx->dev;
> > +
> > +	mfc_debug_enter();
> > +	mfc_debug("inst_no: %d, buf_addr: 0x%08x, buf_size: 0x"
> > +		"%08x (%d)\n",  ctx->inst_no, buf_addr, buf_size, buf_size);
> > +	WRITEL(OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
> > +	WRITEL(CPB_BUF_SIZE, S5P_FIMV_SI_CH0_CPB_SIZE);
> > +	WRITEL(buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
> > +	mfc_debug("Shared_virt: %p (start offset: %d)\n",
> > +					ctx->shared_virt, start_num_byte);
> > +	s5p_mfc_set_start_num(ctx, start_num_byte);
> > +	mfc_debug_leave();
> > +	return 0;
> > +}
> > +
> >
> Snipping
> 

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

