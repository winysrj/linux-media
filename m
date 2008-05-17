Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JxU7e-0003A2-1V
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 23:39:23 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: bvidinli <bvidinli@gmail.com>
In-Reply-To: <36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
References: <617be8890805171034t539f9c67qe339f7b4f79d8e62@mail.gmail.com>
	<36e8a7020805171423q42051749y5f6c82da88b695cd@mail.gmail.com>
Date: Sat, 17 May 2008 23:38:19 +0200
Message-Id: <1211060299.2592.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
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

Hello,

Am Sonntag, den 18.05.2008, 00:23 +0300 schrieb bvidinli:
> Hi,
> thank you for your answer,
> 
> may i ask,
> 
> what is meant by "analog  input", it is mentioned on logs that:" only
> analog inputs supported yet.." like that..
> is that mean: s-video, composit ?

yes, only s-video and composite is enabled there.
Better we would have print only external analog inputs.

> (i installed mythtv on ubuntu kernel 2.6.26.rc2 , it shows in input
> connections only svideo and composit... )
> 
> i want to scan air-tv channels, and dvb-s channels...
> aren't these supported yet ?

Not with 2.6.26, but likely with Matthias' patches.

> i will check your suggestions... and try...
> 
> thanks again
> 
> 
> 
> 2008/5/17 Eduard Huguet <eduardhc@gmail.com>:
> > Hi,
> >     You should maybe try the patches that Matthias Schwarzott made for
> > non-hybrid variant of the A700 card (the one I use). They implement the add
> > DVB-S support for that card, and it's running fine now for me.  don't know
> > if these patches might be also valid for the Hybrid version, but it's
> > probably worth the try.
> >
> >     You can find the patches in the Avermedia A700 wiki page of LinuxTV,
> > here:
> >
> > http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_%28A700%29
> >
> >     Take the lastest full diff file  from ZZam's repository and apply it
> > over the current HG tree. If you are unsure about how to proceed, myou
> > should first take a look at the howto page regarding LinuxTV drivers
> > install:
> >
> > http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
> >
> > Good luck :D
> >   Eduard Huguet
> >
> >
> >
> >
> >
> >> ---------- Missatge reenviat ----------
> >> From: bvidinli <bvidinli@gmail.com>
> >> To: linux-dvb@linuxtv.org, "fahri donmez" <fahridon@gmail.com>,
> >> ozbilen@gmail.com
> >> Date: Sat, 17 May 2008 13:16:14 +0300
> >> Subject: [linux-dvb] merhaba: About Avermedia DVB-S Hybrid+FM A700
> >> i just compiled kernel version 2.6.26.rc2 on my ubuntu linux 8.04,
> >> many things including sound not working, but i got finally name of my
> >> tv/dvb card on dmesg output.
> >> previously i was getting UNKNOWN/GENERIC on dmesg for my tv card,
> >>
> >>  i use tvtime-scanner or tvtime, it does not scan, even analog channels,
> >>  i use following to try new tuners, :
> >> rmmod saa7134
> >> modprobe saa7134 card=141 tuner=2
> >>
> >> i run these two lines fo rtuner 0,1,2,3 and so on... to try different
> >> tuner numbers... on some numbers, computers locks down.. i had to
> >> reset...
> >>
> >>
> >> currently i have two questions:
> >> 1- what is correct statements/commands to be able to scan tv channels...
> >> 2- the log says only analog inputs available now, when it will be
> >> possible to watch dvb channels ?
> >> 3- what is best/good tutorials/sites that describe/help in
> >> dvb/tv/multimedia for ubuntu/linux, (i already looked linuxtv,
> >> searched google, many sites..)
> >>
> >>
> >> thanks.
> >>
> >>
> >> logs: dmesg,
> >>
> >> [   39.243703] saa7133[0]: found at 0000:00:14.0, rev: 209, irq: 12,
> >> latency: 32, mmio: 0xde003000
> >> [   39.243776] saa7133[0]: subsystem: 1461:a7a2, board: Avermedia
> >> DVB-S Hybrid+FM A700 [card=141,autodetected]
> >> [   39.243858] saa7133[0]: board init: gpio is b400
> >> [   39.243909] saa7133[0]: Avermedia DVB-S Hybrid+FM A700: hybrid
> >> analog/dvb card
> >> [   39.243915] saa7133[0]: Sorry, only the analog inputs are supported for
> >> now.
> >>

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
