Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FC1C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A10EA2086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 12:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HXE64boC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A10EA2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbeLMM5B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 07:57:01 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:55150 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbeLMM5B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 07:57:01 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 03555549;
        Thu, 13 Dec 2018 13:56:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544705819;
        bh=tbDd4PW+CvBm/VaNdzcbtdQ1xaJ/tAey7YTv3oLXgKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXE64boC3/up5b+SPfOWvu2BatsBK7eiYAa9WJE5R4r8DT8SWD/wo4EgR0eObWW0j
         5IAFzF0K7dNRwLPHoW7xq+MeHi68CC/71luaZfjbb/KMKk5T66lyH5zqFkDIIbRW2k
         hDuQAxH4h2xPJ3rzodzJwstmRQHG4aeS61WpPyq8=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl, mchehab@kernel.org
Subject: Re: [PATCH 2/3] videobuf2-dma-sg: Prevent size from overflowing
Date:   Thu, 13 Dec 2018 14:57:46 +0200
Message-ID: <4785676.KSXsKKKZGc@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181213104006.401-3-sakari.ailus@linux.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com> <20181213104006.401-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Thank you for the patch.

On Thursday, 13 December 2018 12:40:05 EET Sakari Ailus wrote:
> buf->size is an unsigned long; casting that to int will lead to an
> overflow if buf->size exceeds INT_MAX.
> 
> Fix this by changing the type to unsigned long instead. This is possible
> as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> will never have values lesser than 0.

This feels a bit fragile to me. We at least need a big comment in the code to 
explain this. Another option would be a size -= min(..., size) just to make 
sure.

> Note on backporting to stable: the file used to be under
> drivers/media/v4l2-core, it was moved to the current location after 4.14.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> b/drivers/media/common/videobuf2/videobuf2-dma-sg.c index
> 015e737095cdd..e9bfea986cc47 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -59,7 +59,7 @@ static int vb2_dma_sg_alloc_compacted(struct
> vb2_dma_sg_buf *buf, gfp_t gfp_flags)
>  {
>  	unsigned int last_page = 0;
> -	int size = buf->size;
> +	unsigned long size = buf->size;
> 
>  	while (size > 0) {
>  		struct page *pages;

-- 
Regards,

Laurent Pinchart



