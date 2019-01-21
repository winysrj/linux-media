Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFB0C31680
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285F52089F
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 17:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfAUR7r convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 12:59:47 -0500
Received: from mailoutvs57.siol.net ([185.57.226.248]:35178 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbfAUR7r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 12:59:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 9D51B5208D6;
        Mon, 21 Jan 2019 18:59:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at psrvmta10.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta10.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id YWnJiO7hhOen; Mon, 21 Jan 2019 18:59:42 +0100 (CET)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 1C4065208D5;
        Mon, 21 Jan 2019 18:59:42 +0100 (CET)
Received: from jernej-laptop.localnet (cpe1-8-82.cable.triera.net [213.161.8.82])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPA id 7C424520265;
        Mon, 21 Jan 2019 18:59:41 +0100 (CET)
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
Date:   Mon, 21 Jan 2019 18:59:41 +0100
Message-ID: <11138144.2AFLRTQIGB@jernej-laptop>
In-Reply-To: <CAGb2v65t6kO9HfSTuXZsBu6Pyc+mueLq-5tsYsw9vxwg5o=v4A@mail.gmail.com>
References: <20190111173015.12119-1-jernej.skrabec@siol.net> <3128239.8RYQUhiYef@jernej-laptop> <CAGb2v65t6kO9HfSTuXZsBu6Pyc+mueLq-5tsYsw9vxwg5o=v4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Dne ponedeljek, 21. januar 2019 ob 18:39:26 CET je Chen-Yu Tsai napisal(a):
> On Tue, Jan 22, 2019 at 1:33 AM Jernej Škrabec <jernej.skrabec@siol.net> 
wrote:
> > Dne ponedeljek, 21. januar 2019 ob 10:57:57 CET je Chen-Yu Tsai 
napisal(a):
> > > On Mon, Jan 21, 2019 at 5:50 PM Maxime Ripard
> > > <maxime.ripard@bootlin.com>
> > 
> > wrote:
> > > > Hi,
> > > > 
> > > > I'm a bit late to the party, sorry for that.
> > > > 
> > > > On Sat, Jan 12, 2019 at 09:56:11AM +0800, Chen-Yu Tsai wrote:
> > > > > On Sat, Jan 12, 2019 at 1:30 AM Jernej Skrabec
> > > > > <jernej.skrabec@siol.net>
> > 
> > wrote:
> > > > > > A64 IR is compatible with A13, so add A64 compatible with A13 as a
> > > > > > fallback.
> > > > > 
> > > > > We ask people to add the SoC-specific compatible as a contigency,
> > > > > in case things turn out to be not so "compatible".
> > > > > 
> > > > > To be consistent with all the other SoCs and other peripherals,
> > > > > unless you already spotted a "compatible" difference in the
> > > > > hardware, i.e. the hardware isn't completely the same, this
> > > > > patch isn't needed. On the other hand, if you did, please mention
> > > > > the differences in the commit log.
> > > > 
> > > > Even if we don't spot things, since we have the stable DT now, if we
> > > > ever had that compatible in the DT from day 1, it's much easier to
> > > > deal with.
> > > > 
> > > > I'd really like to have that pattern for all the IPs even if we didn't
> > > > spot any issue, since we can't really say that the datasheet are
> > > > complete, and one can always make a mistake and overlook something.
> > > > 
> > > > I'm fine with this version, and can apply it as is if we all agree.
> > > 
> > > I'm OK with having the fallback compatible. I'm just pointing out
> > > that there are and will be a whole bunch of them, and we don't need
> > > to document all of them unless we are actually doing something to
> > > support them.
> > 
> > If you don't document them, checkpatch will complain. But if you can live
> > with this warning, that's fine by me.
> > 
> > > On the other hand, the compatible string situation for IR needs a
> > > bit of cleaning up at the moment. Right now we have sun4i-a10 and
> > > sun5i-a13. As Jernej pointed out, the A13's register definition is
> > > different from A64 (or any other SoCs later than sun6i). So we need
> > > someone with an A10s/A13 device that has IR to test it and see if
> > > the driver or the manual is wrong, and we'd likely add a compatible
> > > for the A20.
> > > 
> > > Also, the earlier SoCs (A10/sun5i/A20) have IR TX capability. This
> > > was lost in A31, and also all of sun8i / sun50i. So we're going to
> > > need to add an A31 compatible that all later platforms would need
> > > to switch to.
> > 
> > H6 has IR TX peripheral too, but it's different IP block...
> > 
> > Do you want me to switch all A31 and newer to different compatible in this
> > series? I can do this, but I haven't any A13 device to test if this is
> > really needed. Or you can argue that this is needed anyway due to missing
> > TX capability.
> 
> The lack of TX capability does necessitate switching to an A31 compatible.
> So yes, please switch. Lets leave the A10s/A13 alone for now, unless
> someone complains. I think this was done from inception, so if it was
> broken, someone should've complained a long time ago. I just want to
> be sure where the error is, and put in a comment explaining it. However
> I don't have the hardware either.

How do you want me to split patches? I propose following:
1. one patch to add all compatibles to DT binding documentation
2. one patch to add A31 compatible to driver
3. one patch for all 32 bit SoCs DT changes
4. one patch to add A64 compatible
5. one patch to enable OrangePi Win IR node

I don't think it's sensible to have multiple patches (one per SoC) for step 1 
and 3.

Best regards,
Jernej


