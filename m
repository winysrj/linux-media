Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21380C10F00
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 10:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEE99218AC
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 10:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfCOKGU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:06:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:15379 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfCOKGT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 06:06:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Mar 2019 03:06:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,481,1544515200"; 
   d="scan'208";a="140994315"
Received: from ldigrego-mobl1.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.249.45.191])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Mar 2019 03:06:16 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id A5DF921F57; Fri, 15 Mar 2019 12:06:14 +0200 (EET)
Date:   Fri, 15 Mar 2019 12:06:14 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 26/31] adv748x: csi2: add internal routing
 configuration
Message-ID: <20190315100613.avmsmavdraxetkzl@kekkonen.localdomain>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-27-jacopo+renesas@jmondi.org>
 <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
 <20190315094538.bs5ecsdzndrxjdbb@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190315094538.bs5ecsdzndrxjdbb@uno.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Luca, Jacopo,

On Fri, Mar 15, 2019 at 10:45:38AM +0100, Jacopo Mondi wrote:
> Hi Luca,
> 
> On Thu, Mar 14, 2019 at 03:45:27PM +0100, Luca Ceresoli wrote:
> > Hi,
> >
> > begging your pardon for the noob question below...
> >
> 
> Let a noob help another noob then
> 
> > On 05/03/19 19:51, Jacopo Mondi wrote:
> > > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > >
> > > Add support to get and set the internal routing between the adv748x
> > > CSI-2 transmitters sink pad and its multiplexed source pad. This routing
> > > includes which stream of the multiplexed pad to use, allowing the user
> > > to select which CSI-2 virtual channel to use when transmitting the
> > > stream.
> > >
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > > ---
> > >  drivers/media/i2c/adv748x/adv748x-csi2.c | 65 ++++++++++++++++++++++++
> > >  1 file changed, 65 insertions(+)
> > >
> > > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > index d8f7cbee86e7..13454af72c6e 100644
> > > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > > @@ -14,6 +14,8 @@
> > >
> > >  #include "adv748x.h"
> > >
> > > +#define ADV748X_CSI2_ROUTES_MAX 4
> > > +
> > >  struct adv748x_csi2_format {
> > >  	unsigned int code;
> > >  	unsigned int datatype;
> > > @@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
> > >  	return 0;
> > >  }
> > >
> > > +static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
> > > +				    struct v4l2_subdev_krouting *routing)
> > > +{
> > > +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> > > +	struct v4l2_subdev_route *r = routing->routes;
> > > +	unsigned int vc;
> > > +
> > > +	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
> > > +		routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
> > > +		return -ENOSPC;
> > > +	}
> > > +
> > > +	routing->num_routes = ADV748X_CSI2_ROUTES_MAX;
> > > +
> > > +	for (vc = 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
> > > +		r->sink_pad = ADV748X_CSI2_SINK;
> > > +		r->sink_stream = 0;
> > > +		r->source_pad = ADV748X_CSI2_SOURCE;
> > > +		r->source_stream = vc;
> > > +		r->flags = vc == tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
> > > +		r++;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
> > > +				    struct v4l2_subdev_krouting *routing)
> > > +{
> > > +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> > > +	struct v4l2_subdev_route *r = routing->routes;
> > > +	unsigned int i;
> > > +	int vc = -1;
> > > +
> > > +	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
> > > +		return -ENOSPC;
> > > +
> > > +	for (i = 0; i < routing->num_routes; i++) {
> > > +		if (r->sink_pad != ADV748X_CSI2_SINK ||
> > > +		    r->sink_stream != 0 ||
> > > +		    r->source_pad != ADV748X_CSI2_SOURCE ||
> > > +		    r->source_stream >= ADV748X_CSI2_ROUTES_MAX)
> > > +			return -EINVAL;
> > > +
> > > +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
> > > +			if (vc != -1)
> > > +				return -EMLINK;
> > > +
> > > +			vc = r->source_stream;
> > > +		}
> > > +		r++;
> > > +	}
> > > +
> > > +	if (vc != -1)
> > > +		tx->vc = vc;
> > > +
> > > +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
> > > +
> > > +	return 0;
> > > +}
> >
> > Not specific to this patch but rather to the set_routing idea as a
> > whole: can the set_routing ioctl be called while the stream is running?
> >
> > If it cannot, I find it a limiting factor for nowadays use cases. I also
> > didn't find where the ioctl is rejected.
> >
> 
> The framework does not make assumptions about that at the moment.
> 
> > If it can, then shouldn't this function call s_stream(stop) through the
> > sink pad whose route becomes disabled, and a s_stream(start) through the
> > one that gets enabled?
> >
> 
> If I got this right, you're here rightfully pointing out that changing
> the routing between pads in an entity migh impact the pipeline as a
> whole, and this would require, to activate/deactivate devices that
> where not part of the pipeline.

I'd say that ultimately this depends on the devices themselves, whether
they support this or not. In practice I don't think we have any such cases
at the moment, but it's possible in principle. Changes on the framework may
well be needed but likely the biggest complications will still be in
drivers supporting that.

The media links have a dynamic flag for this purpose but I don't think it's
ever been used.

> 
> This is probably the wrong patch to use an example, as this one is for
> a multiplexed interface, where there is no need to go through an
> s_stream() for the two CSI-2 endpoints, but as you pointed out in our
> brief offline chat, the AFE->TX routing example for this very device
> is a good one: if we change the analogue source that is internally
> routed to the CSI-2 output of the adv748x, do we need to s_stream(1)
> the now routed entity and s_stream(0) on the not not-anymore-routed
> one?
> 
> My gut feeling is that this is up to userspace, as it should know
> what are the requirements of the devices in the system, but this mean
> going through an s_stream(0)/s_stream(1) sequence on the video device,
> and that would interrupt the streaming for sure.
> 
> At the same time, I don't feel too much at ease with the idea of
> s_routing calling s_stream on the entity' remote subdevices, as this
> would skip the link format validation that media_pipeline_start()
> performs.

The link validation must be done in this case as well, it may not be
simply skipped.

> 
> So yeah, I understand your point, but I don't have a real answer,
> maybe someone else does and want to share his mind?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
