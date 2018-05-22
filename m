Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:35647 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeEVISH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:18:07 -0400
Date: Tue, 22 May 2018 10:18:03 +0200
From: Simon Horman <horms@verge.net.au>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180522081803.m6vaybet3jdzvac4@verge.net.au>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-6-git-send-email-jacopo+renesas@jmondi.org>
 <20180516221307.GF17948@bigcity.dyn.berto.se>
 <20180517090110.GA20190@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180517090110.GA20190@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 17, 2018 at 11:01:10AM +0200, jacopo mondi wrote:
> Hi Niklas,
> 
> On Thu, May 17, 2018 at 12:13:07AM +0200, Niklas Söderlund wrote:
> > Hi Jacopo,
> >
> > Thanks for your work.
> >
> > On 2018-05-16 18:32:31 +0200, Jacopo Mondi wrote:
> > > The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> > > driver and only confuse users. Remove them in all Gen2 SoC that used
> > > them.
> > >
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  arch/arm/boot/dts/r8a7790-lager.dts   | 3 ---
> > >  arch/arm/boot/dts/r8a7791-koelsch.dts | 3 ---
> > >  arch/arm/boot/dts/r8a7791-porter.dts  | 1 -
> > >  arch/arm/boot/dts/r8a7793-gose.dts    | 3 ---
> > >  arch/arm/boot/dts/r8a7794-alt.dts     | 1 -
> > >  arch/arm/boot/dts/r8a7794-silk.dts    | 1 -
> > >  6 files changed, 12 deletions(-)
> > >
> > > diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
> > > index 063fdb6..b56b309 100644
> > > --- a/arch/arm/boot/dts/r8a7790-lager.dts
> > > +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> > > @@ -873,10 +873,8 @@
> > >  	port {
> > >  		vin0ep2: endpoint {
> > >  			remote-endpoint = <&adv7612_out>;
> > > -			bus-width = <24>;
> >
> > I can't really make up my mind if this is a good thing or not. Device
> > tree describes the hardware and not what the drivers make use of. And
> > the fact is that this bus is 24 bits wide. So I'm not sure we should
> > remove these properties. But I would love to hear what others think
> > about this.
> >
> 
> Just to point out those properties are not even documented in rcar-vin
> bindings (actually, none of them was).
> 
> I feel it's wrong to have them here, as someone may think that
> changing their value should actually change the VIN interface behavior,
> which it's not true, leading to massive confusion and quite some code
> digging for no reason (and they will get mad at us at some point, probably :)

I think its fine that the driver doesn't implement something described in
DT - we are describing the hardware not the implementation. But I think its
not fine that DT includes properties not described in the binding.

So I think we should either
a) Fix the binding documentation, but perhaps it is already correct
   in which case we should;
b) Apply this patch

Once we have decided what is the correct description of the hardware we
can consider implications on the driver implementation.
