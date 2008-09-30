Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <loudestnoise@gmail.com>) id 1KkWXR-00007A-1X
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 06:08:42 +0200
Received: by gxk13 with SMTP id 13so11620003gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 29 Sep 2008 21:08:07 -0700 (PDT)
Message-Id: <2D4C0F1E-D73D-475C-BF64-91EF4A6E0BFE@gmail.com>
From: David Cintron <loudestnoise@gmail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v928.1)
Date: Mon, 29 Sep 2008 23:08:05 -0500
Subject: Re: [linux-dvb] cx18: Testers needed for patch to solve non-working
	CX23418 cards	under linux (Re: cx18: Possible causal
	realtionship for HVR-1600 I2C	errors)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

 > > > To all the users of CX23418 based cards that currently don't  
seem to
work, showing some of the above symptoms, please test my latest changes
at: http://linuxtv.org/hg/~awalls/v4l-dvb
I can't seem to get the HVR-1600 working on my system and I've tried  
awalls' revisions.  I already have a working PVR-500 in my system and  
have am wondering if this is contributing to my problems. I can't seem  
to get the card to initialize.  dmesg | grep cx18 returns nothing.  
Also, I get the errors when running make unload:
loudestnoise@loudestnoise-desktop:~/v4l-dvb-fc3285e4b3fa$ sudo make  
unload
make -C /home/loudesetnoise/v4l-dvb-fc3285e4b3fa/v4l unload
make[1]: Entering directory `/home/loudesetnoise/v4l-dvb-fc3285e4b3fa/ 
v4l'
scripts/rmmod.pl unload
found 268 modules
/sbin/rmmod tuner_types
ERROR: Module tuner_types is in use by tuner_simple
/sbin/rmmod tuner_simple
ERROR: Module tuner_simple is in use
/sbin/rmmod tea5767
ERROR: Module tea5767 is in use
/sbin/rmmod tda9887
ERROR: Module tda9887 is in use
/sbin/rmmod tda8290
/sbin/rmmod ivtv
/sbin/rmmod cx25840
/sbin/rmmod tuner
/sbin/rmmod cx2341x
/sbin/rmmod videodev
/sbin/rmmod tuner_simple
/sbin/rmmod wm8775
/sbin/rmmod compat_ioctl32
/sbin/rmmod tuner_types
/sbin/rmmod tea5767
/sbin/rmmod v4l2_common
/sbin/rmmod tda8290
ERROR: Module tda8290 does not exist in /proc/modules
/sbin/rmmod tda9887
/sbin/rmmod v4l1_compat
/sbin/rmmod tveeprom
/sbin/rmmod tuner_types
ERROR: Module tuner_types does not exist in /proc/modules
/sbin/rmmod tuner_simple
ERROR: Module tuner_simple does not exist in /proc/modules
/sbin/rmmod tea5767
ERROR: Module tea5767 does not exist in /proc/modules
/sbin/rmmod tda9887
ERROR: Module tda9887 does not exist in /proc/modules
/sbin/rmmod tda8290
ERROR: Module tda8290 does not exist in /proc/modules
Couldn't unload: tda8290 tda9887 tea5767 tuner_simple tuner_types
make[1]: Leaving directory `/home/loudesetnoise/v4l-dvb-fc3285e4b3fa/ 
v4l'
- David C. (loudestnoise)


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
