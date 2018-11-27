Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43999 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeK1BTS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 20:19:18 -0500
Date: Tue, 27 Nov 2018 15:21:05 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH v3 5/6] dt-bindings: media: mt9m111: add pclk-sample
 property
Message-ID: <20181127142105.4jb6hlojiu54ipux@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
 <20181127100253.30845-6-m.felsch@pengutronix.de>
 <20181127131320.ejzau4mjqhunlfvu@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127131320.ejzau4mjqhunlfvu@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 18-11-27 15:13, Sakari Ailus wrote:
> Hi Marco,
> 
> On Tue, Nov 27, 2018 at 11:02:52AM +0100, Marco Felsch wrote:
> > Add the pclk-sample property to the list of optional properties
> > for the mt9m111 camera sensor.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/media/i2c/mt9m111.txt | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> > index a431fb45704b..d0bed6fa901a 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
> > @@ -14,6 +14,10 @@ sub-node for its digital output video port, in accordance with the video
> >  interface bindings defined in:
> >  Documentation/devicetree/bindings/media/video-interfaces.txt
> >  
> > +Optional endpoint properties:
> > +- pclk-sample: For information see ../video-interfaces.txt. The value is set to
> > +  0 if it isn't specified.
> 
> How about the data-active, hsync-active and vsync-active properties? Does
> the hardware have a fixed configuration, or can this be set? It appears the
> driver assumes active high for all.

As I understood it correctly the data-active, hsync-active and vsync-active
I/O lines are always ACTIVE_HIGH.

Kind regards,
Marco
 
> If there's something to change, this should be a separate patch IMO.
> 
> > +
> >  Example:
> >  
> >  	i2c_master {
> > @@ -26,6 +30,7 @@ Example:
> >  			port {
> >  				mt9m111_1: endpoint {
> >  					remote-endpoint = <&pxa_camera>;
> > +					pclk-sample = <1>;
> >  				};
> >  			};
> >  		};
> 
> -- 
> Sakari Ailus
> sakari.ailus@linux.intel.com
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
