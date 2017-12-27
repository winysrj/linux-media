Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:17077 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752493AbdL0P2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Dec 2017 10:28:46 -0500
Date: Wed, 27 Dec 2017 17:28:39 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 02/15] rcar-vin: use pad as the starting point for
 a pipeline
Message-ID: <20171227152839.ys5dfw65mz5iyzhk@kekkonen.localdomain>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-3-niklas.soderlund+renesas@ragnatech.se>
 <20171215115402.uvvjkn3ltnxweqy6@paasikivi.fi.intel.com>
 <20171218230856.GF32148@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171218230856.GF32148@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:08:56AM +0100, Niklas Söderlund wrote:
> Hej Sakari,
> 
> Tack för dina kommentarer.
> 
> On 2017-12-15 13:54:02 +0200, Sakari Ailus wrote:
> > On Thu, Dec 14, 2017 at 08:08:22PM +0100, Niklas Söderlund wrote:
> > > The pipeline will be moved from the entity to the pads; reflect this in
> > > the media pipeline function API.
> > 
> > I'll merge this to "media: entity: Use pad as the starting point for a
> > pipeline" if you're fine with that.
> 
> I'm fine with that, the issue is that the rcar-vin Gen3 driver is not 
> yet upstream :-( If it makes it upstream before the work in your vc 
> branch feel free to squash this in. Until then I fear I need to keep 
> carry this in this series.

Oops, I thought it already was there. Anyway, no changes then.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
