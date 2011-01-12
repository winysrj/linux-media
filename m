Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1ALUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jan 2011 15:24:03 -0500
Message-ID: <4D2E0DD8.4010305@redhat.com>
Date: Wed, 12 Jan 2011 18:23:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Andrzej Pietrasiewicz/Poland R&D Center-Linux/./????'"
	<andrzej.p@samsung.com>, pawel@osciak.com,
	linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] Videbuf2 framework, NOON010PC30 sensor
 driver and s5p-fimc updates
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com> <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
In-Reply-To: <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-01-2011 08:25, Marek Szyprowski escreveu:
> Hello Mauro,
> 
> I've rebased our fimc and saa patches onto http://linuxtv.org/git/mchehab/experimental.git
> vb2_test branch.
> 
> The last 2 patches are for SAA7134 driver and are only to show that videobuf2-dma-sg works
> correctly. 

On my first test with saa7134, it hanged. It seems that the code reached a dead lock.

On my test environment, I'm using a remote machine, without monitor. My test is using
qv4l2 via a remote X server. Using a remote X server is an interesting test, as it will
likely loose some frames, increasing the probability of races and dead locks.

That's what happened: 

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.16 loaded
saa7130/34: w/o radio and vbi
saa7133[0]: found at 0000:37:09.0, rev: 209, irq: 21, latency: 32, mmio: 0xfb000
saa7133[0]: subsystem: 17de:b136, board: Kworld PCI SBTVD/ISDB-T Full-Seg Hybri]
saa7133[0]: board init: gpio is 4000
hwinit1
IRQ 21/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/irq: no (more) work
saa7133[0]: i2c eeprom 00: de 17 36 b1 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 ff 01 03 08 ff 01 90 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 1c 00 c0 ff 1c 01 00 ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Chip ID is not zero. It is not a TEA5767
tuner 2-0060: chip found @ 0xc0 (saa7133[0])
tda18271 2-0060: creating new instance
TDA18271HD/C2 detected @ 2-0060
hwinit2
tda18271: performing RF tracking filter calibration
tda18271: RF tracking filter calibration complete
DCSDT: pll: not locked, sync: no, norm: (no signal)
saa7133[0]: registered device video0 [v4l2]
saa7134_dvb: disagrees about version of symbol videobuf_dvb_alloc_frontend
saa7134_dvb: Unknown symbol videobuf_dvb_alloc_frontend
saa7134_dvb: Unknown symbol saa7134_ts_register
saa7134_dvb: disagrees about version of symbol videobuf_dvb_get_frontend
saa7134_dvb: Unknown symbol videobuf_dvb_get_frontend
saa7134_dvb: disagrees about version of symbol videobuf_queue_sg_init
saa7134_dvb: Unknown symbol videobuf_queue_sg_init
saa7134_dvb: disagrees about version of symbol saa7134_set_gpio
saa7134_dvb: Unknown symbol saa7134_set_gpio
saa7134_dvb: Unknown symbol saa7134_ts_qops
saa7134_dvb: Unknown symbol saa7134_ts_unregister
saa7134_alsa: Unknown symbol saa7134_tvaudio_setmute
saa7134_alsa: Unknown symbol saa_dsp_writel
saa7134_alsa: disagrees about version of symbol saa7134_boards
saa7134_alsa: Unknown symbol saa7134_boards
saa7134_alsa: disagrees about version of symbol saa7134_dmasound_init
saa7134_alsa: Unknown symbol saa7134_dmasound_init
saa7134_alsa: disagrees about version of symbol saa7134_dmasound_exit
saa7134_alsa: Unknown symbol saa7134_dmasound_exit
saa7134_alsa: disagrees about version of symbol saa7134_set_dmabits
saa7134_alsa: Unknown symbol saa7134_set_dmabits
saa7134_reqbufs: ffff880051ecd528 ffff880051d2fd48
queue_setup
vb2_dma_sg_alloc: Allocated buffer of 304 pages
saa7134_querybuf: ffff880051ecd528 ffff880051d2fd48
saa7134_reqbufs: ffff880051ecd528 ffff880051d2fd48
vb2_dma_sg_put: Freeing buffer of 304 pages
queue_setup
saa7134_reqbufs: ffff880051ecd528 ffff880051d2fd48
queue_setup
vb2_dma_sg_alloc: Allocated buffer of 304 pages
vb2_dma_sg_alloc: Allocated buffer of 304 pages
vb2_dma_sg_alloc: Allocated buffer of 304 pages
saa7134_querybuf: ffff880051ecd528 ffff880051d2fd48
vb2_common_vm_open: ffff880067d1b178, refcount: 1, vma: 7fa8e0d67000-7fa8e0e9700
saa7134_querybuf: ffff880051ecd528 ffff880051d2fd48
vb2_common_vm_open: ffff8800a21cb278, refcount: 1, vma: 7fa8e0c37000-7fa8e0d6700
saa7134_querybuf: ffff880051ecd528 ffff880051d2fd48
vb2_common_vm_open: ffff880067c84ef8, refcount: 1, vma: 7fa8e0b07000-7fa8e0c3700
saa7134_qbuf: ffff880051ecd528 ffff880051d2fd48
buffer_prepare: sglist:ffffc90005139000 num_pages:304
saa7134_qbuf: ffff880051ecd528 ffff880051d2fd48
buffer_prepare: sglist:ffffc900051ab000 num_pages:304
saa7134_qbuf: ffff880051ecd528 ffff880051d2fd48
buffer_prepare: sglist:ffffc900051bf000 num_pages:304
saa7134_streamon: ffff880051ecd528
buffer_queue
buffer_queue ffff880067dd9800
buffer_activate buf=ffff880067dd9800
saa7134_set_dmabits
dmabits: task=0x01 ctrl=0x01 irq=0x3 split=yes
buffer_queue
buffer_queue ffff880051ecd000
buffer_queue
buffer_queue ffff880088e69800
video_poll: ffff880051ecd528
video_poll: ffff880051ecd528
video_poll: ffff880051ecd528
video_poll: ffff880051ecd528
saa7133[0]/irq[0,4317235087]: r=0x1 s=0x90 DONE_RA0 | RA0=video,a,odd,0
buffer_finish ffff880067dd9800
bu

(yes, the last msg become incomplete on my serial console)

I've rebooted and did more tests, with mmap and qv4l2. On all cases, the first time,
the stream worked, but after a stream off/stream on, it didn't start. read() didn't
work.

After that, I did a test with v4l2grab. It also hanged. The last messages were:

saa7134_set_dmabits
dmabits: task=0x01 ctrl=0x01 irq=0x3 split=yes
buffer_queue
buffer_queue ffff880110a82800
video_poll: ffff88010feac528
saa7133[0]/irq[0,4295231408]: r=0x1 s=0x90 DONE_RA0 | RA0=video,a,odd,0
buffer_finish ffff88010fe33000
buffer_next ffff880110a82800 [prev=ffff88

So, it seems that there's something wrong on it.

