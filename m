Return-Path: <SRS0=5UJH=RM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 840DBC43381
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 01:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 477DB20851
	for <linux-media@archiver.kernel.org>; Sat,  9 Mar 2019 01:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tajq6JwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfCIBAX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 20:00:23 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37125 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfCIBAW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 20:00:22 -0500
Received: by mail-pg1-f196.google.com with SMTP id q206so15440517pgq.4;
        Fri, 08 Mar 2019 17:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=z+fLqt8giOkjt0ea0c22JxCeYEPTH9AsKJLLHKYZZNI=;
        b=Tajq6JwHeoajqpeDAcsa/iGQYbKVqmlxEVkJ4lJgwunqRqifKwPist04HM3ViNcGzs
         OxV13XZUyoBkue05vIaRebIfNdYT15yUrh8DoBhdZ5lAvxV0PNV2WlKPGv2jobp0TNqa
         J8IqA2+lIH0elUA2Tw//aeay3vSLgUlbA95FfRrs/aiI1li3wN+J+p+wSUgkmS7RcMYy
         ohch1Ja5ScDosXiBYAQbR+zwzBFHrPXs454hnOZ667gDGILsFMHoLaVNN0e4zgspAmcq
         VRqEhvMsbZxTTU3eJ6/hLyedXT0r2oYsN1yGH8pQbhigI4JuGBdMI+7VZIhZxzR5pJ+L
         YCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=z+fLqt8giOkjt0ea0c22JxCeYEPTH9AsKJLLHKYZZNI=;
        b=TuKZoglHF/nvLJbaiDdfUOGzDQ3wv56mRMxuG26V7CWCtVyYyzLPUsqMmVZGxAX6zF
         8hJPd0/H+sMqiZl9RzH7T/+3trXe9IcgWII8wspRijzZBvQnTrxnXxJ5HmMvESq2AE4p
         nkpIZdp9m82xOKYalHnstuII6Xw2JrXXvLsAi70SO0L3A1rB5bq23fHL+gk0EANCArRt
         7WUJdH/uCx/gjgDn/2xibkeSZjEoDRItDHpWD6Dr/NdCV+Czr8wzHJIcpcr2Q7JsO39X
         d2Zgg2lAqPHALwRVmtW9VcQ72LRyeMOWnIhsUFJJRAnbfwoc1C1FfNC2+PlHwoadodwH
         XxhA==
X-Gm-Message-State: APjAAAX/8DDazzZcimEGuVLe5kG+Blly7Nx2d3sOOZISnXyZIF9rsReZ
        SMgIV6cQ+cGQQqcWWdpuAyXlKmg3
X-Google-Smtp-Source: APXvYqz6NKPYV4ziWCU8PuB9n7QJLs+U8W1JDNi8YixU0SA7cO42X4FulWm9OTj4rXzfWeoF8CoAwA==
X-Received: by 2002:a63:fe0d:: with SMTP id p13mr18749935pgh.366.1552093220732;
        Fri, 08 Mar 2019 17:00:20 -0800 (PST)
Received: from ?IPv6:2605:e000:d445:6a00:2097:f23b:3b8f:e255? ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id b8sm10293789pgq.33.2019.03.08.17.00.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 17:00:19 -0800 (PST)
Subject: Re: [PATCH v6 2/7] gpu: ipu-v3: ipu-ic: Fix BT.601 coefficients
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>, stable@vger.kernel.org,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
 <20190307233356.23748-3-slongerbeam@gmail.com>
 <1552040639.4009.1.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <d894d2a9-efeb-45ff-526c-05b4e57680cc@gmail.com>
