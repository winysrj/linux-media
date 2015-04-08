Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51128 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbbDHJR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 05:17:26 -0400
Date: Wed, 8 Apr 2015 11:17:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150408091724.GD5646@amd>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
 <5524ECDC.1070609@samsung.com>
 <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > I think that a board designed so that it can be damaged because of
> > software bugs should be considered not eligible for commercial
> > use.

Hello? It is 2015. Yes, that was nice rule... in 1995 or so :-).

> > As I mentioned in the previous message in this subject, the max-microamp
> > property refers also to non-flash LEDs. Since existing LED class devices
> > does not require them, then it should be left optional and default to
> > max. It would however be inconsistent with flash LEDs related
> > properties.

For non-flash LEDs and backward compatibility, I guess you are
right. Inconsistency is fine in this case...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
