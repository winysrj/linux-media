Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jqvyf-0007Eu-A8
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 21:59:04 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Stone <syphyr@gmail.com>
In-Reply-To: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
References: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
Date: Tue, 29 Apr 2008 21:58:09 +0200
Message-Id: <1209499089.3456.34.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined
	with	kernel 2.6.23.17
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

Hi,

Am Dienstag, den 29.04.2008, 07:01 +0200 schrieb Stone:
> I tried to build current v4l-dvb against kernel 2.6.23.17 and now I
> have the following undefined errors.  I assume there is a problem with
> the build script because some of the drivers were moved to a new
> location.  Does anyone have a patch?  I'm not sure if this is another
> problem, but I also noticed that 7 additional modules are built since
> revision 7673 and I did not select any new drivers in the menuconfig.
> 
> Groeten.

due of current changes, but also since long before, the backward compat
of the build system is broken. Means if you use xconfig/menuconfig you
can't trust that all dependencies are resolved automatically.

Specifically at the moment saa7146 related build is broken.
It should select videobuf-dma-sg but doesn't yet.

The worst I did built so far was a 2.6.20 fc5, still doable if you
collect the modules of several different build attempts, since make all
does not enable everything and I had also to disable one frontend
manually the old compiler there did not like.

However, at least 2.6.23/24/25 should build without visible unresolved
dependencies if you "make distclean" and just "make". (all)

The only warning here is: 
CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.o
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c: In function 'attach_inform':
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c:105: warning: unused variable 'tun_setup'

gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

> Kernel build directory is /lib/modules/2.6.23.17.20080229.1/build
> make -C /lib/modules/2.6.23.17.20080229.1/build
> SUBDIRS=/var/local/linuxtv.cvs/v4l-dvb/v4l  modules
> make[2]: Entering directory `/var/local/kernel-src/linux-2.6.23.17'
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvbdev.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dmxdev.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_demux.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_filter.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ca_en50221.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_frontend.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_net.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ringbuffer.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_math.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_hw.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_v4l.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_av.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ca.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ipack.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ir.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_fops.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_video.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_hlp.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vbi.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-core.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.o
>   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.o
>   Building modules, stage 2.
>   MODPOST 27 modules
> WARNING:
> "videobuf_to_dma" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_mmap_mapper" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_mmap_setup" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_queue_cancel" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_streamon" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_iolock" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "saa7146_pgtable_free" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "saa7146_pgtable_alloc" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_read_one" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_qbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "saa7146_pgtable_build_single" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_querybuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_read_stream" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_dma_unmap" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_queue_sg_init" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_stop" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "saa7146_devices" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "saa7146_debug" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_dqbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_waiton" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_reqbufs" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "videobuf_dma_free" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> WARNING:
> "saa7146_devices_lock" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_poll_stream" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "videobuf_streamoff" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> WARNING:
> "saa7146_vfree_destroy_pgtable" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> WARNING:
> "saa7146_vmalloc_build_pgtable" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> WARNING:
> "saa7146_setgpio" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko]
> undefined!
> WARNING:
> "saa7146_register_extension" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> WARNING:
> "saa7146_i2c_adapter_prepare" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> WARNING:
> "saa7146_wait_for_debi_done" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> WARNING:
> "saa7146_unregister_extension" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.ko
>   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.mod.o
>   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.ko
> make[2]: Leaving directory `/var/local/kernel-src/linux-2.6.23.17'
> ./scripts/rmmod.pl check
> found 27 modules

If you enable for example saa7134 support under video you should get the
missing videobuf* modules too until the build dependencies are working
for saa7146 again?

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
