Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28FFxQ0027080
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 10:15:59 -0500
Received: from ex.volia.net (ex.volia.net [82.144.192.10])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m28FFKQh008964
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 10:15:21 -0500
Message-ID: <002701c8812f$33c6ed20$6501a8c0@LocalHost>
From: "itman" <itman@fm.com.ua>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
References: <000f01c808e7$3ab4e3a0$6401a8c0@LocalHost>
	<1191845080.3506.82.camel@pc08.localdom.local>
	<007f01c80e7d$21c02300$6401a8c0@LocalHost>
	<1192788480.18371.4.camel@gaivota>
	<Pine.LNX.4.58.0710190951100.16052@shell4.speakeasy.net>
	<471A4011.8010706@fm.com.ua> <1192922346.4857.8.camel@gaivota>
	<003701c81410$869e6960$6401a8c0@LocalHost>
	<1193043044.30686.22.camel@gaivota>
	<003a01c8150f$6a248490$6401a8c0@LocalHost>
	<1193103690.14811.10.camel@pc08.localdom.local>
	<000401c8151a$080ef4b0$6401a8c0@LocalHost>
	<1193107021.5728.20.camel@gaivota>
	<1193107692.5728.23.camel@gaivota>
Date: Sat, 8 Mar 2008 17:15:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"; reply-type=original
Content-Transfer-Encoding: 8bit
Cc: simon@kalmarkaglan.se, Linux and Kernel Video <video4linux-list@redhat.com>,
	MIDIMaker <midimaker@yandex.ru>, Trent Piepho <xyzzy@speakeasy.org>
Subject: 2.6.24 kernel and MSI TV @nywheremaster MS-8606 status
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

Hi, Mauro.

Could you please be so kind to mention which is right mercurial repository 
to which you have merged your changes and which one should be used for 
2.6.24 kernel?

I've got issue:

Trying now to build drivers for MSI TV @nywheremaster MS-8606 under kernel 
2.6.24.3.

What were done:

1) mkdir /usr/src/linux/tmpmsi
2) cd tmpmsi
3) hg init v4l-dvb
4) hg pull http://linuxtv.org/hg/v4l-dvb
5) cd v4l-dvb
6) make
7) make install


As result I've got cx88-cards.c with fixed gpio for MSI TV @anywhere BUT! 
there are no main parameters for module tuner: port1, port2, qss.


 head Makefile
BUILD_DIR := $(shell pwd)/v4l
TMP ?= /tmp
REPO_PULL := http://linuxtv.org/hg/v4l-dvb



 modinfo  tuner
filename:       /lib/modules/2.6.24.3/kernel/drivers/media/video/tuner.ko
license:        GPL
author:         Ralph Metzler, Gerd Knorr, Gunther Mayer
description:    device driver for various TV and TV+FM radio tuners
depends: 
tea5761,v4l2-common,mt20xx,tuner-simple,tda9887,videodev,tea5767,xc5000,tuner-xc2028,tda8290
vermagic:       2.6.24.3 preempt mod_unload PENTIUM4
parm:           force:List of adapter,address pairs to boldly assume to be 
present (array of short)
parm:           probe:List of adapter,address pairs to scan additionally 
(array of short)
parm:           ignore:List of adapter,address pairs not to scan (array of 
short)
parm:           addr:int
parm:           no_autodetect:int
parm:           show_i2c:int
parm:           debug:int
parm:           pal:string
parm:           secam:string
parm:           ntsc:string
parm:           tv_range:array of int

With best regards,

            Serge Kolotylo


__________________________

Em Ter, 2007-10-23 às 05:11 +0300, itman escreveu:
> After modprobe tuner port1=0 port2=0 qss=1 it works GREAT both TV
> (sound is
> clear and loud) and radio (sound is clear and loud) with DEFAULT
> (card=7,

Great! If you send us the proper tuner name, marked at the metallic can
inside the board, we may add those tda9887 options at tuner-types.c.
This way, passing the parameters to tuners can be avoided.

> PS: will it be merged these changes to vanilla kernel soon?

I've already merged into v4l-dvb tree. However, since this is changing
some stuff at the existing driver, the addition at mainstream should be
postponed to kernel 2.6.25.

-- 
Cheers,
Mauro 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
