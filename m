Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAH4fAm031778
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 12:04:41 -0500
Received: from smtp.agh.edu.pl (smtp.agh.edu.pl [149.156.96.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mAAH4QmY000795
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 12:04:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.agh.edu.pl (Postfix) with ESMTP id E1F582F0088
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 18:04:25 +0100 (CET)
Received: from smtp.agh.edu.pl ([127.0.0.1])
	by localhost (smtp.agh.edu.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1QIWktsM7Ale for <video4linux-list@redhat.com>;
	Mon, 10 Nov 2008 18:04:25 +0100 (CET)
Received: from [192.168.0.2] (chello089077011158.chello.pl [89.77.11.158])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.agh.edu.pl (Postfix) with ESMTPSA id 6907B2F0087
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 18:04:21 +0100 (CET)
From: Szymon Zygmunt <zigi@student.agh.edu.pl>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Mon, 10 Nov 2008 18:04:11 +0100
Message-Id: <1226336651.15056.17.camel@zigi>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: AVerMedia TVPhone98/remote control
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

Hi.

I have the identical problem like here:
http://www.spinics.net/lists/vfl/msg15550.html. It's a very old card,
but maybe someone has this card and resolved this problem. My dmesg in
part about bttv shows:
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 2) at 0000:00:09.0, irq: 11, latency: 32, mmio:
0xe9002000
bttv0: detected: AVerMedia TVPhone98 [card=41], PCI subsystem ID is
1461:0001
bttv0: using: AVerMedia TVPhone 98 [card=41,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=008577c3 [init]
tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
bttv0: Avermedia eeprom[0x4821]: tuner=5 radio:yes remote control:yes
bttv0: tuner type=5
tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and
compatibles))
tuner 1-0061: type set to Philips PAL_BG (FI1
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 . ok
input: bttv IR (card=41)
as /devices/pci0000:00/0000:00:09.0/input/input7

Is there any chance to repair it? Maybe it just a small mistake as I
think, because remote controll works but inapropriate :).

Thanks in advance.

-- 
Szymon Zygmunt

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
