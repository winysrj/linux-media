Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:24288 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751803AbdITPvC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 11:51:02 -0400
Date: Wed, 20 Sep 2017 18:50:58 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170920155057.ded5rjcb3egi3yse@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <1555926.RTv2yyCEgl@avalon>
 <20170919124326.f3q4c6kwt3cfyyno@paasikivi.fi.intel.com>
 <3468276.k9eAkeO3hH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3468276.k9eAkeO3hH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 03:46:18PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 19 September 2017 15:43:26 EEST Sakari Ailus wrote:
> > On Tue, Sep 19, 2017 at 02:40:29PM +0300, Laurent Pinchart wrote:
> > > > @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
> > > > 
> > > >  	if (ret)
> > > >  	
> > > >  		return ret;
> > > > 
> > > > -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> > > > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > > > +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> > > > +		isp_fwnode_parse);
> > > > 
> > > >  	if (ret < 0)
> > > 
> > > The documentation in patch 05/25 states that v4l2_async_notifier_release()
> > > should be called even if v4l2_async_notifier_parse_fwnode_endpoints()
> > > fails. I don't think that's needed here, so you might want to update the
> > > documentation (and possibly the implementation of the function).
> > 
> > It is. If parsing fails, async sub-devices may have been already set up.
> > This happens e.g. when the parsing fails after the first one has been
> > successfully set up already.
> 
> But for v4l2_async_notifier_parse_fwnode_endpoints() we could clean up 
> internally when an error occurs. Otherwise you need to call 
> v4l2_async_notifier_release() here.

If a driver uses the variant that parses the endpoints by port, how should
that function behave? Release just as many async sub-devices it set up, and
leave the rest for the driver to handle?

The reason I left it as such as to make the responsibility clear: it
belongs to the driver.

I can change that if you really think it makes a difference for better. I'm
just not that certain about it.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
