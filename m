Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C95C169C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 01:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BFB5214DA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 01:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uzc9e6OS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfBLBUj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 20:20:39 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40474 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfBLBUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 20:20:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id q1so836435wrp.7;
        Mon, 11 Feb 2019 17:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EgLaCrrg+rEM+zWvavr49CeHkq97YjP+4BZM2b2bB48=;
        b=Uzc9e6OS3wYobpzCPAuolRPLOSkEGUPrOmSF5fteNzsviQrHn+Qe1ajWiY25kyMWsL
         o6OlylIVMuq8VAgpsmPmfHoH173Si37MNRImlm3lB6fIu4uCaFGnm+frOC3VvR97CjSa
         7RPz+fk7iWYaZWZfbjXyjCAQaFrsno3WJH7tu5qkYO8ahSGv+rd2THcsEz80vSn5/Ogv
         QSYPyuMMS5mi4V0Lft9mucmfTyyS2mY0SbxbEoqsSEMq7iIzR0EZIyoQw8pShe8/ydSR
         MQgbUe+LP8SNtC5CY1RelKE4mu0YX2dAMGgr0APleNVYifBIn0XDioqXix1lUPyqEqfq
         WcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EgLaCrrg+rEM+zWvavr49CeHkq97YjP+4BZM2b2bB48=;
        b=cNqZ+P+n1bQnYzTZG42GS8wYXRUJjC2ro+xDFJdNrdAcqWjhOtDl89Lk6JwolFmJb+
         AXjuUYE9UQdcejkpLXbGInW+6lQ3VmUaV3yIi9eQ+TdA57EMq9hnk6aqmnwcmUbBpI6X
         oh6E2V6Q8ugfBYqOlJG2EtSacOqNTYPJkZn1dys31UncCC+eoTXvyldFvnU03mD1+gmp
         c2T73nqfDYU/oGW47J1rQVitlQRcIwC1nZ40X1eH28xyCMrd36ioVQugEkQzmh1oFABk
         6tKK+DQ6KEUevuZQR+cpJlj2ScmlyeD3bX2YrJsEHFpVgiFPCRtPLO1Mu+WJg8q1cyTd
         KETA==
X-Gm-Message-State: AHQUAubt9fZyMjM82heVGb1OR5oswIQJwF2tcyuMkYK1YASqcWOFhdV7
        QaYWsfNgeTcRr8WYttE9v+T1TC9s
X-Google-Smtp-Source: AHgI3IYiknGAMwPn6cnNLiudpgYUU5vFgGwEN9pAPT3oHUgUG0qlBFHg1btYDHVw7oqvtN8ZO4FIJw==
X-Received: by 2002:adf:e342:: with SMTP id n2mr738900wrj.60.1549934435138;
        Mon, 11 Feb 2019 17:20:35 -0800 (PST)
Received: from [172.30.89.184] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id x186sm1538900wmg.41.2019.02.11.17.20.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Feb 2019 17:20:34 -0800 (PST)
Subject: Re: [PATCH v4 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709
 encoding
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
 <20190209014748.10427-4-slongerbeam@gmail.com>
 <1549879951.7687.6.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <440e12af-33ea-5eac-e570-8afa74e3133c@gmail.com>
Date:   Mon, 11 Feb 2019 17:20:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1549879951.7687.6.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/11/19 2:12 AM, Philipp Zabel wrote:
> On Fri, 2019-02-08 at 17:47 -0800, Steve Longerbeam wrote:
>> Pass v4l2 encoding enum to the ipu_ic task init functions, and add
>> support for the BT.709 encoding and inverse encoding matrices.
>>
>> Reported-by: Tim Harvey <tharvey@gateworks.com>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>> Changes in v4:
>> - fix compile error.
>> Chnges in v3:
>> - none.
>> Changes in v2:
>> - only return "Unsupported YCbCr encoding" error if inf != outf,
>>    since if inf == outf, the identity matrix can be used. Reported
>>    by Tim Harvey.
>> ---
>>   drivers/gpu/ipu-v3/ipu-ic.c                 | 71 +++++++++++++++++++--
>>   drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
>>   drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
>>   include/video/imx-ipu-v3.h                  |  5 +-
>>   4 files changed, 71 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
>> index e459615a49a1..c5f83d7e357f 100644
>> --- a/drivers/gpu/ipu-v3/ipu-ic.c
>> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
>> @@ -212,6 +212,23 @@ static const struct ic_csc_params ic_csc_identity = {
>>   	.scale = 2,
>>   };
>>   
>> +/*
>> + * BT.709 encoding from RGB full range to YUV limited range:
>> + *
>> + * Y = R *  .2126 + G *  .7152 + B *  .0722;
>> + * U = R * -.1146 + G * -.3854 + B *  .5000 + 128.;
>> + * V = R *  .5000 + G * -.4542 + B * -.0458 + 128.;
> This is a conversion to YUV full range. Limited range should be:
>
> Y   R *  .1826 + G *  .6142 + B *  .0620 + 16;
> U = R * -.1007 + G * -.3385 + B *  .4392 + 128;
> V   R *  .4392 + G * -.3990 + B * -.0402 + 128;

Yep, I fixed these to encode to limited range YUV, and ...

>> + */
>> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt709 = {
>> +	.coeff = {
>> +		{ 54, 183, 18 },
>> +		{ 483, 413, 128 },
>> +		{ 128, 396, 500 },
>> +	},
>> +	.offset = { 0, 512, 512 },
>> +	.scale = 1,
>> +};
>> +
>>   /*
>>    * Inverse BT.601 encoding from YUV limited range to RGB full range:
>>    *
>> @@ -229,12 +246,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>>   	.scale = 2,
>>   };
>>   
>> +/*
>> + * Inverse BT.709 encoding from YUV limited range to RGB full range:
>> + *
>> + * R = (1. * (Y - 16)) + (1.5748 * (Cr - 128));
>> + * G = (1. * (Y - 16)) - (0.1873 * (Cb - 128)) - (0.4681 * (Cr - 128));
>> + * B = (1. * (Y - 16)) + (1.8556 * (Cb - 128);
> The coefficients look like full range again, conversion from limited
> range YUV should look like:
>
>    R = (1.1644 * (Y - 16)) + (1.7927 * (Cr - 128));
>    G = (1.1644 * (Y - 16)) - (0.2132 * (Cb - 128)) - (0.5329 * (Cr - 128));
>    B = (1.1644 * (Y - 16)) + (2.1124 * (Cb - 128);

fixed these to inverse encode from limited range YUV.

>> + */
>> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt709 = {
>> +	.coeff = {
>> +		{ 128, 0, 202 },
>> +		{ 128, 488, 452 },
>> +		{ 128, 238, 0 },
>> +	},
>> +	.offset = { -435, 136, -507 },
>> +	.scale = 2,
>> +};
>> +
>>   static int init_csc(struct ipu_ic *ic,
>>   		    enum ipu_color_space inf,
>>   		    enum ipu_color_space outf,
>> +		    enum v4l2_ycbcr_encoding encoding,
> Should we support YUV BT.601 <-> YUV REC.709 conversions? That would
> require separate encodings for input and output.

How about if we pass the input and output encodings to the init ic task 
functions, but for now require they be the same? We can support 
transcoding in a later series.

>   Also, this might be a
> good time to think about adding quantization range parameters as well.

Again, I think for now, just include input/output quantization but 
require full range for RGB and limited range for YUV.

But that really balloons the arguments to ipu_ic_task_init_*(). Should 
we create an ipu_ic_task_init structure?

Steve

