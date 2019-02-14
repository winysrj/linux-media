Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68693C4360F
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 20:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B8292192B
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 20:43:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PjT9P+lr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437594AbfBNUnJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:43:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43077 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388630AbfBNUmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 15:42:52 -0500
Received: by mail-lj1-f194.google.com with SMTP id z20so5438380ljj.10
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2019 12:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=ES/sTSLs3PpP4DAVFEvZtGilbCi0ZAjLgxrAh9VXCRM=;
        b=PjT9P+lr72E7geKO/q8rvVkU/ts4UutkCpojyLAkSuZt0iYPhmk3fLXhth+tYQuw/g
         NfulwZb2yWCp1+lZp6lAL4fwfxynAL5cgw5H1IW3CfcxcU6MZr1XyDCbf2VQcleY4sVH
         FmaC7s5ZX/iCs/+okQ3B61ahQgE2m3tSXIRxD4n+3i6NwxbyGbpUPk9Ktg9wyWyTYIMT
         pMvTyb9aGrj5Q4JklU9Xef5ePM25wBGgZewWnWVt344V6gYDSxTO3RvGwRnnhtlDOH3/
         hGNuiEj+IhkLFry3vkK2s4aa8oWOKULb9aYT+sTMlyGPMyp3c5MVi3b3MKFVDWHQALok
         2PXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=ES/sTSLs3PpP4DAVFEvZtGilbCi0ZAjLgxrAh9VXCRM=;
        b=AWR5dvl+xnQtx59nmgXyS86lW3v/Ejcyo/JaCBIY3nqua4kUU4IanSis7SG0xMhPm0
         CLK2RtGr4MIyP6cD82aj7WXyVBpIujbEiYjZCbUSSiCb9seTLw0sqZRxUA5dET5oQEdc
         mFLXYHTz4AbYdtxs/AcQojGGbermfG1zPmNkJjDaOg0pFgitYeyZ2UlOsvRLTYp770yC
         dT3xInXbjlPlOIngE2jHHlTed9AnCTXq10OlMbTlcypk2Uab3OKBu8szE26ltyj7pwpR
         1pvzgTCU3B7dsFnZqSL6vYwKo2d06yN7I/vQYAb7Va2clQL1KTIQlXY9hEwZ+mG53rVp
         G8Og==
X-Gm-Message-State: AHQUAuYQ0GFgBdd1wxqn07sPzLlVAIWFhUFGwGM7+CiUk6tag73KPWlI
        IOJUjcjRiipjH+fX7+3WFuU=
X-Google-Smtp-Source: AHgI3IadpTs2z9NnIp2Rn2c5wBhpVJp8eaZVaxmHN2aQ2e1F9kvFrdUPHUdHLtwu0G40jv8AapCbgA==
X-Received: by 2002:a2e:7a03:: with SMTP id v3mr3621712ljc.22.1550176970309;
        Thu, 14 Feb 2019 12:42:50 -0800 (PST)
Received: from nysse.local (mobile-access-bcee35-123.dhcp.inet.fi. [188.238.53.123])
        by smtp.gmail.com with ESMTPSA id t23-v6sm627461lji.96.2019.02.14.12.42.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 12:42:49 -0800 (PST)
Subject: Re: [PATCH 4/6] drm: Add Y2xx and Y4xx (xx:10/12/16) format
 definitions and fourcc
To:     Swati Sharma <swati2.sharma@intel.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, maarten.lankhorst@linux.intel.com,
        stanislav.lisovskiy@intel.com, daniel.vetter@ffwll.ch,
        ville.syrjala@linux.intel.com,
        Vidya Srinivas <vidya.srinivas@intel.com>
References: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
 <1550064333-6168-5-git-send-email-swati2.sharma@intel.com>
