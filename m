Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:56822 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbZCDXmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 18:42:04 -0500
Date: Wed, 4 Mar 2009 15:42:01 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
In-Reply-To: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com>
Message-ID: <Pine.LNX.4.58.0903041502240.24268@shell2.speakeasy.net>
References: <A24693684029E5489D1D202277BE89442E296E09@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Mar 2009, Aguirre Rodriguez, Sergio Alberto wrote:
> As what I understand, we have 2 possible situations for multiple opens here:
>
> Situation 1
>  - Instance1: Select sensor 1, and Do queue/dequeue of buffers.
>  - Instance2: If sensor 1 is currently selected, Begin loop requesting internally collected OMAP3ISP statistics (with V4L2 private based IOCTLs) for performing user-side Auto-exposure, Auto White Balance, Auto Focus algorithms. And Adjust gains (with S_CTRL) accordingly on sensor as a result.
>
> Situation 2
>  - Instance1: Select sensor1 as input. Begin streaming.
>  - Instance2: Select sensor2 as input. Attempt to begin streaming.
>
> So, if I understood right, on Situation 2, if you attempt to do a S_INPUT
> to sensor2 while capturing from sensor1, it should return a -EBUSY,
> right?  I mean, the app should consciously make sure the input (sensor)
> is the correct one before performing any adjustments.

It's usually perfectly legal to change inputs from one file handle while
another file handle is capturing.

If changing inputs while capturing is hard for your hardware and not
supported, then S_INPUT could return EBUSY while capture is in progress.
But in that case it doesn't matter which file descriptor is trying to
change inputs.

v4l2 is designed to allow a device to be controlled from multiple open file
descriptors.  Just like serial ports or audio mixers can be.

In general, an application should not worry about someone changing inputs
or frequencies while it is running.  If using v4l2-ctl while and app is
running leads to undesirable behavior there is a simple solution:  Don't do
that.

If you want exclusive access you can use a solution external to v4l2.  For
instance most apps that use serial ports (pppd, minicom, etc.) use lock
files in /var/lock to control access.  V4L2 also gives you
VIDIOC_[SG]_PRIORITY to do access control within v4l2, but it's not much
used.  It has little use because exclusive access just isn't something that
important.  In theory it seems important, but in practice no one seems to
care much that it's missing.
