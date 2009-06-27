Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4529 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbZF0M6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 08:58:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: v4l2_int_device vs v4l2_subdev?
Date: Sat, 27 Jun 2009 14:58:14 +0200
Cc: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <4A43FD77.1020709@mlbassoc.com> <200906260830.20193.hverkuil@xs4all.nl> <A24693684029E5489D1D202277BE8944405D0043@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944405D0043@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906271458.14579.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 26 June 2009 16:43:52 Aguirre Rodriguez, Sergio Alberto wrote:
> > > But in user space there is nothing changed having access to
> > > device and control them.
> > > As you know, subdev and int-device is all about how to bind
> > > interface(or host?) and device and make them communicated each other.
> > > But using subdev device driver with int-device supporting interface
> > > (or host) device driver? it won't make any communication.
> > > So if you are running out of time with your project, you'd better use
> > > old driver of TVP. Like TVP driver in kernel 2.6.28 I suppose. But if
> > > you have enough time and wanna be challenging, try to convert
> > > in-device based omap3 camera interface driver to subdev supporting
> > > one.
> > 
> > Someone's got to do this. v4l2_subdev is the future and it has many
> > advantages over the older interfaces. The ability to be able to use the
> > same i2c driver in anything from USB webcams to PCI capture cards to
> > omap/davinci embedded platforms is very powerful.
> 
> Hi,
> 
> We have already this framework migration planned, but we haven't been
> able to do it, because we are still solving stability issues on the driver.
> 
> I beg for your patience, and i hope i can get my hands on this pretty soon.
> 
> I'll be updating my tree when i have something.

Sorry, I was a bit harsh there. It was not aimed at you, Sergio, but at others
who read this. I just want to make sure that everyone is aware of this new
framework and how important it is to migrate to this framework.

Moving to a new framework can be a very time consuming process, but I think
it is very important to try and get this finished as soon as possible. With
the inclusion of the omap and davinci drivers in the kernel I'm sure a lot
of new sensor and video drivers will start popping up. And if they are
written as subdev drivers from the start, then that will make inclusion in
the kernel much easier. Since sensors especially are also used in combination
with other SoCs and webcams it will be very useful indeed to have fully
reusable sensor drivers.

It's an very active period for the v4l-dvb subsystem with a lot of new
drivers and new functionality so any design decisions taken will be with
us for a long time. The extra time spent now on moving to v4l2_subdev and
thinking on how to design new APIs for new functionality is well worth it.

I consider this a critical time for the v4l subsystem in particular: once
all drivers use v4l2_subdev we will have a very powerful foundation to build
on.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
