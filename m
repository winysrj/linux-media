Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5804C282F6
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95E7720879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 10:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfAUKSc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:18:32 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58017 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfAUKSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 05:18:32 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lWewgWg25BDyIlWezgO9lW; Mon, 21 Jan 2019 11:18:29 +0100
Subject: Re: [PATCH v5 0/6] media: vicodec: source change support
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190120132907.30812-1-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aea59f97-8a7c-d49b-704c-26fbab45d055@xs4all.nl>
Date:   Mon, 21 Jan 2019 11:18:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190120132907.30812-1-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKvkj/UxdLqlSkxarkKAnJK/s/w6JzXuehU0tfW4vtiKW0AAKoTZR3IBhtVFjKb/Et7kpcZbaZSfrfGqSjQnVNDvCFQvxkKXHfRPu9+Bt7l6A7GqyINt
 iRC777+bpWZgHF2o/n6xaOa9nDfe0OVBF9zLRaUt7ZXSjvP7OmlJtcLFpDH/xXEPw+G8EPj/CMUHmVaHmX+E074Fi7BEh+PoLtzydDQmqIoFILc0wfzZBzDT
 S/UZsL1qRYA7D50R2VyQ8w==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dafna,

On 01/20/2019 02:29 PM, Dafna Hirschfeld wrote:
> Main changes from v4:
> 1. in patch 5/6 - bugfix in get_next_header
> if memchr returns NULL, set p to p_src + sz
> 2. in 6/6 - some bugfixzes in buf_queue callback
> and remove the field comp_frame_size from vicodec_ctx
> since it can already be accessed from state.header.
> This also fixes a bug where comp_frame_size was set only
> when the full header is dound in job_ready
> 
> Dafna Hirschfeld (6):
>   media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
>   media: vicodec: add support for CROP and COMPOSE selection
>   media: vicodec: use 3 bits for the number of components
>   media: vicodec: Add pixel encoding flags to fwht header
>   media: vicodec: Separate fwht header from the frame data
>   media: vicodec: Add support for resolution change event.
> 
>  drivers/media/platform/vicodec/codec-fwht.c   |  80 ++-
>  drivers/media/platform/vicodec/codec-fwht.h   |  25 +-
>  .../media/platform/vicodec/codec-v4l2-fwht.c  | 384 +++++++----
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |  15 +-
>  drivers/media/platform/vicodec/vicodec-core.c | 611 ++++++++++++++----
>  5 files changed, 812 insertions(+), 303 deletions(-)
> 

I wanted to apply these patches to make a pull request, but I am getting a few
too many checkpatch warnings about lines that are too long:

$ git am -s ~/bundle-677-b1.mbox
Applying: media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
total: 0 errors, 0 warnings, 69 lines checked

Your patch has no obvious style problems and is ready for submission.

Applying: media: vicodec: add support for CROP and COMPOSE selection
WARNING: line over 80 characters
#156: FILE: drivers/media/platform/vicodec/codec-fwht.c:812:
+                        u32 height, u32 width, u32 coded_width, bool uncompressed)

WARNING: line over 80 characters
#181: FILE: drivers/media/platform/vicodec/codec-fwht.c:841:
+                                       add_deltas(cf->de_fwht, refp, coded_width);

WARNING: line over 80 characters
#182: FILE: drivers/media/platform/vicodec/codec-fwht.c:842:
+                               fill_decoder_block(refp, cf->de_fwht, coded_width);

WARNING: line over 80 characters
#342: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:176:
+                                    state->visible_width, state->visible_height,

WARNING: line over 80 characters
#419: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:260:
+       if (hdr_width_div != info->width_div || hdr_height_div != info->height_div)

WARNING: line over 80 characters
#424: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:264:
+                         state->visible_width, state->visible_height, state->coded_width);

