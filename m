Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o9EJ3vDL022306
	for <video4linux-list@redhat.com>; Thu, 14 Oct 2010 15:03:58 -0400
Received: from mail.gmx.net (mailout-de.gmx.net [213.165.64.23])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o9EJ3g2p026414
	for <video4linux-list@redhat.com>; Thu, 14 Oct 2010 15:03:42 -0400
From: Lukas Ruetz <lukas.ruetz@gmx.at>
To: video4linux-list@redhat.com
Subject: bttv/bt878 unable to get fluent playback
Date: Thu, 14 Oct 2010 21:03:38 +0200
MIME-Version: 1.0
Message-Id: <201010142103.38519.lukas.ruetz@gmx.at>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello everyone,

I have a Haupauge Impact capture card (bt878) and the problem that the
playback of the captured PAL-video (no audio) isn't fluent. The video jumps
every few seconds as if there were frames dropped. It occures (or is only
visible) if there is bigger movement in the video. This behaviour is nearly
the same with mplayer, gstreamer and vlc depending on the output type.

First I thought this is maybe a problem of the prop. nvidia driver but there's
no difference to the nv driver.

I've tried the kernels 2.6.28, 2.6.32, 2.6.35 (ubuntu 9.04, 10.04, 10.10)
but it's always the same.

The card itself captures YUV422 - in my tests the players converted to
I420 or YV12

I use a DVD-player as source to ensure that the video is correct.

The PC (Quad-Core, 2GB RAM, Nvidia GF 7300) should not have a problem with
that.

root@test:~# uname -a
Linux allegra 2.6.35-22-generic-pae #34-Ubuntu SMP Sun Oct 10 11:03:48 UTC 
2010 i686 GNU/Linux

root@test:~# dmesg |grep -E 'bttv|bt87'
[   11.291571] bttv: driver version 0.9.18 loaded
[   11.291574] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   11.291622] bttv: Bt8xx card found (0).
[   11.291634] bttv 0000:37:09.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   11.291642] bttv0: Bt878 (rev 17) at 0000:37:09.0, irq: 21, latency: 32, 
mmio: 0xf0000000
[   11.291654] bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 
0070:13eb
[   11.291656] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
[   11.291678] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[   11.294156] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
[   11.326538] tveeprom 0-0050: Hauppauge model 64405, rev C1  , serial# 
9948853
[   11.326541] tveeprom 0-0050: tuner model is Unspecified (idx 2, type 4)
[   11.326542] tveeprom 0-0050: TV standards UNKNOWN (eeprom 0x01)
[   11.326544] tveeprom 0-0050: audio processor is None (idx 0)
[   11.326546] tveeprom 0-0050: decoder processor is BT878 (idx 14)
[   11.326547] tveeprom 0-0050: has no radio
[   11.326548] bttv0: Hauppauge eeprom indicates model#64405
[   11.326550] bttv0: tuner absent
[   11.327184] bttv0: registered device video0
[   11.327253] bttv0: registered device vbi0
[   11.327274] bttv0: PLL: 28636363 => 35468950 .
[   11.360144] Bt87x 0000:37:09.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   11.360219] bt87x0: Using board 1, analog, digital (rate 32000 Hz)


### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "BT878 video (Hauppauge (bt878))"
        type                    : 0x2d [CAPTURE,TELETEXT,OVERLAY,CLIPPING]
        channels                : 4
        audios                  : 0
        maxwidth                : 924
        maxheight               : 576
        minwidth                : 48
        minheight               : 32

Any idea what can cause this problem?

thanks,
Lukas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
