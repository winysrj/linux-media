Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39299 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdISQMR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 12:12:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 06/25] omap3isp: Use generic parser for parsing fwnode endpoints
Date: Tue, 19 Sep 2017 19:12:14 +0300
Message-ID: <2111815.EclloaXXVN@avalon>
In-Reply-To: <20170919144722.4s5j3vos3xsyaaa2@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <3468276.k9eAkeO3hH@avalon> <20170919144722.4s5j3vos3xsyaaa2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 17:47:22 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 03:46:18PM +0300, Laurent Pinchart wrote:
> > On Tuesday, 19 September 2017 15:43:26 EEST Sakari Ailus wrote:
> >> On Tue, Sep 19, 2017 at 02:40:29PM +0300, Laurent Pinchart wrote:
> >>>> @@ -2256,7 +2210,9 @@ static int isp_probe(struct platform_device
> >>>> *pdev)
> >>>>  	if (ret)
> >>>>  		return ret;
> >>>> 
> >>>> -	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> >>>> +	ret = v4l2_async_notifier_parse_fwnode_endpoints(
> >>>> +		&pdev->dev, &isp->notifier, sizeof(struct isp_async_subdev),
> >>>> +		isp_fwnode_parse);
> >>>>  	if (ret < 0)
> >>> 
> >>> The documentation in patch 05/25 states that
> >>> v4l2_async_notifier_release() should be called even if
> >>> v4l2_async_notifier_parse_fwnode_endpoints() fails. I don't think that's
> >>> needed here, so you might want to update the documentation (and possibly
> >>> the implementation of the function).
> >> 
> >> It is. If parsing fails, async sub-devices may have been already set up.
> >> This happens e.g. when the parsing fails after the first one has been
> >> successfully set up already.
> > 
> > But for v4l2_async_notifier_parse_fwnode_endpoints() we could clean up
> > internally when an error occurs. Otherwise you need to call
> > v4l2_async_notifier_release() here.
> 
> The functions that set up async sub-devices can be called multiple times
> (on separate references). This is quite alike setting up a control handler
> really, so I adopted the same pattern.
> 
> If there is a failure, how many async sub-devices should be cleaned up, if
> there have been async sub-devices already set up before calling this
> function?

I'm not opposed to that pattern, I just thought that cleanup could be 
automated for v4l2_async_notifier_parse_fwnode_endpoints() failures, as 
opposed to v4l2_async_notifier_parse_fwnode_endpoints_by_port() failures.

As this patch, written by the author of 
v4l2_async_notifier_parse_fwnode_endpoints() and part of the same patch 
series, is missing a call to v4l2_async_notifier_release(), I expect driver 
authors to make the same mistake and was thus wondering how to prevent that.

I believe that the issue here is that initialization of the notifier is done 
implicitly by the first call to a parsing function. With explicit notification 
it should be clear to driver authors that they need to call the cleanup 
function:

ret = init()
if (ret)
	return ret;

ret = parse()
if (ret) {
	cleanup();
	return ret;
}

ret = parse()
if (ret) {
	cleanup();
	return ret;
}

ret = parse()
if (ret) {
	cleanup();
	return ret;
}

But with an implicit initialization it's easy to miss cleanup when 
v4l2_async_notifier_parse_fwnode_endpoints() fails, as that function can be 
considered as an initilization function that performs cleanup internally.

I'm not sure what the best pattern would be. At the very least you need to fix 
this patch, but that wouldn't prevent future mistakes.

-- 
Regards,

Laurent Pinchart
