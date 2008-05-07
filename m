Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47GkuaB017830
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 12:46:56 -0400
Received: from blu139-omc2-s16.blu139.hotmail.com
	(blu139-omc2-s16.blu139.hotmail.com [65.55.175.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47GkfaS019922
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 12:46:42 -0400
Message-ID: <BLU129-W414F8B338C23B4DDF7DDF8BED10@phx.gbl>
From: lazaro souza <lazarojcs@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Wed, 7 May 2008 16:46:36 +0000
In-Reply-To: <20080507160012.49BAD618E6A@hormel.redhat.com>
References: <20080507160012.49BAD618E6A@hormel.redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: ENCORE ENL TV-FM-2
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


	
esteemed see if I can help, what happens is that I do not control the work of the plate ENCORE ENL TV-FM-2 (Pro TV tuner). this information is of the system without any changes, below postarei the information with the card and tuner that works with the video and radio sound perfectly.

lspci | grep Brooktree
04:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
04:04.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)

lsmod | grep BT
bt878 11832 0
bttv 177012 1 bt878
video_buf 26244 1 bttv
ir_common 35460 1 bttv
compat_ioctl32 2304 1 bttv
i2c_algo_bit 7428 1 bttv
btcx_risc 5896 1 bttv
tveeprom 16784 1 bttv
videodev 29312 1 bttv
v4l2_common 18432 2 bttv, videodev
v4l1_compat 15364 2 bttv, videodev
i2c_core 26112 4 bttv, i2c_algo_bit, tveeprom, i2c_viapro


dmesg | grep BT
[53.292453] bttv: driver loaded version 0.9.17
[53.292459] bttv: using 8 buffers with 2080k (520 pages) each for capture
[54.861778] bttv: Bt8xx card found (0).
[54.861818] bttv0: Bt878 (rev 17) at 0000:04:04.0, irq: 22, latency: 32, mmio: 0xdf9ff000
[54.861833] bttv0: subsystem: 1000:1801 (UNKNOWN)
[54.861842] bttv0: using: UNKNOWN *** / GENERIC *** [card = 0, autodetected]
[54.861869] bttv0: gpio: en = 00000000, out = 00000000 = 00f9807f in [init]
[54.890829] bttv0: using tuner =- 1
[54.890835] bttv0: i2c: checking for MSP34xx @ 0x80 ... Not Found
[54.891510] bttv0: i2c: checking for TDA9875 @ 0xb0 ... Not Found
[54.892590] bttv0: i2c: checking for TDA7432 @ 0x8a ... Not Found
[54.893062] bttv0: i2c: checking for TDA9887 @ 0x86 ... Not Found
[54.893582] bttv0: registered device video0
[54.893614] bttv0: registered device vbi0
[55.182210] bt878: AUDIO driver version 0.0.0 loaded
[55.182263] bt878: Bt878 AUDIO function found (0).
[55.182297] bt878_probe: card id = [0x18011000], Unknown card.
[55.182310] bt878: probe of 0000:04:04.1 failed with error -22

dmesg | grep bt this is with the card = 46 and tuner that works = 38

[6558.741207] bttv: driver loaded version 0.9.17
[6558.741215] bttv: using 8 buffers with 2080k (520 pages) each for capture
[6558.741701] bttv: Bt8xx card found (0).
[6558.741720] bttv0: Bt878 (rev 17) at 0000:04:04.0, irq: 22, latency: 32, mmio: 0xdf9ff000
[6558.742090] bttv0: subsystem: 1000:1801 (UNKNOWN)
[6558.742102] bttv0: using: Zoltrix Genie TV / FM [card = 46, insmod option]
[6558.742133] bttv0: gpio: en = 00000000, out = 00000000 = 00f9807f in [init]
[6558.743984] bttv0: using tuner = 38
[6558.744084] bttv0: i2c: checking for TDA9875 @ 0xb0 ... Not Found
[6558.744807] bttv0: i2c: checking for TDA7432 @ 0x8a ... Not Found
[6558.746280] bttv0: i2c: checking for TDA9887 @ 0x86 ... Not Found
[6558.783580] tuner 1-0060: chip found @ 0xc0 (bt878 # 0 [sw])
[6558.791391] bttv0: registered device video0
[6558.791540] bttv0: registered device vbi0
[6558.791675] bttv0: registered device radio0
[6558.791824] bttv0: PLL: 28636363 => 35468950 .. ok
[6559.875241] bttv0: LDP can sleep, using XTAL (28636363).
[6560.259473] bttv0: OCERR @ 1fd9e014, bits: HSYNC OFLOW FBUS OCERR *
[6560.492707] bttv0: OCERR @ 1fd9e014, bits: HSYNC OFLOW FBUS OCERR *


I look forward to any information in

_________________________________________________________________
Instale a Barra de Ferramentas com Desktop Search e ganhe EMOTICONS para o Messenger! É GRÁTIS!
http://www.msn.com.br/emoticonpack

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
