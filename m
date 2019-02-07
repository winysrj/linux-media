Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07F0C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B05321904
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 09:44:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="KZVEW4VX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBGJoR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 04:44:17 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52243 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfBGJoQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 04:44:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id m1so5365897wml.2
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2019 01:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dORiPU6T2dh+2te+SKsPNlEondhLdDKTGTdZTk6bWF4=;
        b=KZVEW4VXzZ4AANUjI3BZxeRJwh6i0YSNMs0t0H9ckUpMY0aG4RlRoZBKnVSiDXh8dB
         pFCohSPw0DAFZVauY5hCOFimWZR+LRiN1egKSfyiK8Yn47WvgsnGcrSo4XMvzkhHlx+o
         e6U7xTswpk87/ozaW3WOmBftSiig3v+mDlo4bTsyOmJiYnopW1/esZG18L56Qlhej73w
         UZ5TR84jnYGOggExIFxHKpPGJNYy0tW3lkEEtcpwngrTUuc5jHonAtHhVWvWp2Pkdv9X
         ejOEfuyDZoIjtY+YVW4UqTouC+MQZLWz1FG+jxqFo3QgIn/hCX1SVM6eJeZWf1QSUFyi
         qISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dORiPU6T2dh+2te+SKsPNlEondhLdDKTGTdZTk6bWF4=;
        b=n+o4ExEeEXeWcKODurE3BgU1fB0BoEAbhSzTuA9EssIB236+BoSd77JITTsxC3tYNO
         zXhpUcDP5YoN51ZkFmu1JDWw9PHOpsLi3kCP1ahRy7X8ELsd3WzeMisAbdNjqxcOCGWi
         9dFzET00uw2GoSkycODJ6CtV+4ilm5euuyHZ+1TE89ZxqYl4n64iqaygWS1UKCzIdpC2
         y/23tBq1klkEL6qkDaenrO7E/VkBWl0OkJHmAP00uH52M6l0Fsjlasql6Oblz/cM0TWS
         490zLhMqcdwqVDVu5MvmOrCpHkmQWu+uzRg36qQicDaoIgfkVuofJ19GxzKxTAoKFHJs
         PgFg==
X-Gm-Message-State: AHQUAuYUmQLPSRRJ0dkcVnYiErsdD/244UJkuOukK7sXvFq7sHyQsoTe
        flPWUQrE0ECYDQgFfgw1OnNGxqoRkpWYdw==
X-Google-Smtp-Source: AHgI3IbJ2mAN2BxQgrR433hal/d2dbRzygFyg1zYr91nTBR89vYkLJ+Emcjgw0jzv+g5THdA/xOR4A==
X-Received: by 2002:a7b:cb82:: with SMTP id m2mr1892774wmi.135.1549532651855;
        Thu, 07 Feb 2019 01:44:11 -0800 (PST)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id z18sm21926248wml.36.2019.02.07.01.44.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Feb 2019 01:44:11 -0800 (PST)
Subject: Re: [PATCH v10 1/2] drm/fourcc: Add new P010, P016 video format
To:     Ayan Halder <Ayan.Halder@arm.com>, Randy Li <ayaka@soulik.info>,
        "airlied@linux.ie" <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     nd <nd@arm.com>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "mikhail.v.gavrilov@gmail.com" <mikhail.v.gavrilov@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "sean@poorly.run" <sean@poorly.run>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20190109195710.28501-1-ayaka@soulik.info>
 <20190109195710.28501-2-ayaka@soulik.info> <20190114163645.GA16349@arm.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <81f3b266-10d4-f230-c59b-79931e2e3188@baylibre.com>
Date:   Thu, 7 Feb 2019 10:44:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190114163645.GA16349@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 14/01/2019 17:36, Ayan Halder wrote:
> On Thu, Jan 10, 2019 at 03:57:09AM +0800, Randy Li wrote:
>> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits per
>> channel video format.
>>
>> P012 is a planar 4:2:0 YUV 12 bits per channel
>>
>> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits per
>> channel video format.
>>
>> V3: Added P012 and fixed cpp for P010.
>> V4: format definition refined per review.
>> V5: Format comment block for each new pixel format.
>> V6: reversed Cb/Cr order in comments.
>> v7: reversed Cb/Cr order in comments of header files, remove
>> the wrong part of commit message.
>> V8: reversed V7 changes except commit message and rebased.
>> v9: used the new properties to describe those format and
>> rebased.
>>
>> Cc: Daniel Stone <daniel@fooishbar.org>
>> Cc: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
>>
>> Signed-off-by: Randy Li <ayaka@soulik.info>
>> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
>> ---
>>  drivers/gpu/drm/drm_fourcc.c  |  9 +++++++++
>>  include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
>> index d90ee03a84c6..ba7e19d4336c 100644
>> --- a/drivers/gpu/drm/drm_fourcc.c
>> +++ b/drivers/gpu/drm/drm_fourcc.c
>> @@ -238,6 +238,15 @@ const struct drm_format_info *__drm_format_info(u32 format)
>>  		{ .format = DRM_FORMAT_X0L2,		.depth = 0,  .num_planes = 1,
>>  		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
>>  		  .hsub = 2, .vsub = 2, .is_yuv = true },
>> +		{ .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2,
>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
>> +		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2,
>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>> +		   .hsub = 2, .vsub = 2, .is_yuv = true},
>> +		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
>>  	};
>>  
>>  	unsigned int i;
>> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
>> index 0b44260a5ee9..8dd1328bc8d6 100644
>> --- a/include/uapi/drm/drm_fourcc.h
>> +++ b/include/uapi/drm/drm_fourcc.h
>> @@ -195,6 +195,27 @@ extern "C" {
>>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>>  
>> +/*
>> + * 2 plane YCbCr MSB aligned
>> + * index 0 = Y plane, [15:0] Y:x [10:6] little endian
>> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [10:6:10:6] little endian
>> + */
>> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
>> +
>> +/*
>> + * 2 plane YCbCr MSB aligned
>> + * index 0 = Y plane, [15:0] Y:x [12:4] little endian
>> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [12:4:12:4] little endian
>> + */
>> +#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cr:Cb plane 12 bits per channel */
>> +
>> +/*
>> + * 2 plane YCbCr MSB aligned
>> + * index 0 = Y plane, [15:0] Y little endian
>> + * index 1 = Cr:Cb plane, [31:0] Cr:Cb [16:16] little endian
>> + */
>> +#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
>> +
> 
> looks good to me.
> Reviewed by:- Ayan Kumar Halder <ayan.halder@arm.com>
> 
> We are using P010 format for our mali display driver. Our AFBC patch
> series(https://patchwork.freedesktop.org/series/53395/) is dependent
> on this patch. So, that's why I wanted to know when you are planning to
> merge this. As far as I remember, Juha wanted to implement some igt
> tests
> (https://lists.freedesktop.org/archives/intel-gfx/2018-September/174877.html)
> , so is that done now?
> 
> My apologies if I am pushing hard on this.

Looks good to me aswell,

Reviewed by: Neil Armstrong <narmstrong@baylibre.com>

Seems we will also need P010 to support the Amlogic Compressed modifier to display
compressed frames from the HW decoder.

I can apply this to drm-misc-next if everyone is ok

Neil

>>  /*
>>   * 3 plane YCbCr
>>   * index 0: Y plane, [7:0] Y
>> -- 
>> 2.20.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

