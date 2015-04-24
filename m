Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43842 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031393AbbDXTuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 15:50:10 -0400
Date: Fri, 24 Apr 2015 22:49:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Benoit Parrot <bparrot@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 12/15] dt: bindings: Add lane-polarity property to
 endpoint nodes
Message-ID: <20150424194933.GF27451@valkosipuli.retiisi.org.uk>
References: <1427324259-18438-1-git-send-email-sakari.ailus@iki.fi>
 <1427324259-18438-13-git-send-email-sakari.ailus@iki.fi>
 <20150424194100.GG24270@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150424194100.GG24270@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benoit,

On Fri, Apr 24, 2015 at 02:41:00PM -0500, Benoit Parrot wrote:
> Sakari Ailus <sakari.ailus@iki.fi> wrote on Thu [2015-Mar-26 00:57:36 +0200]:
> > Add lane-polarity property to endpoint nodes. This essentially tells that
> > the order of the differential signal wires is inverted.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index 571b4c6..9cd2a36 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -106,6 +106,12 @@ Optional endpoint properties
> >  - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
> >    instance, this is the actual frequency of the bus, not bits per clock per
> >    lane value. An array of 64-bit unsigned integers.
> > +- lane-polarities: an array of polarities of the lanes starting from the clock
> > +  lane and followed by the data lanes in the same order as in data-lanes.
> > +  Valid values are 0 (normal) and 1 (inverted). The length of the array
> > +  should be the combined length of data-lanes and clock-lanes properties.
> > +  If the lane-polarities property is omitted, the value must be interpreted
> > +  as 0 (normal). This property is valid for serial busses only.
> >  
> 
> I am interested in this functionality.
> But I do have the following question.
> If the lane-polarities property is not specified, shouldn't the
> relevant struct member (bus->lane_polarities[i]) be set to 0?

This is done in the caller function; endpoint->bus is zeroed in
v4l2_of_parse_endpoint(). I believe reading rest of the properties relies on
the same.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
