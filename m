Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QBKFo1032174
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 06:20:15 -0500
Received: from mail.mediaxim.be (dns.adview.be [193.74.142.132])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QBJgdj006090
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 06:19:42 -0500
Received: from localhost (mail.mediaxim.be [127.0.0.1])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id 1C67434059
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 12:19:41 +0100 (CET)
Received: from [10.32.13.124] (unknown [10.32.13.124])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id 8DC5434051
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 12:19:39 +0100 (CET)
Message-ID: <47C3F5CB.1010707@mediaxim.be>
Date: Tue, 26 Feb 2008 12:19:39 +0100
From: Michel Bardiaux <mbardiaux@mediaxim.be>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Grabbing 4:3 and 16:9
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

Our current systems use Hauppauge WinTV, dmesg as follows:

bttv1: Bt878 (rev 17) at 01:08.0, irq: 17, latency: 64, mmio: 0xf8001000
bttv1: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv1: using: Hauppauge (bt878) [card=10,autodetected]
bttv1: Hauppauge/Voodoo msp34xx: reset line init [5]
tuner: chip found @ 0xc2
i2c-core.o: client [(tuner unset)] registered to adapter [bt848 #1](pos. 0).
i2c-core.o: adapter bt848 #1 registered as adapter 1.
bttv1: Hauppauge eeprom: model=44806, tuner=Temic 4046FM5 (22), radio=no
bttv1: using tuner=22
tuner: type set to 22 (Temic PAL/SECAM multi (4046 FM5))
bttv1: i2c: checking for MSP34xx @ 0x80... not found
bttv1: i2c: checking for TDA9875 @ 0xb0... not found
bttv1: i2c: checking for TDA7432 @ 0x8a... not found
bttv1: PLL: 28636363 => 35468950 .. ok
bttv1: registered device video1
bttv1: registered device vbi1

Here in Belgium the broadcasts is sometimes 4:3, sometimes 16:9. 
Currently, the card goes automatically in letterbox mode when it 
receives 16:9, and our software captures the 4:3 frames at size 704x576. 
What I would like to do is to capture the 16:9 broadcast without 
letterboxing (and the 4:3 without horizontal padding!) simply by 
changing the pixel aspect ratio stated in our MPEG files. And since we 
do 24/7 captures, this has to be done on-the-fly, no reinitialization of 
the cards or the software allowed. Which leads to 2 questions:

1. How do I sense from the software that the mode is currently 16:9 or 4:3?

2. How do I setup the bttv so that it does variable anamorphosis instead 
of letterboxing? If that is at all possible of course...

I *am* googling for all that, but "16/9" is one of those queries on 
which search engines are really really bad, like "date" or "thread" :-(

TIA,
-- 
Michel Bardiaux
R&D Director
T +32 [0] 2 790 29 41
F +32 [0] 2 790 29 02
E mailto:mbardiaux@mediaxim.be

Mediaxim NV/SA
Vorstlaan 191 Boulevard du Souverain
Brussel 1160 Bruxelles
http://www.mediaxim.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
