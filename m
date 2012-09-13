Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2IMTcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 15:32:50 -0400
Date: Thu, 13 Sep 2012 21:32:26 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-fbdev@vger.kernel.org,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Bryan Wu <bryan.wu@canonical.com>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, Steffen Trumtrar <str@pengutronix.de>
Subject: Re: [RFC 1/5] video: Add generic display panel core
Message-ID: <20120913193226.GT21896@pengutronix.de>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1345164583-18924-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20120904092446.GN24458@pengutronix.de>
 <224585745.5E32B1Gv1v@avalon>
 <20120913112954.GI6180@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913112954.GI6180@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 13, 2012 at 01:29:54PM +0200, Sascha Hauer wrote:
> > > You have seen my of videomode helper proposal. One result there
> > > was that we want to have ranges for the margin/synclen fields.
> > > Does it make sense to base this new panel framework on a more
> > > sophisticated internal reprentation of the panel parameters?
> >
> > I think it does, yes. We need a common video mode structure, and the
> > panel framework should use it. I'll try to rebase my patches on top
> > of your proposal. Have you posted the latest version ?
>
> V2 is the newest version. I'd like to implement ranges for the display
> timings which then makes for a new common video mode structure, which
> then could be used by drm and fbdev, probably with helper functions to
> convert from common videomode to drm/fbdev specific variants.

Steffen has a reworked series with the latest changes and will post them
soon.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
