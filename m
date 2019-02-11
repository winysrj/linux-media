Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC3BC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 18:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E26521B24
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 18:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxKDH3V1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfBKSYg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:24:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34160 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfBKSYg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 13:24:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id y185so460414wmd.1;
        Mon, 11 Feb 2019 10:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TLKBKF1BreLbqnfwvB7Foi1Osm+u55Do0GkwG7DdJOM=;
        b=bxKDH3V1tRUJZkt1XLyFzFqH/szDPRu9wh1ZGEEn4Pyy3fpNYwjIpN2JaE0GXYcekb
         s3sMcTwkK2CALFXVZNkRCx6A3+m5cVS3HtMLkeeAmycyB9yNDKI7M5P4kZ5snTYZsA/V
         nsgRQBmQfC3V4GpPv9z2W/SAq7zb/fSSqIoTpkMfyPXDjRDdMOLdAgaF5j39lqCiQAa2
         FKDIKTWOsFKGzUky4GXVu9HmXSFtyZeaJwiVKPXQJLvZuH+2mZZ9zZYkmdRem/h4f2YM
         2paJVEVb/8rYx16Mlp/QEZyLGtenRhY0HY2xCVD8CQstxs7iYUpxTOMiFJ5ELjLKV+jM
         XTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TLKBKF1BreLbqnfwvB7Foi1Osm+u55Do0GkwG7DdJOM=;
        b=e+FjJlIgCoNHXdQ0ZHg7BbnEF1noE/hj1hyewnd5zKu4mSa13bXM5q7a0qnFUV9uxg
         im6V1Rd4LN54UFPpMvJLjjgVgqDuSSGkKNptrlM9dpLbVXWd53+Zh/K8DInO9GVORNUi
         49qPjy2nNB+EMOCO01Azu5VvTjqMAHFEMfvvQk5U0Bg/r4m1bHH5M5blqKJzZmwUJegh
         PXUYPmNi0dlwGVI4VCZ6yfVL7zEHQeOkOkfiW5sTdHi5uRM/0S0n6G6+VPqj43ZeMzoP
         XBPMTNdIyPqBkpPihb/qdJ9qO8YtcKs5cBmMW8QFEAEQb+oz90R+xdbattjmOnPiA9/Q
         26Yw==
X-Gm-Message-State: AHQUAuZk501VQkaFK3rJIUZUmb6afwm/p4FaANBxdP/taOd4tgUL63WP
        AfDSrSr0DsMUa+ROvu/g7zmPyykA
X-Google-Smtp-Source: AHgI3IaMvxQ0EaU3anpCu/zbZqEp5eVnVm8o2LakiAxnASVtwBVB4aajRcEcic3wIUXiUpupHrswoA==
X-Received: by 2002:a7b:c5d2:: with SMTP id n18mr683175wmk.30.1549909473159;
        Mon, 11 Feb 2019 10:24:33 -0800 (PST)
Received: from [172.30.89.184] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o9sm113121wmh.3.2019.02.11.10.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 10:24:32 -0800 (PST)
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
Message-ID: <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
Date:   Mon, 11 Feb 2019 10:24:28 -0800
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

Hi Philipp,

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

Looking more closely at these coefficients now, I see you are right, 
they are the BT.601 YUV full-range coefficients (Y range 0 to 1, U and V 
range -0.5 to 0.5). Well, not even that -- the coefficients are not 
being scaled to the limited ranges, but the 0.5 offset (128) _is_ being 
added to U/V, but no offset for Y. So it is even more messed up.

Your corrected coefficients and offsets look correct to me: Y 
coefficients scaled to (235 - 16) / 255 and U/V coefficients scaled to 
(240 - 16)  / 255, and add the offsets for both Y and U/V.

But what about this "SAT_MODE" field in the IC task parameter memory? 
According to the manual the hardware will automatically convert the 
written coefficients to the correct limited ranges. I see there is a 
"sat" field defined in the struct but is not being set in the tables.

So what should we do, define the full range coefficients, and make use 
of SAT_MODE h/w feature, or scale/offset the coefficients ourselves and 
not use SAT_MODE? I'm inclined to do the former.

Steve



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

