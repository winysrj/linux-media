Return-Path: <SRS0=PrKG=PU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54584C43387
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 08:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4892133F
	for <linux-media@archiver.kernel.org>; Sat, 12 Jan 2019 08:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbfALIIN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 03:08:13 -0500
Received: from mailoutvs4.siol.net ([185.57.226.195]:57214 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbfALIIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 03:08:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 0B13A520991;
        Sat, 12 Jan 2019 09:08:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta11.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta11.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id wtYuQKiFF0G7; Sat, 12 Jan 2019 09:08:09 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 94B43520AF5;
        Sat, 12 Jan 2019 09:08:09 +0100 (CET)
Received: from jernej-laptop.localnet (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPA id 05832520991;
        Sat, 12 Jan 2019 09:08:08 +0100 (CET)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@siol.net>
To:     Chen-Yu Tsai <wens@csie.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/3] media: dt: bindings: sunxi-ir: Add A64 compatible
Date:   Sat, 12 Jan 2019 09:08:08 +0100
Message-ID: <4866484.1b519qCrCi@jernej-laptop>
In-Reply-To: <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
References: <20190111173015.12119-1-jernej.skrabec@siol.net> <20190111173015.12119-2-jernej.skrabec@siol.net> <CAGb2v66DiqK9sL-hQev4Wy08d9T7f1Yc2DFWJ0gYOnqChJyBRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne sobota, 12. januar 2019 ob 02:56:11 CET je Chen-Yu Tsai napisal(a):
> On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> 
wrote:
> > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > fallback.
> 
> We ask people to add the SoC-specific compatible as a contigency,
> in case things turn out to be not so "compatible".
> 
> To be consistent with all the other SoCs and other peripherals,
> unless you already spotted a "compatible" difference in the
> hardware, i.e. the hardware isn't completely the same, this
> patch isn't needed. On the other hand, if you did, please mention
> the differences in the commit log.

When comparing registers descriptions between A13 and A64, I noticed few minor 
differences:

A13: RXINT: 11:6 RAL
A64: RXINT: 13:8 RAL

A13: IR_RXSTA: 12:6 RAC
A64: IR_RXSTA: 14:8 RAC, 7 STAT (missing on A13)

What is strange that  RAL and RAC field have offset defined as 8 in driver. I'm 
not sure if that is a typo in A13 manual or driver issue. I assume the former, 
otherwise it wouldn't work. I couldn't found original BSP driver source to 
confirm, though.

STAT bit is really not that important. It just tells if IR unit is busy or 
not.

The biggest difference is in 0x34 register. A64 has one more clock option 
(without postdivider), although register values are backward compatible. A64 
also has Active threshold setting (duration of CIR going from idle to active 
state).

If we dismiss RAC and RAL differences as manual error and don't care for new 
clock option and active threshold, then having new compatible maybe really 
doesn't make sense.

Best regards,
Jernej

> 
> ChenYu
> 
> > Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> > ---
> > 
> >  Documentation/devicetree/bindings/media/sunxi-ir.txt | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> > b/Documentation/devicetree/bindings/media/sunxi-ir.txt index
> > 278098987edb..ecac6964b69b 100644
> > --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> > +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> > @@ -1,7 +1,10 @@
> > 
> >  Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
> > 
> >  Required properties:
> > -- compatible       : "allwinner,sun4i-a10-ir" or "allwinner,sun5i-a13-ir"
> > +- compatible       : value must be one of:
> > +  * "allwinner,sun4i-a10-ir"
> > +  * "allwinner,sun5i-a13-ir"
> > +  * "allwinner,sun50i-a64-ir", "allwinner,sun5i-a13-ir"
> > 
> >  - clocks           : list of clock specifiers, corresponding to
> >  
> >                       entries in clock-names property;
> >  
> >  - clock-names      : should contain "apb" and "ir" entries;
> > 
> > --
> > 2.20.1




