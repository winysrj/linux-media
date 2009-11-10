Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZKJS6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 13:58:25 -0500
Date: Tue, 10 Nov 2009 16:57:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: ov538-ov7690
Message-ID: <20091110165747.35d31687@pedra.chehab.org>
In-Reply-To: <20091110090910.18f32748.rdunlap@xenotime.net>
References: <4AF89498.3000103@panicking.kicks-ass.org>
	<4AF93DE5.6060901@panicking.kicks-ass.org>
	<20091110081000.9e7c7717.rdunlap@xenotime.net>
	<4AF99A03.7070303@panicking.kicks-ass.org>
	<20091110090910.18f32748.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Nov 2009 09:09:10 -0800
Randy Dunlap <rdunlap@xenotime.net> escreveu:

> > > (**) This is also one of several codes that different kinds of host
> > > controller use to indicate a transfer has failed because of device
> > > disconnect.  In the interval before the hub driver starts disconnect
> > > processing, devices may receive such fault reports for every request.
> > > 
> > > 
> > >> Ok, this is not a big issue because I can use vlc to test the camera. But anybody
> > >> knows why camorama, camstream, cheese crash during test. is it driver depend? or not?
> > > 
> > > Could be driver.  Easily could be a device problem too.
> > 
> > I think that it can be a vl2 vl1 problem. Because now I can manage in skype too using
> > the v4l1-compat library. Maybe my 2.6.32-rc5 is too new :(
> 
> I don't even know what vl2 vl1 means. ;)

He is probably referring to V4L1 x V4L2 API calls. Very unlikely. What libv4l
does is to convert userspace calls via V4L1 to a V4L2 call to kernel. So,
you're basically using the same API to communicate to userspace.

It should be noticed that, if you're not using libv4l for the other
applications, then you may be using a different format at the driver, since
libv4l has the capability of doing format conversions.

So, it could be possible that the device firmware for some formats are broken.

Another possibility is that maybe libv4l is just discarding such errors.

Or, as Randy mentioned, it can be just a cable or a connector with bad contact.

Cheers,
Mauro
