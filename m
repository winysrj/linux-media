Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nADNNRTO031510
	for <video4linux-list@redhat.com>; Fri, 13 Nov 2009 18:23:27 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nADNNQ2O019559
	for <video4linux-list@redhat.com>; Fri, 13 Nov 2009 18:23:26 -0500
Message-Id: <200911132323.nADNNQ2O019559@mx1.redhat.com>
Date: Sat, 14 Nov 2009 00:23:24 +0100
From: Stefan Tauner <stefan.tauner@gmx.at>
To: video4linux-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: still missing audio device in bttv?
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

hi!

there was a problem with bttv introduced in 2.6.30
http://osdir.com/ml/linux-media/2009-06/msg00495.html

afaik the patch for this was included in 2.6.31:
http://mirror.celinuxforum.org/gitstat/commit-detail.php?commit=2c90577841a76f1935ff3437ffb552b41f5c28fa

i have a hauppauge tv card (model#38104, 109e:036e, 109e:0878) that
worked with kernels prior to 2.6.30, but stopped to create an audio
device afterwards. i tried various kernels (vanilla 2.6.30,
2.6.31, 2.6.32-rc5, ubuntu's 2.6.31 kernel from their 9.10 release).
all of them seem to have the same problem, that was diagnosed via
"bttv0: audio absent, no audio device found!"

could it be, that the patch mentioned above did not fix all cards?
i did not try to work around this with a loopback cable, because alsa
inputs were(/are?) broken for my mainboard too and i think it would be
an inelegant solution anyway :)

dmesg lines from ubuntu's 2.6.31-15-generic:
[   42.137099] bttv: driver version 0.9.18 loaded
[   42.137101] bttv: using 8 buffers with 2080k (520 pages) each forcapture
[   42.138569] bttv: Bt8xx card found (0).
[   42.138582] bttv 0000:01:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   42.138591] bttv0: Bt878 (rev 17) at 0000:01:00.0, irq: 21, latency: 32, mmio: 0xbe000000
[   42.138623] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
[   42.138625] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   42.138627] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   42.138650] bttv0: gpio: en=00000000, out=00000000 in=00fffffb [init]
[   42.141155] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   42.177379] tveeprom 6-0050: Hauppauge model 38104, rev B429, serial# 5055952
[   42.177381] tveeprom 6-0050: tuner model is Temic 4006FH5 (idx 29, type 14)
[   42.177383] tveeprom 6-0050: TV standards PAL(B/G) (eeprom 0x04)
[   42.177385] tveeprom 6-0050: audio processor is None (idx 0)
[   42.177387] tveeprom 6-0050: has no radio
[   42.177388] bttv0: Hauppauge eeprom indicates model#38104
[   42.177390] bttv0: tuner type=14
[   43.239183] bttv0: audio absent, no audio device found!
[   43.351690]   alloc irq_desc for 22 on node 0
[   43.351693]   alloc kstat_irqs on node 0
...
[   43.416300] tuner 6-0061: chip found @ 0xc2 (bt878 #0 [sw])
...
[   44.141866] tuner-simple 6-0061: creating new instance
[   44.141869] tuner-simple 6-0061: type set to 14 (Temic PAL_BG
(4006FH5)) [   44.142579] bttv0: registered device video0
[   44.142596] bttv0: registered device vbi0
[   44.142622] bttv0: PLL: 28636363 => 35468950 .. ok
[   44.191396] Bt87x 0000:01:00.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   44.191521] bt87x0: Using board 1, analog, digital (rate 32000 Hz)

any hints appreciated!
-- 
mit freundlichen Grüßen, Stefan Tauner

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
