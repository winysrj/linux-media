Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42853 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbZCECXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 21:23:55 -0500
Subject: RE: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: hermann pitton <hermann-pitton@arcor.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0903041502240.24268@shell2.speakeasy.net>
References: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com>
	 <Pine.LNX.4.58.0903041502240.24268@shell2.speakeasy.net>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 03:25:20 +0100
Message-Id: <1236219920.2169.16.camel@pc09.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 04.03.2009, 15:42 -0800 schrieb Trent Piepho:
> On Wed, 4 Mar 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> > As what I understand, we have 2 possible situations for multiple opens here:
> >
> > Situation 1
> >  - Instance1: Select sensor 1, and Do queue/dequeue of buffers.
> >  - Instance2: If sensor 1 is currently selected, Begin loop requesting internally collected OMAP3ISP statistics (with V4L2 private based IOCTLs) for performing user-side Auto-exposure, Auto White Balance, Auto Focus algorithms. And Adjust gains (with S_CTRL) accordingly on sensor as a result.
> >
> > Situation 2
> >  - Instance1: Select sensor1 as input. Begin streaming.
> >  - Instance2: Select sensor2 as input. Attempt to begin streaming.
> >
> > So, if I understood right, on Situation 2, if you attempt to do a S_INPUT
> > to sensor2 while capturing from sensor1, it should return a -EBUSY,
> > right?  I mean, the app should consciously make sure the input (sensor)
> > is the correct one before performing any adjustments.
> 
> It's usually perfectly legal to change inputs from one file handle while
> another file handle is capturing.
> 
> If changing inputs while capturing is hard for your hardware and not
> supported, then S_INPUT could return EBUSY while capture is in progress.
> But in that case it doesn't matter which file descriptor is trying to
> change inputs.
> 
> v4l2 is designed to allow a device to be controlled from multiple open file
> descriptors.  Just like serial ports or audio mixers can be.
> 
> In general, an application should not worry about someone changing inputs
> or frequencies while it is running.  If using v4l2-ctl while and app is
> running leads to undesirable behavior there is a simple solution:  Don't do
> that.
> 
> If you want exclusive access you can use a solution external to v4l2.  For
> instance most apps that use serial ports (pppd, minicom, etc.) use lock
> files in /var/lock to control access.  V4L2 also gives you
> VIDIOC_[SG]_PRIORITY to do access control within v4l2, but it's not much
> used.  It has little use because exclusive access just isn't something that
> important.  In theory it seems important, but in practice no one seems to
> care much that it's missing.

Just a note.

All true, but if you fallback to a modem connection with kernel 2.6.22
on FC6 with at least one NIC and an external router/switch, the default
route will still be assigned to eth0 and you can configure kppp to what
ever you want, but it does not override it, but claims to do so at the
GUI. (OK, I'm eight years away from pppd, but ...)

You have to use "route del default" at first like in stoneage and I
suspect there is more of this stuff around.

To make more use of VIDIOC_S/G_PRIORITY I always did propagate :)

The first use case was to capture on /dev/videoN and at once get vbi EPG
data on /dev/vbiN.

Cheers,
Hermann




