Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6F8l49i003231
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:47:04 -0400
Received: from mail6.sea5.speakeasy.net (mail6.sea5.speakeasy.net
	[69.17.117.8])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6F8kNal005197
	for <video4linux-list@redhat.com>; Tue, 15 Jul 2008 04:46:42 -0400
Date: Tue, 15 Jul 2008 01:46:17 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Domenico Andreoli <cavokz@gmail.com>
In-Reply-To: <20080713163952.GA32494@ska.dandreoli.com>
Message-ID: <Pine.LNX.4.58.0807150027230.3550@shell2.speakeasy.net>
References: <200807101914.10174.mb@bu3sch.de> <200807131215.12082.mb@bu3sch.de>
	<20080713154333.GA32133@ska.dandreoli.com>
	<200807131808.35599.mb@bu3sch.de>
	<20080713163952.GA32494@ska.dandreoli.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Brownell <david-b@pacbell.net>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Michael Buesch <mb@bu3sch.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] Add bt8xxgpio driver
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

On Sun, 13 Jul 2008, Domenico Andreoli wrote:
> On Sun, Jul 13, 2008 at 06:08:35PM +0200, Michael Buesch wrote:
> > > +
> > > +	while((ret = gpiochip_remove(&device->chip)) != 0) {
> > > +		printk(KERN_INFO "error unregistering chip %s: %d\n", device->chip.label, ret);
> > > +		schedule();
> > > +	}
> >
> > This loop is dangerous.
> > Simply try to unregister it and exit with an error message if it failed.
> > Looping is of no use.
> > In fact, I think gpiochip_remove should return void. Drivers cannot
> > do anything if it failed, anyway.

gpiolib will inc the use count of the bttvgpio module when a gpio is
requested, so the module shouldn't unload while a gpio is requested.  The
only reason gpiochip_remove() should fail is if a gpio is still requested.
So it shouldn't happen that gpiochip_remove will fail when the module is
unloaded.  Unless the module unload is forced, but in that case the right
thing to do is unload and let the gpiochip_remove() fail instead of
hanging.

There is an issue if the bt8x8 device is hot-unplugged while it's in use.
I doubt the bttv driver handles this very well.

> Here the module is going to free device structure. Ignoring the error
> looks even more dangerous to me. I need to see if scheduling while
> unloading a module is allowed.

I'm pretty sure it is allowed.  The problem is that unless something
un-requests the gpio in use, the module unload will hang in the kernel for
ever.  If someone does rmmod -f, don't turn it into a un-killable rmmod -w.
If they wanted rmmod -w, they would have done it.

> > > --- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv.h	2008-07-13 15:52:08.000000000 +0200
> > > +++ v4l-dvb.git/drivers/media/video/bt8xx/bttv.h	2008-07-13 16:53:42.000000000 +0200
> > > @@ -249,6 +249,8 @@
> > >  	void (*audio_mode_gpio)(struct bttv *btv, struct v4l2_tuner *tuner, int set);
> > >
> > >  	void (*muxsel_hook)(struct bttv *btv, unsigned int input);
> > > +
> > > +	unsigned int has_gpiolib:1;
> >
> > :1 style bitfields generate ugly code and they make no sense most of
> > the time. better use "bool".

David is wrong here.  The bttv driver has a huge card database and it
shouldn't be bloated.  These fields are typically used only once when the
card loads are the code generated is perfectly ok.  But, you must put the
new field with the other bit fields to avoid increasing the size of the
structure.  You should measure the module size with objdump before and
after and see how much bloat you added.

If someone mods their card to use the gpio lines the driver still won't
drive it unless they change it in the card database.  It would be nicer if
there was a module option to export the gpios.  That could also be useful
for figuring out how the gpios are used for things like sound routing,
mute, radio mode, and so on.  I've been using the v4l2 debug register
interface for this, but the sysfs would be another way.

BTW David, V4L2 has an ioctl() that allows one to set the bttv gpios even
if the driver is using them, and it's never caused any complaints.  I fail
see what is different about modifying the same gpios through sysfs that
makes it so dangerous it can't be allowed.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
