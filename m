Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55716 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbbBSVkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 16:40:45 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id AC52721403
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 16:40:44 -0500 (EST)
Date: Thu, 19 Feb 2015 13:40:43 -0800
From: Greg KH <greg@kroah.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com
Subject: Re: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
Message-ID: <20150219214043.GB29875@kroah.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
 <20150218224747.GA3999@amd>
 <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150219090204.GI3915@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 19, 2015 at 11:02:04AM +0200, Sakari Ailus wrote:
> On Wed, Feb 18, 2015 at 11:47:47PM +0100, Pavel Machek wrote:
> > 
> > On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
> > > Add a documentation of LED Flash class specific sysfs attributes.
> > > 
> > > Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> > > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Bryan Wu <cooloney@gmail.com>
> > > Cc: Richard Purdie <rpurdie@rpsys.net>
> > 
> > NAK-ed-by: Pavel Machek
> > 
> > > +What:		/sys/class/leds/<led>/available_sync_leds
> > > +Date:		February 2015
> > > +KernelVersion:	3.20
> > > +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
> > > +Description:	read/write
> > > +		Space separated list of LEDs available for flash strobe
> > > +		synchronization, displayed in the format:
> > > +
> > > +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.
> > 
> > Multiple values per file, with all the problems we had in /proc. I
> > assume led_id is an integer? What prevents space or dot in led name?
> 
> Very good point. How about using a newline instead? That'd be a little bit
> easier to parse, too.

No, please make it one value per-file, which is what sysfs requires.

thanks,

greg k-h
