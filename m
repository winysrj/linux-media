Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:35148 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751911AbdGSJVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:21:12 -0400
Date: Wed, 19 Jul 2017 12:21:06 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 3/8] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170719092106.xqichkcd6yepchxy@kekkonen.localdomain>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170719075255.yuar2xbeyisgl3we@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719075255.yuar2xbeyisgl3we@flea>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Wed, Jul 19, 2017 at 09:52:55AM +0200, Maxime Ripard wrote:
> Hi Sakari,
> 
> On Wed, Jun 14, 2017 at 12:47:14PM +0300, Sakari Ailus wrote:
> > Many camera sensor devices contain EEPROM chips that describe the
> > properties of a given unit --- the data is specific to a given unit can
> > thus is not stored e.g. in user space or the driver.
> > 
> > Some sensors embed the EEPROM chip and it can be accessed through the
> > sensor's I2C interface. This property is to be used for devices where the
> > EEPROM chip is accessed through a different I2C address than the sensor.
> > 
> > The intent is to later provide this information to the user space.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index a18d9b2..ae259924 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -76,6 +76,9 @@ Optional properties
> >  
> >  - lens-focus: A phandle to the node of the focus lens controller.
> >  
> > +- eeprom: A phandle to the node of the EEPROM describing the camera sensor
> > +  (i.e. device specific calibration data), in case it differs from the
> > +  sensor node.
> 
> Wouldn't it makes sense (especially if you want to provide user space
> access) to reuse what nvmem provides for this?

I wasn't aware of the nvmem bindings. Thanks for the pointer.

These are EEPROM chips that already have bindings documented under
Documentation/devicetree/bindings/eeprom as well as existing drivers under
drivers/misc/eeprom. Is there a reason why we have separate eeprom and
nvmem devices? Do you see issues in adding nvmem support for the existing
eeprom drivers, other than it misses using the nvmem framework?

There's also a small issue (or a big one, depending on which part of it you
consider) of the EEPROM content being parsed in the user space. The sensor
drivers do not use that information nor the contents are specific to the
sensor alone, it is ultimately up to the system integrator what to put to
the EEPROM. The typical size of an EEPROM is in perhaps one or two
kilobytes so that there's a lot of room for storing different individual
settings there.

nvmem bindings require referring to individual data cells but it's rather
the entire EEPROM contents that would be of interest here. I guess you
could create a single node under the EEPROM chip that covers the entire
chip. Or change the documentation to allow referring to the chip, rather
than a node under it.

Let me know your thoughts.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
