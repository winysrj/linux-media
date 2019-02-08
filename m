Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC71C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 15:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359532086C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 15:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=ffwll.ch header.i=@ffwll.ch header.b="kPbHsAK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfBHPvN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 10:51:13 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43552 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfBHPvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 10:51:13 -0500
Received: by mail-ed1-f66.google.com with SMTP id f9so3131490eds.10
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 07:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=sender:date:from:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cdSvVmeKQbm6QGxJ90llqWGufezXUzs2hgpTioRJYAI=;
        b=kPbHsAK6qXwUiKG4Zff43sWJ47W0rl1blTBGhCeCRSBAJpiwnSeUnVPXIgMlu7zHvs
         FBjudiOQ7kY9ZW2C3LrVHqnbuSF14YwXxjtsvuwHPgYD09Qp+UvleG1wHKIxSjk0Icgs
         TtCgRf0V0zTvTROHW+oUkIirWHvjX4YQT6lSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=cdSvVmeKQbm6QGxJ90llqWGufezXUzs2hgpTioRJYAI=;
        b=E5v4yFdYuGdb4dRXPqLj8GqkloWepis++eEmzpxXaHBKItQcMstoTBDv1JyS4gzYNA
         YBEhZyjkeGRcATYlp/kjhOBEUSZRkUQmv241J82hNzkGaxHrUcpXrW2gb277aQxpmvlG
         YBbwyipWq0FDAGKuwrKkh3G95Vpo6hQ13AhR07QnC2VU0w1O9yNsj1fgOnBOSEzA7SwM
         lh6iJEOujbkHqId4QflNAtW0WC41bgbEklWafAk7Nm6cxEcuAukIM9OpDV7M8thew/Sl
         zgphSzjFMhczXRvjaxYI/Y2IIcHcL43dnn63w7FHkAMe60/OHAWKPrw99rRRMoRNyKA4
         rwgg==
X-Gm-Message-State: AHQUAuZSZoCf1WMwJbR5hqAm16Ekqy7/5pfSXAR7yK+RdbuMr3/8hFgX
        Jgw7f64VToi4VgNVGu+aMdkFvg==
X-Google-Smtp-Source: AHgI3Ibu9HbxBafIpQDCsY2rh4sOdH7rAuhE5vOz/CWUyIxGcpK3UAQIXc0Xobksr64O4MjYohYLpA==
X-Received: by 2002:a17:906:3da2:: with SMTP id y2-v6mr16335313ejh.160.1549641070572;
        Fri, 08 Feb 2019 07:51:10 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:569e:0:3106:d637:d723:e855])
        by smtp.gmail.com with ESMTPSA id a5sm323659ede.4.2019.02.08.07.51.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 07:51:09 -0800 (PST)
Date:   Fri, 8 Feb 2019 16:51:07 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     Ayan Halder <Ayan.Halder@arm.com>, Randy Li <ayaka@soulik.info>,
        "airlied@linux.ie" <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, nd <nd@arm.com>,
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
Message-ID: <20190208155107.GN23159@phenom.ffwll.local>
Mail-Followup-To: Neil Armstrong <narmstrong@baylibre.com>,
        Ayan Halder <Ayan.Halder@arm.com>, Randy Li <ayaka@soulik.info>,
        "airlied@linux.ie" <airlied@linux.ie>, nd <nd@arm.com>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "laurent.pinchart@ideasonboard.com" <laurent.pinchart@ideasonboard.com>,
        "mikhail.v.gavrilov@gmail.com" <mikhail.v.gavrilov@gmail.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "sean@poorly.run" <sean@poorly.run>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20190109195710.28501-1-ayaka@soulik.info>
 <20190109195710.28501-2-ayaka@soulik.info>
 <20190114163645.GA16349@arm.com>
 <81f3b266-10d4-f230-c59b-79931e2e3188@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81f3b266-10d4-f230-c59b-79931e2e3188@baylibre.com>
