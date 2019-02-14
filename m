Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E60C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 18:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B05F321900
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 18:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqSPKNky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbfBNSy0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 13:54:26 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50874 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfBNSy0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 13:54:26 -0500
Received: by mail-wm1-f68.google.com with SMTP id x7so7421041wmj.0;
        Thu, 14 Feb 2019 10:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=N9eJJVG9XGs4TaN74QOpQZCPONKwYIz2B722eHcHttE=;
        b=UqSPKNkyoJxNYYWFVTemRARDhJD8QPg3kY+ugEchqehm2frEaLoArmiby04EL518I+
         kqTjY5s3sqnefl5VSZ8ISlE/ZjirPJPULWZ13CH+5BA5OfMDDOPVBZl+p5i1Awj+ixoJ
         W41gJhijrljbko7KPyBlFhMX4VkwRwJi5hSNUd+JY9vTHyGVyyNyQR9hFAIt9Wm21c2L
         IUfG+t0uEOO4yFTCHomHORR3s4l+Y7EWs6xLgzsmp5+UTMzfWuSNqYLxfGO0qji5p3xM
         MJlFK77Nkjbl/4s5TjndNTLqVZJa9CSq4vdRHPbQ7dW6KPktkqD4CJ0KYanR5xFAwNvg
         /4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=N9eJJVG9XGs4TaN74QOpQZCPONKwYIz2B722eHcHttE=;
        b=RspIbw+2kh1dAtEQgt/5QtV1zCqQnI6KurM3SFbY1gdyOeMkT98UmnEwtuTbPEyLdR
         wWPaynMCGMoihE5ySqUYx5PjnVLrWDChWOGM/MlnsMlnWl0BLvs35BlyXi1EZGlJWS8y
         67an+Wi1AtGEQYuhtDTOJqtQi4x2FnXZSQSywnpKjyt68zZoZHjklJbwzezRzSNwWOrZ
         r3JqdJWK2kFdykr8Elc1q6rsudGRsKagStfQny3KeOaCC4LOvDBsu+Mi3ESoSmt3XlIV
         unNbavhLlYyZho61mtOWe1P3qitMnHaUKA9LN7xmswcsdsUU+x1di+w2LhN3fz31V1Ln
         EihQ==
X-Gm-Message-State: AHQUAuaZHxrmiVU+H6ke7RxGk30v279+PLKHV2XE5drfoYx5KLRpXd/V
        jDhGbIW2q6svTg23bSV2+IfXWaL9
X-Google-Smtp-Source: AHgI3Iaxelc3rbTtRNAzAshx+KwuL/C5Soqrl4VvDbj6ZTlznDQDqFua6U6bbx+mTsUuhjGYn212EQ==
X-Received: by 2002:a1c:81c2:: with SMTP id c185mr3558479wmd.58.1550170463538;
        Thu, 14 Feb 2019 10:54:23 -0800 (PST)
Received: from [172.30.88.202] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id u134sm2047373wmf.21.2019.02.14.10.54.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 10:54:22 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
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
 <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
 <1549966666.4800.3.camel@pengutronix.de>
 <7d4c5935-ffa1-2320-1632-136e1ce89350@gmail.com>
 <1550054109.3937.1.camel@pengutronix.de>
Message-ID: <58bf1e34-8b9d-7fec-6ba5-5db1d5c5457d@gmail.com>
Date:   Thu, 14 Feb 2019 10:54:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1550054109.3937.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/13/19 2:35 AM, Philipp Zabel wrote:
> On Tue, 2019-02-12 at 09:42 -0800, Steve Longerbeam wrote:
> [...]
>>>> But what about this "SAT_MODE" field in the IC task parameter memory?
>>> That just controls the saturation. The result after the matrix
>>> multiplication is either saturated to [0..255] or to [16..235]/[16..240]
>>> when converting from the internal representation to the 8 bit output.
>> By saturation I think you mean clipped to those ranges?
> Yes, thanks. I didn't realize it sounds weird to use saturated this way.
> See:https://en.wikipedia.org/wiki/Saturation_arithmetic

Ok, saturation can mean the same thing as clipping/clamping. Thanks for 
the article.

I tested a RGB->YUV pipeline with the .sat bit set in the BT.601 rgb2yuv 
table, with the following pipeline on the SabreSD:

'ov5640 1-003c':0
         [fmt:RGB565_2X8_LE/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'imx6-mipi-csi2':0
         [fmt:RGB565_2X8_LE/1024x768 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'imx6-mipi-csi2':2
         [fmt:RGB565_2X8_LE/1024x768 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'ipu1_csi1':0
         [fmt:RGB565_2X8_LE/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range
          crop.bounds:(0,0)/1024x768
          crop:(0,0)/1024x768
          compose.bounds:(0,0)/1024x768
          compose:(0,0)/1024x768]

'ipu1_csi1':1
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'ipu1_ic_prp':0
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'ipu1_ic_prp':1
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'ipu1_ic_prpenc':0
         [fmt:ARGB8888_1X32/1024x768@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

'ipu1_ic_prpenc':1
         [fmt:AYUV8_1X32/800x600@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:lim-range]

/dev/video0:0
Format Video Capture:
     Width/Height      : 800/600
     Pixel Format      : 'YV12'
     Field             : None
     Bytes per Line    : 800
     Size Image        : 720000
     Colorspace        : sRGB
     Transfer Function : sRGB
     YCbCr/HSV Encoding: ITU-R 601
     Quantization      : Limited Range
     Flags             :


The result being that the captured image colors are all off (there's a 
bright pink shade to the images). But I discovered the init_csc() 
function was not setting the saturation bit at the correct bit offset 
within the TPMEM. The saturation bit is bit 42, or bit 10 of the second 
32-bit word. But the code was writing to bit 9 of the second word. After 
correcting this, saturation is working fine. I have added another patch 
that fixes this for v5 series.


>
>>> SAT_MODE should be set for conversions to YUV limited range so that the
>>> coefficients can be rounded to the closest value.
>> Well, we have already rounded the coefficients to the nearest int in the
>> tables. Do you mean the final result (coeff * color component + offset)
>> is rounded?
> The manual says so: "The final calculation result is limited according
> to the SAT_MODE parameter and rounded to 8 bits", but that's not what I
> meant. Still, I might have been mistaken.
>
> I think due to the fact that the coefficients are multiplied by up to
> 255 (max pixel value) and then effectively divided by 256 when
> converting to 8 bit, the only way to overflow limited range is if two
> coefficients are rounded away from zero in the calculation of a single
> component. This doesn't seem to happen in practice.
>
> A constructed example, conversion to YUV limited range with carefully
> chosen coefficients.
>
>    Y = R * .1817 + G * .6153 + B * .0618 + 16;
>
> Note that .1817 + .6153 + .0618 < 219/255.
> With rounded coefficients though:
>
>    Y = (R * 47 + G * 158 + B * 16 + (64 << 6)) / 256 = 236.136

Yes, for a rec.709 conversion and max/worst-case RGB signal = (255,255,255).

But the rec.709 coefficients for Y are actually

Y = (R * 47 + G * 157 + B * 16 + (16 << 8)) / 256


which for RGB = (255,255,255), Y = 235.14, which doesn't overflow 
limited range.

Steve

