Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DC9C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD3D2084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 19:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khhcTPNV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfBHTPH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:15:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55256 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfBHTPH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 14:15:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id a62so4971896wmh.4;
        Fri, 08 Feb 2019 11:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=J0HyZi80ABUFbqHV8+o+6rZvaWNkoNVSHUnqIA+2qVE=;
        b=khhcTPNVJpdVQ70c4d/NcnwRUZqhH8nzRoLDzmDEUmwbSJ5Nu71Zyy99HzyCAy5Vbv
         pfHUxCnXjw1EIR2eN4J5F0d+6izdZ7jb6dHiJH7P/OyRZGW3twCqAxGF+S3V1v3dWlbv
         aLtu1sgv+yHBiudE0SFwcg4WcQcoEmpRLzUiD989ybS7ZxwgwIPOFdt5JfbDbeFUpa96
         rpemUF3eFXEKNx5EMUjftjgbOAfhPzpeHZQeUAcn9kkxtk/AN8oadLxBI1SJ6UnKSFix
         dLBZbK1Kh2XgQMx2vGitwPq/1Bd1PFAKcj9nPgbqooNBaSKeHnpfvi72XA13PKUFzxHv
         oJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=J0HyZi80ABUFbqHV8+o+6rZvaWNkoNVSHUnqIA+2qVE=;
        b=Qx2vElG5npXYX32Uzpxj9PSa4QfDKG/jCElg91wNDx4e9rIAnrqfq7KQBwWgGzkK7k
         UAybhBCeYsJokOq1978rMC/8b1Y+4jiMZW18AUrA+cl4Hz7LYLZwf1RKDo7mZFwuIoUc
         /C0FG7JpYD+ZOyfDozSaHRUQ/9fQKBlKvpfwtcsFsHrVvsnwal1d+Rixxj1o9SZOZFwK
         pCt+/6DrUtQ3UDO94EXmr5LWVKvb1GRNqzjTH7o7QemHQoXwhWGZ+1vISgvcoOevKK0F
         ghvwd9RbfaBpp3SObdMNwp0Bdynw/L3MMcEVn00BujOGDh3SIp5mH6o976/B4oBa1EpV
         vbTA==
X-Gm-Message-State: AHQUAuZJ9/g1rfSID5toeCVw0wBplIBbMYDZ8I0MdJbbt+oimgA3LZNn
        wG5sl/tRrhxgL6nyZW2sX5iiiQIE
X-Google-Smtp-Source: AHgI3IbkivYOiUQQ3sgx8jTBsJX2MwZfVdqh0cn+0EBS24YJOPGR7Hc5e/Ud7WPAzcisGp2q/sb8qQ==
X-Received: by 2002:a1c:eb1a:: with SMTP id j26mr18663wmh.127.1549653303202;
        Fri, 08 Feb 2019 11:15:03 -0800 (PST)
Received: from [172.30.89.46] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id h133sm6311145wmd.8.2019.02.08.11.15.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Feb 2019 11:15:02 -0800 (PST)
Subject: Re: [PATCH 2/3] gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
References: <20190203194744.11546-1-slongerbeam@gmail.com>
 <20190203194744.11546-3-slongerbeam@gmail.com>
 <CAJ+vNU0dP+muS7h=8SaHBk1uTEiQT4JpeHKEDG_+VJXAc20Bew@mail.gmail.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <f276ce25-656f-253b-be23-7d18b6c347c9@gmail.com>
