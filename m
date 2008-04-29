Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <syphyr@gmail.com>) id 1JqxUs-0005Ze-Ju
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 23:36:24 +0200
Received: by mu-out-0910.google.com with SMTP id g7so29815muf.1
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 14:36:19 -0700 (PDT)
Message-ID: <2d842fa80804291436t4464065bycb5b8d3b6b8dc19f@mail.gmail.com>
Date: Tue, 29 Apr 2008 23:36:18 +0200
From: Stone <syphyr@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1209499089.3456.34.camel@pc10.localdom.local>
MIME-Version: 1.0
References: <2d842fa80804282201h5665c596q4048d1f58fdaab5f@mail.gmail.com>
	<1209499089.3456.34.camel@pc10.localdom.local>
Subject: Re: [linux-dvb] saa7146_vv.ko and dvb-ttpci.ko undefined with
	kernel 2.6.23.17
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1572282248=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1572282248==
Content-Type: multipart/alternative;
	boundary="----=_Part_13171_24928314.1209504978529"

------=_Part_13171_24928314.1209504978529
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks for the confirmation.  Would you happen to know which file to edit so
that I can add such missing dependencies (ie; videobuf-dma-sg)?  It seems
like it should be a one line fix.  I would build "all" but my machine is so
slow, it really drags on.  There must be an easier way.

Best Regards.

On Tue, Apr 29, 2008 at 9:58 PM, hermann pitton <hermann-pitton@arcor.de>
wrote:

> Hi,
>
> Am Dienstag, den 29.04.2008, 07:01 +0200 schrieb Stone:
> > I tried to build current v4l-dvb against kernel 2.6.23.17 and now I
> > have the following undefined errors.  I assume there is a problem with
> > the build script because some of the drivers were moved to a new
> > location.  Does anyone have a patch?  I'm not sure if this is another
> > problem, but I also noticed that 7 additional modules are built since
> > revision 7673 and I did not select any new drivers in the menuconfig.
> >
> > Groeten.
>
> due of current changes, but also since long before, the backward compat
> of the build system is broken. Means if you use xconfig/menuconfig you
> can't trust that all dependencies are resolved automatically.
>
> Specifically at the moment saa7146 related build is broken.
> It should select videobuf-dma-sg but doesn't yet.
>
> The worst I did built so far was a 2.6.20 fc5, still doable if you
> collect the modules of several different build attempts, since make all
> does not enable everything and I had also to disable one frontend
> manually the old compiler there did not like.
>
> However, at least 2.6.23/24/25 should build without visible unresolved
> dependencies if you "make distclean" and just "make". (all)
>
> The only warning here is:
> CC [M]  /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.o
> /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c: In function
> 'attach_inform':
> /mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c:105: warning:
> unused variable 'tun_setup'
>
> gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
>
> > Kernel build directory is /lib/modules/2.6.23.17.20080229.1/build
> > make -C /lib/modules/2.6.23.17.20080229.1/build
> > SUBDIRS=/var/local/linuxtv.cvs/v4l-dvb/v4l  modules
> > make[2]: Entering directory `/var/local/kernel-src/linux-2.6.23.17'
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvbdev.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dmxdev.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_demux.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_filter.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ca_en50221.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_frontend.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_net.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ringbuffer.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_math.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_hw.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_v4l.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_av.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ca.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ipack.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ir.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_fops.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_video.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_hlp.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vbi.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-core.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.o
> >   CC [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.o
> >   Building modules, stage 2.
> >   MODPOST 27 modules
> > WARNING:
> > "videobuf_to_dma" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_mmap_mapper"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_mmap_setup" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> > WARNING:
> > "videobuf_queue_cancel"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_streamon" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_iolock" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "saa7146_pgtable_free"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "saa7146_pgtable_alloc"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_read_one" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_qbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "saa7146_pgtable_build_single"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_querybuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_read_stream"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_dma_unmap" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> > WARNING:
> > "videobuf_queue_sg_init"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_stop" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "saa7146_devices" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "saa7146_debug" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_dqbuf" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_waiton" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_reqbufs" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "videobuf_dma_free" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> > undefined!
> > WARNING:
> > "saa7146_devices_lock"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_poll_stream"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!
> > WARNING:
> > "videobuf_streamoff" [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]
> undefined!
> > WARNING:
> > "saa7146_vfree_destroy_pgtable"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> > WARNING:
> > "saa7146_vmalloc_build_pgtable"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> > WARNING:
> > "saa7146_setgpio" [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko]
> > undefined!
> > WARNING:
> > "saa7146_register_extension"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> > WARNING:
> > "saa7146_i2c_adapter_prepare"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> > WARNING:
> > "saa7146_wait_for_debi_done"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> > WARNING:
> > "saa7146_unregister_extension"
> [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.ko
> >   CC      /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.mod.o
> >   LD [M]  /var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.ko
> > make[2]: Leaving directory `/var/local/kernel-src/linux-2.6.23.17'
> > ./scripts/rmmod.pl check
> > found 27 modules
>
> If you enable for example saa7134 support under video you should get the
> missing videobuf* modules too until the build dependencies are working
> for saa7146 again?
>
> Cheers,
> Hermann
>
>
>

