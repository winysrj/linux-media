Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57750 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031139AbeBNPCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 10:02:53 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v7 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Date: Wed, 14 Feb 2018 17:03:26 +0200
Message-ID: <1952975.8AbmfkeE6m@avalon>
In-Reply-To: <20180214131933.t75jg5b5cjfuo7r6@flea.home>
References: <20180208150830.9219-1-maxime.ripard@bootlin.com> <2517178.9jmyBy62ST@avalon> <20180214131933.t75jg5b5cjfuo7r6@flea.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Wednesday, 14 February 2018 15:19:33 EET Maxime Ripard wrote:
> On Thu, Feb 08, 2018 at 08:17:19PM +0200, Laurent Pinchart wrote:
> >> +	/*
> >> +	 * Create a static mapping between the CSI virtual channels
> >> +	 * and the output stream.
> >> +	 *
> >> +	 * This should be enhanced, but v4l2 lacks the support for
> >> +	 * changing that mapping dynamically.
> >> +	 *
> >> +	 * We also cannot enable and disable independant streams here,
> >> +	 * hence the reference counting.
> >> +	 */
> > 
> > If you start all streams in one go, will s_stream(1) be called multiple
> > times ? If not, you could possibly skip the whole reference counting and
> > avoid locking.
> 
> I guess that while we should expect the CSI-2 bus to be always
> enabled, the downstream camera interface could be shutdown
> independently, so I guess s_stream would be called each time one is
> brought up or brought down?

That's the idea. However, we don't have support for multiplexed streams in 
mainline yet, so there's no way it can be implemented today in your driver.

-- 
Regards,

Laurent Pinchart
