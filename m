Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:37049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0JTMVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 08:21:04 -0400
Message-ID: <4CBEDE92.6070800@infradead.org>
Date: Wed, 20 Oct 2010 10:20:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] V4L/DVB: Add the via framebuffer camera controller driver
References: <20101019183211.6af74f57@bike.lwn.net> <201010200907.35954.hverkuil@xs4all.nl>
In-Reply-To: <201010200907.35954.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-10-2010 05:07, Hans Verkuil escreveu:
> On Wednesday, October 20, 2010 02:32:11 Jonathan Corbet wrote:
>> OK, here's a new version of the patch, done against the V4L tree.  Now
>> with 100% fewer compiler errors!  It took a while to figure out the API
>> changes, and I'm not convinced I like them all - the controller driver
>> didn't used to have to worry about format details, but now it does -
>> but so it goes.
> 
> I'm afraid that that change is a sign of V4L growing up and being used in
> much more demanding environments like the omap3. While the pixel format and
> media bus format have a trivial mapping in this controller driver, things
> become a lot more complicated if the same sensor driver were to be used in
> e.g. the omap3 SoC.
> 
> The sensor driver does not know what the video will look like in memory. It
> just passes the video data over a physical bus to some other device. That
> other device is what usually determines how the video data it receives over
> the bus is DMA-ed into memory. Simple devices just copy the video data almost
> directly to memory, but more complex devices can do colorspace transformations,
> dword swapping, 4:2:2 to 4:2:0 conversions, scaling, etc., etc.
> 
> So what finally arrives in memory may look completely different from what the
> sensor supplies.
> 
> The consequence of supporting these more complex devices is that it also
> makes simple device drivers a bit more complex.

Hans,

The kABI changes should not cause troubles for driver developers. 

I actually tried to look how to fix the conflicts, and it is not trivial to convert 
a driver to mbus (well, I'd say that there are 50% of chance of getting the wrong
values, as just inspecting the source code, it is impossible to know if the bus
is LE or BE).

In a matter of fact, we're using the "MBUS" format to do two different things:
a) configure the FOURCC image format;
b) configure the type of mbus.

While all drivers need to do (a), just a few need to do (b), as, for most cases,
the bridge driver just accepts one fixed format.

I can't imagine how a driver like gspca, where most of the work is done via reverse 
engineering could be converted correctly, as I doubt that developers have any glue
about the endianness used on all webcams (or any other parameter for the streaming
bus between the sensor and the bridge).

So, while I understand that this is needed for complex devices used on embedded,
the kABI changes should not cause troubles for other developers, otherwise, they
may just put some "fake" values to workaround the kABI "pedantic" requirements,
causing future problems when someone would try to use it with those more complex
devices or do some other workarounds.

I suspect that we'll need to do some cleanups on it, as, on all drivers but soc_camera
and omap3 (and maybe a few other hardware), just passing the fourcc format is enough.

Cheers,
Mauro

