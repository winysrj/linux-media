Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <techno-mole@ntlworld.com>) id 1L5K69-0003ls-Rf
	for linux-dvb@linuxtv.org; Wed, 26 Nov 2008 14:06:31 +0100
Received: from aamtaout03-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout01-winn.ispmail.ntl.com
	(InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP id
	<20081126130553.XVAG1869.mtaout01-winn.ispmail.ntl.com@aamtaout03-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Wed, 26 Nov 2008 13:05:53 +0000
Received: from [192.168.0.100] (really [82.21.151.49])
	by aamtaout03-winn.ispmail.ntl.com
	(InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP id
	<20081126130552.GNQL2093.aamtaout03-winn.ispmail.ntl.com@[192.168.0.100]>
	for <linux-dvb@linuxtv.org>; Wed, 26 Nov 2008 13:05:52 +0000
Message-ID: <492D49AE.7070103@ntlworld.com>
Date: Wed, 26 Nov 2008 13:05:50 +0000
From: dan <techno-mole@ntlworld.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Kworld Plus TV Hybrid pci card (model dvb-t 210se)
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

Hello.

I have recently purchased a Kworld pci tv card (Kworld PLus Tv Hybrid
pci card, model dvb-t 10se)
Now although I have it working on kubuntu 8.10 (intrepid) using kaffeine
(that was the only one that it did actually work on) Im wondering about
drivers for the card as I am having some small picture quality issues.

Ive been tweaking the de-interlacing and various other settings, but the
picture is choppy at best.
Im using the card on a desktop system, the card is using the arial on
the roof and its also passing through a booster (one compatible with
digital tv signals as well as analogue)

As I have a dual boot set up I also use the tv card on xp, and it works
fine and the picture quality is good, and very rarely changes from being
good.

But I just cant seem to get the same picture quality on kubuntu, the
only kworld card supported according to the dvb-t wiki is the dvb-t 220
which uses a philips saa7134 chip, my card (if i run lspci in a
terminal) comes up as -

" 01:05.0 Multimedia controller: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1) "

So I am wondering if there are drivers for this specific card ? maybe I
would need to compile them myself ? and also if anyone has the same card
and how it runs for them.
I have also thought that the transmitter info might be a little off, I
live in norfolk (uk) and the nearest tv transmitter is Tacolneston (Im
too far from sandy heath, which is the nearest after Tacolneston) I did
have some trouble finding the info for this transmitter, and although if
I use it (eg - with kaffeine in the dvb-t file as uk-Tacolneston)
kaffeine does pick up all the channels Im wondering if the frequencies
are out a little this may affect the reception ?

The other curious thing is that as I mentioned Im using kaffeine as I
found mythtv almost impossible to setup and kaffeine worked more less
straight away, the kaffeine version im using is in the repos for kubuntu
and it comes up as 0.8.6, according to a user on the kaffeine forums I
should be able to set kaffeine to " auto " scan, which as far as I can
tell makes it perform a blind scan and in theory should pick up any
channels it finds, but I dont have the " auto " scan feature, so does
nayone else use kaffeine and have they run into this problem ?

cheers in advance for any help.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
