Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UJg2df007445
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 15:42:03 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7UJfo3p007180
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 15:41:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 30 Aug 2008 21:41:35 +0200
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
	<20080830070310.2ec060d7@mchehab.chehab.org>
	<1220108326.1726.31.camel@localhost>
In-Reply-To: <1220108326.1726.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808302141.35467.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, Sakari Ailus <sakari.ailus@nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
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

On Saturday 30 August 2008 16:58:46 Jean-Francois Moine wrote:
> On Sat, 2008-08-30 at 07:03 -0300, Mauro Carvalho Chehab wrote:
> 	[snip]
>
> > Yes, but still, this is something that it is still painful: gspca
> > has lots of "magic" constants inside. Things like (from etoms.c):
> > 	reg_w_val(gspca_dev, 0x80, 0x00);
>
> 	[snip]
>
> > It is something really hard to understand why reg 3 needs value 1.
> > OK, I know that most of this came from snooping URB's at another
> > system driver, but, if there were bugs at the reversed-engineered
> > driver (and there are bugs there also), you won't have any glue to
> > debug.
>
> Anyway you do it, I (we) have almost no information about the webcam
> bridges and sensors. Sometimes, we find some documents and then, the
> spec calls RSVD (reserved) some registers which are later differently
> initialized for such and such bridge!

I think it makes a big difference whether you have full documentation or 
not. In the first case you have all the information you need to make a 
generic sensor driver, in the second case that will be much harder and 
probably for little gain.

> > It is much clearer if you look, for example, at ov7670:
> > 	{ REG_CLKRC, 0x1 },	/* OV: clock scale (30 fps) */
> > 	{ REG_TSLB,  0x04 },	/* OV */
>
> 	[snip]
>
> > Ok, it is not fair to compare with ov7670, since I suspect that
> > OLPC got the datasheets for that device. Yet, having a driver for
> > each sensor makes easier to add more detailed info at that driver,
> > if later the device manufacturer opens for us their datasheets,
> > like several manufacturers already did.
>
> I don't think so. First, I don't think the device manufacturers will
> give information about their product: they prefer to sell opaque
> drivers. Then, as, at job, I built firmware for embedded boards, I
> know that a master/slave interface may be very complex and not easy
> to explain. Also, once the driver works, why would you change
> anything?

It is true that it is getting easier to obtain datasheets. So that 
definitely helps. And having reusable drivers rather than drivers tied 
to a specific product is preferable in the long run. Improvements to 
that driver will benefit all products that use that driver, as opposed 
to only that particular product. It's not the only consideration, but 
definitely a very important one.

> > > If you look at the gspca code, you will see that many sensors are
> > > used by different bridges. Indeed, some values are closed from
> > > each other, but what to do with the differences? (the initial
> > > values of the sensor registers seem to be tied to the physical
> > > wires, signal levels and capabilities of the bridges)

In general you need a function that you can call to setup such things. 
The same happens with video encoders like the saa7115: depending on how 
it is wired up you have to setup the routing pins, clock frequencies 
and similar settings. Not terribly difficult to do.

> >
> > I can see two ways:
>
> 	[snip]
>
> Why do you want the drivers to be so complexified? I already tried to
> look at such drivers, and I could not find where was the used code.
> With gspca, all the webcam dependant stuff is located in one file
> only.

I can only speak for how the i2c modules are organized that the video 
capture drivers use. Most of these drivers use one or more i2c modules 
to process audio and/or video. Depending on the particular card model 
you load the right combination of modules, but after that you can 
program them all in the same way since they all have the same API. It 
works great there because it makes it easy to add support to a new card 
and also because several of these i2c drivers are quite complex and you 
really do not want to have them duplicated. Also, we have the 
datasheets for pretty much all of them.

> > The real gain is not the size reduction. Having a generic module
> > for a sensor have some benefits:
> >
> > 1) All common stuff being there means that it will be easier to
> > maintain, since a bug found on one module should be replied on
> > other modules;
>
> I never saw that!

Not yet, perhaps.

> > 2) Newer drivers may be written faster, since they may use the
> > existing code.
>
> Usually, newer drivers are written because they do not fall into some
> existing code.
>
> > I'm not saying that we _need_ to do this change for gspca. I'm just
> > saying that this is a _good_ improvement to the code. I know that
> > this change requires lots of janitors effort with little gain to
> > the end users.
>
> I would go to an other way: instead of developping general functions
> which have to be customized, why don't you use the generic gspca
> driver as a base for all the USB video devices (including TV)?

No thank you, especially not for TV drivers. I'll bet that if you would 
have had full documentation from the start for all the devices you 
probably wouldn't have set it up like this.

It is basic good design to have separate drivers (or at least sources) 
for each chip. Due to lack of documentation that isn't always possible, 
so then you have to fall back to an alternative.

Another reason why having a single driver for each chip is good is that 
it allows the community to steadily improve that driver. Usually the 
first implementation will do just the basics. Later additions implement 
the remaining interesting features that most chips offer in one way or 
another. You probably wouldn't do that if the support for the same chip 
was implemented in multiple places. And those improvements will benefit 
all products that use that chip.

Having said all this, I honestly do not know how easy or hard it really 
is to write a generic sensor API to be used with those sensors for 
which a datasheet is available. I don't know enough about webcam 
drivers right now. But I do know that it is a very good long-term 
strategy.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
