Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <syphyr@gmail.com>) id 1Jqhxq-00074t-Ud
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 07:01:18 +0200
Received: by nf-out-0910.google.com with SMTP id d21so1956709nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 28 Apr 2008 22:01:11 -0700 (PDT)
Message-ID: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
Date: Tue, 29 Apr 2008 07:01:10 +0200
From: Stone <syphyr@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined with kernel
	2.6.23.17
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0705445724=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0705445724==
Content-Type: multipart/alternative;
	boundary="----=_Part_9224_18230389.1209445270522"

------=_Part_9224_18230389.1209445270522
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I tried to build current v4l-dvb against kernel 2.6.23.17 and now I have the
following undefined errors.  I assume there is a problem with the build
script because some of the drivers were moved to a new location.  Does
anyone have a patch?  I'm not sure if this is another problem, but I also
noticed that 7 additional modules are built since revision 7673 and I did
not select any new drivers in the menuconfig.

Groeten.

Kernel build directory is /lib/modules/2.6.23.17.20080229.1/build
make -C /lib/modules/2.6.23.17.20080229.1/build
SUBDIRS=/var/local/linuxtv.cvs/v4l-dvb/v4l  modules
make[2]: Entering directory `/var/local/kernel-src/linux-2.6.23.17'
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvbdev.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dmxdev.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_demux.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_filter.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ca_en50221.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_frontend.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_net.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ringbuffer.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_math.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_hw.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_v4l.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_av.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ca.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ipack.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ir.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_fops.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_video.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_hlp.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vbi.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-core.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.o
  CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.o
  Building modules, stage 2.
  MODPOST 27 modules
WARNING: "videobuf_to_dma"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_mmap_mapper"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_mmap_setup"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_queue_cancel"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_streamon"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_iolock"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "saa7146_pgtable_free"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "saa7146_pgtable_alloc"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_read_one"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_qbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
undefined!
WARNING: "saa7146_pgtable_build_single"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_querybuf"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_read_stream"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_dma_unmap"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_queue_sg_init"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_stop" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
undefined!
WARNING: "saa7146_devices"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "saa7146_debug" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
undefined!
WARNING: "videobuf_dqbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
undefined!
WARNING: "videobuf_waiton"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_reqbufs"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_dma_free"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "saa7146_devices_lock"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_poll_stream"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "videobuf_streamoff"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
WARNING: "saa7146_vfree_destroy_pgtable"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
WARNING: "saa7146_vmalloc_build_pgtable"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
WARNING: "saa7146_setgpio" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko]
undefined!
WARNING: "saa7146_register_extension"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
WARNING: "saa7146_i2c_adapter_prepare"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
WARNING: "saa7146_wait_for_debi_done"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
WARNING: "saa7146_unregister_extension"
[/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.ko
  CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.mod.o
  LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.ko
make[2]: Leaving directory `/var/local/kernel-src/linux-2.6.23.17'
./scripts/rmmod.pl check
found 27 modules

------=_Part_9224_18230389.1209445270522
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I tried to build current v4l-dvb against kernel <a href="http://2.6.23.17">2.6.23.17</a> and now I have the following undefined errors.&nbsp; I assume there is a problem with the build script because some of the drivers were moved to a new location.&nbsp; Does anyone have a patch?&nbsp; I&#39;m not sure if this is another problem, but I also noticed that 7 additional modules are built since revision 7673 and I did not select any new drivers in the menuconfig.<br>
<br>Groeten.<br><br>Kernel build directory is /lib/modules/2.6.23.17.20080229.1/build<br>make -C /lib/modules/2.6.23.17.20080229.1/build SUBDIRS=/var/local/linuxtv.cvs/v4l-dvb/v4l&nbsp; modules<br>make[2]: Entering directory `/var/local/kernel-src/linux-2.6.23.17&#39;<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvbdev.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dmxdev.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_demux.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_filter.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ca_en50221.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_frontend.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_net.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ringbuffer.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_math.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_hw.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_v4l.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_av.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ca.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ipack.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ir.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_fops.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_video.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_hlp.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vbi.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-core.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.o<br>
&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.o<br>
&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.o<br>&nbsp; CC [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.o<br>
&nbsp; Building modules, stage 2.<br>&nbsp; MODPOST 27 modules<br>WARNING: &quot;videobuf_to_dma&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_mmap_mapper&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_mmap_setup&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_queue_cancel&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_streamon&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_iolock&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_pgtable_free&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_pgtable_alloc&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_read_one&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_qbuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_pgtable_build_single&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_querybuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_read_stream&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_dma_unmap&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_queue_sg_init&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_stop&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_devices&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;saa7146_debug&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_dqbuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_waiton&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_reqbufs&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_dma_free&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_devices_lock&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
WARNING: &quot;videobuf_poll_stream&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;videobuf_streamoff&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>WARNING: &quot;saa7146_vfree_destroy_pgtable&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
WARNING: &quot;saa7146_vmalloc_build_pgtable&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>WARNING: &quot;saa7146_setgpio&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>WARNING: &quot;saa7146_register_extension&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
WARNING: &quot;saa7146_i2c_adapter_prepare&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>WARNING: &quot;saa7146_wait_for_debi_done&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
WARNING: &quot;saa7146_unregister_extension&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.ko<br>
&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.ko<br>&nbsp; CC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.mod.o<br>&nbsp; LD [M]&nbsp; /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.ko<br>
make[2]: Leaving directory `/var/local/kernel-src/linux-2.6.23.17&#39;<br>./scripts/rmmod.pl check<br>found 27 modules<br>

------=_Part_9224_18230389.1209445270522--


--===============0705445724==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0705445724==--
