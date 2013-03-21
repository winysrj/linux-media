Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3CUQXw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 12:23:52 -0400
Date: Thu, 21 Mar 2013 13:23:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: em28xx: commit aab3125c43d8fecc7134e5f1e729fabf4dd196da broke
 HVR 900
Message-ID: <20130321132344.102fb691@redhat.com>
In-Reply-To: <201303211634.13057.hverkuil@xs4all.nl>
References: <201303210933.41537.hverkuil@xs4all.nl>
	<20130321070327.772c6301@redhat.com>
	<201303211634.13057.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Mar 2013 16:34:13 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Thu March 21 2013 11:03:27 Mauro Carvalho Chehab wrote:
> > Em Thu, 21 Mar 2013 09:33:41 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > > I tried to use my HVR 900 stick today and discovered that it no longer worked.
> > > I traced it to commit aab3125c43d8fecc7134e5f1e729fabf4dd196da: "em28xx: add
> > > support for registering multiple i2c buses".
> > > 
> > > The kernel messages for when it fails are:
> > ...
> > > Mar 21 09:26:57 telek kernel: [ 1396.542517] xc2028 12-0061: attaching existing instance
> > > Mar 21 09:26:57 telek kernel: [ 1396.542521] xc2028 12-0061: type set to XCeive xc2028/xc3028 tuner
> > > Mar 21 09:26:57 telek kernel: [ 1396.542523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
> > ...
> > > Mar 21 09:26:57 telek kernel: [ 1396.547833] xc2028 12-0061: Error on line 1293: -19
> > 
> > Probably, the I2C speed is wrong. I noticed a small bug on this patch.
> > The following patch should fix it. Could you please test?
> 
> No luck, it didn't help.

On a first glance, I've no idea what else is different for devices with
just one I2C bus, like HVR-900.

Could you send me an USB sniff dump with the kernel that works and with
the broken kernel, with this patch applied?

The parsing tools are under v4l-utils contrib/ dir.

The first step is to check the usbmon interface for capture, with:

	$ ./parse_tcpdump_log.pl --list-devices
	usbmon4 ==> 020f (level 2)
	usbmon2 ==> USB2.0 Hub (level 1)
	usbmon1 ==> WinTV HVR-930C (level 7)

Then, you can run the parser to capture the data:

	# ./parse_tcpdump_log.pl --device usbmon1 | ./em28xx/parse_em28xx.pl 

Please load the em28xx driver only after starting the parser, as we want
to see what the driver is doing during the initialization.

Thanks!
Mauro
