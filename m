Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A912C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A3520651
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ILsx9rVy";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oIiAUAAY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfC0PMj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:12:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbfC0PMj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:12:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5EC816081E; Wed, 27 Mar 2019 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553699558;
        bh=t0xNuPpwNdSkkA57YiWakkBis9uX0mb8p8IOUiZAdpg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ILsx9rVyLWK8yKCtiBdFuxsfYpyE1WwsqQhNcUH/Hwh0TJq8IgKZa80Ug+2VCmzKY
         XvBdBTjGrvmiD3s1z3PbhT2GyC1+K1JLV5MIx3g0D7ii0E/g2V+tX9q1jqNBhu9lZ7
         Kgc2wuDC9n0o6tr48KteFt+XbjnmfEq9gH1/fKdk=
Received: from [10.204.79.83] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC2F16079C;
        Wed, 27 Mar 2019 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553699557;
        bh=t0xNuPpwNdSkkA57YiWakkBis9uX0mb8p8IOUiZAdpg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=oIiAUAAY78+YD0hyajKFZMWil/ZgZE3R41+FBDr45jAnIxEqzX+XQl58/mRK4DRZY
         yU8H+EKpAXh+YUWF0HtUHtVqpwqji99urW6ua5Fs1WK4xG2x4AZCTGvtobimIvEqAi
         D943MT7jKx7bxXlLKfmLPQx2UYWYhOn6V4Igl6Bw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC2F16079C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] media: tuners: fix a missing check for regmap_write_bits
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Olli Salonen <olli.salonen@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190324232110.2804-1-kjlu@umn.edu>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <2cac6391-c328-873c-2cc4-f20b4643e0d7@codeaurora.org>
Date:   Wed, 27 Mar 2019 20:42:32 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190324232110.2804-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


On 3/25/2019 4:51 AM, Kangjie Lu wrote:
> regmap_write_bits could fail and thus deserves a check.
>
> The fix returns its error code upstream in case it fails.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

-Mukesh
> ---
>   drivers/media/tuners/tda18250.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/tuners/tda18250.c b/drivers/media/tuners/tda18250.c
> index 20d10ef45ab6..36ede1b02d23 100644
> --- a/drivers/media/tuners/tda18250.c
> +++ b/drivers/media/tuners/tda18250.c
> @@ -703,6 +703,8 @@ static int tda18250_set_params(struct dvb_frontend *fe)
>   
>   	/* charge pump */
>   	ret = regmap_write_bits(dev->regmap, R46_CPUMP, 0x07, buf[2]);
> +	if (ret)
> +		goto err;
>   
>   	return 0;
>   err:
