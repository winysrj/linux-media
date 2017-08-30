Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:55436 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdH3J3s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 05:29:48 -0400
Date: Wed, 30 Aug 2017 11:29:44 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 20/20] arm64: dts: renesas: salvator: use VC1 for CVBS
Message-ID: <20170830092944.GD5183@verge.net.au>
References: <20170811095703.6170-1-niklas.soderlund+renesas@ragnatech.se>
 <20170811095703.6170-21-niklas.soderlund+renesas@ragnatech.se>
 <20170830073637.GM10398@verge.net.au>
 <20170830080824.GK12099@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170830080824.GK12099@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 30, 2017 at 10:08:24AM +0200, Niklas Söderlund wrote:
> Hi Simon,
> 
> On 2017-08-30 09:36:37 +0200, Simon Horman wrote:
> > On Fri, Aug 11, 2017 at 11:57:03AM +0200, Niklas Söderlund wrote:
> > > In order to test Virtual Channels use VC1 for CVBS input from the
> > > adv748x.
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >  arch/arm64/boot/dts/renesas/salvator-common.dtsi | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> > > index 7b67efcb1d22090a..8047fe1df065d63b 100644
> > > --- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> > > +++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
> > > @@ -41,7 +41,7 @@
> > >  	};
> > >  
> > >  	chosen {
> > > -		bootargs = "ignore_loglevel rw root=/dev/nfs ip=dhcp";
> > > +		bootargs = "ignore_loglevel rw root=/dev/nfs ip=dhcp adv748x.txbvc=1";
> > >  		stdout-path = "serial0:115200n8";
> > >  	};
> > 
> > Hi Niklas,
> > 
> > I'm somewhat surprised to see what appears to be a new module parameter.
> > I'm not going to reject this but did you give consideration to doing this
> > another way?
> 
> This is my fault when sending this series out it should be marked as RFC 
> as it's stated in the cover-letter. This new module parameter is not 
> intended to be unstreamed, not even the driver parts. It's only usage is 
> to be able to easy test the multiplexed media pad using the onboard 
> Salvator-X components.
> 
> > 
> > In any case I have marked this as "Deferred" pending acceptance of the
> > driver change. If you think it can go in now then I'm open to discussion.
> 
> You can mark it as rejected and forget about it :-)

Thanks for the clarification, I marked it as RFC :)
