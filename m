Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39138 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbDXTxS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 15:53:18 -0400
Date: Fri, 24 Apr 2015 14:53:02 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<tony@atomide.com>, <sre@kernel.org>, <pali.rohar@gmail.com>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 12/15] dt: bindings: Add lane-polarity property to
 endpoint nodes
Message-ID: <20150424195302.GA12032@ti.com>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
 <1427324259-18438-13-git-send-email-sakari.ailus@iki.fi>
 <20150424194100.GG24270@ti.com>
 <20150424194933.GF27451@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150424194933.GF27451@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus <sakari.ailus@iki.fi> wrote on Fri [2015-Apr-24 22:49:33 +0300]:
> Hi Benoit,
> 
> On Fri, Apr 24, 2015 at 02:41:00PM -0500, Benoit Parrot wrote:
> > Sakari Ailus <sakari.ailus@iki.fi> wrote on Thu [2015-Mar-26 00:57:36 +0200]:
> > > Add lane-polarity property to endpoint nodes. This essentially tells that
> > > the order of the differential signal wires is inverted.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  Documentation/devicetree/bindings/media/video-interfaces.txt |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > index 571b4c6..9cd2a36 100644
> > > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > > @@ -106,6 +106,12 @@ Optional endpoint properties
> > >  - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
> > >    instance, this is the actual frequency of the bus, not bits per clock per
> > >    lane value. An array of 64-bit unsigned integers.
> > > +- lane-polarities: an array of polarities of the lanes starting from the clock
> > > +  lane and followed by the data lanes in the same order as in data-lanes.
> > > +  Valid values are 0 (normal) and 1 (inverted). The length of the array
> > > +  should be the combined length of data-lanes and clock-lanes properties.
> > > +  If the lane-polarities property is omitted, the value must be interpreted
> > > +  as 0 (normal). This property is valid for serial busses only.
> > >  
> > 
> > I am interested in this functionality.
> > But I do have the following question.
> > If the lane-polarities property is not specified, shouldn't the
> > relevant struct member (bus->lane_polarities[i]) be set to 0?
> 
> This is done in the caller function; endpoint->bus is zeroed in
> v4l2_of_parse_endpoint(). I believe reading rest of the properties relies on
> the same.

Dang, missed that.
Sorry for the noise.

> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
