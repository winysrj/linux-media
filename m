Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NKId8m027757
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 16:18:39 -0400
Received: from saufclan.de (static.169.44.46.78.clients.your-server.de
	[78.46.44.169])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8NKHlBJ001930
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 16:17:48 -0400
Received: from [192.168.1.51] (d90-129-47-250.cust.tele2.lu [90.129.47.250])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by saufclan.de (Postfix) with ESMTP id 9EEFC29A80F6
	for <video4linux-list@redhat.com>;
	Tue, 23 Sep 2008 22:17:47 +0200 (CEST)
Message-ID: <48D94EE8.9050802@hardfalcon.net>
Date: Tue, 23 Sep 2008 22:17:44 +0200
From: hardfalcon <spam@hardfalcon.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: saa7134 PCI card (CTX917): FM radio not working
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

Hi, I got a Creatix CTX917 (there seem to exist multiple versions of 
this card, mine got for example on the outside 2 video in  (one cinch 
and one S-Video), a line in jack and 2 RF connectors, one for TV/DVB-T 
and one for the Radio atenna, on the inside there are 3 of these "4 pin 
CD to soundcard" like connectors, one in white, one in red and one in 
yellow).

After I got DVB-T and normal TV to work, I wanted to be able to use the 
built-in FM radio, too. The radio tuner seems to be detected, as 
/dev/radio, /dev/radio1 and /dev/v4l/radio1 are created, but the "radio" 
tool isn't working, neither as user nor as root. It tunes, but there 
simply is not sound, and there are no radio signals detected if I use 
the "auto" mode of gqradio, either.

My distro is Archlinux 64bit with all the latest updates, including 
those from testing and unstable repositories, so my kernel version is 
2.6.26.5. I'm using the stock kernel from the official Archlinux repos 
(package "kernel26", release "2.6.26.5-1").

I recently got a Hauppauge Nova-T (one of the first ones, with the old 
brown PCB and Philips chips), which is working flawlessly (my only 
problem is that I haven't found a way yet to select the DVB-T card I 
want to use in Kaffeine or any of the other DVB apps I've tried. Perhaps 
somebody could give me a hint?)

Here is some more info:
-----[lspci]--------------------
02:0a.0 Multimedia controller: Philips Semiconductors SAA7134/SAA7135HL 
Video Broadcast Decoder (rev 01)
    Subsystem: Creatix Polymedia GmbH Medion 7134
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 84 (21000ns min, 8000ns max)
    Interrupt: pin A routed to IRQ 18
    Region 0: Memory at efefe000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [40] Power Management version 1
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=1 PME-
    Kernel driver in use: saa7134
    Kernel modules: saa7134
--------------------[/lspci]-----


Besides my problem with the CTX917, I'd have a more general question: 
(how) would it be possible to use the tuner of a TV card (analogue TV or 
DVB-T) as some kind of "universal receiver" for a software defined 
reciever? For me as a ham radio operator, a receiver being able to 
digitalize radio signals from such a broad spectrum as 800Mhz would be 
very interesting, especially considering that a "real" receiver (even 
just a handheld) would cost 5 times more than a cheap TV card for my 
computer. Of course, the ability to digitalize the "raw" signal from the 
air without any demodulation would be another great advantage over a 
traditional receiever (although I'd also be more than happy if I was 
just able to demodulate FM signals on this broad spectrum).



Thanks a lot in adavance guys, you're doing a great job here! :)
Pascal

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
