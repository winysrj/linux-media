Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57C1C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83F4320880
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 83F4320880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbeLMLZp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:25:45 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:47900 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726178AbeLMLZp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:25:45 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XP7fgdntFdllcXP7ggDZ3o; Thu, 13 Dec 2018 12:25:44 +0100
Subject: Re: [PATCH 3/3] videobuf2-core.h: Document the alloc memop size
 argument as page aligned
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, laurent.pinchart@ideasonboard.com
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <20181213104006.401-4-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <d1178ac1-7e3d-eda7-edb3-a98792717589@xs4all.nl>
Date:   Thu, 13 Dec 2018 12:25:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181213104006.401-4-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDbBaW25KBPFBumNv2nJQbVj2o2A8X6eC6OrmlfyXvRwYHD+ACMnQpfj8Z5ZPYB6gLdG6c+JL2Z6X9Omd1+2XCIkZagGvWyqysnJZK3jJ4QcRG/JUA8N
 ilekTqY5U7ejS3kVE1uRx3LJMFZvvXcKxulKreXSYkg4xn1V7Xlp2EFbXNUrU3yyEE50St7VDcJS7Y2TvZsxsYRcDV86AtBfB5ljQjvtqiRcrcWr/xWJo7TF
 NJ+47s3W/Gdm8Gd3XyT8OWms87hp3IuHLYZATVWLaQQQRUbNcUjuKo+DAAxLg7mo5D/lgYOQfa1qp6rNOK6I1aRzw99+Qao+DZgN9XgBBAMy3r5XzUQz9Btz
 XALmq5TEmiYsw40E+IrWBmi3bRlc/kAJyBTdFt8o408LRWP81L8=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/13/18 11:40 AM, Sakari Ailus wrote:
> The size argument of the alloc memop, which allocates buffer memory, is
> page aligned. Document it as such, as code elsewhere has not taken this
> into account.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  include/media/videobuf2-core.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index e86981d615ae4..68b9fe660e4f1 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -54,7 +54,8 @@ struct vb2_threadio_data;
>   *		will then be passed as @buf_priv argument to other ops in this
>   *		structure. Additional gfp_flags to use when allocating the
>   *		are also passed to this operation. These flags are from the
> - *		gfp_flags field of vb2_queue.
> + *		gfp_flags field of vb2_queue. The size argument to this function
> + *		shall be *page aligned*.
>   * @put:	inform the allocator that the buffer will no longer be used;
>   *		usually will result in the allocator freeing the buffer (if
>   *		no other users of this buffer are present); the @buf_priv
> 

