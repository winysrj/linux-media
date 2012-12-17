Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45730 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2LQPBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:01:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sascha Hauer <s.hauer@pengutronix.de>,
	Inki Dae <inki.dae@samsung.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 17 Dec 2012 16:02:19 +0100
Message-ID: <2640154.JP12k2CZJX@avalon>
In-Reply-To: <20121123214158.GO10369@pengutronix.de>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <20121123214158.GO10369@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Friday 23 November 2012 22:41:58 Sascha Hauer wrote:
> On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
> > From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > The CDF models this using a Russian doll's model. From the display
> > controller point of view only the first external entity (LVDS to DSI
> > converter) is visible. The display controller thus calls the control
> > operations implemented by the LVDS to DSI transmitter driver (left-most
> > green arrow). The driver is aware of the next entity in the chain,
> 
> I can't find this in the code. I can see the video operations
> propagating upstream using the source field of struct display_entity,
> but how do the control operations propagate downstream? Am I missing
> something?

There's no downstream propagation yet, as there's no display entity driver 
that requires it at the moment. Propagation would be implemented in 
transceiver drivers for instance. I'll have to find one with public 
documentation (and hopefully an existing mainline driver) on one of the boards 
I own.

-- 
Regards,

Laurent Pinchart

