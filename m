Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:53963 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbeFDMZe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:25:34 -0400
Date: Mon, 4 Jun 2018 14:25:15 +0200
From: Simon Horman <horms@verge.net.au>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, geert@glider.be,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 4/4] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180604122511.cfb7cg7ojihel5mx@verge.net.au>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-5-git-send-email-jacopo+renesas@jmondi.org>
 <20180604095308.pnlmd4aalxceuozq@verge.net.au>
 <20180604113154.GC19674@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180604113154.GC19674@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 04, 2018 at 01:31:54PM +0200, Niklas Söderlund wrote:
> Hi Simon,
> 
> On 2018-06-04 11:53:09 +0200, Simon Horman wrote:
> > On Mon, May 21, 2018 at 07:27:43PM +0200, Jacopo Mondi wrote:
> > 
> > > The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> > > driver and only confuse users. Remove them in all Gen2 SoC that use
> > > them.
> > 
> > I think that the rational for removing properties (or not) is their
> > presence in the bindings as DT should describe the hardware and not the
> > current state of the driver implementation.
> > 
> > I see that 'bus-width' may be removed from the binding, as per discussion
> > in a different sub-thread. I'd like that discussion to reach a conclusion
> > before considering that part of this patch any further.
> > 
> > And I'd appreciate Niklas's feedback on the 'pclk-sample' portion.
> 
> My thoughts on 'pclk-sample' is the same as for 'bus-width', they 
> describe the hardware. So we either should keep or remove both. As our 
> discussion in the other thread I'm leaning towards that both should be 
> kept.

Thanks, that sounds reasonable to me.

I'm marking (v4 of) this as deferred pending a conclusion to that
conversation.
