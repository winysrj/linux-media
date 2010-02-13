Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44506 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab0BMBIo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 20:08:44 -0500
Subject: Re: [PATCH 2/5 v2] sony-tuner: Subdev conversion from
 wis-sony-tuner
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pete Eberlein <pete@sensoray.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201002130017.44931.hverkuil@xs4all.nl>
References: <1265934787.4626.251.camel@pete-desktop>
	 <201002122203.15491.hverkuil@xs4all.nl>
	 <1266014180.4626.293.camel@pete-desktop>
	 <201002130017.44931.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 12 Feb 2010 20:08:34 -0500
Message-Id: <1266023314.3062.12.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-02-13 at 00:17 +0100, Hans Verkuil wrote:
> On Friday 12 February 2010 23:36:20 Pete Eberlein wrote:
> > On Fri, 2010-02-12 at 22:03 +0100, Hans Verkuil wrote:

> > > > My company, Sensoray, doesn't have any products that use this tuner.
> > > > This driver was orignally written by Micronas to support their go7007
> > > > chip in the Plextor TV402U models.  I don't have the datasheet or know
> > > > much about tuners anyway.  

> > > So only if an i2c driver is *never* used by parent drivers that have to support
> > > kernels < 2.6.26, then can it drop the v4l2-i2c-drv.h. An example of such an
> > > i2c driver is tvp514x.c.

> >  I've addressed your other comments in
> > the revised patch:
> 
> I've two small comments. See below.
> 
> I also realized that this is really two drivers in one: one driver for the
> actual tuner device and one for the mpx device which seems similar in
> functionality to the vp27smpx.c driver.
> 
> I will look at it again tomorrow, but I might decide that it is better to
> split it up into two drivers: one for the tuner and one for the mpx.


Pete and Hans,


The Sony VAIO GigaPocket cards (ivtv driver) that I have seen on the
'Net have these part numbers:

Sony Part # 859863200
Tuner Model # BTF-PJ401Z

Sony Part # 859860400
Tuner Model # BTF-PJ301Z

Any idea how applicable this driver is to these tuners?  I was about to
add a tuner-cards.c entry for tuner-simple.c to handle using Eric
Anderson's experimental results.

Regards,
Andy

> Regards,
> 
> 	Hans


