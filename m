Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E686EC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3EB82087C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:33:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="St3LT0oV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CvlmPMEV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbfC0NdO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:33:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbfC0NdO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 09:33:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F2EE2611FB; Wed, 27 Mar 2019 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553693593;
        bh=YD26BmPRGpfeY51Nd+t+n+eyeLSlDFrvhIV82plNaYg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=St3LT0oVOgBzfeVR+9yLSI3VMj+a6LqlKLPxvtQ9xQwUSyKoQaJcySuQZCXk3PnzV
         QJtVcl7AkRhlAVCh5n+PRaylWZEsNoPSQbzHQWyds93PabbL5VU8zFZvX3R1v7Znr+
         /oSM+eB6AlZukpkhWSGcjLAXVq6edtOOUcdYIMN0=
Received: from [10.204.79.83] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02DAD611FB;
        Wed, 27 Mar 2019 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553693590;
        bh=YD26BmPRGpfeY51Nd+t+n+eyeLSlDFrvhIV82plNaYg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CvlmPMEVe5Eo0DPLjGtn0QTB0X8ZEz2xPz3US+p6nw/LG/9n7AQ8iW3HI6WufbNqx
         kqGvxvLae8519FO7bckSfrGQtAZ4Y/WH/Ssj6uk6NuLBt12gs9ZG3zBKWg8Wll6alA
         mnhkMdOJNmsyYRwylfd8XA2bR/IYFjfR4VJaFZzU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 02DAD611FB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] media: vpss: fix a potential NULL pointer dereference
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190309065351.1184-1-kjlu@umn.edu>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <521823d8-a884-2772-5f18-9fc8809b69e4@codeaurora.org>
Date:   Wed, 27 Mar 2019 19:03:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190309065351.1184-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 3/9/2019 12:23 PM, Kangjie Lu wrote:
> In case ioremap fails, the fix returns -ENOMEM to avoid NULL
> pointer dereference.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

-Mukesh


> ---
>   drivers/media/platform/davinci/vpss.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
> index 19cf6853411e..f7beed2de9cb 100644
> --- a/drivers/media/platform/davinci/vpss.c
> +++ b/drivers/media/platform/davinci/vpss.c
> @@ -518,6 +518,9 @@ static int __init vpss_init(void)
>   		return -EBUSY;
>   
>   	oper_cfg.vpss_regs_base2 = ioremap(VPSS_CLK_CTRL, 4);
> +	if (unlikely(!oper_cfg.vpss_regs_base2))
> +		return -ENOMEM;
> +
>   	writel(VPSS_CLK_CTRL_VENCCLKEN |
>   		     VPSS_CLK_CTRL_DACCLKEN, oper_cfg.vpss_regs_base2);
>   
