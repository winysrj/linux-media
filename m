Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JyN1Q-0007gw-U0
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 10:16:39 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2181540rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 01:16:29 -0700 (PDT)
Message-ID: <617be8890805200116wb9d1ad8oab957180ceeb9e15@mail.gmail.com>
Date: Tue, 20 May 2008 10:16:29 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1211236203.3241.51.camel@pc10.localdom.local>
MIME-Version: 1.0
References: <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
	<1211236203.3241.51.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu
	8.04, kernel 2.6.24-16-generic
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1293096500=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1293096500==
Content-Type: multipart/alternative;
	boundary="----=_Part_519_3109384.1211271389263"

------=_Part_519_3109384.1211271389263
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
    Another (usually definitive way...) to get rid of this problem is to
recompile your kernel without any DVB, V4L, etc... support and then install
LinuxTV drivers as you did before. This way you'll get sure you're using
only the LinuxTV modules and not trying to mix 'stock' Ubuntu modules with
new ones.

Also make sure you are using the correct kernel source / includes for the
kernel you are using.

regards,
  Eduard


2008/5/20, hermann pitton <hermann-pitton@arcor.de>:
>
> Hi,
>
> Am Dienstag, den 20.05.2008, 00:05 +0300 schrieb bvidinli:
>
> > Unfortunately, failed,
> > below is what i did, if you have any idea, please try to help me...
> >
> > Thanks...
> >
> > on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current kernel.:
> > i got sources and headers for this kernel..
> > (btw, i learned now that zzam = Matthias, thanks.. .)
> >
> > i got mercurial,
> > i did: hg clone http://linuxtv.org/hg/v4l-dvb
> > then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam/dvb/
> > i did:
> > cd v4l-dvb
> > patch -p1 < a700_full_20080519.diff
> > make
> > (make was successfull, without errors.. )
> > sudo make install
> > (install was successfull.)
> >
> >
> > bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa
> > bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod
> > make -C /home/bvidinli/v4l-dvb/v4l rmmod
> > make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'
> > scripts/rmmod.pl unload
> > found 233 modules
> > /sbin/rmmod saa7134
> > /sbin/rmmod videodev
> > /sbin/rmmod videobuf_dma_sg
> > /sbin/rmmod ir_kbd_i2c
> > /sbin/rmmod compat_ioctl32
> > /sbin/rmmod v4l1_compat
> > /sbin/rmmod v4l2_common
> > /sbin/rmmod videobuf_core
> > /sbin/rmmod ir_common
> > make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'
> >
> >
> > bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1
> > FATAL: Error inserting saa7134
> > (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
> > Unknown symbol in module, or unknown parameter (see dmesg)
> > FATAL: Error running install command for saa7134
> > bvidinli@bvidinli-desktop:~/v4l-dvb$
> >
> >
> >
> > dmesg is as follows:
> >
> >
> > [   48.937645] saa7134: disagrees about version of symbol
> videobuf_streamoff
> > [   48.937663] saa7134: Unknown symbol videobuf_streamoff
> > [   48.938027] saa7134: disagrees about version of symbol
> videobuf_poll_stream
> > [   48.938035] saa7134: Unknown symbol videobuf_poll_stream
> > [   48.938809] saa7134: disagrees about version of symbol
> videobuf_dma_free
> > [   48.938817] saa7134: Unknown symbol videobuf_dma_free
> > [   48.939134] saa7134: disagrees about version of symbol
> videobuf_reqbufs
> > [   48.939142] saa7134: Unknown symbol videobuf_reqbufs
> > [   48.939779] saa7134: disagrees about version of symbol videobuf_waiton
> > [   48.939787] saa7134: Unknown symbol videobuf_waiton
> > [   48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf
> > [   48.940340] saa7134: Unknown symbol videobuf_dqbuf
> > [   48.941669] saa7134: disagrees about version of symbol videobuf_stop
> > [   48.941677] saa7134: Unknown symbol videobuf_stop
> > [   48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
> > [   48.942813] saa7134: disagrees about version of symbol
> videobuf_dma_unmap
> > [   48.942822] saa7134: Unknown symbol videobuf_dma_unmap
> > [   48.942972] saa7134: disagrees about version of symbol
> videobuf_read_stream
> > [   48.942981] saa7134: Unknown symbol videobuf_read_stream
> > [   48.943162] saa7134: disagrees about version of symbol
> videobuf_querybuf
> > [   48.943170] saa7134: Unknown symbol videobuf_querybuf
> > [   48.943520] saa7134: disagrees about version of symbol
> > video_unregister_device
> > [   48.943529] saa7134: Unknown symbol video_unregister_device
> > [   48.943647] saa7134: disagrees about version of symbol videobuf_qbuf
> > [   48.943655] saa7134: Unknown symbol videobuf_qbuf
> > [   48.943950] saa7134: disagrees about version of symbol
> video_device_alloc
> > [   48.943958] saa7134: Unknown symbol video_device_alloc
> > [   48.944075] saa7134: disagrees about version of symbol
> videobuf_read_one
> > [   48.944083] saa7134: Unknown symbol videobuf_read_one
> > [   48.944365] saa7134: disagrees about version of symbol
> video_register_device
> > [   48.944373] saa7134: Unknown symbol video_register_device
> > [   48.945156] saa7134: disagrees about version of symbol videobuf_iolock
> > [   48.945164] saa7134: Unknown symbol videobuf_iolock
> > [   48.945433] saa7134: disagrees about version of symbol
> videobuf_streamon
> > [   48.945442] saa7134: Unknown symbol videobuf_streamon
> > [   48.946164] saa7134: disagrees about version of symbol
> video_device_release
> > [   48.946172] saa7134: Unknown symbol video_device_release
> > [   48.946287] saa7134: disagrees about version of symbol
> videobuf_mmap_mapper
> > [   48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
> > [   48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf
> > [   48.946673] saa7134: Unknown symbol videobuf_cgmbuf
> > [   48.947108] saa7134: disagrees about version of symbol videobuf_to_dma
> > [   48.947116] saa7134: Unknown symbol videobuf_to_dma
> > [   48.947228] saa7134: disagrees about version of symbol
> videobuf_mmap_free
> > [   48.947237] saa7134: Unknown symbol videobuf_mmap_free
> >
> > i rebooted, the same..
> >
> >
> > i repeated same compile with patch avertv_A700_dvb_part.diff
> >
> >
> >
> > result:
> > bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1
> > FATAL: Error inserting saa7134
> > (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
> > Unknown symbol in module, or unknown parameter (see dmesg)
> > FATAL: Error running install command for saa7134
> >
> >
> > here is dmesg related output:
> > [ 2023.405692] Linux video capture interface: v2.00
> > [ 2023.525841] saa7134: disagrees about version of symbol
> videobuf_streamoff
> > [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
> > [ 2023.526215] saa7134: disagrees about version of symbol
> videobuf_poll_stream
> > [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
> > [ 2023.526968] saa7134: disagrees about version of symbol
> videobuf_dma_free
> > [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
> > [ 2023.527249] saa7134: disagrees about version of symbol
> videobuf_reqbufs
> > [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
> > [ 2023.527904] saa7134: disagrees about version of symbol videobuf_waiton
> > [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
> > [ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf
> > [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
> > [ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop
> > [ 2023.529935] saa7134: Unknown symbol videobuf_stop
> > [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
> > [ 2023.531137] saa7134: disagrees about version of symbol
> videobuf_dma_unmap
> > [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
> > [ 2023.531271] saa7134: disagrees about version of symbol
> videobuf_read_stream
> > [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
> > [ 2023.531485] saa7134: disagrees about version of symbol
> videobuf_querybuf
> > [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
> > [ 2023.531832] saa7134: disagrees about version of symbol
> > video_unregister_device
> > [ 2023.531841] saa7134: Unknown symbol video_unregister_device
> > [ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf
> > [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
> > [ 2023.532251] saa7134: disagrees about version of symbol
> video_device_alloc
> > [ 2023.532260] saa7134: Unknown symbol video_device_alloc
> > [ 2023.532373] saa7134: disagrees about version of symbol
> videobuf_read_one
> > [ 2023.532381] saa7134: Unknown symbol videobuf_read_one
> > [ 2023.532655] saa7134: disagrees about version of symbol
> video_register_device
> > [ 2023.532663] saa7134: Unknown symbol video_register_device
> > [ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolock
> > [ 2023.533569] saa7134: Unknown symbol videobuf_iolock
> > [ 2023.533831] saa7134: disagrees about version of symbol
> videobuf_streamon
> > [ 2023.533839] saa7134: Unknown symbol videobuf_streamon
> > [ 2023.534615] saa7134: disagrees about version of symbol
> video_device_release
> > [ 2023.534624] saa7134: Unknown symbol video_device_release
> > [ 2023.534736] saa7134: disagrees about version of symbol
> videobuf_mmap_mapper
> > [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
> > [ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmbuf
> > [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
> > [ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_dma
> > [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
> > [ 2023.535717] saa7134: disagrees about version of symbol
> videobuf_mmap_free
> > [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free
> >
> >
> > my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's current
> kernel...
> > i have source and header files for this kernel..
> >
> > bvidinli@bvidinli-desktop:/usr/src$ uname -a
> > Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42
> > UTC 2008 i686 GNU/Linux
> >
> >
> >
> > bvidinli@bvidinli-desktop:/usr/src$ ls -l
> > total 45880
> > lrwxrwxrwx  1 root src        19 2008-05-19 22:14 linux ->
> linux-source-2.6.24
> > drwxr-xr-x 20 root root     4096 2008-04-22 20:54 linux-headers-2.6.24-16
> > drwxr-xr-x  6 root root     4096 2008-04-22 20:54
> > linux-headers-2.6.24-16-generic
> > drwxr-xr-x 23 root root     4096 2008-04-10 19:36 linux-source-2.6.24
> > -rw-r--r--  1 root root 46914792 2008-04-10 19:38
> linux-source-2.6.24.tar.bz2
> > bvidinli@bvidinli-desktop:/usr/src$
> >
> > Attention :
> > should these be applied on 2.6.26.rc2 or 2.6.25 ?
> > i applied to 2.6.24, which is current kernel for ubuntu 8.04...
>
>
> you seem to have mixed old and new modules around.
>
> There have been several reports, that on recent ubuntu stuff, at least
> on heron, v4l-dvb modules are in unusual locations, so they are not
> removed/replaced.
>
> Try to use "modprobe -vr ..."and modprobe -v" to find out where or read
> the lists.
>
> With "make install" you see the correct location for the new modules.
> Delete any other duplicate stuff you find anywhere else and do "depmod
> -a"
>
> Alsa support seems also to be out of tree and produces the same, but you
> don't need it yet.
>
> Cheers,
>
> Hermann
>
>
>

------=_Part_519_3109384.1211271389263
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, <br>&nbsp;&nbsp;&nbsp; Another (usually definitive way...) to get rid of this problem is to recompile your kernel without any DVB, V4L, etc... support and then install LinuxTV drivers as you did before. This way you&#39;ll get sure you&#39;re using only the LinuxTV modules and not trying to mix &#39;stock&#39; Ubuntu modules with new ones.<br>
<br>Also make sure you are using the correct kernel source / includes for the kernel you are using.<br><br>regards, <br>&nbsp; Eduard<br><br><br><div><span class="gmail_quote">2008/5/20, hermann pitton &lt;<a href="mailto:hermann-pitton@arcor.de">hermann-pitton@arcor.de</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br> <br> Am Dienstag, den 20.05.2008, 00:05 +0300 schrieb bvidinli:<br> <br>&gt; Unfortunately, failed,<br> &gt; below is what i did, if you have any idea, please try to help me...<br> &gt;<br> &gt; Thanks...<br> &gt;<br>
 &gt; on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu&#39;s current kernel.:<br> &gt; i got sources and headers for this kernel..<br> &gt; (btw, i learned now that zzam = Matthias, thanks.. .)<br> &gt;<br> &gt; i got mercurial,<br>
 &gt; i did: hg clone <a href="http://linuxtv.org/hg/v4l-dvb">http://linuxtv.org/hg/v4l-dvb</a><br> &gt; then, got a700_full_20080519.diff from <a href="http://dev.gentoo.org/~zzam/dvb/">http://dev.gentoo.org/~zzam/dvb/</a><br>
 &gt; i did:<br> &gt; cd v4l-dvb<br> &gt; patch -p1 &lt; a700_full_20080519.diff<br> &gt; make<br> &gt; (make was successfull, without errors.. )<br> &gt; sudo make install<br> &gt; (install was successfull.)<br> &gt;<br>
 &gt;<br> &gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa<br> &gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod<br> &gt; make -C /home/bvidinli/v4l-dvb/v4l rmmod<br> &gt; make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l&#39;<br>
 &gt; scripts/rmmod.pl unload<br> &gt; found 233 modules<br> &gt; /sbin/rmmod saa7134<br> &gt; /sbin/rmmod videodev<br> &gt; /sbin/rmmod videobuf_dma_sg<br> &gt; /sbin/rmmod ir_kbd_i2c<br> &gt; /sbin/rmmod compat_ioctl32<br>
 &gt; /sbin/rmmod v4l1_compat<br> &gt; /sbin/rmmod v4l2_common<br> &gt; /sbin/rmmod videobuf_core<br> &gt; /sbin/rmmod ir_common<br> &gt; make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l&#39;<br> &gt;<br> &gt;<br> &gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1<br>
 &gt; FATAL: Error inserting saa7134<br> &gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<br> &gt; Unknown symbol in module, or unknown parameter (see dmesg)<br> &gt; FATAL: Error running install command for saa7134<br>
 &gt; bvidinli@bvidinli-desktop:~/v4l-dvb$<br> &gt;<br> &gt;<br> &gt;<br> &gt; dmesg is as follows:<br> &gt;<br> &gt;<br> &gt; [&nbsp;&nbsp; 48.937645] saa7134: disagrees about version of symbol videobuf_streamoff<br> &gt; [&nbsp;&nbsp; 48.937663] saa7134: Unknown symbol videobuf_streamoff<br>
 &gt; [&nbsp;&nbsp; 48.938027] saa7134: disagrees about version of symbol videobuf_poll_stream<br> &gt; [&nbsp;&nbsp; 48.938035] saa7134: Unknown symbol videobuf_poll_stream<br> &gt; [&nbsp;&nbsp; 48.938809] saa7134: disagrees about version of symbol videobuf_dma_free<br>
 &gt; [&nbsp;&nbsp; 48.938817] saa7134: Unknown symbol videobuf_dma_free<br> &gt; [&nbsp;&nbsp; 48.939134] saa7134: disagrees about version of symbol videobuf_reqbufs<br> &gt; [&nbsp;&nbsp; 48.939142] saa7134: Unknown symbol videobuf_reqbufs<br> &gt; [&nbsp;&nbsp; 48.939779] saa7134: disagrees about version of symbol videobuf_waiton<br>
 &gt; [&nbsp;&nbsp; 48.939787] saa7134: Unknown symbol videobuf_waiton<br> &gt; [&nbsp;&nbsp; 48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf<br> &gt; [&nbsp;&nbsp; 48.940340] saa7134: Unknown symbol videobuf_dqbuf<br> &gt; [&nbsp;&nbsp; 48.941669] saa7134: disagrees about version of symbol videobuf_stop<br>
 &gt; [&nbsp;&nbsp; 48.941677] saa7134: Unknown symbol videobuf_stop<br> &gt; [&nbsp;&nbsp; 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init<br> &gt; [&nbsp;&nbsp; 48.942813] saa7134: disagrees about version of symbol videobuf_dma_unmap<br> &gt; [&nbsp;&nbsp; 48.942822] saa7134: Unknown symbol videobuf_dma_unmap<br>
 &gt; [&nbsp;&nbsp; 48.942972] saa7134: disagrees about version of symbol videobuf_read_stream<br> &gt; [&nbsp;&nbsp; 48.942981] saa7134: Unknown symbol videobuf_read_stream<br> &gt; [&nbsp;&nbsp; 48.943162] saa7134: disagrees about version of symbol videobuf_querybuf<br>
 &gt; [&nbsp;&nbsp; 48.943170] saa7134: Unknown symbol videobuf_querybuf<br> &gt; [&nbsp;&nbsp; 48.943520] saa7134: disagrees about version of symbol<br> &gt; video_unregister_device<br> &gt; [&nbsp;&nbsp; 48.943529] saa7134: Unknown symbol video_unregister_device<br>
 &gt; [&nbsp;&nbsp; 48.943647] saa7134: disagrees about version of symbol videobuf_qbuf<br> &gt; [&nbsp;&nbsp; 48.943655] saa7134: Unknown symbol videobuf_qbuf<br> &gt; [&nbsp;&nbsp; 48.943950] saa7134: disagrees about version of symbol video_device_alloc<br>
 &gt; [&nbsp;&nbsp; 48.943958] saa7134: Unknown symbol video_device_alloc<br> &gt; [&nbsp;&nbsp; 48.944075] saa7134: disagrees about version of symbol videobuf_read_one<br> &gt; [&nbsp;&nbsp; 48.944083] saa7134: Unknown symbol videobuf_read_one<br> &gt; [&nbsp;&nbsp; 48.944365] saa7134: disagrees about version of symbol video_register_device<br>
 &gt; [&nbsp;&nbsp; 48.944373] saa7134: Unknown symbol video_register_device<br> &gt; [&nbsp;&nbsp; 48.945156] saa7134: disagrees about version of symbol videobuf_iolock<br> &gt; [&nbsp;&nbsp; 48.945164] saa7134: Unknown symbol videobuf_iolock<br> &gt; [&nbsp;&nbsp; 48.945433] saa7134: disagrees about version of symbol videobuf_streamon<br>
 &gt; [&nbsp;&nbsp; 48.945442] saa7134: Unknown symbol videobuf_streamon<br> &gt; [&nbsp;&nbsp; 48.946164] saa7134: disagrees about version of symbol video_device_release<br> &gt; [&nbsp;&nbsp; 48.946172] saa7134: Unknown symbol video_device_release<br>
 &gt; [&nbsp;&nbsp; 48.946287] saa7134: disagrees about version of symbol videobuf_mmap_mapper<br> &gt; [&nbsp;&nbsp; 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper<br> &gt; [&nbsp;&nbsp; 48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf<br>
 &gt; [&nbsp;&nbsp; 48.946673] saa7134: Unknown symbol videobuf_cgmbuf<br> &gt; [&nbsp;&nbsp; 48.947108] saa7134: disagrees about version of symbol videobuf_to_dma<br> &gt; [&nbsp;&nbsp; 48.947116] saa7134: Unknown symbol videobuf_to_dma<br> &gt; [&nbsp;&nbsp; 48.947228] saa7134: disagrees about version of symbol videobuf_mmap_free<br>
 &gt; [&nbsp;&nbsp; 48.947237] saa7134: Unknown symbol videobuf_mmap_free<br> &gt;<br> &gt; i rebooted, the same..<br> &gt;<br> &gt;<br> &gt; i repeated same compile with patch avertv_A700_dvb_part.diff<br> &gt;<br> &gt;<br> &gt;<br>
 &gt; result:<br> &gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1<br> &gt; FATAL: Error inserting saa7134<br> &gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<br> &gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
 &gt; FATAL: Error running install command for saa7134<br> &gt;<br> &gt;<br> &gt; here is dmesg related output:<br> &gt; [ 2023.405692] Linux video capture interface: v2.00<br> &gt; [ 2023.525841] saa7134: disagrees about version of symbol videobuf_streamoff<br>
 &gt; [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff<br> &gt; [ 2023.526215] saa7134: disagrees about version of symbol videobuf_poll_stream<br> &gt; [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream<br>
 &gt; [ 2023.526968] saa7134: disagrees about version of symbol videobuf_dma_free<br> &gt; [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free<br> &gt; [ 2023.527249] saa7134: disagrees about version of symbol videobuf_reqbufs<br>
 &gt; [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs<br> &gt; [ 2023.527904] saa7134: disagrees about version of symbol videobuf_waiton<br> &gt; [ 2023.527912] saa7134: Unknown symbol videobuf_waiton<br> &gt; [ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf<br>
 &gt; [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf<br> &gt; [ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop<br> &gt; [ 2023.529935] saa7134: Unknown symbol videobuf_stop<br> &gt; [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init<br>
 &gt; [ 2023.531137] saa7134: disagrees about version of symbol videobuf_dma_unmap<br> &gt; [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap<br> &gt; [ 2023.531271] saa7134: disagrees about version of symbol videobuf_read_stream<br>
 &gt; [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream<br> &gt; [ 2023.531485] saa7134: disagrees about version of symbol videobuf_querybuf<br> &gt; [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf<br> &gt; [ 2023.531832] saa7134: disagrees about version of symbol<br>
 &gt; video_unregister_device<br> &gt; [ 2023.531841] saa7134: Unknown symbol video_unregister_device<br> &gt; [ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf<br> &gt; [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf<br>
 &gt; [ 2023.532251] saa7134: disagrees about version of symbol video_device_alloc<br> &gt; [ 2023.532260] saa7134: Unknown symbol video_device_alloc<br> &gt; [ 2023.532373] saa7134: disagrees about version of symbol videobuf_read_one<br>
 &gt; [ 2023.532381] saa7134: Unknown symbol videobuf_read_one<br> &gt; [ 2023.532655] saa7134: disagrees about version of symbol video_register_device<br> &gt; [ 2023.532663] saa7134: Unknown symbol video_register_device<br>
 &gt; [ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolock<br> &gt; [ 2023.533569] saa7134: Unknown symbol videobuf_iolock<br> &gt; [ 2023.533831] saa7134: disagrees about version of symbol videobuf_streamon<br>
 &gt; [ 2023.533839] saa7134: Unknown symbol videobuf_streamon<br> &gt; [ 2023.534615] saa7134: disagrees about version of symbol video_device_release<br> &gt; [ 2023.534624] saa7134: Unknown symbol video_device_release<br>
 &gt; [ 2023.534736] saa7134: disagrees about version of symbol videobuf_mmap_mapper<br> &gt; [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper<br> &gt; [ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmbuf<br>
 &gt; [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf<br> &gt; [ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_dma<br> &gt; [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma<br> &gt; [ 2023.535717] saa7134: disagrees about version of symbol videobuf_mmap_free<br>
 &gt; [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free<br> &gt;<br> &gt;<br> &gt; my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04&#39;s current kernel...<br> &gt; i have source and header files for this kernel..<br>
 &gt;<br> &gt; bvidinli@bvidinli-desktop:/usr/src$ uname -a<br> &gt; Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42<br> &gt; UTC 2008 i686 GNU/Linux<br> &gt;<br> &gt;<br> &gt;<br> &gt; bvidinli@bvidinli-desktop:/usr/src$ ls -l<br>
 &gt; total 45880<br> &gt; lrwxrwxrwx&nbsp;&nbsp;1 root src&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;19 2008-05-19 22:14 linux -&gt; linux-source-2.6.24<br> &gt; drwxr-xr-x 20 root root&nbsp;&nbsp;&nbsp;&nbsp; 4096 2008-04-22 20:54 linux-headers-2.6.24-16<br> &gt; drwxr-xr-x&nbsp;&nbsp;6 root root&nbsp;&nbsp;&nbsp;&nbsp; 4096 2008-04-22 20:54<br>
 &gt; linux-headers-2.6.24-16-generic<br> &gt; drwxr-xr-x 23 root root&nbsp;&nbsp;&nbsp;&nbsp; 4096 2008-04-10 19:36 linux-source-2.6.24<br> &gt; -rw-r--r--&nbsp;&nbsp;1 root root 46914792 2008-04-10 19:38 linux-source-2.6.24.tar.bz2<br> &gt; bvidinli@bvidinli-desktop:/usr/src$<br>
 &gt;<br> &gt; Attention :<br> &gt; should these be applied on 2.6.26.rc2 or 2.6.25 ?<br> &gt; i applied to 2.6.24, which is current kernel for ubuntu 8.04...<br> <br> <br>you seem to have mixed old and new modules around.<br>
 <br> There have been several reports, that on recent ubuntu stuff, at least<br> on heron, v4l-dvb modules are in unusual locations, so they are not<br> removed/replaced.<br> <br> Try to use &quot;modprobe -vr ...&quot;and modprobe -v&quot; to find out where or read<br>
 the lists.<br> <br> With &quot;make install&quot; you see the correct location for the new modules.<br> Delete any other duplicate stuff you find anywhere else and do &quot;depmod<br> -a&quot;<br> <br> Alsa support seems also to be out of tree and produces the same, but you<br>
 don&#39;t need it yet.<br> <br> Cheers,<br> <br>Hermann<br> <br> <br> </blockquote></div><br>

------=_Part_519_3109384.1211271389263--


--===============1293096500==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1293096500==--
