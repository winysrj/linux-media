Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ACAC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14DD2084C
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 20:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="p3S0NLD5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E14DD2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbeLJUY1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 15:24:27 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:38862 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbeLJUY1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 15:24:27 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9E47554B;
        Mon, 10 Dec 2018 21:24:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544473465;
        bh=h4gGAhN9EwZtFZq2S+NcQhZcGpUOpVjWjrCn2e/AIrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3S0NLD5qt/w9W+/R2JEn8Y5xmb1Ac1hPqj+AyZUulHSC6zUeIyJHs5/Kw/KEqia8
         NKsp4Li0Y2Xy4JizEyfOsRMuRF7FB9qMsDHU8YFA31ePrGdSAZerdHQt3aIj6oA53T
         O5UaFlwUECKAwVtUMgFCKa1r9Y+RuaJT0JsM+rkk=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: vsp1: Fix trivial documentation
Date:   Mon, 10 Dec 2018 22:25:06 +0200
Message-ID: <3645934.BnSJS6SbSo@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20181207163134.14279-1-kieran.bingham+renesas@ideasonboard.com>
References: <20181207163134.14279-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

Thank you for the patch.

On Friday, 7 December 2018 18:31:34 EET Kieran Bingham wrote:
> In the partition sizing the term 'prevents' is inappropriately
> pluralized.  Simplify to 'prevent'.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 771dfe1f7c20..7ceaf3222145
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -223,7 +223,7 @@ static void vsp1_video_calculate_partition(struct
> vsp1_pipeline *pipe, * If the modulus is less than half of the partition
> size,
>  	 * the penultimate partition is reduced to half, which is added
>  	 * to the final partition: |1234|1234|1234|12|341|
> -	 * to prevents this:       |1234|1234|1234|1234|1|.
> +	 * to prevent this:        |1234|1234|1234|1234|1|.
>  	 */
>  	if (modulus) {
>  		/*


-- 
Regards,

Laurent Pinchart



