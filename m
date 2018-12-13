Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF37C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4251D208E7
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4251D208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbeLMLWU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:22:20 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:40346 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728674AbeLMLWT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:22:19 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XP44gdltxdllcXP45gDY6l; Thu, 13 Dec 2018 12:22:17 +0100
Subject: Re: [PATCH 1/3] videobuf2-core: Prevent size alignment wrapping
 buffer size to 0
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, laurent.pinchart@ideasonboard.com
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <20181213104006.401-2-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <e9f266c9-a3e0-9e16-03a7-c01220ade2f4@xs4all.nl>
Date:   Thu, 13 Dec 2018 12:22:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181213104006.401-2-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfD07fkT5Yd1tvs0i6Ae+vDNeh7pvfSgc5M2RUEqqzWXwpe+SRpJmXRXvkVdWZhd1rpvGJ1gYuWF+eq33p8+NTxf0FS2igljEp1bbXPuD5wfk44QHVOR/
 4Fu0VKnbB4Q3U/HlXmIGCKobFPu3uJA2BY6VcON32ewmcErBRJPcaUnfSjc862optRuBSJWRodeK4Il5uAOLI+xpEEUY4xieIkzJFGHMcgx2wMLCLh81rQpV
 ZGEJnU5w6vuE5XRwkxqwL+RZWZhbhYwBLSWlo5gsR/QnTlvdhjjUlRyo1cEEfVmYYqeZFmFmHhw91Z0udZ7q5ie4HzgHQdmzmDMZGTvyov497pJDm0vNcEa/
 6WN59KMpzqMWxXeCzS4lVEmaK1x2iz7tbBoYoGb532I+//ULAmE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/13/18 11:40 AM, Sakari Ailus wrote:
> PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
> checking that the aligned value is not smaller than the unaligned one.
> 
> Note on backporting to stable: the file used to be under
> drivers/media/v4l2-core, it was moved to the current location after 4.14.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 0ca81d495bdaf..0234ddbfa4de2 100644
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
> 

