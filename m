Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46934 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaCRNDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 09:03:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@karo-electronics.de>,
	Andrzej Hajda <a.hajda@samsung.com>,
	devel@driverdev.osuosl.org, Philipp Zabel <p.zabel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Denis Carikli <denis@eukrea.com>,
	Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 07/12] drm: drm_display_mode: add signal polarity flags
Date: Tue, 18 Mar 2014 14:05:03 +0100
Message-ID: <126833534.i9WITsrxHj@avalon>
In-Reply-To: <20140318125623.GW21483@n2100.arm.linux.org.uk>
References: <1394731053-6118-1-git-send-email-denis@eukrea.com> <1434295.j7EcSL7GQo@avalon> <20140318125623.GW21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

On Tuesday 18 March 2014 12:56:23 Russell King - ARM Linux wrote:
> On Tue, Mar 18, 2014 at 01:41:54PM +0100, Laurent Pinchart wrote:
> > Hi Lothar,
> > 
> > That's not my point. I *know* that DE is a data gating signal with a
> > polarity already defined by the DRM_MODE_FLAG_POL_DE_(LOW|HIGH) flags.
> > Like all other signals it gets generated on a clock edge and is sampled
> > on a clock edge. The DRM_MODE_FLAG_POL_DE_*EDGE flags proposed above
> > describe seem to describe just that, *not* the signal polarity. I thus
> > want to know whether there are systems where the data signals and the DE
> > signal need to be sampled on different edges of the pixel clock.
> 
> That's not relevant to this patch series though.  This patch series is
> about adding configuration which will allow iMX6 SoCs to be properly
> configured for their displays.
> 
> iMX has the ability to:
> 
> - define the polarity of the clock signal
> - define the polarity of the other signals
> 
> It does not have the ability to define which clock edge individual signals
> like vsync (frame clock), hsync (line clock), disable enable change on
> independently.
> 
> So, it doesn't make sense _here_ for the display enable to be defined by
> an edge - it's not something that can be changed here.  What can only be
> changed is it's active level.
> 
> Of course, there may be some which can do this, and that's a separate
> problem that would need to be addressed when there's hardware that does
> support it.
> 
> The objection which Lothar is raising is that _this_ definition does not
> match the _hardware_ capabilities which it is intended to be used with,
> which is a very valid objection.

Thank you for the clarification. That absolutely makes sense.

-- 
Regards,

Laurent Pinchart

