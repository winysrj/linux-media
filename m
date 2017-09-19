Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19355 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751747AbdISMRM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:17:12 -0400
Date: Tue, 19 Sep 2017 15:16:38 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 15/25] dt: bindings: Add a binding for flash LED
 devices associated to a sensor
Message-ID: <20170919121638.znu2drbzzayxrbwz@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-16-sakari.ailus@linux.intel.com>
 <8102551.bT9icskWgv@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8102551.bT9icskWgv@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 03:12:42PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 17:17:14 EEST Sakari Ailus wrote:
> > Camera flash drivers (and LEDs) are separate from the sensor devices in
> > DT. In order to make an association between the two, provide the
> > association information to the software.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Rob Herring <robh@kernel.org>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > b/Documentation/devicetree/bindings/media/video-interfaces.txt index
> > 852041a7480c..fdba30479b47 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -67,6 +67,14 @@ are required in a relevant parent node:
> >  		    identifier, should be 1.
> >   - #size-cells    : should be zero.
> > 
> > +
> > +Optional properties
> > +-------------------
> > +
> > +- flash-leds: An array of phandles, each referring to a flash LED, a
> > sub-node
> > +  of the LED driver device node.
> 
> What happens with non-LED flash controllers ?

We don't have any at the moment.

The way the bindings are currently defined (LED references are to
individual LEDs for instance) are specific to LED bindings. I'd rather not
make assumptions for e.g. Xenon flash devices. Which might never appear:
LED luminosity, efficiency and maximum current has been steadily increasing
over the past years.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
