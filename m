Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1LD3wX-0004bQ-9m
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 22:28:33 +0100
Date: Wed, 17 Dec 2008 23:28:24 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: ga ver <gavermer@gmail.com>
In-Reply-To: <468e5d620812171159g49b87f0bu484d5445c695249f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812172317020.21437@shogun.pilppa.org>
References: <468e5d620812171159g49b87f0bu484d5445c695249f@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Linux DVB driver API version 5.0?
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

> I download the S2API driver from
> hg clone http://mercurial.intuxication.org/hg/s2-liplianin
> make and make install OK
>
> I try to install scan-s2 and got
> /usr/local/src# cd scan-s2
> root@gv3:/usr/local/src/scan-s2# make
> gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
> In file included from diseqc.c:7:
> scan.h:86: fout: expected specifier-qualifier-list before 'fe_rolloff_t'
> make: *** [diseqc.o] Fout 1

You need to edit the Makefile and change from there the include
"-I../s2/linux/include" to point your "s2-liplianin/linux/include"
directory.

> Installing vdr-1.7.2 gives
> /usr/local/src/vdr-1.7.2# make
> In file included from audio.c:12:
> dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!
> In file included from dvbdevice.c:10:
> dvbdevice.h:19:2: error: #error VDR requires Linux DVB driver API version 5.0!
> In file included from dvbosd.c:15:
>
> Is this not de right driver?, or what is wrong

I do not know is there some better way but I always do these steps in vdr 
dir.
1) cp Make.config.template Make.config

2) edit Make.config and set DVBDIR to point your liblianin driver 
directory. (something like)
DVBDIR   = <abcdkissakavelee>/s2-liplianin/linux

3) make
4) make plugins
5) copy working remote.conf file from older vdr version (or answer to VDR 
questions during the first startup)
6) edit runvdr so that all of your plugins are launched and then launch 
vdr with "./runvdr". If you have tv connected to ff card, you should now 
see the picture. If not, use xineliboutput or streamdev plugins for 
connecting to vdr.

Mika



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
