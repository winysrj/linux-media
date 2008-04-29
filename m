Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TMGeYQ016303
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 18:16:40 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TMFsPB025715
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 18:15:55 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: mahakali <mahakali@orange.fr>
In-Reply-To: <20080429192149.GB10635@orange.fr>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
Content-Type: text/plain; charset=utf-8
Date: Wed, 30 Apr 2008 00:15:02 +0200
Message-Id: <1209507302.3456.83.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
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


Am Dienstag, den 29.04.2008, 21:21 +0200 schrieb mahakali:
> On Mon, Apr 28, 2008 at 09:07:19PM +0200, Adam Pribyl wrote :
> > I have this card too - at least I think, and it works. Not 
> > withoutproblems but works. Make sure you set up properly TV time, then 
> > try to use "nv" driver instead "nvidia". Most probably if you get the 
> > picture, you'll have problems with sound. You have to use module 
> > saa7134-alsa and sox. See e.g.: 
> > https://lowlevel.cz/log/pivot/entry.php?id=122
> > at the end.
> >
> > Adam Pribyl
> >
> 
> On Mon, Apr 28, 2008 at 09:07:19PM +0200, Adam Pribyl wrote :
> > I have this card too - at least I think, and it
> > works. Not withoutproblems but works. Make sure you set up
> >properly TV time, then try to use "nv" driver instead "nvidia". Most
> >probably if you get the picture, you'll have problems with sound. You have
> >to use module saa7134-alsa and sox. See e.g.:
> > https://lowlevel.cz/log/pivot/entry.php?id=122
> > at the end
> > Adam Pribyl
> 
>   
> The problem is: No picture .... I thinkk, if you
> have no signal, it is pretty normal.
> 
> What are the options you pass to the saa7134 module ?
> I mean card=<number> tuner=<number>
> I have card=112 tuner=61 (auto detect).
> In one Saa7134-hardware how-to the autor gives
> following values : card=78 tuner=54.
> 
> Any help would be great.
> 
> mahakali
> 
> 

Hello,

if you have card=112 tuner=61 auto detected something goes very wrong.

On any recent "official" code the card should be auto detected as
card=112, tuner=54, which is the tda8290 analog IF demodulator within
the saa7131e and behind its i2c gate is a tda8275ac1 at address 0x61
which is correct in your logs.

Hopefully you are only confusing tuner address 61 with tuner type,
auto detection should be OK then.

Analog TV is on the upper antenna connector (cable TV) and you need a
saa7134 insmod option "secam=L" in France. ("modinfo saa7134")
On La Corse may still be some "secam=Lc" broadcast, not sure about that.

DVB-T (numerique) is on the lower antenna connector where also is
radio/FM.

We have many reports that there often is an positive offset of about
166000Hz needed in France, which you don't seem to use on your digital
tuning attempt. If this is needed and missing, the tda10046 will fail.
You might try to add it.

Download dvb-apps from linuxtv.org mercurial and check if there is an
updated initial scan file for your region in scan/dvb-t.

example with offset:

# Paris - France - various DVB-T transmitters
# contributed by Alexis de Lattre < >
# Paris - Tour Eiffel      : 21 24 27 29 32 35
# Paris Est - Chennevières : 35 51 54 57 60 63
# Paris Nord - Sannois     : 35 51 54 57 60 63
# Paris Sud - Villebon     : 35 51 56 57 60 63
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
T 714166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

You can also try to "scan" on a known frequency and bandwidth and set
the rest to AUTO AUTO ... or get "wscan" or try with "kaffeine".

You might also try to increase the tuning timeout.

Good Luck,

Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
