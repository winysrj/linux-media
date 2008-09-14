Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <c8b4dbe10809141322h6c3b8745o16ce6df016f516da@mail.gmail.com>
Date: Sun, 14 Sep 2008 21:22:58 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Frantisek Hanzlik" <franta@hanzlici.cz>
In-Reply-To: <48C6E413.5010401@hanzlici.cz>
MIME-Version: 1.0
Content-Disposition: inline
References: <48C6E413.5010401@hanzlici.cz>
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Kworld DVB-T 323U hybrid tuner (eb1a:e323) - no
	analog audio
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
List-ID: <video4linux-list@redhat.com>

Hi,

On Tue, Sep 9, 2008 at 10:01 PM, Frantisek Hanzlik <franta@hanzlici.cz> wrote:
> Hi,
> is possible audio on analog TV on Kworld VS-DVB-T 323UR hybrid tuner?
> After several days of playing with, I'm without luck..
>
> My piece of knowledge and proofs:
> - Stick use these chips: Empia EM2882, TI TVP5150AM1, Xceive XC3028ACQ,
> Empia EMP202, Intel WJCE6353 (I have some photos too)
>
> - I tested v4l-dvb-085961e0b1cc and v4l-dvb-6032ecd6ad7e sources from
> linuxtv.org v4l-dvb repo, on Fedora 9 x86 2.6.25.14, 2.6.26.3 and
> 2.6.26.3-PAE kernels.
>
> - Tuner firmware (xc3028-v27.fw) I extracted from in "extract_xc3028.pl"
> recommended http source:
> www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
> as Kworld's driver has different structure, there are not hcw85bda.sys,
> but some emBDA.sys, emAudio.sys and emOEM.sys files.
>
> - Our country use PAL-DK TV norm. On WinXP with Kworlds driver and their
> v3.50 HyperMedia Center apps all incl. audio works fine. On Linux I tried
> tvtime-1.0.2 and xawtv-3.95 (from F9 distro), on both video is OK, but
> without audio.

Firstly, if you're using these apps, you need to run a seperate
command at the same time for sound. If you have sox installed, usually
"sox -r 48000 -w -c 2 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp" will do
the trick, though you might want something cleaner that won't tie up
the soundcard for actual use.

> Sep  9 20:49:25 q kernel: Vendor/Product ID= eb1a:e323
> Sep  9 20:49:25 q kernel: AC97 audio (5 sample rates)
> Sep  9 20:49:25 q kernel: 500mA max power
> Sep  9 20:49:25 q kernel: Table at 0x04, strings=0x226a, 0x0000, 0x0000
> Sep  9 20:49:25 q kernel: em28xx #0:
> Sep  9 20:49:25 q kernel:
> Sep  9 20:49:25 q kernel: em28xx #0: The support for this board weren't valid yet.
> Sep  9 20:49:25 q kernel: em28xx #0: Please send a report of having this working
> Sep  9 20:49:25 q kernel: em28xx #0: not to V4L mailing list (and/or to other addresses)
> Sep  9 20:49:25 q kernel:
> Sep  9 20:49:25 q kernel: tvp5150.c: starting probe for adapter SMBus I801 adapter at 0400 (0x40004)
> Sep  9 20:49:25 q kernel: tvp5150.c: starting probe for adapter em28xx #0 (0x1001f)
> Sep  9 20:49:25 q kernel: tvp5150.c: detecting tvp5150 client on address 0xb8
> Sep  9 20:49:25 q kernel: tuner' 1-0061: I2C RECV = b2 00 4a fe b2 00 4a fe b2 00 4a fe b2 00 4a fe
> Sep  9 20:49:25 q kernel: tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
> Sep  9 20:49:25 q kernel: xc2028 1-0061: creating new instance
> Sep  9 20:49:25 q kernel: xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> Sep  9 20:49:25 q kernel: firmware: requesting xc3028-v27.fw
> Sep  9 20:49:25 q kernel: xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> Sep  9 20:49:25 q kernel: xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> Sep  9 20:49:26 q kernel: xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
> Sep  9 20:49:26 q kernel: xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
> Sep  9 20:49:26 q kernel: tvp5150 1-005c: tvp5150am1 detected.
> Sep  9 20:49:27 q kernel: em28xx #0 em28xx_set_alternate :minimum isoc packet size: 2888 (alt=6)
> Sep  9 20:49:27 q kernel: em28xx #0 em28xx_set_alternate :setting alternate 6 with wMaxPacketSize=2892
> Sep  9 20:49:27 q kernel: em28xx #0 em28xx_accumulator_set :em28xx Scale: (1,1)-(179,71)
> Sep  9 20:49:27 q kernel: em28xx #0 em28xx_capture_area_set :em28xx Area Set: (180,72)
> Sep  9 20:49:27 q kernel: em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> Sep  9 20:49:27 q kernel: em28xx #0: Found Kworld VS-DVB-T 323UR
> Sep  9 20:49:27 q kernel: usbcore: registered new interface driver em28xx
> Sep  9 20:49:27 q kernel: em28xx-audio.c: probing for em28x1 non standard usbaudio
> Sep  9 20:49:27 q kernel: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> Sep  9 20:49:27 q kernel: Em28xx: Initialized (Em28xx Audio Extension) extension
> Sep  9 20:49:27 q kernel: tvp5150 1-005c: tvp5150am1 detected.

Secondly, if you still don't get any sound you may need to make a
slight change to the source code, since this hardware hasn't been
tested with this driver. Open
linux/drivers/media/video/em28xx/em28xx-cards.c, find the line that
says "[EM2882_BOARD_KWORLD_VS_DVBT] = {", and after the ".tuner_type
= TUNER_XC2028," line following it, add a new line ".mts_firmware =
1,". Recompile and reload the driver and see if that helps. (Hopefully
it should.)

>
>
> - in Gnome volume control applet is only Intel HDA device (well, once I
> had there em28xx audiodevice, but I cannot tell what witcheries got it
> there... And can't repeat this :)
>
> Got someone this device working? I have some usbsnoop.log from Benoit's
> Windos USB sniffer too, but it's 480MB big and beyond my understanding...
>
> Thanks, Franta Hanzlik

(I'd have replied to this sooner, but I keep forgetting to check my
e-mail. Sorry.)

You'll probably have to make some other changes too if you want DVB-T
to work, but that might be slightly harder.

Hope this helps,
Aidan.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
