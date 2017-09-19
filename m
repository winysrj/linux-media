Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:61960 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdISMnb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:43:31 -0400
Date: Tue, 19 Sep 2017 15:43:26 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170919124326.f3q4c6kwt3cfyyno@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-7-sakari.ailus@linux.intel.com>
 <1555926.RTv2yyCEgl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1555926.RTv2yyCEgl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 19, 2017 at 02:40:29PM +0300, Laurent Pinchart wrote:
> > @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
> >  	if (ret)
> >  		return ret;
> > 
> > -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> > +		isp_fwnode_parse);
> >  	if (ret < 0)
> 
> The documentation in patch 05/25 states that v4l2_async_notifier_release() 
> should be called even if v4l2_async_notifier_parse_fwnode_endpoints() fails. I 
> don't think that's needed here, so you might want to update the documentation 
> (and possibly the implementation of the function).

It is. If parsing fails, async sub-devices may have been already set up.
This happens e.g. when the parsing fails after the first one has been
successfully set up already.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
