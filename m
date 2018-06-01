Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32037 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbeFAWfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 18:35:15 -0400
Date: Sat, 2 Jun 2018 01:35:07 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/8] dt-bindings: media: Document data-enable-active
 property
Message-ID: <20180601223506.n4cbfkm2cxbwixsi@kekkonen.localdomain>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180601102910.3qhe6bhg3w263chq@paasikivi.fi.intel.com>
 <20180601145827.GG10472@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180601145827.GG10472@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 01, 2018 at 04:58:27PM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Fri, Jun 01, 2018 at 01:29:10PM +0300, Sakari Ailus wrote:
> > Hi Jacopo,
> >
> > Thanks for the patch.
> >
> > On Tue, May 29, 2018 at 05:05:53PM +0200, Jacopo Mondi wrote:
> > > Add 'data-enable-active' property to endpoint node properties list.
> > >
> > > The property allows to specify the polarity of the data-enable signal, which
> > > when in active state determinates when data lanes have to sampled for valid
> > > pixel data.
> >
> > Lanes or lines? I understand this is forthe parallel interface.
> >
> 
> Now I'm confused. Are the parallel data 'lines' and the CSI-2 one
> 'lanes'? I thought 'lanes' applies to both.. am I wrong?

"Lane" is conventionally refer to a differential pair of wires on a serial
bus such as CSI-2. "Line" is used of a wire on a parallel bus.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
