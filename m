Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3U4jIjB017479
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 00:45:18 -0400
Received: from smtp28.orange.fr (smtp28.orange.fr [80.12.242.101])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3U4j42j024627
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 00:45:04 -0400
Date: Wed, 30 Apr 2008 06:44:58 +0200
From: mahakali <mahakali@orange.fr>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080430044458.GA6031@orange.fr>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
	<1209507302.3456.83.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1209507302.3456.83.camel@pc10.localdom.local>
Cc: video4linux-list@redhat.com
Subject: Re: Card Asus P7131 hybrid > no signal
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

On Wed, Apr 30, 2008 at 12:15:02AM +0200, hermann pitton wrote :
 
> Hello,
> 
> if you have card=112 tuner=61 auto detected something goes very wrong.
> 
> On any recent "official" code the card should be auto detected as
> card=112, tuner=54, which is the tda8290 analog IF demodulator within
> the saa7131e and behind its i2c gate is a tda8275ac1 at address 0x61
> which is correct in your logs.
> 
> Hopefully you are only confusing tuner address 61 with tuner type,
> auto detection should be OK then.
> 
> Analog TV is on the upper antenna connector (cable TV) and you need a
> saa7134 insmod option "secam=L" in France. ("modinfo saa7134")
> On La Corse may still be some "secam=Lc" broadcast, not sure about that.
> 
> DVB-T (numerique) is on the lower antenna connector where also is
> radio/FM.
> 
> We have many reports that there often is an positive offset of about
> 166000Hz needed in France, which you don't seem to use on your digital
> tuning attempt. If this is needed and missing, the tda10046 will fail.
> You might try to add it.
> 
> Download dvb-apps from linuxtv.org mercurial and check if there is an
> updated initial scan file for your region in scan/dvb-t.
> 
> example with offset:
> 
> # Paris - France - various DVB-T transmitters
> # contributed by Alexis de Lattre < >
> # Paris - Tour Eiffel      : 21 24 27 29 32 35
> # Paris Est - Chennevières : 35 51 54 57 60 63
> # Paris Nord - Sannois     : 35 51 54 57 60 63
> # Paris Sud - Villebon     : 35 51 56 57 60 63
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
> T 714166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> 
> You can also try to "scan" on a known frequency and bandwidth and set
> the rest to AUTO AUTO ... or get "wscan" or try with "kaffeine".
> 
> You might also try to increase the tuning timeout.
> 
> Good Luck,
> 
> Hermann
> 
> 
 Thanks for your answer, I already found some messages from you about
this card in the archives of the list, I am now going to work, I try
what you are suggesting this evening.

I will - I have to -  re-read your message in order to understand it
well.

Auf Deutsch fliesst es mir leichter von der Feder - also Tastatur :
Besten Dank, ich versuche das ganze heute Abend, wenn ich zurück von der
Arbeit bin.

mfG

mahakali

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
