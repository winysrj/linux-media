Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33178 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752246AbdHOLYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:24:49 -0400
Date: Tue, 15 Aug 2017 14:24:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: Re: [RFC 04/19] dt: bindings: Add lens-focus binding for image
 sensors
Message-ID: <20170815112446.5qhasjopvnbdraez@valkosipuli.retiisi.org.uk>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-5-sakari.ailus@linux.intel.com>
 <dcd84739-7e83-e07f-9290-a066013af102@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcd84739-7e83-e07f-9290-a066013af102@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jul 28, 2017 at 10:53:35AM +0200, Hans Verkuil wrote:
> Hi Sakari,
> 
> Is the lens-focus phandle specific to voice-coil controllers? What about

I think it's not important. Right now the information is used for making
the association only.

> motor-controlled focus systems? What when there are multiple motors? E.g.
> one for the focus, one for the iris control (yes, we have that).

I'd add another property for this purpose.

> 
> What if you have two sensors (stereoscopic) controlled by one motor?

You can refer to the same controller from both, I don't see a problem with
that. The software would need to support that though, I think changes to
the async framework would be needed.

> 
> Just trying to understand this from a bigger perspective. Specifically
> how this will scale when more of these supporting devices as added.
> 
> Regards,
> 
> 	Hans
> 
> On 07/18/2017 09:03 PM, Sakari Ailus wrote:
> > The lens-focus property contains a phandle to the lens voice coil driver
> > that is associated to the sensor; typically both are contained in the same
> > camera module.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index 9723f7e1c7db..a18d9b2d309f 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -74,6 +74,8 @@ Optional properties
> >  - flash: phandle referring to the flash driver chip. A flash driver may
> >    have multiple flashes connected to it.
> >  
> > +- lens-focus: A phandle to the node of the focus lens controller.
> > +
> >  
> >  Optional endpoint properties
> >  ----------------------------
> > 
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
