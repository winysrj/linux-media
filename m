Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcDXWF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 18:05:27 -0400
Date: Mon, 25 Apr 2016 00:05:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Subject: Re: [RFC PATCH 01/24] V4L fixes
Message-ID: <20160424220524.GB6338@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1461532104-24032-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2016-04-25 00:08:01, Ivaylo Dimitrov wrote:
> From: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
> 
> Squashed from the following upstream commits:
> 
> V4L: Create control class for sensor mode
> V4L: add ad5820 focus specific custom controls
> V4L: add V4L2_CID_TEST_PATTERN
> V4L: Add V4L2_CID_MODE_OPSYSCLOCK for reading output system clock
> 
> Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

I guess you need to append your Signed-off-by: here.

Otherwise it looks good, so

Acked-by: Pavel Machek <pavel@ucw.cz>

(And thanks for all the work).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