From:   =?UTF-8?Q?Juha-Pekka_Heikkil=c3=a4?= <juhapekka.heikkila@gmail.com>
Message-ID: <1805f0e5-c589-4491-77c1-2d29f309e493@gmail.com>
Date:   Thu, 14 Feb 2019 22:42:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1550064333-6168-5-git-send-email-swati2.sharma@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Swati Sharma kirjoitti 13.2.2019 klo 15.25:
> The following pixel formats are packed format that follows 4:2:2
> chroma sampling. For memory represenation each component is
> allocated 16 bits each. Thus each pixel occupies 32bit.
> 
> Y210:	For each component, valid data occupies MSB 10 bits.
> 	LSB 6 bits are filled with zeroes.
> Y212:	For each component, valid data occupies MSB 12 bits.
> 	LSB 4 bits are filled with zeroes.
> Y216:	For each component valid data occupies 16 bits,
> 	doesn't require any padding bits.
> 
> First 16 bits stores the Y value and the next 16 bits stores one
> of the chroma samples alternatively. The first luma sample will
> be accompanied by first U sample and second luma sample is
> accompanied by the first V sample.
> 
> The following pixel formats are packed format that follows 4:4:4
> chroma sampling. Channels are arranged in the order UYVA in
> increasing memory order.
> 
> Y410:	Each color component occupies 10 bits and X component
> 	takes 2 bits, thus each pixel occupies 32 bits.
> Y412:   Each color component is 16 bits where valid data
> 	occupies MSB 12 bits. LSB 4 bits are filled with zeroes.
> 	Thus, each pixel occupies 64 bits.
> Y416:   Each color component occupies 16 bits for valid data,
> 	doesn't require any padding bits. Thus, each pixel
> 	occupies 64 bits.
> 
> Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
> Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
> ---
>   drivers/gpu/drm/drm_fourcc.c  |  6 ++++++
>   include/uapi/drm/drm_fourcc.h | 18 +++++++++++++++++-
>   2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index ba7e19d..45c9882 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -226,6 +226,12 @@ const struct drm_format_info *__drm_format_info(u32 format)
>   		{ .format = DRM_FORMAT_VYUY,		.depth = 0,  .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
>   		{ .format = DRM_FORMAT_XYUV8888,	.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
>   		{ .format = DRM_FORMAT_AYUV,		.depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y210,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y212,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y216,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 2, .vsub = 1, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y410,            .depth = 0,  .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y412,            .depth = 0,  .num_planes = 1, .cpp = { 8, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
> +		{ .format = DRM_FORMAT_Y416,            .depth = 0,  .num_planes = 1, .cpp = { 8, 0, 0 }, .hsub = 1, .vsub = 1, .is_yuv = true },
>   		{ .format = DRM_FORMAT_Y0L0,		.depth = 0,  .num_planes = 1,
>   		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
>   		  .hsub = 2, .vsub = 2, .has_alpha = true, .is_yuv = true },
> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> index bab2029..6e20ced 100644
> --- a/include/uapi/drm/drm_fourcc.h
> +++ b/include/uapi/drm/drm_fourcc.h
> @@ -151,7 +151,23 @@
>   #define DRM_FORMAT_VYUY		fourcc_code('V', 'Y', 'U', 'Y') /* [31:0] Y1:Cb0:Y0:Cr0 8:8:8:8 little endian */
>   
>   #define DRM_FORMAT_AYUV		fourcc_code('A', 'Y', 'U', 'V') /* [31:0] A:Y:Cb:Cr 8:8:8:8 little endian */
> -#define DRM_FORMAT_XYUV8888		fourcc_code('X', 'Y', 'U', 'V') /* [31:0] X:Y:Cb:Cr 8:8:8:8 little endian */
> +#define DRM_FORMAT_XYUV8888	fourcc_code('X', 'Y', 'U', 'V') /* [31:0] X:Y:Cb:Cr 8:8:8:8 little endian */
^^
one tab removed?

With that fixed this is
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

> +
> +/*
> + * packed Y2xx indicate for each component, xx valid data occupy msb
> + * 16-xx padding occupy lsb
> + */
> +#define DRM_FORMAT_Y210         fourcc_code('Y', '2', '1', '0') /* [63:0] Y0:x:Cb0:x:Y1:x:Cr1:x 10:6:10:6:10:6:10:6 little endian per 2 Y pixels */
> +#define DRM_FORMAT_Y212         fourcc_code('Y', '2', '1', '2') /* [63:0] Y0:x:Cb0:x:Y1:x:Cr1:x 12:4:12:4:12:4:12:4 little endian per 2 Y pixels */
> +#define DRM_FORMAT_Y216         fourcc_code('Y', '2', '1', '6') /* [63:0] Y0:Cb0:Y1:Cr1 16:16:16:16 little endian per 2 Y pixels */
> +
> +/*
> + * packed Y4xx indicate for each component, xx valid data occupy msb
> + * 16-xx padding occupy lsb except Y410
> + */
> +#define DRM_FORMAT_Y410         fourcc_code('Y', '4', '1', '0') /* [31:0] X:V:Y:U 2:10:10:10 little endian */
> +#define DRM_FORMAT_Y412         fourcc_code('Y', '4', '1', '2') /* [63:0] X:x:V:x:Y:x:U:x 12:4:12:4:12:4:12:4 little endian */
> +#define DRM_FORMAT_Y416         fourcc_code('Y', '4', '1', '6') /* [63:0] X:V:Y:U 16:16:16:16 little endian */
>   
>   /*
>    * packed YCbCr420 2x2 tiled formats
> 
