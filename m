Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46958 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbcD2JuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 05:50:06 -0400
Date: Fri, 29 Apr 2016 11:50:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
	sre@kernel.org, kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, serge@hallyn.com, tuukkat76@gmail.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: v4l subdevs without big device was Re:
 drivers/media/i2c/adp1653.c: does not show as /dev/video* or v4l-subdev*
Message-ID: <20160429095002.GA22743@amd>
References: <20160428084546.GA9957@amd>
 <20160429071525.GA4823@amd>
 <57230DE7.3020701@xs4all.nl>
 <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160429075649.GG32125@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > adp1653 registers itself as a subdev, but there's no device that
> > > register it as its part.
> > > 
> > > (ad5820 driver seems to have the same problem).
> > > 
> > > Is there example "dummy" device I could use, for sole purpose of
> > > having these devices appear in /dev? They are on i2c, so both can work
> > > on their own.
> > 
> > Ah, interesting. This was discussed a little bit during the Media Summit
> > a few weeks back:
> > 
> > http://linuxtv.org/news.php?entry=2016-04-20.mchehab
> > 
> > See section 5:
> > 
> > "5. DT Bindings for flash & lens controllers
> > 
> > There are drivers that create their MC topology using the device tree information,
> > which works great for entities that transport data, but how to detect entities
> > that don’t transport data such as flash devices, focusers, etc.? How can those be
> > deduced using the device tree?
> > 
> > Sensor DT node add phandle to focus controller: add generic v4l binding properties
> > to reference such devices."
> > 
> > This wasn't a problem with the original N900 since that didn't use DT AFAIK and
> > these devices were loaded explicitly through board code.

> > But now you run into the same problem that I have.

Actually... being able to do board-code solution for testing for now
would be nice...

> > 
> > The solution is that sensor devices have to provide phandles to those controller
> > devices. And to do that you need to define bindings which is always the hard part.
> > 
> > Look in Documentation/devicetree/bindings/media/video-interfaces.txt, section
> > "Optional endpoint properties".
> > 
> > Something like:
> > 
> > controllers: an array of phandles to controller devices associated with this
> > endpoint such as flash and lens controllers.
> > 
> > Warning: I'm no DT expert, so this is just a first attempt.
> > 
> > Platform drivers (omap3isp) will have to add these controller devices to the list
> > of subdevs to load asynchronously.
> 
> I seem to have patches I haven't had time to push back then:
> 
> <URL:http://salottisipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux.git;a=shortlog;h=refs/heads/leds-as3645a>
>

That gitweb is a bit confused about its own address, but I figured it
out. Let me check...

pavel@amd:/data/l/linux-n900$ git fetch
git://git.retiisi.org.uk/~sailus/linux.git leds-as3645a:leds-as3645a
fatal: unable to connect to git.retiisi.org.uk:
git.retiisi.org.uk: Name or service not known

pavel@amd:/data/l/linux-n900$ git fetch
git://salottisipuli.retiisi.org.uk/~sailus/linux.git
leds-as3645a:leds-as3645a
remote: Counting objects: 132, done.
remote: Compressing objects: 100% (46/46), done.
remote: Total 132 (delta 111), reused 107 (delta 86)
Receiving objects: 100% (132/132), 22.80 KiB | 0 bytes/s, done.
Resolving deltas: 100% (111/111), completed with 34 local objects.
>From git://salottisipuli.retiisi.org.uk/~sailus/linux
 * [new branch]      leds-as3645a -> leds-as3645a
 

> This seems to be mostly in line with what has been discussed in the meeting,
> except that the patches add a device specific property. Please ignore the
> led patches in that tree for now (i.e. four patches on the top are the
> relevant ones here).
> 

I'm currently trying to apply them to v4.6, but am getting rather ugly
rejects :-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