------=_Part_13171_24928314.1209504978529
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thanks for the confirmation.&nbsp; Would you happen to know which file to
edit so that I can add such missing dependencies (ie;
videobuf-dma-sg)?&nbsp; It seems like it should be a one line fix.&nbsp; I would
build &quot;all&quot; but my machine is so slow, it really drags on.&nbsp; There must
be an easier way.<br>
<br>Best Regards.<br><br><div class="gmail_quote">On Tue, Apr 29, 2008 at 9:58 PM, hermann pitton &lt;<a href="mailto:hermann-pitton@arcor.de">hermann-pitton@arcor.de</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<br>
Am Dienstag, den 29.04.2008, 07:01 +0200 schrieb Stone:<br>
<div class="Ih2E3d">&gt; I tried to build current v4l-dvb against kernel <a href="http://2.6.23.17" target="_blank">2.6.23.17</a> and now I<br>
&gt; have the following undefined errors. &nbsp;I assume there is a problem with<br>
&gt; the build script because some of the drivers were moved to a new<br>
&gt; location. &nbsp;Does anyone have a patch? &nbsp;I&#39;m not sure if this is another<br>
&gt; problem, but I also noticed that 7 additional modules are built since<br>
&gt; revision 7673 and I did not select any new drivers in the menuconfig.<br>
&gt;<br>
&gt; Groeten.<br>
<br>
</div>due of current changes, but also since long before, the backward compat<br>
of the build system is broken. Means if you use xconfig/menuconfig you<br>
can&#39;t trust that all dependencies are resolved automatically.<br>
<br>
Specifically at the moment saa7146 related build is broken.<br>
It should select videobuf-dma-sg but doesn&#39;t yet.<br>
<br>
The worst I did built so far was a 2.6.20 fc5, still doable if you<br>
collect the modules of several different build attempts, since make all<br>
does not enable everything and I had also to disable one frontend<br>
manually the old compiler there did not like.<br>
<br>
However, at least 2.6.23/24/25 should build without visible unresolved<br>
dependencies if you &quot;make distclean&quot; and just &quot;make&quot;. (all)<br>
<br>
The only warning here is:<br>
CC [M] &nbsp;/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.o<br>
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c: In function &#39;attach_inform&#39;:<br>
/mnt/xfer/mercurial/v4l-dvb-head/v4l-dvb/v4l/cx88-i2c.c:105: warning: unused variable &#39;tun_setup&#39;<br>
<br>
gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)<br>
<div><div></div><div class="Wj3C7c"><br>
&gt; Kernel build directory is /lib/modules/2.6.23.17.20080229.1/build<br>
&gt; make -C /lib/modules/2.6.23.17.20080229.1/build<br>
&gt; SUBDIRS=/var/local/linuxtv.cvs/v4l-dvb/v4l &nbsp;modules<br>
&gt; make[2]: Entering directory `/var/local/kernel-src/linux-2.6.23.17&#39;<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvbdev.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dmxdev.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_demux.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_filter.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ca_en50221.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_frontend.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_net.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_ringbuffer.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb_math.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_hw.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_v4l.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_av.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ca.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ipack.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/av7110_ir.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_fops.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_video.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_hlp.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vbi.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-core.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.o<br>
&gt; &nbsp; CC [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.o<br>
&gt; &nbsp; Building modules, stage 2.<br>
&gt; &nbsp; MODPOST 27 modules<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_to_dma&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_mmap_mapper&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_mmap_setup&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_queue_cancel&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_streamon&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_iolock&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_pgtable_free&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_pgtable_alloc&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_read_one&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_qbuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_pgtable_build_single&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_querybuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_read_stream&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_dma_unmap&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_queue_sg_init&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_stop&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_devices&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_debug&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_dqbuf&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_waiton&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_reqbufs&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_dma_free&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_devices_lock&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_poll_stream&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;videobuf_streamoff&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_vfree_destroy_pgtable&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_vmalloc_build_pgtable&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_setgpio&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko]<br>
&gt; undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_register_extension&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_i2c_adapter_prepare&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_wait_for_debi_done&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; WARNING:<br>
&gt; &quot;saa7146_unregister_extension&quot; [/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko] undefined!<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/compat_ioctl32.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-core.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/dvb-ttpci.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/l64781.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/lnbp21.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/mt20xx.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/saa7146_vv.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/sp8870.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0297.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/stv0299.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8083.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda8290.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tda9887.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5761.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tea5767.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ttpci-eeprom.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-simple.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-types.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner-xc2028.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/tuner.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l1-compat.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-common.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/v4l2-int-device.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1820.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/ves1x93.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/videodev.ko<br>
&gt; &nbsp; CC &nbsp; &nbsp; &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.mod.o<br>
&gt; &nbsp; LD [M] &nbsp;/var/local/linuxtv.cvs/v4l-dvb/v4l/xc5000.ko<br>
&gt; make[2]: Leaving directory `/var/local/kernel-src/linux-2.6.23.17&#39;<br>
&gt; ./scripts/rmmod.pl check<br>
&gt; found 27 modules<br>
<br>
</div></div>If you enable for example saa7134 support under video you should get the<br>
missing videobuf* modules too until the build dependencies are working<br>
for saa7146 again?<br>
<br>
Cheers,<br>
<font color="#888888">Hermann<br>
<br>
<br>
</font></blockquote></div><br>

------=_Part_13171_24928314.1209504978529--


--===============1572282248==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1572282248==--
