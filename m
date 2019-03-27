Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5A9C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6289921734
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 13:08:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="HHvZJWsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfC0NIf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:08:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36411 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbfC0NIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 09:08:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id h18so16748409wml.1
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2019 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=o9uJEjl7eHJ6UJweIfITCGVkOb/EtrHXodgXHlNELLY=;
        b=HHvZJWslhLFIo/A0/ILiF+o3wvu9fkUp4z3y1pdcDrhbDYED9J7Sto/TLrRYxxYU1m
         tppSqBuGU5DxCYX9xeFlFpYOJ6c21tr6dOxG5y+X1UQ6KxMzO7Pf4toEaKxTIb4F0/sS
         Tm4VyO+UbcYGHMvQIP7FFta5T2AP2su0+6j4fnPPN0SGNCNRohIjkj0f18AxIjcPmr+T
         ju1abw/6IYlH5fjql1rt+50p+DoOvlgjh2vFbJTerluVxdI7exS9j6jOXB4ZGISJ8Ma0
         ccaZv88N28PTvQO2WzLnVaSICfeZTyzqMA5IH8TaPmDoRw19eCuVbpWj8j7rWJ3X6bwn
         GJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=o9uJEjl7eHJ6UJweIfITCGVkOb/EtrHXodgXHlNELLY=;
        b=ENOF6wIEBupBsPAINT4RDGfQzy4DxVJ46l2vF4dnfwKNywd70I8BCjT/LzzECij5Fi
         tN8+6A/dbsFCIfC8ZEh9Ih8/+UpanDsXLG5SwYq5NcVX7EoVjaDHoZExx4gaf9JKk01z
         1NJtPVXt1Zcq1J7nHEdoZsR0P6lQ5/5gjZmcri25Ibp+99X4Iw4TlZWR/67yuwWHBPjd
         +/HsakXXw0gIuXMlckKtvEiyq8skozB405+vGj48CerWQefIeXh6y6wwIA7xUpsM4Z1g
         BvXYG7QDWvni1A31NHZ3K+cO69Lr7GUGOUR7Gjg/cEUUwzFV/aBIGOcg0HhvPpZHuDGi
         ERnw==
X-Gm-Message-State: APjAAAUJjxzGwZAMX44nfVmdwBSjr/BkgHO7JhJIkr9vp35UydX5IqUf
        jcVrt4KnbZrv7JmyHl0dDzriTA==
X-Google-Smtp-Source: APXvYqxeIwjSDQFEIsTecczKoddoqLi23842Rf6mFsNCNeQJrNwtP1PnxxbPu7K/zVJqMQnFA7kXsw==
X-Received: by 2002:a1c:eb1a:: with SMTP id j26mr17623217wmh.43.1553692112371;
        Wed, 27 Mar 2019 06:08:32 -0700 (PDT)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id b10sm31103826wrt.86.2019.03.27.06.08.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 06:08:31 -0700 (PDT)
Subject: Re: [PATCH 1/3] media: dt-bindings: media: meson-ao-cec: Add G12A
 AO-CEC-B Compatible
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        devicetree@vger.kernel.org
Cc:     linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190325173501.22863-1-narmstrong@baylibre.com>
 <20190325173501.22863-2-narmstrong@baylibre.com>
 <518678c1-2e1d-ca27-55bd-0dd10965354f@xs4all.nl>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <74e84d99-dc7e-2779-fed0-e6a9e8324ba7@baylibre.com>
Date:   Wed, 27 Mar 2019 14:08:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <518678c1-2e1d-ca27-55bd-0dd10965354f@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 27/03/2019 13:39, Hans Verkuil wrote:
> On 3/25/19 6:34 PM, Neil Armstrong wrote:
>> The Amlogic G12A embeds a second CEC controller named AO-CEC-B, and
>> the other one is AO-CEC-A described by the current bindings.
>>
>> The registers interface is very close but the internal architecture
> 
> registers -> register
> 
>> is totally different.
>>
>> The other difference is the closk source, the AO-CEC-B takes the
> 
> closk -> clock
> 
>> "oscin", the Always-On Oscillator clock, as input and embeds a
>> dual-divider clock divider to provide the precise 32768Hz base
>> clock for CEC communication.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  .../devicetree/bindings/media/meson-ao-cec.txt    | 15 +++++++++++----
>>  1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/meson-ao-cec.txt b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
>> index 8671bdb08080..d6e2f9cf0aaf 100644
>> --- a/Documentation/devicetree/bindings/media/meson-ao-cec.txt
>> +++ b/Documentation/devicetree/bindings/media/meson-ao-cec.txt
>> @@ -4,16 +4,23 @@ The Amlogic Meson AO-CEC module is present is Amlogic SoCs and its purpose is
>>  to handle communication between HDMI connected devices over the CEC bus.
>>  
>>  Required properties:
>> -  - compatible : value should be following
>> -	"amlogic,meson-gx-ao-cec"
>> +  - compatible : value should be following depending on the SoC :
>> +  	For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
>> +  	"amlogic,meson-gx-ao-cec"
>> +	For G12A (AO_CEC_B module) :
>> +	"amlogic,meson-g12a-ao-cec"
> 
> The driver uses "amlogic,meson-g12a-ao-cec-b", so there is a mismatch between
> the bindings and the driver.
> 
> Please repost since it is important that the two correspond.

Indeed, thanks for spotting this, I'll fix the typos and the compatible in v2

Neil

> 
> Thanks!
> 
> 	Hans
> 
>>  
>>    - reg : Physical base address of the IP registers and length of memory
>>  	  mapped region.
>>  
>>    - interrupts : AO-CEC interrupt number to the CPU.
>>    - clocks : from common clock binding: handle to AO-CEC clock.
>> -  - clock-names : from common clock binding: must contain "core",
>> -		  corresponding to entry in the clocks property.
>> +  - clock-names : from common clock binding, must contain :
>> +		For GXBB, GXL, GXM and G12A (AO_CEC_A module) :
>> +		- "core"
>> +		For G12A (AO_CEC_B module) :
>> +		- "oscin"
>> +		corresponding to entry in the clocks property.
>>    - hdmi-phandle: phandle to the HDMI controller
>>  
>>  Example:
>>
> 

