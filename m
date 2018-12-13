Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3246AC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 034EA20880
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 11:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 034EA20880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbeLMLYH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 06:24:07 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:45568 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728733AbeLMLYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 06:24:06 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XP63gdmzMdllcXP64gDYcf; Thu, 13 Dec 2018 12:24:04 +0100
Subject: Re: [PATCH 2/3] videobuf2-dma-sg: Prevent size from overflowing
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, laurent.pinchart@ideasonboard.com
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
 <20181213104006.401-3-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a65dd1c9-bfdb-e854-027e-23059f8f4300@xs4all.nl>
Date:   Thu, 13 Dec 2018 12:24:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181213104006.401-3-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHd/bLHzF+MlxUpm5SQxGP8J1zj8IKxoWDhKf7+PVgRwwwvP4Tkf3UvVVTk9Ewkaz0aXvsn6ycPOz9sFHeRQ1tba7C2AbuJhLetUWpcgl91HF4/Dk/2V
 F1L1OXdbhOhaEtF6Qtf581q8pJ0JE3aPG87xt7Dh85rQhqQ04SD9wE1Klqt9FtHKSvIlXRpOOhzWo62hR6FtmWMf4BYL9ho98Fwj7B1PI1DXQMVKMu+FtSrx
 ae/Hk92JwQ33dnHa9Db3OOx6X/ZDWZVya6BnQ3L4BSBz4v2nx/PiQIX3SyfRiB1lgbx+2hao/rPi19GQBZixoE+rgidfs4CkzoPp2ExJ1tpw4bsBMeXhkGZa
 xy0096Sqa3GmUyArNBcSlslLUqy9rQxgzLdYt+n3IA2Z1Q1E9SA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/13/18 11:40 AM, Sakari Ailus wrote:
> buf->size is an unsigned long; casting that to int will lead to an
> overflow if buf->size exceeds INT_MAX.
> 
> Fix this by changing the type to unsigned long instead. This is possible
> as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> will never have values lesser than 0.
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
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 015e737095cdd..e9bfea986cc47 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -59,7 +59,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>  		gfp_t gfp_flags)
>  {
>  	unsigned int last_page = 0;
> -	int size = buf->size;
> +	unsigned long size = buf->size;
>  
>  	while (size > 0) {
>  		struct page *pages;
> 

