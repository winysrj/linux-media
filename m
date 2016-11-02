Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:45599 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750786AbcKBEjd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 00:39:33 -0400
Date: Wed, 02 Nov 2016 13:39:30 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: David =?iso-8859-15?Q?H=E4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 5/7] [media] ir-lirc-codec: don't wait any transmitting
 time for tx only devices
Message-id: <20161102043929.eaf7nlje2cru7nky@gangnam.samsung>
References: <20161027143601.GA5103@gofer.mess.org>
 <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-6-andi.shyti@samsung.com>
 <CGME20160902084206epcas1p26e535506ec1c418ede9ba230d40f0656@epcas1p2.samsung.com>
 <20160902084158.GA25342@gofer.mess.org>
 <20161027074401.wxg5icc6hcpwnfsf@gangnam.samsung>
 <7e2f88ed83c4044c30bc03aaea9f09e1@hardeman.nu>
 <20161031170526.GA8183@gofer.mess.org>
 <20161101065111.hofyxjps2iwmxpzj@gangnam.samsung>
 <20161101103408.GA15939@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20161101103408.GA15939@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > > Andi, it would be good to know what the use-case for the original change is.
> > 
> > the use case is the ir-spi itself which doesn't need the lirc to
> > perform any waiting on its behalf.
> 
> Here is the crux of the problem: in the ir-spi case no wait will actually 
> happen here, and certainly no "over-wait". The patch below will not change
> behaviour at all.
> 
> In the ir-spi case, "towait" will be 0 and no wait happens.
> 
> I think the code is already in good shape but somehow there is a 
> misunderstanding. Did I miss something?

We can just drop this patch, it's just something small that is
bothering me.

I will send a new patchset without this one.

Thanks,
Andi
