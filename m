Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2772 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZEJKXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 06:23:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Scoping the effort to add a media controller )Re: [ivtv-users] Delay loading v4l-cx25840.fw)
Date: Sun, 10 May 2009 12:23:28 +0200
Cc: linux-media@vger.kernel.org
References: <1241054296.3374.44.camel@palomino.walls.org> <1241739191.4035.3.camel@palomino.walls.org> <200905080845.10438.hverkuil@xs4all.nl>
In-Reply-To: <200905080845.10438.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101223.28739.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 08 May 2009 08:45:10 Hans Verkuil wrote:
> On Friday 08 May 2009 01:33:11 Andy Walls wrote:
> > On Sat, 2009-05-02 at 17:49 +0200, Hans Verkuil wrote:
> > > On Friday 01 May 2009 04:21:36 Andy Walls wrote:
> > > > On Wed, 2009-04-29 at 21:18 -0400, Andy Walls wrote:
> > > > > On Wed, 2009-04-29 at 13:33 +0200, Hans Verkuil wrote:
> > > >
> > > > Hans, it sounds like your media_controller device node idea is
> > > > really what we need to get implemented here for user space to do
> > > > queires on hardware.  This problem obviously affects more than the
> > > > ivtv driver so I'd recommend against an ivtv band-aid.
> > > >
> > > > We'd also want to coordinate with the hald folks and other user
> > > > space app/plumbing developers, as this likely affects a few v4l2
> > > > drivers. It sounds like an LPC agenda item to me...
> > > >
> > > > Regards,
> > > > Andy
> > >
> > > I agree. A media controller device is exactly what we need. It's
> > > ideal for applications and daemons like hald.
> > >
> > > Now all I need is the time to work on it and I don't see that
> > > happening anytime soon. :-(
> > >
> > > Any volunteers? I have a general idea of how it should be
> > > implemented, but it needs a fair amount of research as well.
> >
> > I recall a design document or brief: can you provide a pointer to them?
> >
> > What is the research that you think needs to be done?
> >
> > Regards,
> > Andy
> >
> > > Regards,
> > >
> > > 	Hans
>
> Hi Andy,
>
> Here is a link to the original RFC:
>
> http://www.archivum.info/video4linux-list%40redhat.com/2008-07/msg00371.h
>tml
>
> It's pretty old but the basic idea is still valid. I'll follow up this
> mail tonight or tomorrow with my latest thoughts on this subject and what
> the research is that has to be done.

OK, here is my follow-up:

I think the initial research should look into the device-discovery problem. 
Let's just start with a prototype that creates a single mediacontroller 
device for each struct v4l2_device and a simple test program that can open 
the media controller and enumerate the /dev device nodes that the board 
supports.

Note that the v4l2-sysfs-patch.c utility is useless for this, because it 
does not take into account udev rules setup by the user that renames the 
device nodes in /dev. I suspect (haven't tested it) that it also fails for 
cx88 devices where you have separate PCI devices for sound, video and dvb.

The right way to do it IMHO is to research the new capabilities of the 
recent udev versions: a new libudev was introduced and new capabilities of 
mapping a sysfs path to a /dev path, taking into account any user defined 
rules. So the media controller should enumerate all devices the driver 
created (v4l, dvb, alsa, fb, i2c, ir) and pass the needed data on to the 
application, which uses libudev to find the corresponding /dev device node.

I have not had the time to look at the new udev, so I don't know what 
exactly is needed to do this mapping: a sysfs path to something? Just a 
major and minor number of the device? In addition, how does one obtain the 
necessary data for each of the device node types? video is easy, but how do 
you do this for dvb, alsa, fb, etc.?

This is really the crucial part of this media controller device: this has to 
work well before we can proceed.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
