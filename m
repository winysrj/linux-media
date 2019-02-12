Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E40C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 396AD2077B
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 10:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfBLKRs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 05:17:48 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46563 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfBLKRs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 05:17:48 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gtV8M-00068m-Sn; Tue, 12 Feb 2019 11:17:46 +0100
Message-ID: <1549966666.4800.3.camel@pengutronix.de>
Subject: Re: [PATCH v4 1/4] gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding
 matrices
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 12 Feb 2019 11:17:46 +0100
In-Reply-To: <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
References: <20190209014748.10427-1-slongerbeam@gmail.com>
         <20190209014748.10427-2-slongerbeam@gmail.com>
         <1549879117.7687.2.camel@pengutronix.de>
         <0f987e19-e6e9-a56e-00ec-61e7e300a92e@gmail.com>
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

Hi Steve,

On Mon, 2019-02-11 at 10:24 -0800, Steve Longerbeam wrote:
[...]
> Looking more closely at these coefficients now, I see you are right, 
> they are the BT.601 YUV full-range coefficients (Y range 0 to 1, U and V 
> range -0.5 to 0.5). Well, not even that -- the coefficients are not 
> being scaled to the limited ranges, but the 0.5 offset (128) _is_ being 
> added to U/V, but no offset for Y. So it is even more messed up.
>
> Your corrected coefficients and offsets look correct to me: Y 
> coefficients scaled to (235 - 16) / 255 and U/V coefficients scaled to 
> (240 - 16)  / 255, and add the offsets for both Y and U/V.
> 
> But what about this "SAT_MODE" field in the IC task parameter memory? 

That just controls the saturation. The result after the matrix
multiplication is either saturated to [0..255] or to [16..235]/[16..240]
when converting from the internal representation to the 8 bit output.

> According to the manual the hardware will automatically convert the 
> written coefficients to the correct limited ranges.

Where did you get that from? "The final calculation result is limited
according to the SAT_MODE parameter and rounded to 8 bits." I see no
mention of coefficients being modified.

> I see there is a "sat" field defined in the struct but is not being
> set in the tables.
> 
> So what should we do, define the full range coefficients, and make use 
> of SAT_MODE h/w feature, or scale/offset the coefficients ourselves and 
> not use SAT_MODE? I'm inclined to do the former.

SAT_MODE should be set for conversions to YUV limited range so that the
coefficients can be rounded to the closest value. Otherwise we'd have to
round towards zero, possibly with a larger error, to make sure the
results are inside the valid ranges.

regards
Philipp
