Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8OMwKww020841
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 18:58:20 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8OMv4Av029538
	for <video4linux-list@redhat.com>; Wed, 24 Sep 2008 18:57:04 -0400
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net
	[151.189.8.85])
	by mail-in-06.arcor-online.net (Postfix) with ESMTP id 6D7EA31EA43
	for <video4linux-list@redhat.com>;
	Thu, 25 Sep 2008 00:57:03 +0200 (CEST)
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id 5975B1078B7
	for <video4linux-list@redhat.com>;
	Thu, 25 Sep 2008 00:57:03 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-12.arcor-online.net (Postfix) with ESMTP id 772FE8C461
	for <video4linux-list@redhat.com>;
	Thu, 25 Sep 2008 00:57:02 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <48DA9ACB.1020900@hardfalcon.net>
References: <48DA9ACB.1020900@hardfalcon.net>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 00:51:05 +0200
Message-Id: <1222296665.3323.62.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: saa7134 PCI card (CTX917): FM radio not working
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

Hi Pascal,

Am Mittwoch, den 24.09.2008, 21:53 +0200 schrieb hardfalcon:
> Hi, I got a Creatix CTX917 (there seem to exist multiple versions of
> this card, mine got for example on the outside 2 video in  (one cinch
> and one S-Video), a line in jack and 2 RF connectors, one for TV/DVB-T
> and one for the Radio atenna, on the inside there are 3 of these "4 pin
> CD to soundcard" like connectors, one in white, one in red and one in
> yellow).

card=12 Medion 7134 represents lots of different cards, also with three
different tuners and they are configured through eeprom detection.

The CTX917 is only one of them and beside me on the desk is a V1 version
with only FM and TV antenna connector on the bracket. I checked it a
half year back with some others also detected as card=12 and all was
like expected.

I still have a different md7134 with FMD1216ME MK3 hybrid tuner in a
machine, but I can reinsert the CTX917 as well, if we don't come closer
to your radio problem.

The white MPC2 style onboard connector is audio in, the red one is audio
out to the sound card/chip and yellow is S-Video in and also Composite
over S-Video in.

> After I got DVB-T and normal TV to work, I wanted to be able to use the
> built-in FM radio, too. The radio tuner seems to be detected, as
> /dev/radio, /dev/radio1 and /dev/v4l/radio1 are created, but the "radio"
> tool isn't working, neither as user nor as root. It tunes, but there
> simply is not sound, and there are no radio signals detected if I use
> the "auto" mode of gqradio, either.

The FMD1216ME MK3 hybrid does not yet support radio auto scanning :(
You need to create a station list manually.

Now the main question.
Do you have the red analog audio out connected to your sound card?
Usually you would use CD or AUX in and can use an analog audio cable
from a cdrom for it. In later Medion machines analog audio out was not
connected anymore.

You could be using mplayer or mythtv with saa7134-alsa dma sound for
analog TV?

Without analog audio out connected you could try saa7134-alsa with a
helper application like sox.
sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 32000 /dev/dsp

You might get sync issues on the saa7134 chip and radio, then better use
the audio cable.

> My distro is Archlinux 64bit with all the latest updates, including
> those from testing and unstable repositories, so my kernel version is
> 2.6.26.5. I'm using the stock kernel from the official Archlinux repos
> (package "kernel26", release "2.6.26.5-1").
> 
> I recently got a Hauppauge Nova-T (one of the first ones, with the old
> brown PCB and Philips chips), which is working flawlessly (my only
> problem is that I haven't found a way yet to select the DVB-T card I
> want to use in Kaffeine or any of the other DVB apps I've tried. Perhaps
> somebody could give me a hint?)

mplayer -v -ao oss dvb://2@"some channel" would take the second adapter.

On recent stuff we also have a option for the adapter enumeration.
Try "modinfo saa7134-dvb"

options saa7134-dvb adapter_nr=1,0,2,3
in /etc/modprobe.conf and "depmod -a"

DVB: registering new adapter (saa7133[0])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
DVB: registering new adapter (saa7133[1])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
DVB: registering new adapter (saa7133[2])
DVB: registering frontend 2 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 26 -- ok
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[3])
DVB: registering frontend 3 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok


> Here is some more info:
> -----[lspci]--------------------
> 02:0a.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL
> Video Broadcast Decoder (rev 01)
>     Subsystem: Creatix Polymedia GmbH Medion 7134
>     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 84 (21000ns min, 8000ns max)
>     Interrupt: pin A routed to IRQ 18
>     Region 0: Memory at efefe000 (32-bit, non-prefetchable) [size=1K]
>     Capabilities: [40] Power Management version 1
>         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>     Kernel driver in use: saa7134
>     Kernel modules: saa7134
> --------------------[/lspci]-----

Better would be relevant "dmesg" output for saa7134 and tuner stuff.

> Besides my problem with the CTX917, I'd have a more general question:
> (how) would it be possible to use the tuner of a TV card (analogue TV or
> DVB-T) as some kind of "universal receiver" for a software defined
> reciever? For me as a ham radio operator, a receiver being able to
> digitalize radio signals from such a broad spectrum as 800Mhz would be
> very interesting, especially considering that a "real" receiver (even
> just a handheld) would cost 5 times more than a cheap TV card for my
> computer. Of course, the ability to digitalize the "raw" signal from the
> air without any demodulation would be another great advantage over a
> traditional receiever (although I'd also be more than happy if I was
> just able to demodulate FM signals on this broad spectrum).
> 

Maybe somebody else on this?

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
