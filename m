Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667A3C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357362147C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 12:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AViqVceg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="pP15t0rx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729104AbfC0M63 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:58:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfC0M6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 08:58:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2527960A44; Wed, 27 Mar 2019 12:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553691504;
        bh=d78/h/tHRsNnx9gRlWBavJP4nZRXWlNrGu1vdw/qw4U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=AViqVceghdeotuDtBHCrcOAziTsjPD0aVxU5FqO1MMMbCEtNIFmWib+IWPfdTkL2K
         hyKFwAggv7CzsFufdFCqXN0GfcaxNvphBE/YjfzQRKBOOVi22bE2k7cy/Xm/tMPN5P
         2akZWv9WYiNbH5EijL+UWupIGRP1U15bdsTclDlw=
Received: from [10.204.79.83] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C86DF60736;
        Wed, 27 Mar 2019 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553691503;
        bh=d78/h/tHRsNnx9gRlWBavJP4nZRXWlNrGu1vdw/qw4U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pP15t0rxOoP+i9OBkxAS2voMB7k1V2OwumxniZ+bUxIBnBUkx/7OfOS7kiq1GZ1q0
         f8R6S8jw/ZbYdl3QBisTxyBFq5hDgBj1kSJc+SQyXJFHJTxkVvlILtyUSWWGaF2pxp
         jbURJOeWXz2/qf/tfHDlnpCaC80jPiZ28r4B18Lo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C86DF60736
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] media: vpss: fix a potential NULL pointer dereference
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190323025106.15865-1-kjlu@umn.edu>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <f54947a6-8b9c-18d5-4e9b-d33d504131c6@codeaurora.org>
Date:   Wed, 27 Mar 2019 18:28:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190323025106.15865-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 3/23/2019 8:21 AM, Kangjie Lu wrote:
> In case ioremap fails, the fix returns -ENOMEM to avoid NULL
> pointer dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>


Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

-Mukesh

> ---
>   drivers/media/platform/davinci/vpss.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
> index 19cf6853411e..89a86c19579b 100644
> --- a/drivers/media/platform/davinci/vpss.c
> +++ b/drivers/media/platform/davinci/vpss.c
> @@ -518,6 +518,11 @@ static int __init vpss_init(void)
>   		return -EBUSY;
>   
>   	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
> +	if (unlikely(!oper_cfg.vpss_regs_base2)) {
> +		release_mem_region(VPSS_CLK_CTRL, 4);
> +		return -ENOMEM;
> +	}
> +
>   	writel(VPSS_CLK_CTRL_VENCCLKEN |
>   		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
>   
