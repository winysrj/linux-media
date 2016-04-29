Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42456 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbcD2HP3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 03:15:29 -0400
Date: Fri, 29 Apr 2016 09:15:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, sakari.ailus@iki.fi,
	tuukkat76@gmail.com
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: v4l subdevs without big device was Re: drivers/media/i2c/adp1653.c:
 does not show as /dev/video* or v4l-subdev*
Message-ID: <20160429071525.GA4823@amd>
References: <20160428084546.GA9957@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160428084546.GA9957@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> On n900, probe finishes ok (verified by adding printks), and the
> device shows up in /sys, but I  don't get /dev/video* or
> /dev/v4l-subdev*.
> 
> Other drivers (back and front camera) load ok, and actually work. Any
> idea what could be wrong?

Ok, so I guess I realized what is the problem:

adp1653 registers itself as a subdev, but there's no device that
register it as its part.

(ad5820 driver seems to have the same problem).

Is there example "dummy" device I could use, for sole purpose of
having these devices appear in /dev? They are on i2c, so both can work
on their own.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