Date:   Fri, 8 Mar 2019 17:00:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <1552040639.4009.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 3/8/19 2:23 AM, Philipp Zabel wrote:
> Hi Steve,
>
> On Thu, 2019-03-07 at 15:33 -0800, Steve Longerbeam wrote:
>> The ycbcr2rgb and inverse rgb2ycbcr tables define the BT.601 Y'CbCr
>> encoding coefficients.
>>
>> The rgb2ycbcr table specifically describes the BT.601 encoding from
>> full range RGB to full range YUV. Add table comments to make this more
>> clear.
>>
>> The ycbcr2rgb inverse table describes encoding YUV limited range to RGB
>> full range. To be consistent with the rgb2ycbcr table, convert this to
>> YUV full range to RGB full range, and adjust/expand on the comments.
>>
>> The ic_csc_rgb2rgb table is just an identity matrix, so rename to
>> ic_encode_identity.
>>
>> Fixes: 1aa8ea0d2bd5d ("gpu: ipu-v3: Add Image Converter unit")
>>
>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/gpu/ipu-v3/ipu-ic.c | 61 ++++++++++++++++++++++---------------
>>   1 file changed, 37 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
>> index 18816ccf600e..b63a2826b629 100644
>> --- a/drivers/gpu/ipu-v3/ipu-ic.c
>> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
>> @@ -175,7 +175,7 @@ static inline void ipu_ic_write(struct ipu_ic *ic, u32 value, unsigned offset)
>>   	writel(value, ic->priv->base + offset);
>>   }
>>   
>> -struct ic_csc_params {
>> +struct ic_encode_coeff {
> This less accurate. These are called IC (Task) Parameters in the
> reference manual, the 64-bit aligned words are called CSC words. Beside
> the coefficients, this structure also contains the coefficient scale,
> the offsets, and the saturation mode flag.

It seemed to me the renaming was more clear, but I agree the former name 
conforms better to the manual nomenclature. I will revert this renaming.


>
>>   	s16 coeff[3][3];	/* signed 9-bit integer coefficients */
>>   	s16 offset[3];		/* signed 11+2-bit fixed point offset */
>>   	u8 scale:2;		/* scale coefficients * 2^(scale-1) */
>> @@ -183,13 +183,15 @@ struct ic_csc_params {
>>   };
>>   
>>   /*
>> - * Y = R *  .299 + G *  .587 + B *  .114;
>> - * U = R * -.169 + G * -.332 + B *  .500 + 128.;
>> - * V = R *  .500 + G * -.419 + B * -.0813 + 128.;
>> + * BT.601 encoding from RGB full range to YUV full range:
>> + *
>> + * Y =  .2990 * R + .5870 * G + .1140 * B
>> + * U = -.1687 * R - .3313 * G + .5000 * B + 128
>> + * V =  .5000 * R - .4187 * G - .0813 * B + 128
>>    */
>> -static const struct ic_csc_params ic_csc_rgb2ycbcr = {
>> +static const struct ic_encode_coeff ic_encode_rgb2ycbcr_601 = {
>>   	.coeff = {
>> -		{ 77, 150, 29 },
>> +		{  77, 150,  29 },
>>   		{ 469, 427, 128 },
>>   		{ 128, 405, 491 },
> We could subtract 512 from the negative values, to improve readability.

Agreed.

>
>>   	},
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
>> +static const struct ic_encode_coeff ic_encode_identity = {
>>   	.coeff = {
>>   		{ 128, 0, 0 },
>>   		{ 0, 128, 0 },
>> @@ -208,17 +213,25 @@ static const struct ic_csc_params ic_csc_rgb2rgb = {
>>   };
>>   
>>   /*
>> - * R = (1.164 * (Y - 16)) + (1.596 * (Cr - 128));
>> - * G = (1.164 * (Y - 16)) - (0.392 * (Cb - 128)) - (0.813 * (Cr - 128));
>> - * B = (1.164 * (Y - 16)) + (2.017 * (Cb - 128);
>> + * Inverse BT.601 encoding from YUV full range to RGB full range:
>> + *
>> + * R = 1. * Y +      0 * (Cb - 128) + 1.4020 * (Cr - 128)
>> + * G = 1. * Y -  .3442 * (Cb - 128) - 0.7142 * (Cr - 128)
> Should that be      ^^^^^ .3441   and     ^^^^^ .7141 ?
> The coefficients and offsets after rounding should end up the same.

Ok.

>
> Also, let's consistently either add the leading zero, or leave it out.

Yes.

>
>> + * B = 1. * Y + 1.7720 * (Cb - 128) +      0 * (Cr - 128)
>> + *
>> + * equivalently (factoring out the offsets):
>> + *
>> + * R = 1. * Y  +      0 * Cb + 1.4020 * Cr - 179.456
>> + * G = 1. * Y  -  .3442 * Cb - 0.7142 * Cr + 135.475
>> + * B = 1. * Y  + 1.7720 * Cb +      0 * Cr - 226.816
>>    */
>> -static const struct ic_csc_params ic_csc_ycbcr2rgb = {
>> +static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
>>   	.coeff = {
>> -		{ 149, 0, 204 },
>> -		{ 149, 462, 408 },
>> -		{ 149, 255, 0 },
>> +		{ 128,   0, 179 },
>> +		{ 128, 468, 421 },
>> +		{ 128, 227,   0 },
>>   	},
>> -	.offset = { -446, 266, -554 },
>> +	.offset = { -359, 271, -454 },
> These seem to be correct. Again, I think this would be easier to read if
> the negative coefficients were written with a sign as well.
>
>>   	.scale = 2,
>>   };
>>   
>> @@ -228,7 +241,7 @@ static int init_csc(struct ipu_ic *ic,
>>   		    int csc_index)
>>   {
>>   	struct ipu_ic_priv *priv = ic->priv;
>> -	const struct ic_csc_params *params;
>> +	const struct ic_encode_coeff *coeff;
>>   	u32 __iomem *base;
>>   	const u16 (*c)[3];
>>   	const u16 *a;
>> @@ -238,26 +251,26 @@ static int init_csc(struct ipu_ic *ic,
>>   		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>>   
>>   	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
>> -		params = &ic_csc_ycbcr2rgb;
>> +		coeff = &ic_encode_ycbcr2rgb_601;
>>   	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
>> -		params = &ic_csc_rgb2ycbcr;
>> +		coeff = &ic_encode_rgb2ycbcr_601;
>>   	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
>> -		params = &ic_csc_rgb2rgb;
>> +		coeff = &ic_encode_identity;
>>   	else {
>>   		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>>   		return -EINVAL;
>>   	}
>>   
>>   	/* Cast to unsigned */
>> -	c = (const u16 (*)[3])params->coeff;
>> -	a = (const u16 *)params->offset;
>> +	c = (const u16 (*)[3])coeff->coeff;
>> +	a = (const u16 *)coeff->offset;
> This looks weird to me. I'd be in favor of not renaming the type.

Ok.

Steve

