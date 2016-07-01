Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42155 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbcGAHbv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 03:31:51 -0400
Date: Fri, 1 Jul 2016 09:31:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	laurent.pinchart@ideasonboard.com
Cc: Sebastian Reichel <sre@kernel.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: square-only image on Nokia N900 camera -- pipeline setup in python
 (was Re: [RFC PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160701073146.GA21405@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
 <20160617171214.GA5830@amd>
 <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On gitlab is the latest version of pipeline setup if python. I also
got fcam to work (slowly) on the camera, with autofocus and
autogain. Capturing from preview modes works fine, but image quality
is not good, as expected. Capturing raw GRBG10 images works, but
images are square, with values being outside square being 0.

Same problem is there with yavta and fcam-dev capture, so I suspect
there's something in kernel. If you have an idea what could be wrong /
what to try, let me know. If omap3isp works for you in v4.6, and
produces expected rectangular images, that would be useful to know,
too.

Python capture script is at

https://gitlab.com/tui/tui/commit/266b6eb302dcf1481e3e90a05bf98180e5759168

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
