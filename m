Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C176AC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 11:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9149D2083B
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfBLLe0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:34:26 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56949 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfBLLe0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 06:34:26 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gtWKX-0007GH-Ca; Tue, 12 Feb 2019 12:34:25 +0100
Message-ID: <1549971262.4800.5.camel@pengutronix.de>
Subject: Re: [PATCH v4 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709
 encoding
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Date:   Tue, 12 Feb 2019 12:34:22 +0100
In-Reply-To: <440e12af-33ea-5eac-e570-8afa74e3133c@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
         <20190209014748.10427-4-slongerbeam@gmail.com>
         <1549879951.7687.6.camel@pengutronix.de>
         <440e12af-33ea-5eac-e570-8afa74e3133c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On Mon, 2019-02-11 at 17:20 -0800, Steve Longerbeam wrote:
[...]
> > Should we support YUV BT.601 <-> YUV REC.709 conversions? That would
> > require separate encodings for input and output.
> 
> How about if we pass the input and output encodings to the init ic task 
> functions, but for now require they be the same? We can support 
> transcoding in a later series.
[...]
> Again, I think for now, just include input/output quantization but 
> require full range for RGB and limited range for YUV.

Yes, that is fine. I'd just like to avoid unnecessary interface changes
between ipu-v3 and imx-media. So if we have to change it right now, why
not plan ahead.

> But that really balloons the arguments to ipu_ic_task_init_*(). Should 
> we create an ipu_ic_task_init structure?

I wonder if we should just expose struct ic_csc_params and provide a
helper to fill it given colorspace and V4L2 encoding/quantization
parameters. Something like:

	struct ipu_ic_csc_params csc;

	imx_media_init_ic_csc_params(&csc,
			in_cs, in_encoding, in_quantization,
			out_cs, out_encoding, out_quantization);

	ipu_ic_task_init(ic,
			in_width, in_height,
			out_width, out_height, &csc);
	// or
	ipu_ic_task_init_rsc(ic, rsc, &csc);

regards
Philipp
