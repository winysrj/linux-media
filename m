Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44699 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753574AbcJNPtA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 11:49:00 -0400
Message-ID: <1476460139.11834.45.camel@pengutronix.de>
Subject: Re: [PATCH 03/22] [media] v4l: of: add v4l2_of_subdev_registered
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@pengutronix.de
Date: Fri, 14 Oct 2016 17:48:59 +0200
In-Reply-To: <99f7a5c6-2b51-38f0-5984-366cdc858f3d@denx.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
         <20161007160107.5074-4-p.zabel@pengutronix.de>
         <99f7a5c6-2b51-38f0-5984-366cdc858f3d@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 07.10.2016, 20:50 +0200 schrieb Marek Vasut:
> On 10/07/2016 06:00 PM, Philipp Zabel wrote:
> > Provide a default registered callback for device tree probed subdevices
> > that use OF graph bindings to add still missing source subdevices to
> > the async notifier waiting list.
> > This is only necessary for subdevices that have input ports to which
> > other subdevices are connected that are not initially known to the
> > master/bridge device when it sets up the notifier.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> [...]
> 
> > +int v4l2_of_subdev_registered(struct v4l2_subdev *sd)
> > +{
> > +	struct device_node *ep;
> > +
> > +	for_each_endpoint_of_node(sd->of_node, ep) {
> > +		struct v4l2_of_link link;
> > +		struct media_entity *entity;
> > +		unsigned int pad;
> > +		int ret;
> > +
> > +		ret = v4l2_of_parse_link(ep, &link);
> > +		if (ret)
> > +			continue;
> > +
> > +		/*
> > +		 * Assume 1:1 correspondence between OF node and entity,
> > +		 * and between OF port numbers and pad indices.
> > +		 */
> > +		entity = &sd->entity;
> 
> This here will not compile if CONFIG_MEDIA_CONTROLLER is not set,
> because ->entity will be missing from struct v4l2_subdev {} .

Thanks, I'll fix this.

regards
Philipp

