Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57254 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbBRWru (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 17:47:50 -0500
Date: Wed, 18 Feb 2015 23:47:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	Greg KH <greg@kroah.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, kyungmin.park@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com
Subject: 0.led_name 2.other.led.name in /sysfs Re: [PATCH/RFC v11 01/20]
 leds: flash: document sysfs interface
Message-ID: <20150218224747.GA3999@amd>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
 <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1424276441-3969-2-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Wed 2015-02-18 17:20:22, Jacek Anaszewski wrote:
> Add a documentation of LED Flash class specific sysfs attributes.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>

NAK-ed-by: Pavel Machek

> +What:		/sys/class/leds/<led>/available_sync_leds
> +Date:		February 2015
> +KernelVersion:	3.20
> +Contact:	Jacek Anaszewski <j.anaszewski@samsung.com>
> +Description:	read/write
> +		Space separated list of LEDs available for flash strobe
> +		synchronization, displayed in the format:
> +
> +		led1_id.led1_name led2_id.led2_name led3_id.led3_name etc.

Multiple values per file, with all the problems we had in /proc. I
assume led_id is an integer? What prevents space or dot in led name?

       	      	    	     	  	   	    	       Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
