Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37267 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752054AbbBSJCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:02:16 -0500
Date: Thu, 19 Feb 2015 11:02:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Greg KH <greg@kroah.com>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
Message-ID: <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150218224747.GA3999@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 18, 2015 at 11:47:47PM +0100, Pavel Machek wrote:
> 
> On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
> > Add a documentation of LED Flash class specific sysfs attributes.
> > 
> > Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Bryan Wu <cooloney@gmail.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> 
> NAK-ed-by: Pavel Machek
> 
> > +What:		/sys/class/leds/<led>/available_sync_leds
> > +Date:		February 2015
> > +KernelVersion:	3.20
> > +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
> > +Description:	read/write
> > +		Space separated list of LEDs available for flash strobe
> > +		synchronization, displayed in the format:
> > +
> > +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
> 
> Multiple values per file, with all the problems we had in /proc. I
> assume led_id is an integer? What prevents space or dot in led name?

Very good point. How about using a newline instead? That'd be a little bit
easier to parse, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
