Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DGeH0k029444
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 12:40:17 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DGdgEM010571
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 12:39:42 -0400
Received: by ug-out-1314.google.com with SMTP id s2so147734uge.6
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 09:39:42 -0700 (PDT)
Date: Sun, 13 Jul 2008 18:39:52 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Message-ID: <20080713163952.GA32494@ska.dandreoli.com>
References: <200807101914.10174.mb@bu3sch.de> <200807131215.12082.mb@bu3sch.de>
	<20080713154333.GA32133@ska.dandreoli.com>
	<200807131808.35599.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807131808.35599.mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>, video4linux-list@redhat.com,
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

On Sun, Jul 13, 2008 at 06:08:35PM +0200, Michael Buesch wrote:
> On Sunday 13 July 2008 17:43:33 Domenico Andreoli wrote:
> > 
> > Index: v4l-dvb.git/drivers/media/video/bt8xx/Makefile
> > ===================================================================
> > --- v4l-dvb.git.orig/drivers/media/video/bt8xx/Makefile	2008-07-13 15:52:08.000000000 +0200
> > +++ v4l-dvb.git/drivers/media/video/bt8xx/Makefile	2008-07-13 17:11:27.000000000 +0200
> > @@ -6,7 +6,11 @@
> >  		       bttv-risc.o bttv-vbi.o bttv-i2c.o bttv-gpio.o \
> >  		       bttv-input.o bttv-audio-hook.o

[...]

> > +
> > +static void __devexit bttv_gpiolib_remove(struct bttv_sub_device *sub)
> > +{
> > +	int ret;
> > +	struct bttv_gpiolib_device *device = dev_get_drvdata(&sub->dev);
> > +
> > +	while((ret = gpiochip_remove(&device->chip)) != 0) {
> > +		printk(KERN_INFO "error unregistering chip %s: %d\n", device->chip.label, ret);
> > +		schedule();
> > +	}
> 
> This loop is dangerous.
> Simply try to unregister it and exit with an error message if it failed.
> Looping is of no use.
> In fact, I think gpiochip_remove should return void. Drivers cannot
> do anything if it failed, anyway.

Here the module is going to free device structure. Ignoring the error
looks even more dangerous to me. I need to see if scheduling while
unloading a module is allowed.

[...]

> >
> > Index: v4l-dvb.git/drivers/media/video/bt8xx/bttv.h
> > ===================================================================
> > --- v4l-dvb.git.orig/drivers/media/video/bt8xx/bttv.h	2008-07-13 15:52:08.000000000 +0200
> > +++ v4l-dvb.git/drivers/media/video/bt8xx/bttv.h	2008-07-13 16:53:42.000000000 +0200
> > @@ -249,6 +249,8 @@
> >  	void (*audio_mode_gpio)(struct bttv *btv, struct v4l2_tuner *tuner, int set);
> >  
> >  	void (*muxsel_hook)(struct bttv *btv, unsigned int input);
> > +
> > +	unsigned int has_gpiolib:1;
> 
> :1 style bitfields generate ugly code and they make no sense most of
> the time. better use "bool".

This is copied stuff from bt8xxgpio and dvb-bt8xx ;)

Thanks,
Domenico

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
