Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AD4C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D1220850
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 16:04:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53D1220850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=collabora.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbeLEQEP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 11:04:15 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50172 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbeLEQEP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Dec 2018 11:04:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 4B2F627D8DC
Message-ID: <92f2751675e0f2be95cbf8bb1181a2c92437daed.camel@collabora.com>
Subject: Re: [PATCH v11 4/4] media: add Rockchip VPU JPEG encoder driver
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
Date:   Wed, 05 Dec 2018 13:04:03 -0300
In-Reply-To: <07aed803-0e2f-c7c1-7f1c-752b82ffad7c@xs4all.nl>
References: <20181130173433.24185-1-ezequiel@collabora.com>
         <20181130173433.24185-5-ezequiel@collabora.com>
         <07aed803-0e2f-c7c1-7f1c-752b82ffad7c@xs4all.nl>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Wed, 2018-12-05 at 16:01 +0100, Hans Verkuil wrote:
> On 11/30/18 18:34, Ezequiel Garcia wrote:
> > Add a mem2mem driver for the VPU available on Rockchip SoCs.
> > Currently only JPEG encoding is supported, for RK3399 and RK3288
> > platforms.
> > 
> > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > ---
> 
> <snip>
> 
[..]
> 
> 
> Unless something unexpected happens, then v12 should be the final
> version and I'll make a pull request for it. Note that it will
> probably won't make 4.20, unless you manage to do it within the next
> hour :-)
> 

Thanks for the review. Here are the changes that will be on v12.

Besides your feedback, I found a missing parenthesis issue,
which seems to have sneaked into v11! Apparently, v11 had
last minute changes and I failed to run v4l2-compliance.  

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index f2752a0c71c0..962412c79b91 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -60,11 +60,13 @@ static void rockchip_vpu_job_finish(struct rockchip_vpu_dev *vpu,
 	dst->sequence = ctx->sequence_cap++;
 
 	dst->field = src->field;
-	if (dst->flags & V4L2_BUF_FLAG_TIMECODE)
+	if (src->flags & V4L2_BUF_FLAG_TIMECODE)
 		dst->timecode = src->timecode;
 	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
-	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
-	dst->flags |= src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->flags &= ~(V4L2_BUF_FLAG_TSTAMP_SRC_MASK |
+			V4L2_BUF_FLAG_TIMECODE);
+	dst->flags |= src->flags & (V4L2_BUF_FLAG_TSTAMP_SRC_MASK |
+				    V4L2_BUF_FLAG_TIMECODE);
 
 	avail_size = vb2_plane_size(&dst->vb2_buf, 0) -
 		     ctx->vpu_dst_fmt->header_size;
@@ -151,6 +153,12 @@ enc_queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
 	src_vq->drv_priv = ctx;
 	src_vq->ops = &rockchip_vpu_enc_queue_ops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+
+	/*
+	 * Driver does mostly sequential access, so sacrifice TLB efficiency
+	 * for faster allocation. Also, no CPU access on the source queue,
+	 * so no kernel mapping needed.
+	 */
 	src_vq->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES |
 			    DMA_ATTR_NO_KERNEL_MAPPING;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
@@ -197,8 +205,6 @@ static int rockchip_vpu_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->jpeg_quality = ctrl->val;
 		break;
 	default:
-		vpu_err("Invalid control id = %d, val = %d\n",
-			ctrl->id, ctrl->val);
 		return -EINVAL;
 	}
 
diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index 6aadd194e999..3dbd15d5fabe 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -142,7 +142,7 @@ rockchip_vpu_get_default_fmt(struct rockchip_vpu_ctx *ctx, bool bitstream)
 	formats = dev->variant->enc_fmts;
 	num_fmts = dev->variant->num_enc_fmts;
 	for (i = 0; i < num_fmts; i++) {
-		if (bitstream == formats[i].codec_mode != RK_VPU_MODE_NONE)
+		if (bitstream == (formats[i].codec_mode != RK_VPU_MODE_NONE))
 			return &formats[i];
 	}
 	return NULL;

