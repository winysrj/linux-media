Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0479FC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 08:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C652620856
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 08:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="DMg2Qg2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfCZIza (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 04:55:30 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:32851 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfCZIz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 04:55:29 -0400
Received: by mail-lj1-f196.google.com with SMTP id f23so10387992ljc.0
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 01:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CSqLyd1qqQ5g5t6R5OSPrsrB0O28htgLwCty7rfYmg8=;
        b=DMg2Qg2jP45Ru10WFKCRk4IkmDE4254N9ibTa9SQ9B/aDhRb1Y3VjGtkJ1NniP2lLH
         cfyIp0yibf3EG1olrOPM10ynsHBp7lK44lJXo2rAjOrZgreXJGnRc4yiyjP01OewNx/z
         aKhAczwifK4MO0//6GkRZjN1cvsRVIzw3OCDlhnwwMbp/itVF0FyGEE+4t3ExN/W4LmF
         UyVLC9bjsnHWy3QJmoatHGLE64s/h1mIN8sLZp1REBYkUVJa2UnHtOm1u1eDWRtO7qHp
         uYBQFyaoaZ9Aa63hwoLsJN0wVMYFX0cA+idSrPN0MSEmCYMsCazkjI0HTv/ziqiIQ1gg
         DpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CSqLyd1qqQ5g5t6R5OSPrsrB0O28htgLwCty7rfYmg8=;
        b=UIrFEHwYypSQdviqnJTEjcU9Ys950UuS/ZxUMQal6kbb/I/a4LR81s0vl0ZjtcjBda
         6cDCMDg9jXjh1pUQ999ZyfWEZjNxC8pcPW8ZlcNtWhleY4mRfUC9jm/7zp4Rvm8T1vLM
         2WorL7aJFZeU/EvtpZjFF15KJgw44m8IhZGShNY394tlYDUXigpmWLZheN8DYoSWh88G
         tlM1a58Gb9EQGMvaEO8dm5Y+o48xlFaj8vD6x0yrJ7CvIchovvNSbDGUPslv3dbY/3sY
         wgWDwb0mtPJetjZaH4Ds1ziP+oO60ItdwAdJ5zE/TEl/yCiU5xVIdxFwKyfoEy0QjHrN
         rkIQ==
X-Gm-Message-State: APjAAAX+w1SMzsJjxJMJiljeNM/TUUDJ7WCS8lpecYhoK4YDrXV0NGCs
        n32HjDCCdvPnaAUgB2xWNr/weQ==
X-Google-Smtp-Source: APXvYqyrM0Ju/1HQuizG2QXMKnicgl9K3SVPu+Q8s/5EgKGFzvxDhDIbZOhcvFqc8J8rIJnOvzutSw==
X-Received: by 2002:a2e:9010:: with SMTP id h16mr7067101ljg.16.1553590527703;
        Tue, 26 Mar 2019 01:55:27 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.243])
        by smtp.gmail.com with ESMTPSA id q5sm3908370lfm.16.2019.03.26.01.55.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 01:55:26 -0700 (PDT)
Subject: Re: [PATCH 4/5] media: rcar-dma: p_set can't be NULL
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        linux-renesas-soc@vger.kernel.org
References: <cover.1553551369.git.mchehab+samsung@kernel.org>
 <bf78f23acf023d5bc9d31bab2918a3092dc821f0.1553551369.git.mchehab+samsung@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <bd186557-8027-a221-bdaf-1653659193a5@cogentembedded.com>
Date:   Tue, 26 Mar 2019 11:55:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <bf78f23acf023d5bc9d31bab2918a3092dc821f0.1553551369.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello!

    I'd have used instead (or at least mentioned) the driver's name (rcar-vin) 
in the subject.

On 26.03.2019 1:03, Mauro Carvalho Chehab wrote:
> The only way for p_set to be NULL would be if vin_coef_set would be an
> empty array.
> 
> On such case, the driver will OOPS, as it would try to de-reference a
> NULL value. So, the check if p_set is not NULL doesn't make any sense.
> 
> Solves those two smatch warnings:
> 
> 	drivers/media/platform/rcar-vin/rcar-dma.c:489 rvin_set_coeff() warn: variable dereferenced before check 'p_set' (see line 484)
> 	drivers/media/platform/rcar-vin/rcar-dma.c:494 rvin_set_coeff() error: we previously assumed 'p_set' could be null (see line 489)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>   drivers/media/platform/rcar-vin/rcar-dma.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 2207a31d355e..91ab064404a1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -486,7 +486,7 @@ static void rvin_set_coeff(struct rvin_dev *vin, unsigned short xs)
>   	}
>   
>   	/* Use previous value if its XS value is closer */
> -	if (p_prev_set && p_set &&
> +	if (p_prev_set &&
>   	    xs - p_prev_set->xs_value < p_set->xs_value - xs)
>   		p_set = p_prev_set;
>   

MBR, Sergei
