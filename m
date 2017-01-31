Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36832
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752060AbdAaNtL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 08:49:11 -0500
Date: Tue, 31 Jan 2017 11:48:57 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick FERTRE <yannick.fertre@st.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Subject: Re: [PATCH v3 1/3] st-hva: encoding summary at instance release
Message-ID: <20170131114857.187fa4ad@vento.lan>
In-Reply-To: <690624c4-4f73-a414-79ef-9fbe4ebce8cb@st.com>
References: <1480329054-30403-1-git-send-email-jean-christophe.trotin@st.com>
        <1480329054-30403-2-git-send-email-jean-christophe.trotin@st.com>
        <20170130152803.4c7ab073@vento.lan>
        <690624c4-4f73-a414-79ef-9fbe4ebce8cb@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 31 Jan 2017 08:50:38 +0000
Jean Christophe TROTIN <jean-christophe.trotin@st.com> escreveu:

> On 01/30/2017 06:28 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 28 Nov 2016 11:30:52 +0100
> > Jean-Christophe Trotin <jean-christophe.trotin@st.com> escreveu:
> >  
> >> This patch prints unconditionnaly a short summary  
> >
> > Why? Is this driver so broken that everyone would need an
> > unconditional "short summary" about what happened there?
> >
> > If not, then please use dev_dbg() or debugfs instead. If yes, then
> > we should move this driver to staging.
> >  
> Hi Mauro,
> 
> The unconditional character of this "short summary" was a "facility" that our 
> customers used to get (it doesn't mean that this driver is broken).
> That's said, I understand your comment, and I will propose today a new version 
> of this patch with dev_dbg() instead of dev_info().

Thanks, the new version looks OK on my eyes. As I got it from Hans
tree, I'll wait for either his ack/SOB or for him to merge on his
tree.

Regards,
Mauro

> 
> Regards,
> Jean-Christophe.
> 
> >> about the encoding
> >> operation at each instance closing, for debug purpose:
> >> - information about the frame (format, resolution)
> >> - information about the stream (format, profile, level, resolution)
> >> - number of encoded frames
> >> - potential (system, encoding...) errors
> >>
> >> Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
> >> Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
> >> ---
> >>  drivers/media/platform/sti/hva/hva-h264.c |  6 ++++
> >>  drivers/media/platform/sti/hva/hva-hw.c   |  5 ++++
> >>  drivers/media/platform/sti/hva/hva-mem.c  |  5 +++-
> >>  drivers/media/platform/sti/hva/hva-v4l2.c | 49 ++++++++++++++++++++++++-------
> >>  drivers/media/platform/sti/hva/hva.h      |  8 +++++
> >>  5 files changed, 62 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
> >> index 8cc8467..e6f247a 100644
> >> --- a/drivers/media/platform/sti/hva/hva-h264.c
> >> +++ b/drivers/media/platform/sti/hva/hva-h264.c
> >> @@ -607,6 +607,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
> >>  			"%s   width(%d) or height(%d) exceeds limits (%dx%d)\n",
> >>  			pctx->name, frame_width, frame_height,
> >>  			H264_MAX_SIZE_W, H264_MAX_SIZE_H);
> >> +		pctx->frame_errors++;
> >>  		return -EINVAL;
> >>  	}
> >>
> >> @@ -717,6 +718,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
> >>  	default:
> >>  		dev_err(dev, "%s   invalid source pixel format\n",
> >>  			pctx->name);
> >> +		pctx->frame_errors++;
> >>  		return -EINVAL;
> >>  	}
> >>
> >> @@ -741,6 +743,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
> >>
> >>  	if (td->framerate_den == 0) {
> >>  		dev_err(dev, "%s   invalid framerate\n", pctx->name);
> >> +		pctx->frame_errors++;
> >>  		return -EINVAL;
> >>  	}
> >>
> >> @@ -831,6 +834,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
> >>  	    (payload > MAX_SPS_PPS_SIZE)) {
> >>  		dev_err(dev, "%s   invalid sps/pps size %d\n", pctx->name,
> >>  			payload);
> >> +		pctx->frame_errors++;
> >>  		return -EINVAL;
> >>  	}
> >>
> >> @@ -842,6 +846,7 @@ static int hva_h264_prepare_task(struct hva_ctx *pctx,
> >>  						   (u8 *)stream->vaddr,
> >>  						   &payload)) {
> >>  		dev_err(dev, "%s   fail to get SEI nal\n", pctx->name);
> >> +		pctx->frame_errors++;
> >>  		return -EINVAL;
> >>  	}
> >>
> >> @@ -963,6 +968,7 @@ static int hva_h264_open(struct hva_ctx *pctx)
> >>  err_ctx:
> >>  	devm_kfree(dev, ctx);
> >>  err:
> >> +	pctx->sys_errors++;
> >>  	return ret;
> >>  }
> >>
> >> diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
> >> index 68d625b..5104068 100644
> >> --- a/drivers/media/platform/sti/hva/hva-hw.c
> >> +++ b/drivers/media/platform/sti/hva/hva-hw.c
> >> @@ -470,6 +470,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> >>
> >>  	if (pm_runtime_get_sync(dev) < 0) {
> >>  		dev_err(dev, "%s     failed to get pm_runtime\n", ctx->name);
> >> +		ctx->sys_errors++;
> >>  		ret = -EFAULT;
> >>  		goto out;
> >>  	}
> >> @@ -481,6 +482,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> >>  		break;
> >>  	default:
> >>  		dev_dbg(dev, "%s     unknown command 0x%x\n", ctx->name, cmd);
> >> +		ctx->encode_errors++;
> >>  		ret = -EFAULT;
> >>  		goto out;
> >>  	}
> >> @@ -511,6 +513,7 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> >>  					 msecs_to_jiffies(2000))) {
> >>  		dev_err(dev, "%s     %s: time out on completion\n", ctx->name,
> >>  			__func__);
> >> +		ctx->encode_errors++;
> >>  		ret = -EFAULT;
> >>  		goto out;
> >>  	}
> >> @@ -518,6 +521,8 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
> >>  	/* get encoding status */
> >>  	ret = ctx->hw_err ? -EFAULT : 0;
> >>
> >> +	ctx->encode_errors += ctx->hw_err ? 1 : 0;
> >> +
> >>  out:
> >>  	disable_irq(hva->irq_its);
> >>  	disable_irq(hva->irq_err);
> >> diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
> >> index 649f660..821c78e 100644
> >> --- a/drivers/media/platform/sti/hva/hva-mem.c
> >> +++ b/drivers/media/platform/sti/hva/hva-mem.c
> >> @@ -17,14 +17,17 @@ int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
> >>  	void *base;
> >>
> >>  	b = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);
> >> -	if (!b)
> >> +	if (!b) {
> >> +		ctx->sys_errors++;
> >>  		return -ENOMEM;
> >> +	}
> >>
> >>  	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
> >>  			       DMA_ATTR_WRITE_COMBINE);
> >>  	if (!base) {
> >>  		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
> >>  			ctx->name, __func__, name, size);
> >> +		ctx->sys_errors++;
> >>  		devm_kfree(dev, b);
> >>  		return -ENOMEM;
> >>  	}
> >> diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
> >> index 6bf3c858..a13b03c 100644
> >> --- a/drivers/media/platform/sti/hva/hva-v4l2.c
> >> +++ b/drivers/media/platform/sti/hva/hva-v4l2.c
> >> @@ -226,6 +226,28 @@ static int hva_open_encoder(struct hva_ctx *ctx, u32 streamformat,
> >>  	return ret;
> >>  }
> >>
> >> +void hva_dbg_summary(struct hva_ctx *ctx)
> >> +{
> >> +	struct device *dev = ctx_to_dev(ctx);
> >> +	struct hva_streaminfo *stream = &ctx->streaminfo;
> >> +	struct hva_frameinfo *frame = &ctx->frameinfo;
> >> +
> >> +	if (!(ctx->flags & HVA_FLAG_STREAMINFO))
> >> +		return;
> >> +
> >> +	dev_info(dev, "%s %4.4s %dx%d > %4.4s %dx%d %s %s: %d frames encoded, %d system errors, %d encoding errors, %d frame errors\n",
> >> +		 ctx->name,
> >> +		 (char *)&frame->pixelformat,
> >> +		 frame->aligned_width, frame->aligned_height,
> >> +		 (char *)&stream->streamformat,
> >> +		 stream->width, stream->height,
> >> +		 stream->profile, stream->level,
> >> +		 ctx->encoded_frames,
> >> +		 ctx->sys_errors,
> >> +		 ctx->encode_errors,
> >> +		 ctx->frame_errors);
> >> +}
> >> +
> >>  /*
> >>   * V4L2 ioctl operations
> >>   */
> >> @@ -614,19 +636,17 @@ static int hva_s_ctrl(struct v4l2_ctrl *ctrl)
> >>  		break;
> >>  	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
> >>  		ctx->ctrls.profile = ctrl->val;
> >> -		if (ctx->flags & HVA_FLAG_STREAMINFO)
> >> -			snprintf(ctx->streaminfo.profile,
> >> -				 sizeof(ctx->streaminfo.profile),
> >> -				 "%s profile",
> >> -				 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> >> +		snprintf(ctx->streaminfo.profile,
> >> +			 sizeof(ctx->streaminfo.profile),
> >> +			 "%s profile",
> >> +			 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> >>  		break;
> >>  	case V4L2_CID_MPEG_VIDEO_H264_LEVEL:
> >>  		ctx->ctrls.level = ctrl->val;
> >> -		if (ctx->flags & HVA_FLAG_STREAMINFO)
> >> -			snprintf(ctx->streaminfo.level,
> >> -				 sizeof(ctx->streaminfo.level),
> >> -				 "level %s",
> >> -				 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> >> +		snprintf(ctx->streaminfo.level,
> >> +			 sizeof(ctx->streaminfo.level),
> >> +			 "level %s",
> >> +			 v4l2_ctrl_get_menu(ctrl->id)[ctrl->val]);
> >>  		break;
> >>  	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
> >>  		ctx->ctrls.entropy_mode = ctrl->val;
> >> @@ -812,6 +832,8 @@ static void hva_run_work(struct work_struct *work)
> >>  		dst_buf->field = V4L2_FIELD_NONE;
> >>  		dst_buf->sequence = ctx->stream_num - 1;
> >>
> >> +		ctx->encoded_frames++;
> >> +
> >>  		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> >>  		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> >>  	}
> >> @@ -1026,6 +1048,8 @@ static int hva_start_streaming(struct vb2_queue *vq, unsigned int count)
> >>  			v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
> >>  	}
> >>
> >> +	ctx->sys_errors++;
> >> +
> >>  	return ret;
> >>  }
> >>
> >> @@ -1150,6 +1174,7 @@ static int hva_open(struct file *file)
> >>  	if (ret) {
> >>  		dev_err(dev, "%s [x:x] failed to setup controls\n",
> >>  			HVA_PREFIX);
> >> +		ctx->sys_errors++;
> >>  		goto err_fh;
> >>  	}
> >>  	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> >> @@ -1162,6 +1187,7 @@ static int hva_open(struct file *file)
> >>  		ret = PTR_ERR(ctx->fh.m2m_ctx);
> >>  		dev_err(dev, "%s failed to initialize m2m context (%d)\n",
> >>  			HVA_PREFIX, ret);
> >> +		ctx->sys_errors++;
> >>  		goto err_ctrls;
> >>  	}
> >>
> >> @@ -1206,6 +1232,9 @@ static int hva_release(struct file *file)
> >>  		hva->nb_of_instances--;
> >>  	}
> >>
> >> +	/* trace a summary of instance before closing (debug purpose) */
> >> +	hva_dbg_summary(ctx);
> >> +
> >>  	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> >>
> >>  	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> >> diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
> >> index caa5808..1e30abe 100644
> >> --- a/drivers/media/platform/sti/hva/hva.h
> >> +++ b/drivers/media/platform/sti/hva/hva.h
> >> @@ -182,6 +182,10 @@ struct hva_stream {
> >>   * @priv:            private codec data for this instance, allocated
> >>   *                   by encoder @open time
> >>   * @hw_err:          true if hardware error detected
> >> + * @encoded_frames:  number of encoded frames
> >> + * @sys_errors:      number of system errors (memory, resource, pm...)
> >> + * @encode_errors:   number of encoding errors (hw/driver errors)
> >> + * @frame_errors:    number of frame errors (format, size, header...)
> >>   */
> >>  struct hva_ctx {
> >>  	struct hva_dev		        *hva_dev;
> >> @@ -207,6 +211,10 @@ struct hva_ctx {
> >>  	struct hva_enc			*enc;
> >>  	void				*priv;
> >>  	bool				hw_err;
> >> +	u32				encoded_frames;
> >> +	u32				sys_errors;
> >> +	u32				encode_errors;
> >> +	u32				frame_errors;
> >>  };
> >>
> >>  #define HVA_FLAG_STREAMINFO	0x0001  
> >
> >
> >
> > Thanks,
> > Mauro
>   



Thanks,
Mauro
