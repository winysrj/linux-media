Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55634 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab2HTX3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 19:29:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC 0/5] Generic panel framework
Date: Tue, 21 Aug 2012 01:29:52 +0200
Message-ID: <3937256.gcqPRVoNWN@avalon>
In-Reply-To: <1345462770.2684.23.camel@deskari>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com> <4948190.AFNtaaFKXQ@avalon> <1345462770.2684.23.camel@deskari>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On Monday 20 August 2012 14:39:30 Tomi Valkeinen wrote:
> On Sat, 2012-08-18 at 03:16 +0200, Laurent Pinchart wrote:
> > Hi Tomi,
> > 
> > mipi-dbi-bus might not belong to include/video/panel/ though, as it can be
> > used for non-panel devices (at least in theory). The future mipi-dsi-bus
> > certainly will.
> 
> They are both display busses. So while they could be used for anything,
> I find it quite unlikely as there are much better alternatives for
> generic bus needs.

My point is that they could be used for display devices other than panels. 
This is especially true for DSI, as there are DSI to HDMI converters. 
Technically speaking that's also true for DBI, as DBI chips convert from DBI 
to DPI, but we can group both the DBI-to-DPI chip and the panel in a single 
panel object.

> > Would you be able to send incremental patches on top of v2 to implement
> > the solution you have in mind ? It would be neat if you could also
> > implement mipi- dsi-bus for the OMAP DSS and test the code with a real
> > device :-)
> 
> Yes, I'd like to try this out on OMAP, both DBI and DSI. However, I fear
> it'll be quite complex due to the dependencies all around we have in the
> current driver. We're working on simplifying things so that it'll be
> easier to try thing like the panel framework, though, so we're going in
> the right direction.

If you want the panel framework to support your use cases I'm afraid you will 
need to work on that ;-)
 
> > > Generally about locks, if we define that panel ops may only be called
> > > exclusively, does it simplify things? I think we can make such
> > > requirements, as there should be only one display framework that handles
> > > the panel. Then we don't need locking for things like enable/disable.
> > 
> > Pushing locking to callers would indeed simplify panel drivers, but we
> > need to make sure we won't need to expose a panel to several callers in
> > the future.
>
> I have a feeling that would be a bad idea.
> 
> Display related stuff are quite sensitive to any delays, so any extra
> transactions over, say, DSI bus could cause a noticeable glitch on the
> screen. I'm not sure what are all the possible ops that a panel can
> offer, but I think all that affect the display or could cause delays
> should be handled by one controlling entity (drm or such). The
> controlling entity needs to handle locking anyway, so in that sense I
> don't think it's an extra burden for it.
> 
> The things that come to my mind that could possibly cause calls to the
> panel outside drm: debugfs, sysfs, audio, backlight. Of those, I think
> backlight should go through drm. Audio, no idea. debugfs and sysfs
> locking needs to be handled by the panel driver, and they are a bit
> problematic as I guess having them requires full locking.

-- 
Regards,

Laurent Pinchart

