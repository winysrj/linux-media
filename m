Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48824 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993440Ab2KOPr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 10:47:58 -0500
Received: by mail-wi0-f170.google.com with SMTP id cb5so1219150wib.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 07:47:57 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v10 1/6] video: add display_timing and videomode
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	devicetree-discuss@lists.ozlabs.org
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
In-Reply-To: <1352971437-29877-2-git-send-email-s.trumtrar@pengutronix.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de> <1352971437-29877-2-git-send-email-s.trumtrar@pengutronix.de>
Date: Thu, 15 Nov 2012 15:47:53 +0000
Message-Id: <20121115154753.C82223E194B@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Nov 2012 10:23:52 +0100, Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> Add display_timing structure and the according helper functions. This allows
> the description of a display via its supported timing parameters.
> 
> Every timing parameter can be specified as a single value or a range
> <min typ max>.
> 
> Also, add helper functions to convert from display timings to a generic videomode
> structure. This videomode can then be converted to the corresponding subsystem
> mode representation (e.g. fb_videomode).
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Hmmm... here's my thoughts as an outside reviewer. Correct me if I'm
making an incorrect assumption.

It looks to me that the purpose of this entire series is to decode video
timings from the device tree and (eventually) provide the data in the
form 'struct videomode'. Correct?

If so, then it looks over engineered. Creating new infrastructure to
allocate, maintain, and free a new 'struct display_timings' doesn't make
any sense when it is an intermediary data format that will never be used
by drivers.

Can the DT parsing code instead return a table of struct videomode?

But, wait... struct videomode is also a new structure. So it looks like
this series creates two new intermediary data structures;
display_timings and videomode. And at least as far as I can see in this
series struct fb_videomode is the only user.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
