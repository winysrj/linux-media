Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C0BC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 23:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5858A214DA
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 23:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tfJMpQia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfBKXd3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 18:33:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51886 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfBKXd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 18:33:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so1029749wmj.1;
        Mon, 11 Feb 2019 15:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4YsmXbJZrgA9KlysuvIxL9L2aT/wmgrin1tjWxSQvBE=;
        b=tfJMpQiazUSzR2qIVuT0xukmGuQjxoqz3KItn52+wHoAjme1fx6romoXUzRZ1SBMvS
         RLKIyyL4vgaArpImqkRlTjYMJLCPdupolf199NH/Ucx3FGnRKWIo7h/Aahkg7pOz0dm4
         BTEmf/K/5ZylkFK+OwbLAda1X/JEcFGOYva7Q4+OdHrxFh8adWEYqmQUldEkv3wZQcOu
         rH2Wa7ekxk/LSrfrY4dEFqLW2zQzxNiTo9dPwva+75WoSm6KV8qMvIq5rbN7CGMiWcoA
         bLK0GCGOJhny9IcVb+2lxC51hzyq+GcKMkjtopuk4UkTFU3gKQjaOrk21RvUb3ixZaDY
         ZUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4YsmXbJZrgA9KlysuvIxL9L2aT/wmgrin1tjWxSQvBE=;
        b=sFcn8V3n6iSsRmYPmqXdPBBGIqsvTqBgxqy0C1lc78nz00BTFPl2pl15c/5f++Y8Fq
         DXK1sknvF3c5IFk0gzRm2Qhs579A0/D/3byGDOEhwD3bC1qqBWiY1WlSYlSENJIne401
         Jv/gbhgzvKQSwIXY3cwgL2oVFf8E376q46lT2qlCHmwIiJ5TG7p3m90si6K1xF8b1rKF
         mKizLdpxMQpjOH091V5aCpr8CM3cCS6fkdDg1al+7t9IB088f9UOtE3v4aXtn2dwbKn+
         nQo/0AMT+my5jgw0Qi07K7pzqqdZkJf5WJ1AgPiy72pKoBVtmi/UeVJAztz2YAI8+sf8
         0qow==
X-Gm-Message-State: AHQUAubwLrdAnPjTv5+6OQwYub+x8hFMA5K8iJUfc7/RKNLkcZhR78uv
        1MKWPzB6aQ+J/zeRrPJjWwLN0TAR
X-Google-Smtp-Source: AHgI3IZ0kop33OzKaHrXPmJt6bncCCyRrsJQLIVm+Xbf2Eied9mtC8rmTcBToP0r5QKsFAyzUkND7w==
X-Received: by 2002:a7b:c854:: with SMTP id c20mr506627wml.153.1549928005622;
        Mon, 11 Feb 2019 15:33:25 -0800 (PST)
Received: from [172.30.89.184] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id q21sm934970wmc.14.2019.02.11.15.33.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 15:33:24 -0800 (PST)
Subject: Re: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding
 matrices
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
 <20190209014748.10427-2-slongerbeam@gmail.com>
 <1549879117.7687.2.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <8a3a9c63-d466-e328-d49a-1810952d2e9a@gmail.com>
Date:   Mon, 11 Feb 2019 15:33:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549879117.7687.2.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/11/19 1:58 AM, Philipp Zabel wrote:
> On Fri, 2019-02-08 at 17:47 -0800, Steve Longerbeam wrote:
>> The ycbcr2rgb and inverse rgb2ycbcr matrices define the BT.601 encoding
>> coefficients, so rename them to indicate that. And add some comments
>> to make clear these are BT.601 coefficients encoding between YUV limited
>> range and RGB full range. The ic_csc_rgb2rgb matrix is just an identity
>> matrix, so rename to ic_csc_identity. No functional changes.
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>> Changes in v2:
>> - rename ic_csc_rgb2rgb matrix to ic_csc_identity.
>> ---
>>   drivers/gpu/ipu-v3/ipu-ic.c | 21 ++++++++++++++-------
>>   1 file changed, 14 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
>> index 594c3cbc8291..3ef61f0b509b 100644
>> --- a/drivers/gpu/ipu-v3/ipu-ic.c
>> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
>> @@ -183,11 +183,13 @@ struct ic_csc_params {
>>   };
>>   
>>   /*
>> + * BT.601 encoding from RGB full range to YUV limited range:
>> + *
>>    * Y = R *  .299 + G *  .587 + B *  .114;
>>    * U = R * -.169 + G * -.332 + B *  .500 + 128.;
>>    * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
> Hm, this is a conversion to full range BT.601. For limited range, the
> matrix coefficients
>
>     0.2990  0.5870  0.1140
>    -0.1687 -0.3313  0.5000
>     0.5000 -0.4187 -0.0813
>
> should be multiplied with 219/255 (Y) and 224/255 (U,V), respectively:
>
>    Y = R *  .2568 + G *  .5041 + B *  .0979 + 16;
>    U = R * -.1482 + G * -.2910 + B *  .4392 + 128;
>    V = R *  .4392 + G * -.3678 + B * -.0714 + 128;
>
>>    */
>> -static const struct ic_csc_params ic_csc_rgb2ycbcr = {
>> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
>>   	.coeff = {
>>   		{ 77, 150, 29 },
>>   		{ 469, 427, 128 },
>> @@ -197,8 +199,11 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr = {
>>   	.scale = 1,
>>   };
>>   
>> -/* transparent RGB->RGB matrix for graphics combining */
>> -static const struct ic_csc_params ic_csc_rgb2rgb = {
>> +/*
>> + * identity matrix, used for transparent RGB->RGB graphics
>> + * combining.
>> + */
>> +static const struct ic_csc_params ic_csc_identity = {
>>   	.coeff = {
>>   		{ 128, 0, 0 },
>>   		{ 0, 128, 0 },
>> @@ -208,11 +213,13 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
>>   };
>>   
>>   /*
>> + * Inverse BT.601 encoding from YUV limited range to RGB full range:
>> + *
>>    * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
>>    * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
>>    * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
>>    */
> This looks correct.

Agreed, the coefficients in the comments are correct, but the actual 
table values were a bit off. I will correct them for v5 (Green offset 
should be 272 in the table, not 266).

Steve

>
>> -static const struct ic_csc_params ic_csc_ycbcr2rgb = {
>> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>>   	.coeff = {
>>   		{ 149, 0, 204 },
>>   		{ 149, 462, 408 },
>> @@ -238,11 +245,11 @@ static int init_csc(struct ipu_ic *ic,
>>   		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>>   
>>   	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
>> -		params = &ic_csc_ycbcr2rgb;
>> +		params = &ic_csc_ycbcr2rgb_bt601;
>>   	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
>> -		params = &ic_csc_rgb2ycbcr;
>> +		params = &ic_csc_rgb2ycbcr_bt601;
>>   	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
>> -		params = &ic_csc_rgb2rgb;
>> +		params = &ic_csc_identity;
>>   	else {
>>   		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>>   		return -EINVAL;
> regards
> Philipp

