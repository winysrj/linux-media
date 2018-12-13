Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501FEC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F1220870
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="YmTGGQXu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14F1220870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbeLMMtA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:49:00 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54764 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728517AbeLMMtA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:49:00 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8BBEC549;
        Thu, 13 Dec 2018 13:48:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544705338;
        bh=MWs9zy2sg+3YTvgXLZCzVUQtClfmZwTBWgqPbZ6sBE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmTGGQXuh5Ty9JMs+0MsI1K7JJDi4hBm2733c4MhjzIUXuoG822kUftSUmihoG6q/
         MmAltgtMYwGIgUmsqAOoX9x6UzA3T1E/4ZV/9fI5cufp3DTo2r5W75sp+gDE5cg3iE
         YQOU+xkNxOyBC4mHEYwuh9w8TxL+cdBbaMHGy/Go=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 1/3] videobuf2-core: Prevent size alignment wrapping buffer size to 0
Date:   Thu, 13 Dec 2018 14:49:44 +0200
Message-ID: <11116293.zm9aLRIdQE@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181213104006.401-2-sakari.ailus@linux.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com> <20181213104006.401-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Thursday, 13 December 2018 12:40:04 EET Sakari Ailus wrote:
> PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> checking that the aligned value is not smaller than the unaligned one.
> 
> Note on backporting to stable: the file used to be under
> drivers/media/v4l2-core, it was moved to the current location after 4.14.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c
> b/drivers/media/common/videobuf2/videobuf2-core.c index
> 0ca81d495bdaf..0234ddbfa4de2 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
> 
> +		/* Did it wrap around? */
> +		if (size < vb->planes[plane].length)
> +			goto free;
> +
>  		mem_priv = call_ptr_memop(vb, alloc,
>  				q->alloc_devs[plane] ? : q->dev,
>  				q->dma_attrs, size, q->dma_dir, q->gfp_flags);

Wouldn't it be better to reject length > INT_MAX (or some variations of that) 
a few steps before, for instance just before calling __vb2_queue_alloc() ? 
There's already a check in vb2_core_reqbufs():

        /* Check that driver has set sane values */
        if (WARN_ON(!num_planes))
                return -EINVAL;

        for (i = 0; i < num_planes; i++)
                if (WARN_ON(!plane_sizes[i]))
                        return -EINVAL;

It could be extended to validate the sizes against wrap-around, and moved to a 
separate function to be called in vb2_core_create_bufs() as well (as those 
checks are missing there). Alternatively, the checks could be moved to the 
beginning of __vb2_queue_alloc().

-- 
Regards,

Laurent Pinchart



