Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34190 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753120AbbCGX5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 18:57:47 -0500
Date: Sun, 8 Mar 2015 01:57:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC 12/18] dt: bindings: Add lane-polarity property to endpoint
 nodes
Message-ID: <20150307235714.GI6539@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-13-git-send-email-sakari.ailus@iki.fi>
 <2025225.4flgD7jFWe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025225.4flgD7jFWe@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 08, 2015 at 01:46:02AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> (CC'ing Sylwester)
> 
> On Saturday 07 March 2015 23:41:09 Sakari Ailus wrote:
> > Add lane-polarity property to endpoint nodes. This essentially tells that
> > the order of the differential signal wires is inverted.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > b/Documentation/devicetree/bindings/media/video-interfaces.txt index
> > 571b4c6..058d1e6 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -106,6 +106,11 @@ Optional endpoint properties
> >  - link-frequencies: Allowed data bus frequencies. For MIPI CSI-2, for
> >    instance, this is the actual frequency of the bus, not bits per clock per
> > lane value. An array of 64-bit unsigned integers.
> > +- lane-polarity: an array of polarities of the lanes starting from the
> > clock
> > +  lane and followed by the data lanes in the same order as in data-lanes.
> > +  Valid values are 0 (normal) and 1 (inverted).
> 
> Would it make sense to add #define's for this ?

Good question. I don't really have too much of an opinion. I think I'd just
use a number until someone else needs this. :-)

> > The length of the array
> > +  should be the combined length of data-lanes and clock-lanes
> > properties.
> > +  This property is valid for serial busses only.
> 
> You should also document what happens when the property is omitted.

Will add.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
