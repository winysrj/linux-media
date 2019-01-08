Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D4FC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 21:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B0520883
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 21:28:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="uOfBo26D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbfAHV2L (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 16:28:11 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:39028 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbfAHV2L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 16:28:11 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 74A19586;
        Tue,  8 Jan 2019 22:28:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1546982888;
        bh=AKQITtpu4zuSO93qTr4/BO567gEQeeCLPJfMSQEe4OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOfBo26DP8b3PeYswSbbdNLW2kPGjj9mP8wmDNEz5Sl2ikYhiSNJYvEdhEzBg9smf
         +X5PUUTioYR+5PG1C3Z0fs1mHINHETuDhpJM4A+ToeexpxfjGWc2V0AgHG3AQbrdg2
         EpXULP79Fqjwrf2AUg/67cjm6hjZLKTAnAEGEwyE=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        linux-media@vger.kernel.org
Subject: Re: Kernel error "Unknown pixelformat 0x00000000" occurs when I start capture video
Date:   Tue, 08 Jan 2019 23:29:17 +0200
Message-ID: <2295088.CIBgFgJDf4@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <20190108164916.55aa9b93@coco.lan>
References: <CABXGCsNxy8-PUPhSSZ3MwUhHixE_R0R-jCw8yGfN88fSu-CXLw@mail.gmail.com> <CABXGCsOMdyzXACZa9T1OdUmDhNPDK=cX+DfBCAnY2A4aozCFHA@mail.gmail.com> <20190108164916.55aa9b93@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Tuesday, 8 January 2019 20:49:16 EET Mauro Carvalho Chehab wrote:
> Em Tue, 8 Jan 2019 21:11:41 +0500 Mikhail Gavrilov escreveu:
> > On Tue, 8 Jan 2019 at 20:57, Laurent Pinchart wrote:
> >> Thank you.
> >> 
> >> Your device exposes five formats: YUY2 (YUYV), YV12 (YVU420), NV12, P010
> >> and BGR3 (BGR24). They are all supported by V4L2 and the uvcvideo
> >> driver except for the P010 format. This would be easy to fix in the
> >> uvcvideo driver if it wasn't for the fact that the P010 format isn't
> >> support by V4L2. Adding support for it isn't difficult, but I don't
> >> have time to do this myself at the moment. Would you consider
> >> volunteering if I guide you ? :-)
> > 
> > Sure, I'd be happy to help. What is required of me?
> 
> It shouldn't be hard.

Thank you for the detailed and clear explanation.

> First, you need to add the new format at include/uapi/linux/videodev2.h,
> like this one:
> 
> 	#define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420
> planar */
> 
> Please put it together with the other YUV formats.
> 
> As the fourcc "P010" was not used on Linux yet, you could use it,
> e. g., something like:
> 
> 	#define V4L2_PIX_FMT_YUV_P10 v4l2_fourcc('P', '0', '1', '0') /* 10  YUV420
> planar */
> 
> You need then to document it. Each V4L2 format should have a description,
> like this:
> 
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-yuv420m.html
> 
> This is generated via a text file (using ReST syntax). On the above example,
> it is produced by this file:
> 
> 	https://git.linuxtv.org/media_tree.git/tree/Documentation/media/uapi/v4l/pi
> xfmt-yuv420m.rst
> 
> Writing it would take a little more time, but, provided that you don't
> copy what's written from external docs, you could take a look at the
> Internet for the P010 descriptions, and use the pixfmt-yuy420m.rst file
> as the basis for a new pixfmt-p010.rst file.
> 
> This will produce a patch similar to this one:
> 
> 	https://git.linuxtv.org/media_tree.git/commit/?id=5df082e2312c
> 
> Finally, you need to teach the uvc driver that it should report P010
> format, instead of 0x00000000, by adding it at uvc_format_desc uvc_fmts,
> with the corresponding UVC GUID. We usually do this on a separate patch.
> Something like this:
> 
> 	https://git.linuxtv.org/media_tree.git/commit/?id=6ea0d588d35b
> 
> Once you have the patches, submit it to the ML :-)
> 
> You could take a look at the LinuxTV wiki page about how to submit,
> at the developer's section:
> 
> 	https://linuxtv.org/wiki/index.php/Developer_section
> 
> In particular, take a look at "Submitting Your Work" section there.

-- 
Regards,

Laurent Pinchart



