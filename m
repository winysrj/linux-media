Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44192 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaAVW46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 17:56:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sebastian Reichel <sre@debian.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [RFCv2] Device Tree bindings for OMAP3 Camera System
Date: Wed, 22 Jan 2014 23:57:45 +0100
Message-ID: <2960230.3bGpm3THhQ@avalon>
In-Reply-To: <52E045DE.10706@gmail.com>
References: <20131103220315.GA11659@earth.universe> <20140120232719.GA30894@earth.universe> <52E045DE.10706@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 22 January 2014 23:27:42 Sylwester Nawrocki wrote:
> On 01/21/2014 12:27 AM, Sebastian Reichel wrote:
> > On Mon, Jan 20, 2014 at 11:16:43PM +0100, Sylwester Nawrocki wrote:
> >> On 01/20/2014 05:19 AM, Sakari Ailus wrote:

[snip]

> >>>> camera-switch {
> >>>> 
> >>>>      /*
> >>>>       * TODO:
> >>>>       *  - check if the switching code is generic enough to use a
> >>>>       *    more generic name like "gpio-camera-switch".

I think you can use a more generic name. You could probably get some 
inspiration from the i2c-mux-gpio DT bindings.

> >>>>       *  - document the camera-switch binding
> >>>>       */
> >>>>      
> >>>>      compatible = "nokia,n900-camera-switch";
> >>> 
> >>> Indeed. I don't think the hardware engineers realised what kind of a
> >>> long standing issue they created for us when they chose that solution.
> >>> ;)
> >>> 
> >>> Writing a small driver for this that exports a sub-device would probably
> >>> be the best option as this is hardly very generic. Should this be shown
> >>> to the user space or not? Probably it'd be nice to avoid showing the
> >>> related sub-device if there would be one.
> >> 
> >> Probably we should avoid exposing such a hardware detail to user space.
> >> OTOH it would be easy to handle as a media entity through the media
> >> controller API.
> > 
> > If this is exposed to the userspace, then a userspace application
> > "knows", that it cannot use both cameras at the same time. Otherwise
> > it can just react to error messages when it tries to use the second
> > camera.
> 
> Indeed, that's a good argument, I forgot about it for a while.
> 
> >>> I'm still trying to get N9 support working first, the drivers are in a
> >>> better shape and there are no such hardware hacks.
> >>> 
> >>>>      gpios =<&gpio4 1>; /* 97 */
> >> 
> >> I think the binding should be defining how state of the GPIO corresponds
> >> to state of the mux.
> > 
> > Obviously it should be mentioned in the n900-camera-switch binding
> > Documentation. This document was just the proposal for the omap3isp
> > node :)
> 
> Huh, I wasn't reading carefully enough! Then since it is just about the
> OMAP3 ISP it might be a good idea to drop the switch from the example,
> it seems unrelated.
> 
> >>>>      port@0 {
> >>>>          switch_in: endpoint {
> >>>>              remote-endpoint =<&csi1_ep>;
> >>>>          };
> >>>>          switch_out1: endpoint {
> >>>>              remote-endpoint =<&et8ek8>;
> >>>>          };
> >>>>          switch_out2: endpoint {
> >>>>              remote-endpoint =<&smiapp_dfl>;
> >>>>          };
> >>>>      };
> >> 
> >> This won't work, since names of the nodes are identical they will be
> >> combined by the dtc into a single 'endpoint' node with single
> >> 'remote-endpoint' property
> >> - might not be exactly something that you want.
> > 
> >> So it could be rewritten like:
> > right.
> > 
> >> [...]
> >> However, simplifying a bit, the 'endpoint' nodes are supposed to describe
> >> the configuration of a bus interface (port) for a specific remote device.
> >> 
> >> Then what you need might be something like:
> >>   camera-switch {
> >> 	
> >> 	compatible = "nokia,n900-camera-switch";
> >> 	
> >> 	#address-cells =<1>;
> >> 	#size-cells =<0>;
> >> 	
> >> 	switch_in: port@0 {
> >> 		reg =<0>;
> >> 		endpoint {
> >> 			remote-endpoint =<&csi1_ep>;
> >> 		};
> >> 	};
> >>          switch_out1: port@1 {
> >> 		reg =<1>;
> >> 		endpoint {
> >> 			remote-endpoint =<&et8ek8>;
> >> 		};
> >> 	};
> >> 	switch_out2: port@2 {
> >> 		endpoint {
> >> 			reg =<2>;
> >> 			remote-endpoint =<&smiapp_dfl>;
> >> 		};
> >> 	};
> >>   };
> > 
> > sounds fine to me.
> > 
> >> I'm just wondering if we need to be describing this in DT in such
> >> detail.
> > 
> > Do you have an alternative suggestion for the N900's bus switch
> > hack?
> 
> No, not really anything better at the moment.

-- 
Regards,

Laurent Pinchart

