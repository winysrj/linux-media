Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:58173 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935486AbaDJLiv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 07:38:51 -0400
Date: Thu, 10 Apr 2014 08:38:41 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: shuah.kh@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
	tj@kernel.org, rafael.j.wysocki@intel.com, linux@roeck-us.net,
	toshi.kani@hp.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
Message-id: <20140410083841.488f9c43@samsung.com>
In-reply-to: <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com> <5345CD32.8010305@samsung.com>
 <20140410120435.4c439a8b@alan.etchedpixels.co.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Em Thu, 10 Apr 2014 12:04:35 +0100
One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> escreveu:

> > >>   - Construct string with (dev is struct em28xx *dev)
> > >> 		format: "tuner:%s-%s-%d"
> > >> 		with the following:
> > >>     	            dev_name(&dev->udev->dev)
> > >>                  dev->udev->bus->bus_name
> > >>                  dev->tuner_addr
> 
> What guarantees this won't get confused by hot plugging and re-use of the
> bus slot ?

Good point. Yes, this should be addressed.

> I'm also not sure I understand why you can't have a shared parent device
> and simply attach the resources to that. This sounds like a problem mfd
> already solved ?

There are some devices that have lots of different functions spread
out on several subsystems.

For example, some devices provide standard USB Audio Class, handled by
snd-usb-audio for the audio stream, while the video stream is handled
via a separate driver, like some em28xx devices.

There are even more complex devices that provide 3G modem, storage
and digital TV, whose USB ID changes when either the 3G modem starts
or when the digital TV firmware is loaded.

So, we need to find a way to lock some hardware resources among
different subsystems that don't share anything in common. Not sure if
mfd has the same type of problem of a non-mfd driver using another
function of the same device that has some shared hardware resources
between the separate functions, and, if so, how they solved it.

Regards,
Mauro
