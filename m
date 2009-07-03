Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47880 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZGCGVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 02:21:04 -0400
Date: Fri, 3 Jul 2009 03:21:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joel Jordan <zcacjxj@hotmail.com>
Cc: <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMPIA Silvercrest 2710
Message-ID: <20090703032100.64c3f70d@pedra.chehab.org>
In-Reply-To: <BAY103-W483504B84F25BC84275FAAC190@phx.gbl>
References: <BAY103-W483504B84F25BC84275FAAC190@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joel,

Em Fri, 7 Nov 2008 10:10:45 +0000
Joel Jordan <zcacjxj@hotmail.com> escreveu:

 
>   Has there been any work done on the eMPIA Silvercrest EM2710 (device for webcams)?

I borrowed a Silvercrest 1.3 Mpix camera, based on em2710 and mt9v011 with a
friend, at the end of a conference that happened last week. After spending some
spare time on it at the airplane while returning back home, I discovered how to
enable stream on it.

Basically, there were just a very few registers that was needing a different
initialization, plus a driver to the sensor inside.

Could you please test the latest development code and see if this works for you also?

It is at:
	http://linuxtv.org/hg/v4l-dvb

The driver is the em28xx. As the camera uses the generic vendor usb id
(eb1a:2820), you'll need to force the driver to load the proper card
parameters, by using card=71 at module probing. This can be done by calling:

	modprobe em28xx card=71

Or by adding an options line on your /etc/modprobe.conf (or the equivalent file on your machine):
	options em28xx card=71

You need to do one of the above procedures _before_ plug the camera, or
otherwise it will take the generic entry that won't work.

Currently, the driver offers a very basic support. Only 640x480 with auto gain, auto
bright, etc. The normal controls (contrast, bright, etc) are not available.

When I have more spare time, I'll try to play with the sensors and see what
else we can enable. The sensor seems to support some fancy things like digital
zoom, and CIF/QVGA resolutions at higher rate. However, don't expect too much
time from me on it, due to my other duties.

If you also want to play with it, the specs of the sensor is available at:
	http://download.micron.com/pdf/datasheets/imaging/MT9V011.pdf

Feel free to submit us patches to improve the webcam support



Cheers,
Mauro
