Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52910 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754101AbcJNPrw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:47:52 -0400
Message-ID: <1476460046.11834.40.camel@pengutronix.de>
Subject: Re: [PATCH 02/22] [media] v4l2-async: allow subdevices to add
 further subdevices to the notifier waiting list
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Sascha Hauer <kernel@pengutronix.de>
Date: Fri, 14 Oct 2016 17:47:26 +0200
In-Reply-To: <20161013115617.GJ9460@valkosipuli.retiisi.org.uk>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-3-p.zabel@pengutronix.de>
         <20161007215216.GB9460@valkosipuli.retiisi.org.uk>
         <CA+gwMcft-E2n-hMre70Uj3u=PFPYpCbOYo9uOaCayve1ec1m-A@mail.gmail.com>
         <20161013115617.GJ9460@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 13.10.2016, 14:56 +0300 schrieb Sakari Ailus:
> Hi Philipp,
> 
> On Wed, Oct 12, 2016 at 03:26:48PM +0200, Philipp Zabel wrote:
> > On Fri, Oct 7, 2016 at 11:52 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > > Hi Philipp,
> > >
> > > On Fri, Oct 07, 2016 at 06:00:47PM +0200, Philipp Zabel wrote:
> > >> Currently the v4l2_async_notifier needs to be given a list of matches
> > >> for all expected subdevices on creation. When chaining subdevices that
> > >> are asynchronously probed via device tree, the bridge device that sets
> > >> up the notifier does not know the complete list of subdevices, as it
> > >> can only parse its own device tree node to obtain information about
> > >> the nearest neighbor subdevices.
> > >> To support indirectly connected subdevices, we need to support amending
> > >> the existing notifier waiting list with newly found neighbor subdevices
> > >> with each registered subdevice.
> > >
> > > Could you elaborate a little what's the exact use case for this? What kind
> > > of a device?
> > 
> > On i.MX6 there's a
> > 
> > DW MIPI CSI2 host -> Mux -> IPU/CSI
> > 
> > path and all three are asynchronous subdevices in my patchset and only
> > the last one is directly known to the media device from the device
> > tree, since each driver should only parse its own device tree node an
> > can not follow the of_graph over multiple steps.
> 
> Ok. Are all these devices part of the SoC? Is the mux doing something else
> than just sitting in between the two? :-)

Yes, in this case the muxes are part of the SoC. Depending on the SoC
variant they have a different number of inputs, and they are controlled
via the IOMUXC block that also controls the pin configuration. They
don't have any additional functionality beyond selecting one active
input.

regards
Philipp


