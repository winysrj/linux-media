Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36068 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752273AbdASVox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 16:44:53 -0500
Date: Thu, 19 Jan 2017 23:37:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Pavel Machek <pavel@ucw.cz>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCHv2] dt: bindings: Add support for CSI1 bus
Message-ID: <20170119213753.GC3205@valkosipuli.retiisi.org.uk>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
 <20170112120603.6gwtpwhyuaynvlj3@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112120603.6gwtpwhyuaynvlj3@tarshish>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,

On Thu, Jan 12, 2017 at 02:06:03PM +0200, Baruch Siach wrote:
> Hi Pavel,
> 
> On Wed, Jan 11, 2017 at 11:53:35PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > In the vast majority of cases the bus type is known to the driver(s)
> > since a receiver or transmitter can only support a single one. There
> > are cases however where different options are possible.
> > 
> > The existing V4L2 OF support tries to figure out the bus type and
> > parse the bus parameters based on that. This does not scale too well
> > as there are multiple serial busses that share common properties.
> > 
> > Some hardware also supports multiple types of busses on the same
> > interfaces.
> > 
> > Document the CSI1/CCP2 property strobe. It signifies the clock or
> > strobe mode.
> >  
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index 9cd2a36..08c4498 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -76,6 +76,11 @@ Optional endpoint properties
> >    mode horizontal and vertical synchronization signals are provided to the
> >    slave device (data source) by the master device (data sink). In the master
> >    mode the data source device is also the source of the synchronization signals.
> > +- bus-type: data bus type. Possible values are:
> > +  0 - MIPI CSI2
> > +  1 - parallel / Bt656
> 
> Why not have separate values for parallel and BT.656?

The current implementation of V4L2 OF support digs the information from
other properties (hsync-active, vsync-active and field-even-active). If any
of them are present, the bus is considered to be a regular parallel bus ---
the Bt.656 has no such signals.

CSI-2 bus is assumed if CSI-2 specific properties can be found. However,
explicit bus type is needed as the type of the bus isn't anymore implicitly
determinable with the addition of CSI-1 and CCP2 busses: they use the same
properties.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
