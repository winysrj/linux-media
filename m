Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:57288 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1LSHR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 02:17:28 -0500
Date: Mon, 19 Dec 2011 09:17:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 3/4] omap3isp: Configure CSI-2 phy based on platform data
Message-ID: <20111219071723.GL3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
 <201112151354.53360.laurent.pinchart@ideasonboard.com>
 <20111215215033.GG3677@valkosipuli.localdomain>
 <201112190131.10973.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112190131.10973.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Dec 19, 2011 at 01:31:09AM +0100, Laurent Pinchart wrote:
> On Thursday 15 December 2011 22:50:33 Sakari Ailus wrote:
> > On Thu, Dec 15, 2011 at 01:54:52PM +0100, Laurent Pinchart wrote:
> > > On Thursday 15 December 2011 12:53:03 Sakari Ailus wrote:
> > > > On Thu, Dec 15, 2011 at 11:28:06AM +0100, Laurent Pinchart wrote:
> > > > > On Thursday 15 December 2011 10:50:34 Sakari Ailus wrote:
> > > > > > Configure CSI-2 phy based on platform data in the ISP driver rather
> > > > > > than in platform code.
> > > > > > 
> > > > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > 
> > > [snip]
> > > 
> > > > > > diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> > > > > > b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..52af308
> > > > > > 100644 --- a/drivers/media/video/omap3isp/ispcsiphy.c
> > > > > > +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> > > > > > @@ -28,6 +28,8 @@
> > > 
> > > [snip]
> > > 
> > > > > > +int omap3isp_csiphy_config(struct isp_device *isp,
> > > > > > +			   struct v4l2_subdev *csi2_subdev,
> > > > > > +			   struct v4l2_subdev *sensor,
> > > > > > +			   struct v4l2_mbus_framefmt *sensor_fmt)
> > > > > 
> > > > > The number of lanes can depend on the format. Wouldn't it be better
> > > > > to add a subdev operation to query the sensor for its bus
> > > > > configuration instead of relying on ISP platform data ?
> > > > 
> > > > In principle, yes. That's an interesting point; how this kind of
> > > > information would best be delivered?
> > > 
> > > There are two separate information that need to be delivered:
> > > 
> > > - how the lanes are connected on the board
> > > - which lanes are used by the sensor, and for what purpose
> > > 
> > > The first information must be supplied through platform data, either to
> > > the sensor driver or the OMAP3 ISP driver (or both). As the second
> > > information
> > 
> > Both, and both of them may require configuring it. I don't know sensors
> > that allow it, but the CSI-2 receiver is flexible in lane mapping.
> > 
> > > comes from the sensor, my idea was to provide the first to the sensor,
> > > and to query the sensor in the OMAP3 ISP driver for the full
> > > configuration.
> > 
> > In theory, at least, configurations with less lanes need to be specified
> > separately. There may be limitations on how the lanes can be used, say,
> > using two out of three lanes may require leaving a aparticular lane unused.
> 
> In theory, I fully agree. This brings additional complexity for use cases that 
> might never exist though. Do you think we need to support it from the very 
> beginning ?

I don't see need for it, at least not for the time being. Still we might
want to show the number of lanes to the user as a read-onlycontrol, but that
could wait as well IMO.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
