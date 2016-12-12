Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:34170 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbcLLEeD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Dec 2016 23:34:03 -0500
Received: by mail-ua0-f169.google.com with SMTP id 51so71357023uai.1
        for <linux-media@vger.kernel.org>; Sun, 11 Dec 2016 20:34:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480475340-21893-3-git-send-email-rick.chang@mediatek.com>
References: <1480475340-21893-1-git-send-email-rick.chang@mediatek.com> <1480475340-21893-3-git-send-email-rick.chang@mediatek.com>
From: Ricky Liang <jcliang@chromium.org>
Date: Mon, 12 Dec 2016 12:34:01 +0800
Message-ID: <CAAJzSMfNyMiia==mXKo6aBw1VxMBxGE20LB870Zm1u9mCoioyQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] vcodec: mediatek: Add Mediatek JPEG Decoder Driver
To: Rick Chang <rick.chang@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, srv_heupstream@mediatek.com,
        "moderated list:ARM/Mediatek SoC..."
        <linux-mediatek@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..."
        <linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rick,

On Wed, Nov 30, 2016 at 11:08 AM, Rick Chang <rick.chang@mediatek.com> wrote:
> Add v4l2 driver for Mediatek JPEG Decoder
>
> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>

<snip...>

> +static bool mtk_jpeg_check_resolution_change(struct mtk_jpeg_ctx *ctx,
> +                                            struct mtk_jpeg_dec_param *param)
> +{
> +       struct mtk_jpeg_dev *jpeg = ctx->jpeg;
> +       struct mtk_jpeg_q_data *q_data;
> +
> +       q_data = &ctx->out_q;
> +       if (q_data->w != param->pic_w || q_data->h != param->pic_h) {
> +               v4l2_dbg(1, debug, &jpeg->v4l2_dev, "Picture size change\n");
> +               return true;
> +       }
> +
> +       q_data = &ctx->cap_q;
> +       if (q_data->fmt != mtk_jpeg_find_format(ctx, param->dst_fourcc,
> +                                               MTK_JPEG_FMT_TYPE_CAPTURE)) {
> +               v4l2_dbg(1, debug, &jpeg->v4l2_dev, "format change\n");
> +               return true;
> +       }
> +       return false;

<snip...>

> +static void mtk_jpeg_device_run(void *priv)
> +{
> +       struct mtk_jpeg_ctx *ctx = priv;
> +       struct mtk_jpeg_dev *jpeg = ctx->jpeg;
> +       struct vb2_buffer *src_buf, *dst_buf;
> +       enum vb2_buffer_state buf_state = VB2_BUF_STATE_ERROR;
> +       unsigned long flags;
> +       struct mtk_jpeg_src_buf *jpeg_src_buf;
> +       struct mtk_jpeg_bs bs;
> +       struct mtk_jpeg_fb fb;
> +       int i;
> +
> +       src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +       dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +       jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
> +
> +       if (jpeg_src_buf->flags & MTK_JPEG_BUF_FLAGS_LAST_FRAME) {
> +               for (i = 0; i < dst_buf->num_planes; i++)
> +                       vb2_set_plane_payload(dst_buf, i, 0);
> +               buf_state = VB2_BUF_STATE_DONE;
> +               goto dec_end;
> +       }
> +
> +       if (mtk_jpeg_check_resolution_change(ctx, &jpeg_src_buf->dec_param)) {
> +               mtk_jpeg_queue_src_chg_event(ctx);
> +               ctx->state = MTK_JPEG_SOURCE_CHANGE;
> +               v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
> +               return;
> +       }

This only detects source change if multiple OUPUT buffers are queued.
It does not catch the source change in the following scenario:

- OUPUT buffers for jpeg1 enqueued
- OUTPUT queue STREAMON
- userspace creates CAPTURE buffers
- CAPTURE buffers enqueued
- CAPTURE queue STREAMON
- decode
- OUTPUT queue STREAMOFF
- userspace recreates OUTPUT buffers for jpeg2
- OUTPUT buffers for jpeg2 enqueued
- OUTPUT queue STREAMON

In the above sequence if jpeg2's decoded size is larger than jpeg1 the
function fails to detect that the existing CAPTURE buffers are not big
enough to hold the decoded data.

A possible fix is to pass *dst_buf to
mtk_jpeg_check_resolution_change(), and check in the function that all
the dst_buf planes are large enough to hold the decoded data.

> +
> +       mtk_jpeg_set_dec_src(ctx, src_buf, &bs);
> +       if (mtk_jpeg_set_dec_dst(ctx, &jpeg_src_buf->dec_param, dst_buf, &fb))
> +               goto dec_end;
> +
> +       spin_lock_irqsave(&jpeg->hw_lock, flags);
> +       mtk_jpeg_dec_reset(jpeg->dec_reg_base);
> +       mtk_jpeg_dec_set_config(jpeg->dec_reg_base,
> +                               &jpeg_src_buf->dec_param, &bs, &fb);
> +
> +       mtk_jpeg_dec_start(jpeg->dec_reg_base);
> +       spin_unlock_irqrestore(&jpeg->hw_lock, flags);
> +       return;
> +
> +dec_end:
> +       v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +       v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +       v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), buf_state);
> +       v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), buf_state);
> +       v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
> +}

<snip...>
