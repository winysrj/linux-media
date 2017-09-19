Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34512 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750872AbdISOrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 10:47:25 -0400
Date: Tue, 19 Sep 2017 17:47:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing
 fwnode endpoints
Message-ID: <20170919144722.4s5j3vos3xsyaaa2@valkosipuli.retiisi.org.uk>
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

The functions that set up async sub-devices can be called multiple times
(on separate references). This is quite alike setting up a control handler
really, so I adopted the same pattern.

If there is a failure, how many async sub-devices should be cleaned up, if
there have been async sub-devices already set up before calling this
function?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
