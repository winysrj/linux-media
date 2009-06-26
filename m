Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53524 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZFZOsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:48:18 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
CC: Gary Thomas <gary@mlbassoc.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 26 Jun 2009 09:43:52 -0500
Subject: RE: v4l2_int_device vs v4l2_subdev?
Message-ID: <A24693684029E5489D1D202277BE8944405D0043@dlee02.ent.ti.com>
References: <4A43FD77.1020709@mlbassoc.com>
 <5e9665e10906252227i4f667915rc1b52d6148c1a0e9@mail.gmail.com>,<200906260830.20193.hverkuil@xs4all.nl>
In-Reply-To: <200906260830.20193.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > But in user space there is nothing changed having access to
> > device and control them.
> > As you know, subdev and int-device is all about how to bind
> > interface(or host?) and device and make them communicated each other.
> > But using subdev device driver with int-device supporting interface
> > (or host) device driver? it won't make any communication.
> > So if you are running out of time with your project, you'd better use
> > old driver of TVP. Like TVP driver in kernel 2.6.28 I suppose. But if
> > you have enough time and wanna be challenging, try to convert
> > in-device based omap3 camera interface driver to subdev supporting
> > one.
> 
> Someone's got to do this. v4l2_subdev is the future and it has many
> advantages over the older interfaces. The ability to be able to use the
> same i2c driver in anything from USB webcams to PCI capture cards to
> omap/davinci embedded platforms is very powerful.

Hi,

We have already this framework migration planned, but we haven't been
able to do it, because we are still solving stability issues on the driver.

I beg for your patience, and i hope i can get my hands on this pretty soon.

I'll be updating my tree when i have something.

Regards,
Sergio