Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36387 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1KRWfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 17:35:16 -0500
Date: Fri, 18 Nov 2011 23:35:10 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	shawn.guo@linaro.org, richard.zhao@linaro.org,
	fabio.estevam@freescale.com, kernel@pengutronix.de,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] MEM2MEM: Add support for eMMa-PrP mem2mem operations.
Message-ID: <20111118223510.GN12903@pengutronix.de>
References: <1321460614-2108-1-git-send-email-javier.martin@vista-silicon.com>
 <4EC682B8.10300@gmail.com>
 <CACKLOr0spqXzYZUPcDkDxCqZXkCM+F6crEQ3R0VbS-HGvZADtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CACKLOr0spqXzYZUPcDkDxCqZXkCM+F6crEQ3R0VbS-HGvZADtA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 18, 2011 at 05:27:12PM +0100, javier Martin wrote:
> But yes, it could be possible. AFAIK, Sascha Hauer (added to CC) has a
> prototype driver for this one though.

Yes, we have indeed a prototype for the VPU, both on MX27 and MX53.
However, it wasn't changed to a mem2mem device yet, although that is
what needs to be done. Unfortunately, we currently do not have a
customer who would let us drive that forward, so it probably needs some
time until we find somebody and can work on that again.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