X-Operating-System: Linux phenom 4.19.0-1-amd64 
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Feb 07, 2019 at 10:44:10AM +0100, Neil Armstrong wrote:
> Hi,
> 
> On 14/01/2019 17:36, Ayan Halder wrote:
> > On Thu, Jan 10, 2019 at 03:57:09AM +0800, Randy Li wrote:
> >> P010 is a planar 4:2:0 YUV with interleaved UV plane, 10 bits per
> >> channel video format.
> >>
> >> P012 is a planar 4:2:0 YUV 12 bits per channel
> >>
> >> P016 is a planar 4:2:0 YUV with interleaved UV plane, 16 bits per
> >> channel video format.
> >>
> >> V3: Added P012 and fixed cpp for P010.
> >> V4: format definition refined per review.
> >> V5: Format comment block for each new pixel format.
> >> V6: reversed Cb/Cr order in comments.
> >> v7: reversed Cb/Cr order in comments of header files, remove
> >> the wrong part of commit message.
> >> V8: reversed V7 changes except commit message and rebased.
> >> v9: used the new properties to describe those format and
> >> rebased.
> >>
> >> Cc: Daniel Stone <daniel@fooishbar.org>
> >> Cc: Ville Syrj??l?? <ville.syrjala@linux.intel.com>
> >>
> >> Signed-off-by: Randy Li <ayaka@soulik.info>
> >> Signed-off-by: Clint Taylor <clinton.a.taylor@intel.com>
> >> ---
> >>  drivers/gpu/drm/drm_fourcc.c  |  9 +++++++++
> >>  include/uapi/drm/drm_fourcc.h | 21 +++++++++++++++++++++
> >>  2 files changed, 30 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> >> index d90ee03a84c6..ba7e19d4336c 100644
> >> --- a/drivers/gpu/drm/drm_fourcc.c
> >> +++ b/drivers/gpu/drm/drm_fourcc.c
> >> @@ -238,6 +238,15 @@ const struct drm_format_info *__drm_format_info(u32 format)
> >>  		{ .format = DRM_FORMAT_X0L2,		.depth = 0,  .num_planes = 1,
> >>  		  .char_per_block = { 8, 0, 0 }, .block_w = { 2, 0, 0 }, .block_h = { 2, 0, 0 },
> >>  		  .hsub = 2, .vsub = 2, .is_yuv = true },
> >> +		{ .format = DRM_FORMAT_P010,            .depth = 0,  .num_planes = 2,
> >> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
> >> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
> >> +		{ .format = DRM_FORMAT_P012,		.depth = 0,  .num_planes = 2,
> >> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
> >> +		   .hsub = 2, .vsub = 2, .is_yuv = true},
> >> +		{ .format = DRM_FORMAT_P016,		.depth = 0,  .num_planes = 2,
> >> +		  .char_per_block = { 2, 4, 0 }, .block_w = { 1, 0, 0 }, .block_h = { 1, 0, 0 },
> >> +		  .hsub = 2, .vsub = 2, .is_yuv = true},
> >>  	};
> >>  
> >>  	unsigned int i;
> >> diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
> >> index 0b44260a5ee9..8dd1328bc8d6 100644
> >> --- a/include/uapi/drm/drm_fourcc.h
> >> +++ b/include/uapi/drm/drm_fourcc.h
> >> @@ -195,6 +195,27 @@ extern "C" {
> >>  #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
> >>  #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
> >>  
> >> +/*
> >> + * 2 plane YCbCr MSB aligned
> >> + * index 0 = Y plane, [15:0] Y:x [10:6] little endian
> >> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [10:6:10:6] little endian
> >> + */
> >> +#define DRM_FORMAT_P010		fourcc_code('P', '0', '1', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel */
> >> +
> >> +/*
> >> + * 2 plane YCbCr MSB aligned
> >> + * index 0 = Y plane, [15:0] Y:x [12:4] little endian
> >> + * index 1 = Cr:Cb plane, [31:0] Cr:x:Cb:x [12:4:12:4] little endian
> >> + */
> >> +#define DRM_FORMAT_P012		fourcc_code('P', '0', '1', '2') /* 2x2 subsampled Cr:Cb plane 12 bits per channel */
> >> +
> >> +/*
> >> + * 2 plane YCbCr MSB aligned
> >> + * index 0 = Y plane, [15:0] Y little endian
> >> + * index 1 = Cr:Cb plane, [31:0] Cr:Cb [16:16] little endian
> >> + */
> >> +#define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
> >> +
> > 
> > looks good to me.
> > Reviewed by:- Ayan Kumar Halder <ayan.halder@arm.com>
> > 
> > We are using P010 format for our mali display driver. Our AFBC patch
> > series(https://patchwork.freedesktop.org/series/53395/) is dependent
> > on this patch. So, that's why I wanted to know when you are planning to
> > merge this. As far as I remember, Juha wanted to implement some igt
> > tests
> > (https://lists.freedesktop.org/archives/intel-gfx/2018-September/174877.html)
> > , so is that done now?
> > 
> > My apologies if I am pushing hard on this.
> 
> Looks good to me aswell,
> 
> Reviewed by: Neil Armstrong <narmstrong@baylibre.com>
> 
> Seems we will also need P010 to support the Amlogic Compressed modifier to display
> compressed frames from the HW decoder.
> 
> I can apply this to drm-misc-next if everyone is ok

Matches what's still flaoting around by intel devs:

https://patchwork.freedesktop.org/patch/284801/

Except this one uses the new block descriptors and has much neater
comments.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Please push to drm-misc-next asap so intel folks aren't blocked.

Thanks, Daniel

> 
> Neil
> 
> >>  /*
> >>   * 3 plane YCbCr
> >>   * index 0: Y plane, [7:0] Y
> >> -- 
> >> 2.20.1
> >>
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