Date:   Fri, 8 Feb 2019 11:14:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU0dP+muS7h=8SaHBk1uTEiQT4JpeHKEDG_+VJXAc20Bew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 2/8/19 8:24 AM, Tim Harvey wrote:
> On Sun, Feb 3, 2019 at 11:48 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>> Pass v4l2 encoding enum to the ipu_ic task init functions, and add
>> support for the BT.709 encoding and inverse encoding matrices.
>>
>> Reported-by: Tim Harvey <tharvey@gateworks.com>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/gpu/ipu-v3/ipu-ic.c                 | 67 ++++++++++++++++++---
>>   drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
>>   drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
>>   include/video/imx-ipu-v3.h                  |  5 +-
>>   4 files changed, 67 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
>> index 35ae86ff0585..63362b4fff81 100644
>> --- a/drivers/gpu/ipu-v3/ipu-ic.c
>> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
>> @@ -199,6 +199,23 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
>>          .scale = 1,
>>   };
>>
>> +/*
>> + * BT.709 encoding from RGB full range to YUV limited range:
>> + *
>> + * Y = R *  .2126 + G *  .7152 + B *  .0722;
>> + * U = R * -.1146 + G * -.3854 + B *  .5000 + 128.;
>> + * V = R *  .5000 + G * -.4542 + B * -.0458 + 128.;
>> + */
>> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt709 = {
>> +       .coeff = {
>> +               { 54, 183, 18 },
>> +               { 483, 413, 128 },
>> +               { 128, 396, 500 },
>> +       },
>> +       .offset = { 0, 512, 512 },
>> +       .scale = 1,
>> +};
>> +
>>   /* transparent RGB->RGB matrix for graphics combining */
>>   static const struct ic_csc_params ic_csc_rgb2rgb = {
>>          .coeff = {
>> @@ -226,12 +243,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>>          .scale = 2,
>>   };
>>
>> +/*
>> + * Inverse BT.709 encoding from YUV limited range to RGB full range:
>> + *
>> + * R = (1. * (Y - 16)) + (1.5748 * (Cr - 128));
>> + * G = (1. * (Y - 16)) - (0.1873 * (Cb - 128)) - (0.4681 * (Cr - 128));
>> + * B = (1. * (Y - 16)) + (1.8556 * (Cb - 128);
>> + */
>> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt709 = {
>> +       .coeff = {
>> +               { 128, 0, 202 },
>> +               { 128, 488, 452 },
>> +               { 128, 238, 0 },
>> +       },
>> +       .offset = { -435, 136, -507 },
>> +       .scale = 2,
>> +};
>> +
>>   static int init_csc(struct ipu_ic *ic,
>>                      enum ipu_color_space inf,
>>                      enum ipu_color_space outf,
>> +                   enum v4l2_ycbcr_encoding encoding,
>>                      int csc_index)
>>   {
>>          struct ipu_ic_priv *priv = ic->priv;
>> +       const struct ic_csc_params *params_rgb2yuv, *params_yuv2rgb;
>>          const struct ic_csc_params *params;
>>          u32 __iomem *base;
>>          const u16 (*c)[3];
>> @@ -241,10 +277,24 @@ static int init_csc(struct ipu_ic *ic,
>>          base = (u32 __iomem *)
>>                  (priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>>
>> +       switch (encoding) {
>> +       case V4L2_YCBCR_ENC_601:
>> +               params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt601;
>> +               params_yuv2rgb = &ic_csc_ycbcr2rgb_bt601;
>> +               break;
>> +       case V4L2_YCBCR_ENC_709:
>> +               params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt709;
>> +               params_yuv2rgb = &ic_csc_ycbcr2rgb_bt709;
>> +               break;
>> +       default:
>> +               dev_err(priv->ipu->dev, "Unsupported YCbCr encoding\n");
>> +               return -EINVAL;
>> +       }
>> +
> Steve,
>
> This will fail for RGB to RGB with 'Unsupported YCbCr encoding. We
> need to account for the RGB->RGB case.
>
> How about something like:


Thanks for reporting Tim

I rather keep the check for supported encoding, and instead get rid of 
"Unsupported color space conversion" error, because that is the YUV->YUV 
case which can be allowed using the identity matrix.

Steve

>
>   static int init_csc(struct ipu_ic *ic,
>                      enum ipu_color_space inf,
>                      enum ipu_color_space outf,
> +                   enum v4l2_ycbcr_encoding encoding,
>                      int csc_index)
>   {
>          struct ipu_ic_priv *priv = ic->priv;
> -       const struct ic_csc_params *params;
> +       const struct ic_csc_params *params = NULL;
>          u32 __iomem *base;
>          const u16 (*c)[3];
>          const u16 *a;
> @@ -241,13 +276,18 @@ static int init_csc(struct ipu_ic *ic,
>          base = (u32 __iomem *)
>                  (priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>
> -       if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
> -               params = &ic_csc_ycbcr2rgb_bt601;
> -       else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
> -               params = &ic_csc_rgb2ycbcr_bt601;
> +       if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB) {
> +               params = (encoding == V4L2_YCBCR_ENC_601) ?
> +                       &ic_csc_ycbcr2rgb_bt601 : &ic_csc_ycbcr2rgb_bt709;
> +       }
> +       else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV) {
> +               params = (encoding == V4L2_YCBCR_ENC_601) ?
> +                       &ic_csc_rgb2ycbcr_bt601 : &ic_csc_rgb2ycbcr_bt709;
> +       }
>          else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
>                  params = &ic_csc_rgb2rgb;
> -       else {
> +
> +       if (!params) {
>                  dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
>                  return -EINVAL;
>          }
>
> Tim

