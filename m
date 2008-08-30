Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UFPAXH029111
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:25:11 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UFOvsL031200
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 11:24:57 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080830070310.2ec060d7@mchehab.chehab.org>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<200808282058.26623.hverkuil@xs4all.nl> <48B7E8C4.5060605@nokia.com>
	<200808291543.27863.hverkuil@xs4all.nl>
	<20080829183420.1fcbfc11@mchehab.chehab.org>
	<1220080964.1736.55.camel@localhost>
	<20080830070310.2ec060d7@mchehab.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 30 Aug 2008 16:58:46 +0200
Message-Id: <1220108326.1726.31.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, Sakari Ailus <sakari.ailus@nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] soc-camera: add API documentation
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sat, 2008-08-30 at 07:03 -0300, Mauro Carvalho Chehab wrote:
	[snip]
> Yes, but still, this is something that it is still painful: gspca has lots of
> "magic" constants inside. Things like (from etoms.c):
> 	reg_w_val(gspca_dev, 0x80, 0x00);
	[snip]
> It is something really hard to understand why reg 3 needs value 1. OK, I know that
> most of this came from snooping URB's at another system driver, but, if there
> were bugs at the reversed-engineered driver (and there are bugs there also),
> you won't have any glue to debug.

Anyway you do it, I (we) have almost no information about the webcam
bridges and sensors. Sometimes, we find some documents and then, the
spec calls RSVD (reserved) some registers which are later differently
initialized for such and such bridge!

> It is much clearer if you look, for example, at ov7670:
> 	{ REG_CLKRC, 0x1 },	/* OV: clock scale (30 fps) */
> 	{ REG_TSLB,  0x04 },	/* OV */
	[snip]
> Ok, it is not fair to compare with ov7670, since I suspect that OLPC got the
> datasheets for that device. Yet, having a driver for each sensor makes easier
> to add more detailed info at that driver, if later the device manufacturer
> opens for us their datasheets, like several manufacturers already did.

I don't think so. First, I don't think the device manufacturers will
give information about their product: they prefer to sell opaque
drivers. Then, as, at job, I built firmware for embedded boards, I know
that a master/slave interface may be very complex and not easy to
explain. Also, once the driver works, why would you change anything?

> > If you look at the gspca code, you will see that many sensors are used
> > by different bridges. Indeed, some values are closed from each other,
> > but what to do with the differences? (the initial values of the sensor
> > registers seem to be tied to the physical wires, signal levels and
> > capabilities of the bridges)
> 
> I can see two ways:
	[snip]

Why do you want the drivers to be so complexified? I already tried to
look at such drivers, and I could not find where was the used code. With
gspca, all the webcam dependant stuff is located in one file only.

> The real gain is not the size reduction. Having a generic module for a sensor
> have some benefits:
> 
> 1) All common stuff being there means that it will be easier to maintain, since
> a bug found on one module should be replied on other modules;

I never saw that!

> 2) Newer drivers may be written faster, since they may use the existing code.

Usually, newer drivers are written because they do not fall into some
existing code.

> I'm not saying that we _need_ to do this change for gspca. I'm just saying that
> this is a _good_ improvement to the code. I know that this change
> requires lots of janitors effort with little gain to the end users.

I would go to an other way: instead of developping general functions
which have to be customized, why don't you use the generic gspca driver
as a base for all the USB video devices (including TV)?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
