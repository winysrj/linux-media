Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36817 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbbCBPMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 10:12:17 -0500
Date: Mon, 2 Mar 2015 16:12:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Greg KH <greg@kroah.com>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
Message-ID: <20150302151205.GA10376@amd>
References: <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd>
 <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
 <20150219214043.GB29875@kroah.com>
 <54E6E89B.4050404@samsung.com>
 <20150220153616.GB18111@kroah.com>
 <20150220205738.GA28995@amd>
 <20150221105733.GO3915@valkosipuli.retiisi.org.uk>
 <54F0806E.2040309@samsung.com>
 <20150302125414.GS6539@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150302125414.GS6539@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > Of course the relevant sysfs group could be initialized only with
> > the needed number of sync leds attributes, but still this is less
> > than optimal design.
> > 
> > It looks like this interface indeed doesn't fit for sysfs.
> > 
> > I am leaning towards removing the support for synchronized flash LEDs
> > from the LED subsystem entirely and leave it only to V4L2.
> 
> Perfectly fine for me as well, I guess the synchronised strobe has mostly
> use on V4L2. It could always be added later on if needed.

Makes sense...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
