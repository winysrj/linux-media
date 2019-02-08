Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0679C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB7AF20855
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 21:11:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="o2lpEMzR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfBHVLX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 16:11:23 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55159 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfBHVLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 16:11:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so5583179wmh.4
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 13:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-transfer-encoding;
        bh=X8YUq5z6SPlRLoIo3i4beGJadbtO/lLXkz0jDZaiwAo=;
        b=o2lpEMzRPKrkU9l8ge+zq9Qwyy4JpKQhZXt+uKYTkqYzwt8dYObDX0eiIaLCKdFzmk
         hfkx8PIXDb0OCdyZVdJbkxKookOk6CO38YH/QbivTEPQON2pKnw08qruCJ9hnSk08Ixa
         yYLpKKFuRZjeRKcKJ38HXDiQCUq32gDj111OANAQ2i+jEXtf/qsjzD2V7Qz70+/YvLsz
         Aio7XmO5fSKG1bMXhMpJmPkppSsiLxMbycOKusfvS1ToHy7N4LF9zIZ+I8QZ1DbZUatY
         OTlwYw+9sye2YWU+NRON0Pll/AZofhPZEHT8Qe1g1XFkNaoEu5Klo7lEhbxfZgA617me
         +lIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :subject:references:in-reply-to:content-transfer-encoding;
        bh=X8YUq5z6SPlRLoIo3i4beGJadbtO/lLXkz0jDZaiwAo=;
        b=X02AWKdZlIgz9nNnd2FhafoAGsHq4scXMivvomgflLqvyUB4ZSVrO8HQ3b0yfCUAdT
         m2C780d0nbiphrpnfYGvSAJo44QaOt/GFBuLm8gJcjOmysps20sNWQCKSaMQoi9b2+89
         5AdYKuf3JFoHeqtrsroRKIETAVTuyO8yQdbkIPJJZH5CrV+78Ay/3IMMK4bYI80i8cnO
         pQfrMHksBOtT+Gimcx3HLfP8c9qP1VcvM4XEQCQtqeZRFvTRYDGdn2wi3wBc7aKF4qgw
         C+idm0SIxmQ5UoLzeNWcqZ6Olr/+8uAkXLYzmGDcULpCcJNZU458iFzSJjf+gBiCWOZR
         BK1w==
X-Gm-Message-State: AHQUAuYP4G4u258jiO/rrtk665KN7IprN2fv+rhuYcqcyd2Sw/3//lzI
        njFAZJ+yJxpiPk6RWSk7XfktLA==
X-Google-Smtp-Source: AHgI3Ib8FqRhEQ239Sbs1IkiVvUZfYacobjZMb90C617RpW7cCR9oJDS6csCXMp1lbwwnuCnejTKaw==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr333083wmc.96.1549660280043;
        Fri, 08 Feb 2019 13:11:20 -0800 (PST)
