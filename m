Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56133 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750807AbbCYWjP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 18:39:15 -0400
Date: Thu, 26 Mar 2015 00:38:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH v1.1 14/15] omap3isp: Add support for the Device Tree
Message-ID: <20150325223839.GO18321@valkosipuli.retiisi.org.uk>
References: <2603487.gEIKMl6vV7@avalon>
 <1426889104-17921-1-git-send-email-sakari.ailus@iki.fi>
 <3913985.bpC1SiT8Tn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3913985.bpC1SiT8Tn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks again for the comments!

On Sun, Mar 22, 2015 at 10:26:39PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch. This looks good to me, except that there's one last 
> bug I've spotted. Please see below.
> 
> On Saturday 21 March 2015 00:05:04 Sakari Ailus wrote:
> > Add the ISP device to omap3 DT include file and add support to the driver to
> > use it.
> > 
> > Also obtain information on the external entities and the ISP configuration
> > related to them through the Device Tree in addition to the platform data.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > since v1:
> > 
> > - Print endpoint name in debug message when parsing an endpoint.
> > 
> > - Rename lane-polarity property as lane-polarities.
> > 
> > - Print endpoint name with the interface if the interface is invalid.
> > 
> > - Remove assignment to two variables at the same time.
> > 
> > - Fix multiple sub-device support in isp_of_parse_nodes().
> > 
> > - Put of_node properly in isp_of_parse_nodes() (requires Philipp Zabel's
> >   patch "of: Decrement refcount of previous endpoint in
> >   of_graph_get_next_endpoint".
> > 
> > - Rename return value variable rval as ret to be consistent with the rest of
> > the driver.
> > 
> > - Read the register offset from the syscom property's first argument.
> > 
> >  drivers/media/platform/omap3isp/isp.c       |  218 ++++++++++++++++++++++--
> >  drivers/media/platform/omap3isp/isp.h       |   11 ++
> >  drivers/media/platform/omap3isp/ispcsiphy.c |    7 +
> >  3 files changed, 224 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 992e74c..92a859e 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> 
> [snip]
> 
> > +static int isp_of_parse_nodes(struct device *dev,
> > +			      struct v4l2_async_notifier *notifier)
> > +{
> > +	struct device_node *node;
> > +
> > +	notifier->subdevs = devm_kcalloc(
> > +		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> > +	if (!notifier->subdevs)
> > +		return -ENOMEM;
> > +
> > +	while ((node = of_graph_get_next_endpoint(dev->of_node, node)) &&
> > +	       notifier->num_subdevs < ISP_MAX_SUBDEVS) {
> 
> If the first condition evaluates to true and the second one to false, the loop 
> will be exited without releasing the reference to the DT node. You could just 
> switch the two conditions to fix this.

Oh, I missed this. I'll resend the set.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
