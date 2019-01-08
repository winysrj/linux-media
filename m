Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52250C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2232820657
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 15:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfAHPab (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 10:30:31 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33303 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfAHPab (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 10:30:31 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggtKn-0000GK-Vu; Tue, 08 Jan 2019 16:30:29 +0100
Message-ID: <1546961428.5406.4.camel@pengutronix.de>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>, kernel@pengutronix.de
Date:   Tue, 08 Jan 2019 16:30:28 +0100
In-Reply-To: <4acdd5bd4af28f33ae60d4ac244292e71dd9780d.camel@ndufresne.ca>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <4acdd5bd4af28f33ae60d4ac244292e71dd9780d.camel@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Nicolas,

On Mon, 2019-01-07 at 17:36 -0500, Nicolas Dufresne wrote:
> Le lundi 03 décembre 2018 à 12:48 +0100, Philipp Zabel a écrit :
> > Add a single imx-media mem2mem video device that uses the IPU IC PP
> > (image converter post processing) task for scaling and colorspace
> > conversion.
> > On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
> > 
> > The hardware only supports writing to destination buffers up to
> > 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> > by rendering multiple tiles per frame.
> 
> While testing this driver, I found that the color conversion from YUYV
> to BGR32 is broken.

Thank you for testing, do you mean V4L2_PIX_FMT_RGB32?

V4L2_PIX_FMT_BGR32 is still contained in the ipu_rgb_formats array in
imx-media-utils, but happens to be never returned by enum_fmt since that
already stops at the bayer formats.

>  Our test showed that the output of the m2m driver
> is in fact RGBX/8888, a format that does not yet exist in V4L2
> interface but that is supported by the imx-drm driver. This was tested
> with GStreamer (master of gst-plugins-good), though some changes to
> gst-plugins-bad is needed to add the missing format to kmssink. Let me
> know if you need this to produce or not.
> 
> # To demonstrate (with patched gst-plugins-bad https://paste.fedoraproject.org/paste/rs-CbEq7coL4XSKrnWpEDw)
> gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2convert ! video/x-raw,format=xRGB ! kmssink

Is this with an old kernel? Since c525350f6ed0 ("media: imx: use well
defined 32-bit RGB pixel format") that command line should make this
select V4L2_PIX_FMT_XRGB32 ("BX24").

> # Software fix for the color format produced
> gst-launch-1.0 videotestsrc ! video/x-raw,format=YUY2 ! v4l2convert ! video/x-raw,format=xRGB ! capssetter replace=0 caps="video/x-raw,format=RGBx" ! kmssink -v
> 
> Also, BGR32 is deprecated and should not be used, this is mapped by 
> imx_media_enum_format() which I believe is already upstream. If that
> is, this bug is just inherited from that helper.

regards
Philipp
