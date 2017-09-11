Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48632 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751250AbdIKHpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 03:45:54 -0400
Date: Mon, 11 Sep 2017 10:45:50 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v9 23/24] dt: bindings: smiapp: Document lens-focus and
 flash properties
Message-ID: <20170911074550.5lzfh5r5g4z7fyjo@valkosipuli.retiisi.org.uk>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
 <20170908131822.31020-19-sakari.ailus@linux.intel.com>
 <20170908133652.GR18365@amd>
 <20170908134226.m5ts637dej7oa4jw@valkosipuli.retiisi.org.uk>
 <20170908214544.GB27428@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908214544.GB27428@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 11:45:44PM +0200, Pavel Machek wrote:
> On Fri 2017-09-08 16:42:26, Sakari Ailus wrote:
> > Hi Pavel,
> > 
> > On Fri, Sep 08, 2017 at 03:36:52PM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Document optional lens-focus and flash properties for the smiapp driver.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/media/i2c/nokia,smia.txt | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > > index 855e1faf73e2..a052969365d9 100644
> > > > --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > > +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> > > > @@ -27,6 +27,8 @@ Optional properties
> > > >  - nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
> > > >    the NVM contents will not be read.
> > > >  - reset-gpios: XSHUTDOWN GPIO
> > > > +- flash-leds: One or more phandles to refer to flash LEDs
> > > > +- lens-focus: Phandle for lens focus
> > > 
> > > Should we simply reference the generic documentation here? If it needs
> > > changing, it will be easier changing single place.
> > 
> > Good question.
> > 
> > Ideally the properties at least would never change; we do have a common
> > parser for the properties which is part of the patchset so in theory it
> > would be possible to change the documentation in a backward-compatible way.
> > 
> > I added these properties as well as all the other properties supported by
> > the sensor driver are documented here. That has been the practice AFAIU,
> > albeit omissions do happen occasionally.
> > 
> > The issue I see with omitting the documentation here is that the user
> > otherwise won't know whether a driver uses a given property or not: it
> > shouldn't be necessary to read driver code to write DT source.
> 
> I see... OTOH documentation in central place _is_ a bit more verbose:
> 
> +- flash-leds: An array of phandles, each referring to a flash LED, a sub-node
> +  of the LED driver device node.
> 
> What about:
> 
> flash-leds, lens-focus: see <reference to central place>
> 
> ?

How about this?

diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
index a052969365d9..33f10a94c381 100644
--- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
+++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
@@ -27,8 +27,8 @@ Optional properties
 - nokia,nvm-size: The size of the NVM, in bytes. If the size is not given,
   the NVM contents will not be read.
 - reset-gpios: XSHUTDOWN GPIO
-- flash-leds: One or more phandles to refer to flash LEDs
-- lens-focus: Phandle for lens focus
+- flash-leds: See ../video-interfaces.txt
+- lens-focus: See ../video-interfaces.txt
 
 
 Endpoint node mandatory properties

I prefer to put them on separate lines as it's easier to read that way.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
