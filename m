Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cheroke@gmail.com>) id 1JhDN7-0000kx-7y
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 02:32:11 +0200
Received: by fg-out-1718.google.com with SMTP id 22so2509771fge.25
	for <linux-dvb@linuxtv.org>; Wed, 02 Apr 2008 17:32:01 -0700 (PDT)
To: linux-dvb@linuxtv.org
Date: Thu, 03 Apr 2008 02:31:45 +0200
Message-Id: <1207182705.31477.17.camel@fugitif>
Mime-Version: 1.0
From: cherOKe <cheroke@gmail.com>
Subject: [linux-dvb] i can't make my Lifeview trio CARDBUS works.
Reply-To: cherOKe@gmail.com
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

Hi, it's my first timer here, i'm cheroke from spain. 

I,ve trying to istall y lifeview trio several times with no good
results, the only that I've made works it's analog tv without sound :(.

the last thing that i've made eforo write this was follow the
instruccions that I found here:

http://www.selenic.com/mercurial/wiki/index.cgi/UnixInstall#head-a2d5313c6a815573ef51192eea7fa0deed53cca3

after that i made this :

http://www.linuxtv.org/repo/

i've UNKNOWN/GENERIC in the $dmesg exit and i tryed to unload de modules
and reload it, but when i made:
$sudo rmmod saa7134_alsa saa7134-dvb saa7134
the exit was.
ERROR: Module saa7134_alsa does not exist in /proc/modules
ERROR: Module saa7134_dvb does not exist in /proc/modules

then i tryed to load de modules with:

$ sudo modprobe saa7134 card=84
$ sudo modprobe saa7134_alsa
$ sudo modprobe saa7134-dvb

but in the first sentence....

ERROR: Module saa7134_alsa does not exist in /proc/modules
ERROR: Module saa7134_dvb does not exist in /proc/modules
ERROR: Module saa7134 does not exist in /proc/modules
cheroke@fugitif:~$ sudo modprobe saa7134 card=84
WARNING: Error inserting videobuf_core (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videobuf_core (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-core.ko): Invalid module format
WARNING: Error inserting videobuf_dma_sg (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/videobuf-dma-sg.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting saa7134 (/lib/modules/2.6.24-12-generic/kernel/drivers/media/video/saa7134/saa7134.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error running install command for saa7134

this is my $ dmesg |grep saa exit now: 
[   42.744505] saa7130/34: v4l2 driver version 0.2.14 loaded
[   42.744616] saa7133[0]: found at 0000:09:00.0, rev: 209, irq: 18,
latency: 0, mmio: 0x90000000
[   42.744637] saa7133[0]: subsystem: 5168:0520, board: UNKNOWN/GENERIC
[card=0,autodetected]
[   42.744650] saa7133[0]: board init: gpio is 210000
[   42.787696] saa7133[0]: i2c eeprom 00: 68 51 20 05 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[   42.787714] saa7133[0]: i2c eeprom 10: 00 00 60 0a ff 20 ff ff ff ff
ff ff ff ff ff ff
[   42.787730] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff
01 02 ff ff ff ff
[   42.787746] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   42.787762] saa7133[0]: i2c eeprom 40: ff 00 10 c0 96 12 08 00 c2 96
c6 1c 16 3a 15 ff
[   42.787778] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   42.787794] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   42.787809] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   42.788327] saa7133[0]: registered device video0 [v4l2]
[   42.788357] saa7133[0]: registered device vbi0
[25942.933953] saa7134_dvb: Unknown symbol videobuf_dvb_unregister
[25942.934022] saa7134_dvb: Unknown symbol videobuf_dvb_register
[34073.218239] saa7134: disagrees about version of symbol
videobuf_streamoff
[34073.218245] saa7134: Unknown symbol videobuf_streamoff
[34073.218377] saa7134: disagrees about version of symbol
videobuf_poll_stream
videobuf_mmap_free .......
...................  ---- and much more ---

Could someone help me or orientate a little?

Sorry for the big test, thanks: cherOKe




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
