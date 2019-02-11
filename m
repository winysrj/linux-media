Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A80FC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 19:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CFA21B25
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 19:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfBKTs2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 14:48:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39070 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfBKTs2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 14:48:28 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id B983A27EC6B
Message-ID: <5a31f5596c04390d76bf34fdb8b71b6a96306943.camel@collabora.com>
Subject: Re: [PATCH v3 2/2] media: cedrus: Add H264 decoding support
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date:   Mon, 11 Feb 2019 16:48:17 -0300
In-Reply-To: <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
         <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 2019-02-11 at 15:39 +0100, Maxime Ripard wrote:
> Introduce some basic H264 decoding support in cedrus. So far, only the
> baseline profile videos have been tested, and some more advanced features
> used in higher profiles are not even implemented.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
[..]


> +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> +				   struct cedrus_run *run,
> +				   const u8 *ref_list, u8 num_ref,
> +				   enum cedrus_h264_sram_off sram)
> +{
> +	const struct v4l2_ctrl_h264_decode_param *decode = run->h264.decode_param;
> +	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
> +	const struct vb2_buffer *dst_buf = &run->dst->vb2_buf;
> +	struct cedrus_dev *dev = ctx->dev;
> +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> +	unsigned int size, i;
> +
> +	memset(sram_array, 0, sizeof(sram_array));
> +
> +	for (i = 0; i < num_ref; i++) {
> +		const struct v4l2_h264_dpb_entry *dpb;
> +		const struct cedrus_buffer *cedrus_buf;
> +		const struct vb2_v4l2_buffer *ref_buf;
> +		unsigned int position;
> +		int buf_idx;
> +		u8 dpb_idx;
> +
> +		dpb_idx = ref_list[i];
> +		dpb = &decode->dpb[dpb_idx];
> +
> +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> +			continue;
> +
> +		if (dst_buf->timestamp == dpb->timestamp)
> +			buf_idx = dst_buf->index;
> +		else
> +			buf_idx = vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> +
> +		if (buf_idx < 0)
> +			continue;
> +
> +		ref_buf = to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> +		cedrus_buf = vb2_v4l2_to_cedrus_buffer(ref_buf);
> +		position = cedrus_buf->codec.h264.position;
> +
> +		sram_array[i] |= position << 1;
> +		if (ref_buf->field == V4L2_FIELD_BOTTOM)
> +			sram_array[i] |= BIT(0);
> +	}
> +
> +	size = min((unsigned int)ALIGN(num_ref, 4), sizeof(sram_array));

Perhaps s/unsigned int/size_t, so the arguments to min() have the same type?

Otherwise, I got this warning:

/home/zeta/repos/linux/media_tree/drivers/staging/media/sunxi/cedrus/cedrus_h264.c: In function ‘_cedrus_write_ref_list’:
/home/zeta/repos/linux/media_tree/include/linux/kernel.h:846:29: warning: comparison of distinct pointer types lacks a cast
   (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))

Regards,
Ez

