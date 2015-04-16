Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53220 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbDPTWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 15:22:38 -0400
Date: Thu, 16 Apr 2015 21:22:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150416192235.GA8188@amd>
References: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
 <20150416052442.GA31095@earth>
 <20150416055817.GA2749@amd>
 <20150416162905.GA3181@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150416162905.GA3181@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > This will reduce complexity in the driver and should be fairly easy
> > > to implement, since there is no adp1653 platform code user in the
> > > mainline kernel anyways.
> > 
> > I'd hate to break out of tree users for very little gain.
...
> So let's have a look at the advantages of removing the power gpio:

One change per patch. My change did what it said, "add a device tree
support", if you want to do second change "break existing interface",
feel free doing it as a separate patch.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
