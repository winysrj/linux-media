Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33KEfv0002021
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 16:14:41 -0400
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33KERNc026561
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 16:14:27 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: cherOKe@gmail.com
In-Reply-To: <1207182705.31477.17.camel@fugitif>
References: <1207182705.31477.17.camel@fugitif>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 22:14:08 +0200
Message-Id: <1207253648.15452.62.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] i can't make my Lifeview trio CARDBUS works.
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

Hi,

Am Donnerstag, den 03.04.2008, 02:31 +0200 schrieb cherOKe:
> Hi, it's my first timer here, i'm cheroke from spain. 
> 
> I,ve trying to istall y lifeview trio several times with no good
> results, the only that I've made works it's analog tv without sound :(.

for devices without analog sound out you need a helper application like
"sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -w -r 48000 /dev/dsp"
to get the sound from here assumed saa7134-alsa device /dev/dsp1 to your sound card.

Only mplayer and mencoder support this directly from the saa7134-alsa dsp with immediatemode=0.

Sample commands could look like.

/usr/local/bin/mplayer -v tv:// -vf pp=lb -tv driver=v4l2:norm=PAL:input=0:alsa:adevice=hw.1,0:forceaudio:immediatemode=0:audiorate=32000:amode=1:width=640:height=480:outfmt=yuy2:device=/dev/video0:chanlist=europe-west:channel=E9

/usr/local/bin/mencoder -v tv:// -tv driver=v4l2:device=/dev/video0:width=640:height=480:chanlist=europe-west:alsa:adevice=hw.1,0:audiorate=32000:amode=1:forceaudio:volume=95:immediatemode=0:norm=PAL -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=3600 -vf pp=lb -oac mp3lame -lameopts cbr:br=128:mode=0 -o mytest.avi

> the last thing that i've made eforo write this was follow the
> instruccions that I found here:
> 
> http://www.selenic.com/mercurial/wiki/index.cgi/UnixInstall#head-a2d5313c6a815573ef51192eea7fa0deed53cca3
> 
> after that i made this :
> 
> http://www.linuxtv.org/repo/

OK, I assume you have a recent v4l-dvb master copy now.

> i've UNKNOWN/GENERIC in the $dmesg exit and i tryed to unload de modules
> and reload it, but when i made:
> $sudo rmmod saa7134_alsa saa7134-dvb saa7134
> the exit was.
> ERROR: Module saa7134_alsa does not exist in /proc/modules
> ERROR: Module saa7134_dvb does not exist in /proc/modules
> 
> then i tryed to load de modules with:
> 
> $ sudo modprobe saa7134 card=84
> $ sudo modprobe saa7134_alsa
> $ sudo modprobe saa7134-dvb
> 
> but in the first sentence....
> 
> ERROR: Module saa7134_alsa does not exist in /proc/modules
> ERROR: Module saa7134_dvb does not exist in /proc/modules
> ERROR: Module saa7134 does not exist in /proc/modules
> cheroke@fugitif:~$ sudo modprobe saa7134 card=84
> WARNING: Error inserting videobuf_core (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
> WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting videobuf_core (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
> WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting saa7134 (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/saa7134/saa7134.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error running install command for saa7134
> 
> this is my $ dmesg |grep saa exit now: 
> [   42.744505] saa7130/34: v4l2 driver version 0.2.14 loaded
> [   42.744616] saa7133[0]: found at 0000:09:00.0, rev: 209, irq: 18,
> latency: 0, mmio: 0x90000000
> [   42.744637] saa7133[0]: subsystem: 5168:0520, board: UNKNOWN/GENERIC
........................................^^^^^^^^^
> [card=0,autodetected]
> [   42.744650] saa7133[0]: board init: gpio is 210000
.................................................^^^^^^
> [   42.787696] saa7133[0]: i2c eeprom 00: 68 51 20 05 54 20 1c 00 43 43
> a9 1c 55 d2 b2 92
> [   42.787714] saa7133[0]: i2c eeprom 10: 00 00 60 0a ff 20 ff ff ff ff
> ff ff ff ff ff ff
> [   42.787730] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff
> 01 02 ff ff ff ff
> [   42.787746] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   42.787762] saa7133[0]: i2c eeprom 40: ff 00 10 c0 96 12 08 00 c2 96
> c6 1c 16 3a 15 ff
> [   42.787778] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   42.787794] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   42.787809] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [   42.788327] saa7133[0]: registered device video0 [v4l2]
> [   42.788357] saa7133[0]: registered device vbi0
> [25942.933953] saa7134_dvb: Unknown symbol videobuf_dvb_unregister
> [25942.934022] saa7134_dvb: Unknown symbol videobuf_dvb_register
> [34073.218239] saa7134: disagrees about version of symbol
> videobuf_streamoff
> [34073.218245] saa7134: Unknown symbol videobuf_streamoff
> [34073.218377] saa7134: disagrees about version of symbol
> videobuf_poll_stream
> videobuf_mmap_free .......
> ...................  ---- and much more ---
> 
> Could someone help me or orientate a little?

On older kernels, like 2.6.20, a simple "make" does not make all it
seems, also "make allmodconfig" doesn't work. You get all bttv, cx88,
saa7134 related and others not built. This might be the case here.

This results in a mixture of incompatible old and new modules after
"make install".

Try "make distclean" and then "make xconfig" and enable all missing
modules, also go through dvb and check that the related frontends
tda10045/46 and tda10086 and the isl6421 are ready, see it with
customize dvb froontends. In short enable all you can and if possible
always as modules. Then "make".

If installing first time on an older kernel, try to make sure you have 
really all older *.ko removed from /lib/modules/uname -r/kernel/drivers/media

With "make rmmod" you might not be able to unload all modules and might
try to get the rest with "modprobe -vr" or must reboot later.

Do "make rminstall", this should remove all *.ko from the media folder,
but check with "ls -R |grep .ko" there and remove/delete any remaining
module. Do "make install". Reboot if there are any related modules still
loaded.

If you want to test DVB-S, it is best to put
"options saa7134-dvb use_frontend=1" in /etc/modprobe.conf or what your
distribution uses else for module options and "depmod -a".

Also put "options saa7134 card=84 latency=64" something there to avoid
card=0 on boot, but from now on everything else should work too.

If it should have a remote, support is not in tree, if it has radio
support, please test. Please report, that we might be able to add it to
auto detection. We have one previous report for now and that cardbus
version was functional so far.

Happy testing,

Hermann












--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
