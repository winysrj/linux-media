Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44696 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726736AbeIMPJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 11:09:30 -0400
Date: Thu, 13 Sep 2018 13:00:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3 00/23] V4L2 fwnode rework; support for default
 configuration
Message-ID: <20180913100043.gibskvsvy7zrw4an@valkosipuli.retiisi.org.uk>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
 <20180913095450.GA28160@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180913095450.GA28160@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2018 at 11:54:50AM +0200, jacopo mondi wrote:
> Hi Sakari,
> 
> On Thu, Sep 13, 2018 at 12:29:19AM +0300, Sakari Ailus wrote:
> > Hello everyone,
> >
> > I've long thought the V4L2 fwnode framework requires some work (it's buggy
> > and it does not adequately serve common needs). This set should address in
> > particular these matters:
> >
> > - Most devices support a particular media bus type but the V4L2 fwnode
> >   framework was not able to use such information, but instead tried to
> >   guess the bus type with varying levels of success while drivers
> >   generally ignored the results. This patchset makes that possible ---
> >   setting a bus type enables parsing configuration for only that bus.
> >   Failing that check results in returning -ENXIO to be returned.
> >
> > - Support specifying default configuration. If the endpoint has no
> >   configuration, the defaults set by the driver (as documented in DT
> >   bindings) will prevail. Any available configuration will still be read
> >   from the endpoint as one could expect. A common use case for this is
> >   e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
> >   default 1:1 mapping is provided in absence of a valid default or
> >   configuration read OF.
> >
> > - Debugging information is greatly improved.
> >
> > - Recognition of the differences between CSI-2 D-PHY and C-PHY. All
> >   currently supported hardware (or at least drivers) is D-PHY only, so
> >   this change is still easy.
> >
> > The smiapp driver is converted to use the new functionality. This patchset
> > does not address remaining issues such as supporting setting defaults for
> > e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
> > patchset we're much closer to that goal. I've rebased this set on top of
> > Steve's. Albeit the two deal with the same files, there were only a few
> > trivial conflicts.
> >
> > Note that I've only tested parsing endpoints for the CSI-2 bus (no
> > parallel IF hardware). Jacopo has tested an earlier version of the set
> > with a few changes to the parallel bus handling compared to this one.
> 
> I've tested on parallel bus with CEU and MT9V111.
> 
> You can add my:
> Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> to this version too.

Thanks!

I'll put your ack on the DT binding documentation patch as Tested-by: isn't
really meaningful in that case.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
