Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136F3C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7F992070B
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="dUrKWD+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfAHRrO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:47:14 -0500
Received: from mail-qt1-f170.google.com ([209.85.160.170]:33812 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbfAHRrO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 12:47:14 -0500
Received: by mail-qt1-f170.google.com with SMTP id r14so5333128qtp.1
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 09:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CP/8VMKtfwvOU0bGoljD8aJ+eVe9m+3KtCXOZ24rNj4=;
        b=dUrKWD+zbwuCicRjgytDgTJbdpJVwEEH1jzxCOVs8q7WVS6NZH5cSA+BsfSsqWNgJF
         LBJcfz3XKOE0SA431CrrPkHdzr2uMdqDsc9NRj3GcWax5oJivMwXcevLN/94x6z0QriM
         8itMALz5SedJUDpPAhfw3pnYR0OnrcUaZxUbgl49YoOqXbVyOxWbzOzE7EhVYEnLoaVQ
         Obb3Q9jRz7xq5uH50DA2sRHnJyLh5nFi5Wc2Ei87OJ+MttR7mtYh5hKUxcjCE1EZOXAv
         io94Xafwc7bmsOd994lX2MhwUHSKttQsLIVoba5Iuc90BAIev7cbAbQ2QJTEaW9YU3xE
         fopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CP/8VMKtfwvOU0bGoljD8aJ+eVe9m+3KtCXOZ24rNj4=;
        b=D/QDBvPB9AehIzcN0ERVyWnZt/Xt9SCxor7KtqtFRFn6cEUCGwTnbJnR2lYl6Yj+tM
         MyJN2J2akNhw5lhEPPVmouJk7cKICI7RN2vxsrZ9boYDUkYzVwqSe/YrjNlcEw3Cjh6V
         kZMd/Sl1VICMLwG+sgCU+m4XzPzsmQCC5pIHBHyMUmPVurFFpsfmWI31c4bBlUdpafVL
         KsBKadrvXsI7zUiFAkiv4e4wW7yziGCxCGyZPzQPfGq6C18yyQx2tq1qWjeu1/798814
         k6BvEzdy0hOEW1oTMjy8AMe6fCNIBF4ckC3BVsGymSBl5rrmqRCOO5y6AFWMdk17s0P4
         7YWQ==
X-Gm-Message-State: AJcUukdQH9B4jCYW18SF8AGYqgRZm57avGMKF2PxSkNXeZ7qwJKOA03g
        rTXdrvTEVsqtsya+Dt+ksHRMqQ==
X-Google-Smtp-Source: ALg8bN6m1GUS7EuMrNPtpZ2ldx/FdrtPN33AUCgSMIJtQ6SyhHunv9dfadMK6jneqeDHsHlk9Q92ZA==
X-Received: by 2002:ac8:254c:: with SMTP id 12mr2481869qtn.88.1546969632562;
        Tue, 08 Jan 2019 09:47:12 -0800 (PST)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id p42sm36644050qte.8.2019.01.08.09.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Jan 2019 09:47:11 -0800 (PST)
Message-ID: <e93a6dc4c79f8fee458e3eaa61e32958aa0ee8c6.camel@ndufresne.ca>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Date:   Tue, 08 Jan 2019 12:47:10 -0500
In-Reply-To: <1546961428.5406.4.camel@pengutronix.de>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <4acdd5bd4af28f33ae60d4ac244292e71dd9780d.camel@ndufresne.ca>
         <1546961428.5406.4.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mardi 08 janvier 2019 à 16:30 +0100, Philipp Zabel a écrit :
> Hi Nicolas,
> 
> On Mon, 2019-01-07 at 17:36 -0500, Nicolas Dufresne wrote:
> > Le lundi 03 décembre 2018 à 12:48 +0100, Philipp Zabel a écrit :
> > > Add a single imx-media mem2mem video device that uses the IPU IC PP
> > > (image converter post processing) task for scaling and colorspace
> > > conversion.
> > > On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
> > > 
> > > The hardware only supports writing to destination buffers up to
> > > 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> > > by rendering multiple tiles per frame.
> > 
> > While testing this driver, I found that the color conversion from YUYV
> > to BGR32 is broken.
> 
> Thank you for testing, do you mean V4L2_PIX_FMT_RGB32?
> 
> V4L2_PIX_FMT_BGR32 is still contained in the ipu_rgb_formats array in
> imx-media-utils, but happens to be never returned by enum_fmt since that
> already stops at the bayer formats.
> 
> >  Our test showed that the output of the m2m driver
> > is in fact RGBX/8888, a format that does not yet exist in V4L2
> > interface but that is supported by the imx-drm driver. This was tested
> > with GStreamer (master of gst-plugins-good), though some changes to
> > gst-plugins-bad is needed to add the missing format to kmssink. Let me
> > know if you need this to produce or not.
> > 
> > # To demonstrate (with patched gst-plugins-bad https://paste.fedoraproject.org/paste/rs-CbEq7coL4XSKrnWpEDw)
> > gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2convert ! video/x-raw,format=xRGB ! kmssink
> 
> Is this with an old kernel? Since c525350f6ed0 ("media: imx: use well
> defined 32-bit RGB pixel format") that command line should make this
> select V4L2_PIX_FMT_XRGB32 ("BX24").

My testing is done with a slightly older kernel yes, but my colleagues
do reproduce on something more up to date. I should be updating the
test kernel soon, just need to find the time. As the pixel format
produced does not exist in v4l2 headers, the problem should still be
present for you on the most recent kernels.

Ideally I should produce a manual test of all conversion combination
(like I did for Exynos FIMC). This is fairly easy with GStreamer, I
just need to find the time slot to do so. Though, I thought this was
was rather important as the capture often produce YUYV and RGB can be
useful.

> 
> > # Software fix for the color format produced
> > gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2convert ! video/x-raw,format=xRGB ! capssetter replace=0 caps="video/x-raw,format=RGBx" ! kmssink -v
> > 
> > Also, BGR32 is deprecated and should not be used, this is mapped by 
> > imx_media_enum_format() which I believe is already upstream. If that
> > is, this bug is just inherited from that helper.
> 
> regards
> Philipp

