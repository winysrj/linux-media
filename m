Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46089 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab2LQPOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:14:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Date: Mon, 17 Dec 2012 16:15:35 +0100
Message-ID: <2584890.nIjxiaN4DG@avalon>
In-Reply-To: <20121126144708.3daec09e@pyramind.ukuu.org.uk>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <50B07427.1010605@ti.com> <20121126144708.3daec09e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Monday 26 November 2012 14:47:08 Alan Cox wrote:
> On Sat, 24 Nov 2012 09:15:51 +0200 Tomi Valkeinen wrote:
> > On 2012-11-23 21:56, Thierry Reding wrote:
> > > On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
> > > [...]
> > > 
> > >> Display entities are accessed by driver using notifiers. Any driver can
> > >> register a display entity notifier with the CDF, which then calls the
> > >> notifier when a matching display entity is registered.
> 
> The framebuffer layer has some similar 'anyone can' type notifier
> behaviour and its not a good thing. That kind of "any one can" behaviour
> leads to some really horrible messes unless the connections and the
> locking are well defined IMHO.

I agree with you. I dislike the FBDEV notifier model, and I definitely don't 
intend to duplicate it in the common display framework.

In the CDF model, when the display device driver registers a notifier, it 
tells the core which device it wants to receive events for. This currently 
takes the form of a struct device pointer, and the API will also support 
device nodes in a future version (this is still work in progress). The goal is 
to implement panel discovery in a way that is compatible with (and very 
similar to) hotpluggable display discovery.

Thinking about it now, the API could be cleaner and less subject to abuse if 
the notifier was registered for a given video port instead of a given 
connected device. I'll add that to my TODO list.

-- 
Regards,

Laurent Pinchart

