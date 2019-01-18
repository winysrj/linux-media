Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CAEC5ACD3
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44EF820883
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tXGZ3AD1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbfARTBo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:01:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33029 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbfARTBn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 14:01:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id r24so1628643wmh.0;
        Fri, 18 Jan 2019 11:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=o2aBihmd7kCS/IVyvwHcJEqsYBV/JMJi5NSNOXEgv4A=;
        b=tXGZ3AD1uewX/gkWlTNNLm2/qjJk40/HlKu7T3b5hToJ3gndB6XlsgDvcU0EVv/Wfc
         c6KP9BFVovCKcxm1yXXnqRtP3TS4DCMi47r2Agnkj1OZKebaI/2N8+OR/DuLpqN7tUUw
         EXxCE9wwz2GXxsM6UnK6uOGWYlw56iR9qFYC0cwK4n2ex3afnTnHfnDAglwJaS9NYsro
         OGas3G9kIDDfnDwhTaoVwzyTTg98NvdTLtMc7GriibzccJ0r8VAuT03aIHoKnBeD3fGU
         FH4Pf7CBBPCPLnXbdH7RbxsU36xdAC/VYJgKXWFKyPySxPe09cE83bTnqabBMKMQnivi
         YLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o2aBihmd7kCS/IVyvwHcJEqsYBV/JMJi5NSNOXEgv4A=;
        b=VXjow91VBEpFgJ3f7UhhKGw2jDWo4yAKKp36WYjvrFwyfXZuDLhLnpjfQdCLIargQ0
         VHH/OYTm5mKmBp6lDHgia/rQhLU0/EMSRaDT4W7eH5T2vtwsuasRmm8oa2fYtN15tgL5
         wmra2s+Ycyantml09TUIiBvlmHZobYhsJaBb8fjXODLBTsm85HqXZj1FU1j/ijidqik/
         KCYBXPbufpDP3EgL3HV3AK81ml66IMkknGbgw2qL9CIEDpIZrDcbLMp4dyrWl2PpFwcK
         PA7iJydY5uTGnkeAE5I7KvjJcwkvIklEKh9N7natCF1rMGRAR06XoYgAgp0JIO/UVGyv
         pdSQ==
X-Gm-Message-State: AJcUukdpbku/EcG38/9HTESLjzBDrDOeGjCp4NY+uY/3FA2RIBHlMpXN
        uHd1J7dtayZzVGY0Yb2wAUwjhIBN
X-Google-Smtp-Source: ALg8bN56wZ5fgNVJwFuW9dR2p//ZaZ9K/zujqfjUGMJmJTZgU+X1tgP0EFVv0vikyPlOPU05Nx0UDw==
X-Received: by 2002:a1c:e345:: with SMTP id a66mr16368663wmh.12.1547838100050;
        Fri, 18 Jan 2019 11:01:40 -0800 (PST)
Received: from [172.30.88.68] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o9sm27557988wmh.3.2019.01.18.11.01.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jan 2019 11:01:39 -0800 (PST)
Subject: Re: [PATCH v2 1/2] media: imx: csi: Disable CSI immediately after
 last EOF
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190117204912.28456-1-slongerbeam@gmail.com>
 <20190117204912.28456-2-slongerbeam@gmail.com>
 <1547807043.3375.3.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <56b43909-136b-fce0-e743-26cd6afd0eea@gmail.com>
Date:   Fri, 18 Jan 2019 11:01:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1547807043.3375.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/18/19 2:24 AM, Philipp Zabel wrote:
> On Thu, 2019-01-17 at 12:49 -0800, Steve Longerbeam wrote:
>> Disable the CSI immediately after receiving the last EOF before stream
>> off (and thus before disabling the IDMA channel).
>>
>> This fixes a complete system hard lockup on the SabreAuto when streaming
>> from the ADV7180, by repeatedly sending a stream off immediately followed
>> by stream on:
>>
>> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
>>
>> Eventually this either causes the system lockup or EOF timeouts at all
>> subsequent stream on, until a system reset.
>>
>> The lockup occurs when disabling the IDMA channel at stream off. Disabling
>> the CSI before disabling the IDMA channel appears to be a reliable fix for
>> the hard lockup.
>>
>> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
>>
>> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>> Changes in v2:
>> - restore an empty line
>> - Add Fixes: and Cc: stable
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index e18f58f56dfb..e0f6f88e2e70 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -681,6 +681,8 @@ static void csi_idmac_stop(struct csi_priv *priv)
>>   	if (ret == 0)
>>   		v4l2_warn(&priv->sd, "wait last EOF timeout\n");
>>   
>> +	ipu_csi_disable(priv->csi);
>> +
> Can you add a short comment why this call is here? Since now
> csi_idmac_stop is kind of a misnomer and symmetry with csi(_idmac)_start
> is broken, I think this is a bit un-obvious.

Yeah. I think a cleaner, more symmetric solution would be to split up 
csi_idmac_stop.

>
> Also note that now the error path of csi_start() will now call
> ipu_csi_disable() while the CSI is disabled. This happens to work
> because that just calls ipu_module_disable(), which is not refcounted.

Thanks for catching. Splitting up csi_idmac_stop will fix this. Working 
on that.

Steve

>
>>   	devm_free_irq(priv->dev, priv->eof_irq, priv);
>>   	devm_free_irq(priv->dev, priv->nfb4eof_irq, priv);
>>   
>> @@ -793,9 +795,9 @@ static void csi_stop(struct csi_priv *priv)
>>   		/* stop the frame interval monitor */
>>   		if (priv->fim)
>>   			imx_media_fim_set_stream(priv->fim, NULL, false);
>> +	} else {
>> +		ipu_csi_disable(priv->csi);
>>   	}
>> -
>> -	ipu_csi_disable(priv->csi);
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> regards
> Philipp

