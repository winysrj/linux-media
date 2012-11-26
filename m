Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40504 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KZOmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 09:42:12 -0500
Date: Mon, 26 Nov 2012 14:47:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v2 0/5] Common Display Framework
Message-ID: <20121126144708.3daec09e@pyramind.ukuu.org.uk>
In-Reply-To: <50B07427.1010605@ti.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<20121123195607.GA20990@avionic-0098.adnet.avionic-design.de>
	<50B07427.1010605@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 24 Nov 2012 09:15:51 +0200
Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:

> On 2012-11-23 21:56, Thierry Reding wrote:
> > On Thu, Nov 22, 2012 at 10:45:31PM +0100, Laurent Pinchart wrote:
> > [...]
> >> Display entities are accessed by driver using notifiers. Any driver can
> >> register a display entity notifier with the CDF, which then calls the notifier
> >> when a matching display entity is registered.

The framebuffer layer has some similar 'anyone can' type notifier
behaviour and its not a good thing. That kind of "any one can" behaviour
leads to some really horrible messes unless the connections and the
locking are well defined IMHO.

Alan
