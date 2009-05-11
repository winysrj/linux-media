Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33825 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZEKCsK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 22:48:10 -0400
Subject: Re: Scoping the effort to add a media controller )Re: [ivtv-users]
 Delay loading v4l-cx25840.fw)
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200905101223.28739.hverkuil@xs4all.nl>
References: <1241054296.3374.44.camel@palomino.walls.org>
	 <1241739191.4035.3.camel@palomino.walls.org>
	 <200905080845.10438.hverkuil@xs4all.nl>
	 <200905101223.28739.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sun, 10 May 2009 22:48:53 -0400
Message-Id: <1242010133.23118.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-05-10 at 12:23 +0200, Hans Verkuil wrote:

> > Hi Andy,
> >
> > Here is a link to the original RFC:
> >
> > http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.h
> >tml
> >
> > It's pretty old but the basic idea is still valid. I'll follow up this
> > mail tonight or tomorrow with my latest thoughts on this subject and what
> > the research is that has to be done.
> 
> OK, here is my follow-up:
> 
> I think the initial research should look into the device-discovery problem. 
> Let's just start with a prototype that creates a single mediacontroller 
> device for each struct v4l2_device and a simple test program that can open 
> the media controller and enumerate the /dev device nodes that the board 
> supports.
> 
> Note that the v4l2-sysfs-patch.c utility is useless for this, because it 
> does not take into account udev rules setup by the user that renames the 
> device nodes in /dev. I suspect (haven't tested it) that it also fails for 
> cx88 devices where you have separate PCI devices for sound, video and dvb.
> 
> The right way to do it IMHO is to research the new capabilities of the 
> recent udev versions: a new libudev was introduced and new capabilities of 
> mapping a sysfs path to a /dev path, taking into account any user defined 
> rules. So the media controller should enumerate all devices the driver 
> created (v4l, dvb, alsa, fb, i2c, ir) and pass the needed data on to the 
> application, which uses libudev to find the corresponding /dev device node.
> 
> I have not had the time to look at the new udev, so I don't know what 
> exactly is needed to do this mapping: a sysfs path to something? Just a 
> major and minor number of the device? In addition, how does one obtain the 
> necessary data for each of the device node types? video is easy, but how do 
> you do this for dvb, alsa, fb, etc.?

I'll start looking at this this week while I'm away from my setup.

Obvoiusly the bridge driver can feed all the information about dev nodes
it has allocated to the v4l2_device class.

I'll assume the hard part is when a separate module takes care of a
related device function.  That's at least 3 part problem:

1. define what type of "relationships" can exist (i.e. video decoder &
audio decoder on the same PCI device, but different function numbers and
different modules)

2. how can all the different types of relationships be identified.

3. how to get notification when another module has claimed or
relinquished said related device or otherwise done something to change
the /dev node associated with it.  (a kernel event interface of some
sort - which I assume already exists.)

Regards,
Andy

> This is really the crucial part of this media controller device: this has to 
> work well before we can proceed.
> 
> Regards,
> 
> 	Hans
> 