Received: from Armstrongs-MacBook-Pro.local (176-150-251-154.abo.bbox.fr. [176.150.251.154])
        by smtp.gmail.com with ESMTPSA id n11sm2866628wrw.60.2019.02.08.13.11.18
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 13:11:19 -0800 (PST)
Message-ID: <5C5DF075.4090702@baylibre.com>
Date:   Fri, 08 Feb 2019 22:11:17 +0100
From:   Neil Armstrong <narmstrong@baylibre.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To:     Ayan Halder <Ayan.Halder@arm.com>, Randy Li <ayaka@soulik.info>,
        "airlied@linux.ie" <airlied@linux.ie>, nd <nd@arm.com>,
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
Subject: Re: [PATCH v10 1/2] drm/fourcc: Add new P010, P016 video format
References: <20190109195710.28501-1-ayaka@soulik.info> <20190109195710.28501-2-ayaka@soulik.info> <20190114163645.GA16349@arm.com> <81f3b266-10d4-f230-c59b-79931e2e3188@baylibre.com> <20190208155107.GN23159@phenom.ffwll.local>
In-Reply-To: <20190208155107.GN23159@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Le 08/02/2019 16:51, Daniel Vetter a écrit :
> On Thu, Feb 07, 2019 at 10:44:10AM +0100, Neil Armstrong wrote:
>> Hi,
>>
>> On 14/01/2019 17:36, Ayan Halder wrote:
>>> On Thu, Jan 10, 2019 at 03:57:09AM +0800, Randy Li wrote:
>>>> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits per
>>>> channel video format.
>>>>
>>>> P012 is a planar 4:2:0 YUV 12 bits per channel
>>>>
>>>> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits per
>>>> channel video format.
>>>>
>>>> V3: Added P012 and fixed cpp for P010.
>>>> V4: format definition refined per review.
>>>> V5: Format comment block for each new pixel format.
>>>> V6: reversed Cb/Cr order in comments.
>>>> v7: reversed Cb/Cr order in comments of header files, remove
>>>> the wrong part of commit message.
>>>> V8: reversed V7 changes except commit message and rebased.
>>>> v9: used the new properties to describe those format and
>>>> rebased.
>>>>
>>>> Cc: Daniel Stone <daniel@fooishbar.org>
>>>> Cc: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
>>>>
>>>> Signed-off-by: Randy Li <ayaka@soulik.info>
>>>> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
>>>> ---
>>>>  drivers/gpu/drm/drm_fourcc.c  |  9 +++++++++
>>>>  include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
>>>>  2 files changed, 30 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
>>>> index d90ee03a84c6..ba7e19d4336c 100644
>>>> --- a/drivers/gpu/drm/drm_fourcc.c
>>>> +++ b/drivers/gpu/drm/drm_fourcc.c
>>>> @@ -238,6 +238,15 @@ const struct drm_format_info *__drm_format_info(u32 format)
>>>>  		{ .format = DRM_FORMAT_X0L2,		.depth = 0,  .num_planes = 1,
>>>>  		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
>>>>  		  .hsub = 2, .vsub = 2, .is_yuv = true },
>>>> +		{ .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2,
>>>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>>>> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
>>>> +		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2,
>>>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>>>> +		   .hsub = 2, .vsub = 2, .is_yuv = true},
>>>> +		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
>>>> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
>>>> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
>>>>  	};
>>>>  
>>>>  	unsigned int i;
>>>> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
>>>> index 0b44260a5ee9..8dd1328bc8d6 100644
>>>> --- a/include/uapi/drm/drm_fourcc.h
>>>> +++ b/include/uapi/drm/drm_fourcc.h
>>>> @@ -195,6 +195,27 @@ extern "C" {
>>>>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
>>>>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
>>>>  
>>>> +/*
>>>> + * 2 plane YCbCr MSB aligned
>>>> + * index 0 = Y plane, [15:0] Y:x [10:6] little endian
>>>> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [10:6:10:6] little endian
>>>> + */
>>>> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
>>>> +
>>>> +/*
>>>> + * 2 plane YCbCr MSB aligned
>>>> + * index 0 = Y plane, [15:0] Y:x [12:4] little endian
>>>> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [12:4:12:4] little endian
>>>> + */
>>>> +#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cr:Cb plane 12 bits per channel */
>>>> +
>>>> +/*
>>>> + * 2 plane YCbCr MSB aligned
>>>> + * index 0 = Y plane, [15:0] Y little endian
>>>> + * index 1 = Cr:Cb plane, [31:0] Cr:Cb [16:16] little endian
>>>> + */
>>>> +#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
>>>> +
>>>
>>> looks good to me.
>>> Reviewed by:- Ayan Kumar Halder <ayan.halder@arm.com>
>>>
>>> We are using P010 format for our mali display driver. Our AFBC patch
>>> series(https://patchwork.freedesktop.org/series/53395/) is dependent
>>> on this patch. So, that's why I wanted to know when you are planning to
>>> merge this. As far as I remember, Juha wanted to implement some igt
>>> tests
>>> (https://lists.freedesktop.org/archives/intel-gfx/2018-September/174877.html)
>>> , so is that done now?
>>>
>>> My apologies if I am pushing hard on this.
>>
>> Looks good to me aswell,
>>
>> Reviewed by: Neil Armstrong <narmstrong@baylibre.com>
>>
>> Seems we will also need P010 to support the Amlogic Compressed modifier to display
>> compressed frames from the HW decoder.
>>
>> I can apply this to drm-misc-next if everyone is ok
> 
> Matches what's still flaoting around by intel devs:
> 
> https://patchwork.freedesktop.org/patch/284801/
> 
> Except this one uses the new block descriptors and has much neater
> comments.
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Please push to drm-misc-next asap so intel folks aren't blocked.
> 
> Thanks, Daniel


Applying now, thanks !

Neil

> 
>>
>> Neil
>>
>>>>  /*
>>>>   * 3 plane YCbCr
>>>>   * index 0: Y plane, [7:0] Y
>>>> -- 
>>>> 2.20.1
>>>>
>>>> _______________________________________________
>>>> dri-devel mailing list
>>>> dri-devel@lists.freedesktop.org
>>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>>>
>>
> 
