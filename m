Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54425 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbGQOGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:06:41 -0400
Message-ID: <1437141997.3254.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/4] [media] tc358743: support probe from device tree
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Fri, 17 Jul 2015 16:06:37 +0200
In-Reply-To: <55A8F3A6.5030000@xs4all.nl>
References: <1437130692-8256-1-git-send-email-p.zabel@pengutronix.de>
	 <1437130692-8256-3-git-send-email-p.zabel@pengutronix.de>
	 <55A8F3A6.5030000@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Freitag, den 17.07.2015, 14:23 +0200 schrieb Hans Verkuil:
[...]
> > +	endpoint = v4l2_of_alloc_parse_endpoint(ep);
> > +	if (IS_ERR(endpoint)) {
> > +		dev_err(dev, "failed to parse endpoint\n");
> > +		return PTR_ERR(endpoint);
> > +	}
> > +
> > +	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
> > +	    endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
> > +	    endpoint->nr_of_link_frequencies == 0) {
> > +		dev_err(dev, "missing CSI-2 properties in endpoint\n");
> > +		goto free_endpoint;
> > +	}
> > +
> > +	state->bus = endpoint.bus.mipi_csi2;
> 
> This should be endpoint->bus. You clearly didn't compile it.
> 
> Please make a v3, ensure that it compiles and please test it as well.

Sorry, fixed, tested, and resent.

regards
Philipp

