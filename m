Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218EBC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E601220855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 19:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfAQThD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 14:37:03 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41626 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfAQThD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 14:37:03 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id EC95D27078E
Message-ID: <8c6b01796a96120fc34c0b944420e6cfb7e3c626.camel@collabora.com>
Subject: Re: [PATCHv6 1/8] v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper
 function
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Date:   Thu, 17 Jan 2019 16:36:55 -0300
In-Reply-To: <20190107113441.21569-2-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
         <20190107113441.21569-2-hverkuil-cisco@xs4all.nl>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 2019-01-07 at 12:34 +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Memory-to-memory devices should copy various parts of
> struct v4l2_buffer from the output buffer to the capture buffer.
> 
> Add a helper function that does that to simplify the driver code.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> ---
> 
[..]
> +
>  void v4l2_m2m_request_queue(struct media_request *req)
>  {
>  	struct media_request_object *obj, *obj_safe;
> diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
> index 5467264771ec..43e447dcf69d 100644
> --- a/include/media/v4l2-mem2mem.h
> +++ b/include/media/v4l2-mem2mem.h
> @@ -622,6 +622,26 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
>  	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
>  }
>  
> +/**
> + * v4l2_m2m_buf_copy_data() - copy buffer data from the output buffer to the
> + * capture buffer
> + *

On revisiting this patchset, I've noticed that the name and the
description is really confusing as it strongly suggests this function
will copy the
contents of the buffer.

Can we maybe replace it with v4l2_m2m_buf_copy_metadata?

Too bad I didn't spot this earlier.

Ezequiel

