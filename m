Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47087 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbbDCUhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 16:37:34 -0400
Date: Fri, 3 Apr 2015 22:37:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
Message-ID: <20150403203730.GA13009@amd>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
 <551E8DEA.5070205@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551E8DEA.5070205@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> >>+- flash-timeout-us : Timeout in microseconds after which the flash
> >>+                     LED is turned off. If omitted this will default to the
> >>+		     maximum timeout allowed by the device.
> >>
> >>
> >>  Examples:
> >
> >Pavel pointed out that the brightness between maximum current and the
> >maximum *allowed* another current might not be noticeable,leading a
> >potential spelling error to cause the LED being run at too high current.
> 
> Where did he point this out? Do you think about the current version
> of the leds/common.txt documentation or there was some other message,
> that I don't see?

Date: Thu, 2 Apr 2015 22:30:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCHv3] media: i2c/adp1653: devicetree support for adp1653

> Besides, I can't understand your point. Could you express it in other
> words, please?

Typo in device tree would cause hardware damage. But idea. Make the
properties mandatory.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
