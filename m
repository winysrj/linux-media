Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE78C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3765621872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 18:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfAXS5F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:57:05 -0500
Received: from mailoutvs9.siol.net ([185.57.226.200]:43178 "EHLO mail.siol.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbfAXS5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 13:57:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 1677852211F;
        Thu, 24 Jan 2019 19:57:01 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta10.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta10.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id JqBQMIXHXtE4; Thu, 24 Jan 2019 19:57:00 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 8046652215C;
        Thu, 24 Jan 2019 19:57:00 +0100 (CET)
Received: from jernej-laptop.localnet (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPA id 9D3F1522118;
        Thu, 24 Jan 2019 19:56:58 +0100 (CET)
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
Date:   Thu, 24 Jan 2019 19:56:57 +0100
Message-ID: <2800701.S2xdS7azMu@jernej-laptop>
In-Reply-To: <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
References: <20190111173015.12119-1-jernej.skrabec@siol.net> <20190121095014.b6iq5dubfi7x2pi4@flea> <CAGb2v66d0wM8Yt2uS4MMhU6PP02h8CKwKjinasO6jtZ4ue1CAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne ponedeljek, 21. januar 2019 ob 10:57:57 CET je Chen-Yu Tsai napisal(a):
> On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard <maxime.ripard@bootlin.com> 
wrote:
> > Hi,
> > 
> > I'm a bit late to the party, sorry for that.
> > 
> > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec <jernej.skrabec@siol.net> 
wrote:
> > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > fallback.
> > > 
> > > We ask people to add the SoC-specific compatible as a contigency,
> > > in case things turn out to be not so "compatible".
> > > 
> > > To be consistent with all the other SoCs and other peripherals,
> > > unless you already spotted a "compatible" difference in the
> > > hardware, i.e. the hardware isn't completely the same, this
> > > patch isn't needed. On the other hand, if you did, please mention
> > > the differences in the commit log.
> > 
> > Even if we don't spot things, since we have the stable DT now, if we
> > ever had that compatible in the DT from day 1, it's much easier to
> > deal with.
> > 
> > I'd really like to have that pattern for all the IPs even if we didn't
> > spot any issue, since we can't really say that the datasheet are
> > complete, and one can always make a mistake and overlook something.
> > 
> > I'm fine with this version, and can apply it as is if we all agree.
> 
> I'm OK with having the fallback compatible. I'm just pointing out
> that there are and will be a whole bunch of them, and we don't need
> to document all of them unless we are actually doing something to
> support them.
> 
> On the other hand, the compatible string situation for IR needs a
> bit of cleaning up at the moment. Right now we have sun4i-a10 and
> sun5i-a13. As Jernej pointed out, the A13's register definition is
> different from A64 (or any other SoCs later than sun6i). So we need
> someone with an A10s/A13 device that has IR to test it and see if
> the driver or the manual is wrong, and we'd likely add a compatible
> for the A20.
> 
> Also, the earlier SoCs (A10/sun5i/A20) have IR TX capability. This
> was lost in A31, and also all of sun8i / sun50i. So we're going to
> need to add an A31 compatible that all later platforms would need
> to switch to.

Actually, A13 also doesn't have IR TX capability. So I still think it's best 
having A13 compatible as a fallback and not A31. Unless A31 was released 
before A13?

Best regards,
Jernej



