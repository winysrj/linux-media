Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56552 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751322AbdGRKI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:08:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required regulators can't be obtained
Date: Tue, 18 Jul 2017 13:08:34 +0300
Message-ID: <3294296.B0HR3QnnsQ@avalon>
In-Reply-To: <20170718100352.GA28481@amd>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com> <1652763.9EYemjAvaH@avalon> <20170718100352.GA28481@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tuesday 18 Jul 2017 12:03:52 Pavel Machek wrote:
> Hi!
> 
> >> diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> >> b/drivers/media/platform/omap3isp/ispccp2.c index
> >> 4f8fd0c00748..47210b102bcb 100644
> >> --- a/drivers/media/platform/omap3isp/ispccp2.c
> >> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> >> @@ -1140,6 +1140,11 @@ int omap3isp_ccp2_init(struct isp_device *isp)
> >>  	if (isp->revision == ISP_REVISION_2_0) {
> >>  		ccp2->vdds_csib = devm_regulator_get(isp->dev, "vdds_csib");
> >>  		if (IS_ERR(ccp2->vdds_csib)) {
> >> +			if (PTR_ERR(ccp2->vdds_csib) == -EPROBE_DEFER) {
> >> +				dev_dbg(isp->dev,
> >> +					"Can't get regulator vdds_csib,
> >> deferring probing\n");
> >> +				return -EPROBE_DEFER;
> >> +			}
> >> 
> >>  			dev_dbg(isp->dev,
> >>  				"Could not get regulator vdds_csib\n");
> > 
> > I would just move this message above the -EPROBE_DEFER check and remove
> > the one inside the check. Probe deferral debug information can be obtained
> > by enabling the debug messages in the driver core.
> 
> Actually, in such case perhaps the message in -EPROBE_DEFER could be
> removed. Deferred probing happens all the time. OTOH "Could not get
> regulator" probably should be dev_err(), as it will make device
> unusable?

Messages along the lines of "I'm deferring probe" are in my opinion not 
valuable, as we can get that from the driver core. Debug messages that tell 
why probe is being deferred can however be useful for debugging. That's why I 
proposed to move the regulator get error debug message above the probe 
deferral check, as it would then always be printed. Turning it into an error 
makes sense, but only when not deferring probe then.

-- 
Regards,

Laurent Pinchart