WARNING: line over 80 characters
#510: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:334:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#535: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:354:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#551: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:365:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#569: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:378:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#587: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:391:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#605: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:404:
+                       for (j = 0, p = p_out; j < state->coded_width / 2; j++) {

WARNING: line over 80 characters
#770: FILE: drivers/media/platform/vicodec/vicodec-core.c:463:
+               pix->bytesperline = q_data->coded_width * info->bytesperline_mult;

WARNING: line over 80 characters
#797: FILE: drivers/media/platform/vicodec/vicodec-core.c:523:
+               pix->width = vic_round_dim(clamp(pix->width, MIN_WIDTH, MAX_WIDTH), info->width_div);

WARNING: line over 80 characters
#798: FILE: drivers/media/platform/vicodec/vicodec-core.c:524:
+               pix->height = vic_round_dim(clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);

WARNING: line over 80 characters
#809: FILE: drivers/media/platform/vicodec/vicodec-core.c:540:
+               pix_mp->width = vic_round_dim(clamp(pix_mp->width, MIN_WIDTH, MAX_WIDTH), info->width_div);

WARNING: line over 80 characters
#810: FILE: drivers/media/platform/vicodec/vicodec-core.c:541:
+               pix_mp->height = vic_round_dim(clamp(pix_mp->height, MIN_HEIGHT, MAX_HEIGHT), info->height_div);

WARNING: line over 80 characters
#938: FILE: drivers/media/platform/vicodec/vicodec-core.c:812:
+       if (!ctx->is_enc || s->type != out_type || s->target != V4L2_SEL_TGT_CROP)

WARNING: line over 80 characters
#943: FILE: drivers/media/platform/vicodec/vicodec-core.c:817:
+       q_data->visible_width = clamp(s->r.width, MIN_WIDTH, q_data->coded_width);

WARNING: line over 80 characters
#945: FILE: drivers/media/platform/vicodec/vicodec-core.c:819:
+       q_data->visible_height = clamp(s->r.height, MIN_HEIGHT, q_data->coded_height);

WARNING: line over 80 characters
#983: FILE: drivers/media/platform/vicodec/vicodec-core.c:1086:
+                       state->stride = q_data->coded_width * info->bytesperline_mult;

total: 0 errors, 21 warnings, 951 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Your patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Applying: media: vicodec: use 3 bits for the number of components
total: 0 errors, 0 warnings, 8 lines checked

Your patch has no obvious style problems and is ready for submission.

Applying: media: vicodec: Add pixel encoding flags to fwht header
WARNING: line over 80 characters
#76: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:40:
+const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div, u32 height_div,

WARNING: line over 80 characters
#79: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.c:43:
+                                                         unsigned int start_idx)

WARNING: line over 80 characters
#144: FILE: drivers/media/platform/vicodec/codec-v4l2-fwht.h:53:
+                                                         unsigned int start_idx);

WARNING: line over 80 characters
#157: FILE: drivers/media/platform/vicodec/vicodec-core.c:398:
+static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx, bool is_out)

WARNING: line over 80 characters
#170: FILE: drivers/media/platform/vicodec/vicodec-core.c:408:
+               const struct v4l2_fwht_pixfmt_info *info = get_q_data(ctx, f->type)->info;

total: 0 errors, 5 warnings, 174 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Your patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Applying: media: vicodec: Separate fwht header from the frame data
total: 0 errors, 0 warnings, 211 lines checked

Your patch has no obvious style problems and is ready for submission.

Applying: media: vicodec: Add support for resolution change event.
WARNING: line over 80 characters
#21: FILE: drivers/media/platform/vicodec/vicodec-core.c:327:
+static const struct v4l2_fwht_pixfmt_info *info_from_header(const struct fwht_cframe_hdr *p_hdr)

WARNING: line over 80 characters
#76: FILE: drivers/media/platform/vicodec/vicodec-core.c:382:
+       unsigned int hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;

WARNING: line over 80 characters
#77: FILE: drivers/media/platform/vicodec/vicodec-core.c:383:
+       unsigned int hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;

WARNING: line over 80 characters
#175: FILE: drivers/media/platform/vicodec/vicodec-core.c:489:
+       if (ctx->comp_has_frame && sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {

total: 0 errors, 4 warnings, 484 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

Your patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Can you make a v6 that fixes this?

Otherwise this series looks good.

Regards,

	Hans
