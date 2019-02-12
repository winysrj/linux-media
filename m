Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4364C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 12:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F47820823
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 12:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfBLMrS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:47:18 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:58913 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLMrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 07:47:18 -0500
Received: from localhost (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id B38EE24000D;
        Tue, 12 Feb 2019 12:47:13 +0000 (UTC)
Date:   Tue, 12 Feb 2019 13:47:13 +0100
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        jernej.skrabec@gmail.com, jonas@kwiboo.se,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v3 2/2] media: cedrus: Add H264 decoding support
Message-ID: <20190212124713.cqms5jofw433nx6m@flea>
References: <cover.d3bb4d93da91ed5668025354ee1fca656e7d5b8b.1549895062.git-series.maxime.ripard@bootlin.com>
 <4c00e1ab1e70adb1d94db59c37393250ca3791c5.1549895062.git-series.maxime.ripard@bootlin.com>
 <5a31f5596c04390d76bf34fdb8b71b6a96306943.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5a31f5596c04390d76bf34fdb8b71b6a96306943.camel@collabora.com>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 11, 2019 at 04:48:17PM -0300, Ezequiel Garcia wrote:
> On Mon, 2019-02-11 at 15:39 +0100, Maxime Ripard wrote:
> > Introduce some basic H264 decoding support in cedrus. So far, only the
> > baseline profile videos have been tested, and some more advanced features
> > used in higher profiles are not even implemented.
> > 
> > Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> [..]
> 
> 
> > +static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
> > +				   struct cedrus_run *run,
> > +				   const u8 *ref_list, u8 num_ref,
> > +				   enum cedrus_h264_sram_off sram)
> > +{
> > +	const struct v4l2_ctrl_h264_decode_param *decode = run->h264.decode_param;
> > +	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
> > +	const struct vb2_buffer *dst_buf = &run->dst->vb2_buf;
> > +	struct cedrus_dev *dev = ctx->dev;
> > +	u8 sram_array[CEDRUS_MAX_REF_IDX];
> > +	unsigned int size, i;
> > +
> > +	memset(sram_array, 0, sizeof(sram_array));
> > +
> > +	for (i = 0; i < num_ref; i++) {
> > +		const struct v4l2_h264_dpb_entry *dpb;
> > +		const struct cedrus_buffer *cedrus_buf;
> > +		const struct vb2_v4l2_buffer *ref_buf;
> > +		unsigned int position;
> > +		int buf_idx;
> > +		u8 dpb_idx;
> > +
> > +		dpb_idx = ref_list[i];
> > +		dpb = &decode->dpb[dpb_idx];
> > +
> > +		if (!(dpb->flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE))
> > +			continue;
> > +
> > +		if (dst_buf->timestamp == dpb->timestamp)
> > +			buf_idx = dst_buf->index;
> > +		else
> > +			buf_idx = vb2_find_timestamp(cap_q, dpb->timestamp, 0);
> > +
> > +		if (buf_idx < 0)
> > +			continue;
> > +
> > +		ref_buf = to_vb2_v4l2_buffer(ctx->dst_bufs[buf_idx]);
> > +		cedrus_buf = vb2_v4l2_to_cedrus_buffer(ref_buf);
> > +		position = cedrus_buf->codec.h264.position;
> > +
> > +		sram_array[i] |= position << 1;
> > +		if (ref_buf->field == V4L2_FIELD_BOTTOM)
> > +			sram_array[i] |= BIT(0);
> > +	}
> > +
> > +	size = min((unsigned int)ALIGN(num_ref, 4), sizeof(sram_array));
> 
> Perhaps s/unsigned int/size_t, so the arguments to min() have the same type?
> 
> Otherwise, I got this warning:
> 
> /home/zeta/repos/linux/media_tree/drivers/staging/media/sunxi/cedrus/cedrus_h264.c: In function ‘_cedrus_write_ref_list’:
> /home/zeta/repos/linux/media_tree/include/linux/kernel.h:846:29: warning: comparison of distinct pointer types lacks a cast
>    (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))

Strange, I didn't notice any warning. I'll make sure to fix it.

Thanks!
Maxime

-- 
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
