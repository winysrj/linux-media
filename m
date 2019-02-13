Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E368C282CA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 10:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38BFD2190A
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 10:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390180AbfBMKfM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 05:35:12 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56051 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390178AbfBMKfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 05:35:11 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gtrsk-00043n-2R; Wed, 13 Feb 2019 11:35:10 +0100
Message-ID: <1550054109.3937.1.camel@pengutronix.de>
Subject: Re: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding
 matrices
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 13 Feb 2019 11:35:09 +0100
In-Reply-To: <7d4c5935-ffa1-2320-1632-136e1ce89350@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
         <20190209014748.10427-2-slongerbeam@gmail.com>
         <1549879117.7687.2.camel@pengutronix.de>
         <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
         <1549966666.4800.3.camel@pengutronix.de>
         <7d4c5935-ffa1-2320-1632-136e1ce89350@gmail.com>
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

On Tue, 2019-02-12 at 09:42 -0800, Steve Longerbeam wrote:
[...]
> > > But what about this "SAT_MODE" field in the IC task parameter memory?
> > 
> > That just controls the saturation. The result after the matrix
> > multiplication is either saturated to [0..255] or to [16..235]/[16..240]
> > when converting from the internal representation to the 8 bit output.
> 
> By saturation I think you mean clipped to those ranges?

Yes, thanks. I didn't realize it sounds weird to use saturated this way.
See: https://en.wikipedia.org/wiki/Saturation_arithmetic

> > > According to the manual the hardware will automatically convert the
> > > written coefficients to the correct limited ranges.
> > 
> > Where did you get that from? "The final calculation result is limited
> > according to the SAT_MODE parameter and rounded to 8 bits." I see no
> > mention of coefficients being modified.
> 
> Well, as is often the case with this manual, I was interpreting based on 
> poorly written information. By "final calculation result is limited 
> according to the SAT_MODE parameter" I interpreted that to mean the 
> hardware enables scaling from full range to limited range. But I concede 
> that it more likely means it clips the output to those ranges.

Ok, with this manual I'm never sure that there aren't some conflicting
statements somewhere else that I might have overlooked. Good to see that
we are at least basing our interpretations on the same text.

> > > I see there is a "sat" field defined in the struct but is not being
> > > set in the tables.
> > > 
> > > So what should we do, define the full range coefficients, and make use
> > > of SAT_MODE h/w feature, or scale/offset the coefficients ourselves and
> > > not use SAT_MODE? I'm inclined to do the former.
> > 
> > SAT_MODE should be set for conversions to YUV limited range so that the
> > coefficients can be rounded to the closest value.
> 
> Well, we have already rounded the coefficients to the nearest int in the 
> tables. Do you mean the final result (coeff * color component + offset) 
> is rounded?

The manual says so: "The final calculation result is limited according
to the SAT_MODE parameter and rounded to 8 bits", but that's not what I
meant. Still, I might have been mistaken.

I think due to the fact that the coefficients are multiplied by up to
255 (max pixel value) and then effectively divided by 256 when
converting to 8 bit, the only way to overflow limited range is if two
coefficients are rounded away from zero in the calculation of a single
component. This doesn't seem to happen in practice.

A constructed example, conversion to YUV limited range with carefully
chosen coefficients.

  Y = R * .1817 + G * .6153 + B * .0618 + 16;

Note that .1817 + .6153 + .0618 < 219/255.
With rounded coefficients though:

  Y = (R * 47 + G * 158 + B * 16 + (64 << 6)) / 256 = 236.136

Now 47 + 158 + 16 > 219, and the result is out of range.

regards
Philipp
