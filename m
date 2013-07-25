Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36959 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755983Ab3GYNne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 09:43:34 -0400
Date: Thu, 25 Jul 2013 16:43:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 5/5] v4l: Renesas R-Car VSP1 driver
Message-ID: <20130725134328.GH12281@valkosipuli.retiisi.org.uk>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1374072882-14598-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20130724224858.GG12281@valkosipuli.retiisi.org.uk>
 <1833071.CAa8KOE02B@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1833071.CAa8KOE02B@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Jul 25, 2013 at 01:46:54PM +0200, Laurent Pinchart wrote:
> > On Wed, Jul 17, 2013 at 04:54:42PM +0200, Laurent Pinchart wrote:
> > ...
> > 
> > > +static void vsp1_device_init(struct vsp1_device *vsp1)
> > > +{
> > > +	unsigned int i;
> > > +	u32 status;
> > > +
> > > +	/* Reset any channel that might be running. */
> > > +	status = vsp1_read(vsp1, VI6_STATUS);
> > > +
> > > +	for (i = 0; i < VPS1_MAX_WPF; ++i) {
> > > +		unsigned int timeout;
> > > +
> > > +		if (!(status & VI6_STATUS_SYS_ACT(i)))
> > > +			continue;
> > > +
> > > +		vsp1_write(vsp1, VI6_SRESET, VI6_SRESET_SRTS(i));
> > > +		for (timeout = 10; timeout > 0; --timeout) {
> > > +			status = vsp1_read(vsp1, VI6_STATUS);
> > > +			if (!(status & VI6_STATUS_SYS_ACT(i)))
> > > +				break;
> > > +
> > > +			usleep_range(1000, 2000);
> > > +		}
> > > +
> > > +		if (timeout)
> > > +			dev_err(vsp1->dev, "failed to reset wpf.%u\n", i);
> > 
> > Have you seen this happening in practice? Do you expect the device to
> > function if resetting it fails?
> 
> I've seen this happening during development when I had messed up register 
> values, but not otherwise. I don't expect the deviec to still function if 
> resetting the WPF fails, but I need to make sure that the busy loop exits.

Shouldn't you also return an error in this case? The function currently
returns void.

...

> > > +	/* Follow links downstream for each input and make sure the graph
> > > +	 * contains no loop and that all branches end at the output WPF.
> > > +	 */
> > 
> > I wonder if checking for loops should be done already in pipeline validation
> > done by the framework. That's fine to do later on IMHO, too.
> 
> It would have to be performed by the core, as the callbacks are local to 
> links. That's feasible (but should be optional, as some devices might support 
> circular graphs), feel free to submit a patch :-)

As a matter of fact I think I will. I'd like you to test it though since I
have no hardware with such media graph. :-)

But please don't expect to see that in time for your driver to get in. Let's
think about that later on.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
