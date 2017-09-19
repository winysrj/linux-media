Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38302 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbdISMqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:46:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing fwnode endpoints
Date: Tue, 19 Sep 2017 15:46:18 +0300
Message-ID: <3468276.k9eAkeO3hH@avalon>
In-Reply-To: <20170919124326.f3q4c6kwt3cfyyno@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <1555926.RTv2yyCEgl@avalon> <20170919124326.f3q4c6kwt3cfyyno@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 15:43:26 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 02:40:29PM +0300, Laurent Pinchart wrote:
> > > @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device *pdev)
> > > 
> > >  	if (ret)
> > >  	
> > >  		return ret;
> > > 
> > > -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> > > +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> > > +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> > > +		isp_fwnode_parse);
> > > 
> > >  	if (ret < 0)
> > 
> > The documentation in patch 05/25 states that v4l2_async_notifier_release()
> > should be called even if v4l2_async_notifier_parse_fwnode_endpoints()
> > fails. I don't think that's needed here, so you might want to update the
> > documentation (and possibly the implementation of the function).
> 
> It is. If parsing fails, async sub-devices may have been already set up.
> This happens e.g. when the parsing fails after the first one has been
> successfully set up already.

But for v4l2_async_notifier_parse_fwnode_endpoints() we could clean up 
internally when an error occurs. Otherwise you need to call 
v4l2_async_notifier_release() here.

-- 
Regards,

Laurent Pinchart
