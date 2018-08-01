Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49242 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387576AbeHANCY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Aug 2018 09:02:24 -0400
Date: Wed, 1 Aug 2018 14:16:27 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rob Herring <robh@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 05/21] dt-bindings: media: Specify bus type for MIPI
 D-PHY, others, explicitly
Message-ID: <20180801111627.gtvnhzo2b2j4haa2@paasikivi.fi.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
 <20180723134706.15334-6-sakari.ailus@linux.intel.com>
 <20180731213210.GA28374@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180731213210.GA28374@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thanks for the review.

On Tue, Jul 31, 2018 at 03:32:10PM -0600, Rob Herring wrote:
> On Mon, Jul 23, 2018 at 04:46:50PM +0300, Sakari Ailus wrote:
> > Allow specifying the bus type explicitly for MIPI D-PHY, parallel and
> > Bt.656 busses. This is useful for devices that can make use of different
> > bus types. There are CSI-2 transmitters and receivers but the PHY
> > selection needs to be made between C-PHY and D-PHY; many devices also
> > support parallel and Bt.656 interfaces but the means to pass that
> > information to software wasn't there.
> > 
> > Autodetection (value 0) is removed as an option as the property could be
> > simply omitted in that case.
> 
> Presumably there are users, so you can't remove it. But documenting 
> behavior when absent would be good.

Well, it's effectively the same as having no such property at all: the type
is not specified. Generally there are two possibilities: the hardware
supports just a single bus or it supports more than one. If there's just
one, the type can be known by the driver. In that case there's no use for
autodetection.

The second case is a bit more complicated: the bus type detection is solely
based on properties available in the endpoint, and I think that may have
been feasible approach when there were just parallel and Bt.656 busses that
were supported, but with the additional busses, the V4L2 fwnode framework
may no longer guess the bus in any meaningful way from the available
properties. I'd think the only known-good option here is to specify the
type explicitly in that case: there's no room for guessing. (This patchset
makes it possible for drivers to explicitly define the bus type, but the
autodetection support is maintained for backwards compatibility.)

One of the existing issues is that there are combined parallel/Bt.656
receivers that need to know the type of the bus. This is based on the
existence parallel interface only properties: if any of these exist, then
the interface is parallel, otherwise it is Bt.656. The DT bindings for the
same devices also define the defaults for the parallel interface. This
leaves the end result ambiguous: is it the parallel interface with the
default configuration or is it Bt.656?

There will likely be similar issues for CSI-2 D-PHY and CSI-2 C-PHY. The
question there would be: is this CSI-2 C-PHY or CSI-2 D-PHY with default
clock lane configuration?

In either case the autodetection option for the bus type provides no useful
information. If it exists in DT source, that's fine, there's just no use
for it.

Let me know if you still think it should be maintained in binding
documentation.

> 
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index baf9d9756b3c..f884ada0bffc 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -100,10 +100,12 @@ Optional endpoint properties
> >    slave device (data source) by the master device (data sink). In the master
> >    mode the data source device is also the source of the synchronization signals.
> >  - bus-type: data bus type. Possible values are:
> > -  0 - autodetect based on other properties (MIPI CSI-2 D-PHY, parallel or Bt656)
> >    1 - MIPI CSI-2 C-PHY
> >    2 - MIPI CSI1
> >    3 - CCP2
> > +  4 - MIPI CSI-2 D-PHY
> > +  5 - Parallel
> 
> Is that really specific enough to be useful?

Yes; see above.

> 
> > +  6 - Bt.656
> >  - bus-width: number of data lines actively used, valid for the parallel busses.
> >  - data-shift: on the parallel data busses, if bus-width is used to specify the
> >    number of data lines, data-shift can be used to specify which data lines are

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
