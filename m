Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Jyw4m-0006AB-3Q
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 23:42:28 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	418991800201
	for <linux-dvb@linuxtv.org>; Wed, 21 May 2008 21:41:46 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: bvidinli <bvidinli@gmail.com>, stev391@email.com,
	linux-dvb@linuxtv.org
Date: Thu, 22 May 2008 07:41:45 +1000
Message-Id: <20080521214145.C7CCEBE4079@ws1-9.us4.outblaze.com>
Subject: Re: [linux-dvb] fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
 kernel 2.6.24-16-generic (bvidinli)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0457605682=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0457605682==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121140610563310"

This is a multi-part message in MIME format.

--_----------=_121140610563310
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-9"

With ubuntu 8.04 they made a copy of some of the drivers (I had the
directory structure wrong in my previous email as I have already removed
mine), check in:
/lib/modules/`uname -r`/ubuntu/media/

for any folders relating to cx* and saa* and remove them as Ubuntu checks
here first for the modules instead of the new freshly compiled ones.
the run depmod -a and try again.

Regards,

Stephen.

  ----- Original Message -----
  From: bvidinli
  To: stev391@email.com, linux-dvb@linuxtv.org
  Subject: fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel
  2.6.24-16-generic (bvidinli)
  Date: Wed, 21 May 2008 16:10:08 +0300

  This problem persists, continues,
  does anybody have suggestions ?

  i continue on my search of this problem...

  thanks.


  2008/5/21 bvidinli :
  > i did your suggestions, but result is same.
  >
  > there was no file at locations you specified, (/lib/modules/`uname
  > -r`/ubuntu/media/common/)
  > instead i removed files on :
  > rm -rvf /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/
  > dvb, video, etc...
  >
  > if you/anybody may help me, please do..
  >
  >
  > root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134
  i2c_scan=3D1
  > FATAL: Error inserting saa7134
  > (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
  > Unknown symbol in module, or unknown parameter (see dmesg)
  > FATAL: Error running install command for saa7134
  > root@bvidinli-desktop:/home/bvidinli/v4l-dvb#
  >
  >
  > dmesg output:
  >
  > [ 4261.474794] Linux video capture interface: v2.00
  > [ 4261.603077] saa7134: disagrees about version of symbol
  videobuf_streamoff
  > [ 4261.603104] saa7134: Unknown symbol videobuf_streamoff
  > [ 4261.603450] saa7134: disagrees about version of symbol
  > videobuf_poll_stream
  > [ 4261.603459] saa7134: Unknown symbol videobuf_poll_stream
  > [ 4261.604240] saa7134: disagrees about version of symbol
  videobuf_dma_free
  > [ 4261.604249] saa7134: Unknown symbol videobuf_dma_free
  > [ 4261.604521] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  > [ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs
  > [ 4261.605140] saa7134: disagrees about version of symbol
  videobuf_waiton
  > [ 4261.605148] saa7134: Unknown symbol videobuf_waiton
  > [ 4261.605672] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  > [ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf
  > [ 4261.607190] saa7134: disagrees about version of symbol
  videobuf_stop
  > [ 4261.607199] saa7134: Unknown symbol videobuf_stop
  > [ 4261.608245] saa7134: Unknown symbol videobuf_queue_pci_init
  > [ 4261.608459] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  > [ 4261.608467] saa7134: Unknown symbol videobuf_dma_unmap
  > [ 4261.608592] saa7134: disagrees about version of symbol
  > videobuf_read_stream
  > [ 4261.608600] saa7134: Unknown symbol videobuf_read_stream
  > [ 4261.608776] saa7134: disagrees about version of symbol
  videobuf_querybuf
  > [ 4261.608784] saa7134: Unknown symbol videobuf_querybuf
  > [ 4261.609121] saa7134: disagrees about version of symbol
  > video_unregister_device
  > [ 4261.609130] saa7134: Unknown symbol video_unregister_device
  > [ 4261.609244] saa7134: disagrees about version of symbol
  videobuf_qbuf
  > [ 4261.609252] saa7134: Unknown symbol videobuf_qbuf
  > [ 4261.609538] saa7134: disagrees about version of symbol
  video_device_alloc
  > [ 4261.609547] saa7134: Unknown symbol video_device_alloc
  > [ 4261.609660] saa7134: disagrees about version of symbol
  videobuf_read_one
  > [ 4261.609668] saa7134: Unknown symbol videobuf_read_one
  > [ 4261.609940] saa7134: disagrees about version of symbol
  > video_register_device
  > [ 4261.609948] saa7134: Unknown symbol video_register_device
  > [ 4261.610871] saa7134: disagrees about version of symbol
  videobuf_iolock
  > [ 4261.610879] saa7134: Unknown symbol videobuf_iolock
  > [ 4261.611139] saa7134: disagrees about version of symbol
  videobuf_streamon
  > [ 4261.611147] saa7134: Unknown symbol videobuf_streamon
  > [ 4261.611941] saa7134: disagrees about version of symbol
  > video_device_release
  > [ 4261.611950] saa7134: Unknown symbol video_device_release
  > [ 4261.612061] saa7134: disagrees about version of symbol
  > videobuf_mmap_mapper
  > [ 4261.612070] saa7134: Unknown symbol videobuf_mmap_mapper
  > [ 4261.612426] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  > [ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf
  > [ 4261.612908] saa7134: disagrees about version of symbol
  videobuf_to_dma
  > [ 4261.612917] saa7134: Unknown symbol videobuf_to_dma
  > [ 4261.613027] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  > [ 4261.613035] saa7134: Unknown symbol videobuf_mmap_free
  >
  >
  >
  > 2008/5/20 :
  >> bvidibli,
  >>
  >> To get this working try removing all modules(all files) in the
  following
  >> directories:
  >> /lib/modules/`uname -r`/ubuntu/media/common/
  >> /lib/modules/`uname -r`/ubuntu/media/dvb/
  >> /lib/modules/`uname -r`/ubuntu/media/radio/
  >> /lib/modules/`uname -r`/ubuntu/media/video/
  >>
  >> For some reason Ubuntu decided to rearrange the module directory
  and broke
  >> the normal make install scripts.
  >>
  >> If this breaks something that you need, just reinstall the
  >> linux-ubuntu-modules-`uname -r` package to get them back.
  >>
  >> This solved the issues that I had with Unkown symbol and version
  disagrees
  >> error messages.
  >>
  >> Regards,
  >> Stephen.
  >>
  >> Date: Tue, 20 May 2008 00:05:47 +0300
  >> From: bvidinli
  >> Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on
  ubuntu
  >> 8.04, kernel 2.6.24-16-generic
  >> To: "Eduard Huguet" , "Matthias Schwarzott"
  >> , linux-dvb@linuxtv.org
  >> Message-ID:
  >> <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
  >> Content-Type: text/plain; charset=3DISO-8859-1
  >>
  >> Unfortunately, failed,
  >> below is what i did, if you have any idea, please try to help
  me...
  >>
  >> Thanks...
  >>
  >> on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current
  kernel.:
  >> i got sources and headers for this kernel..
  >> (btw, i learned now that zzam =3D Matthias, thanks.. .)
  >>
  >> i got mercurial,
  >> i did: hg clone http://linuxtv.org/hg/v4l-dvb
  >> then, got a700_full_20080519.diff from
  http://dev.gentoo.org/~zzam/dvb/
  >> i did:
  >> cd v4l-dvb
  >> patch -p1 < a700_full_20080519.diff
  >> make
  >> (make was successfull, without errors.. )
  >> sudo make install
  >> (install was successfull.)
  >>
  >>
  >> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa
  >> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod
  >> make -C /home/bvidinli/v4l-dvb/v4l rmmod
  >> make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'
  >> scripts/rmmod.pl unload
  >> found 233 modules
  >> /sbin/rmmod saa7134
  >> /sbin/rmmod videodev
  >> /sbin/rmmod videobuf_dma_sg
  >> /sbin/rmmod ir_kbd_i2c
  >> /sbin/rmmod compat_ioctl32
  >> /sbin/rmmod v4l1_compat
  >> /sbin/rmmod v4l2_common
  >> /sbin/rmmod videobuf_core
  >> /sbin/rmmod ir_common
  >> make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'
  >>
  >>
  >> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134
  i2c_scan=3D1
  >> FATAL: Error inserting saa7134
  >> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
  >> Unknown symbol in module, or unknown parameter (see dmesg)
  >> FATAL: Error running install command for saa7134
  >> bvidinli@bvidinli-desktop:~/v4l-dvb$
  >>
  >>
  >>
  >> dmesg is as follows:
  >>
  >>
  >> [ 48.937645] saa7134: disagrees about version of symbol
  videobuf_streamoff
  >> [ 48.937663] saa7134: Unknown symbol videobuf_streamoff
  >> [ 48.938027] saa7134: disagrees about version of symbol
  videobuf_poll_stream
  >> [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream
  >> [ 48.938809] saa7134: disagrees about version of symbol
  videobuf_dma_free
  >> [ 48.938817] saa7134: Unknown symbol videobuf_dma_free
  >> [ 48.939134] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  >> [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs
  >> [ 48.939779] saa7134: disagrees about version of symbol
  videobuf_waiton
  >> [ 48.939787] saa7134: Unknown symbol videobuf_waiton
  >> [ 48.940332] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  >> [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf
  >> [ 48.941669] saa7134: disagrees about version of symbol
  videobuf_stop
  >> [ 48.941677] saa7134: Unknown symbol videobuf_stop
  >> [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
  >> [ 48.942813] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  >> [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap
  >> [ 48.942972] saa7134: disagrees about version of symbol
  videobuf_read_stream
  >> [ 48.942981] saa7134: Unknown symbol videobuf_read_stream
  >> [ 48.943162] saa7134: disagrees about version of symbol
  videobuf_querybuf
  >> [ 48.943170] saa7134: Unknown symbol videobuf_querybuf
  >> [ 48.943520] saa7134: disagrees about version of symbol
  >> video_unregister_device
  >> [ 48.943529] saa7134: Unknown symbol video_unregister_device
  >> [ 48.943647] saa7134: disagrees about version of symbol
  videobuf_qbuf
  >> [ 48.943655] saa7134: Unknown symbol videobuf_qbuf
  >> [ 48.943950] saa7134: disagrees about version of symbol
  video_device_alloc
  >> [ 48.943958] saa7134: Unknown symbol video_device_alloc
  >> [ 48.944075] saa7134: disagrees about version of symbol
  videobuf_read_one
  >> [ 48.944083] saa7134: Unknown symbol videobuf_read_one
  >> [ 48.944365] saa7134: disagrees about version of symbol
  >> video_register_device
  >> [ 48.944373] saa7134: Unknown symbol video_register_device
  >> [ 48.945156] saa7134: disagrees about version of symbol
  videobuf_iolock
  >> [ 48.945164] saa7134: Unknown symbol videobuf_iolock
  >> [ 48.945433] saa7134: disagrees about version of symbol
  videobuf_streamon
  >> [ 48.945442] saa7134: Unknown symbol videobuf_streamon
  >> [ 48.946164] saa7134: disagrees about version of symbol
  video_device_release
  >> [ 48.946172] saa7134: Unknown symbol video_device_release
  >> [ 48.946287] saa7134: disagrees about version of symbol
  videobuf_mmap_mapper
  >> [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
  >> [ 48.946665] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  >> [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf
  >> [ 48.947108] saa7134: disagrees about version of symbol
  videobuf_to_dma
  >> [ 48.947116] saa7134: Unknown symbol videobuf_to_dma
  >> [ 48.947228] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  >> [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free
  >>
  >> i rebooted, the same..
  >>
  >>
  >> i repeated same compile with patch avertv_A700_dvb_part.diff
  >>
  >>
  >>
  >> result:
  >> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134
  i2c_scan=3D1
  >> FATAL: Error inserting saa7134
  >> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
  >> Unknown symbol in module, or unknown parameter (see dmesg)
  >> FATAL: Error running install command for saa7134
  >>
  >>
  >> here is dmesg related output:
  >> [ 2023.405692] Linux video capture interface: v2.00
  >> [ 2023.525841] saa7134: disagrees about version of symbol
  videobuf_streamoff
  >> [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
  >> [ 2023.526215] saa7134: disagrees about version of symbol
  >> videobuf_poll_stream
  >> [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
  >> [ 2023.526968] saa7134: disagrees about version of symbol
  videobuf_dma_free
  >> [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
  >> [ 2023.527249] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  >> [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
  >> [ 2023.527904] saa7134: disagrees about version of symbol
  videobuf_waiton
  >> [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
  >> [ 2023.528438] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  >> [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
  >> [ 2023.529926] saa7134: disagrees about version of symbol
  videobuf_stop
  >> [ 2023.529935] saa7134: Unknown symbol videobuf_stop
  >> [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
  >> [ 2023.531137] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  >> [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
  >> [ 2023.531271] saa7134: disagrees about version of symbol
  >> videobuf_read_stream
  >> [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
  >> [ 2023.531485] saa7134: disagrees about version of symbol
  videobuf_querybuf
  >> [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
  >> [ 2023.531832] saa7134: disagrees about version of symbol
  >> video_unregister_device
  >> [ 2023.531841] saa7134: Unknown symbol video_unregister_device
  >> [ 2023.531956] saa7134: disagrees about version of symbol
  videobuf_qbuf
  >> [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
  >> [ 2023.532251] saa7134: disagrees about version of symbol
  video_device_alloc
  >> [ 2023.532260] saa7134: Unknown symbol video_device_alloc
  >> [ 2023.532373] saa7134: disagrees about version of symbol
  videobuf_read_one
  >> [ 2023.532381] saa7134: Unknown symbol videobuf_read_one
  >> [ 2023.532655] saa7134: disagrees about version of symbol
  >> video_register_device
  >> [ 2023.532663] saa7134: Unknown symbol video_register_device
  >> [ 2023.533561] saa7134: disagrees about version of symbol
  videobuf_iolock
  >> [ 2023.533569] saa7134: Unknown symbol videobuf_iolock
  >> [ 2023.533831] saa7134: disagrees about version of symbol
  videobuf_streamon
  >> [ 2023.533839] saa7134: Unknown symbol videobuf_streamon
  >> [ 2023.534615] saa7134: disagrees about version of symbol
  >> video_device_release
  >> [ 2023.534624] saa7134: Unknown symbol video_device_release
  >> [ 2023.534736] saa7134: disagrees about version of symbol
  >> videobuf_mmap_mapper
  >> [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
  >> [ 2023.535101] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  >> [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
  >> [ 2023.535598] saa7134: disagrees about version of symbol
  videobuf_to_dma
  >> [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
  >> [ 2023.535717] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  >> [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free
  >>
  >>
  >> my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's
  >> current kernel...
  >> i have source and header files for this kernel..
  >>
  >> bvidinli@bvidinli-desktop:/usr/src$ uname -a
  >> Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10
  13:23:42
  >> UTC 2008 i686 GNU/Linux
  >>
  >>
  >>
  >> bvidinli@bvidinli-desktop:/usr/src$ ls -l
  >> total 45880
  >> lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux ->
  linux-source-2.6.24
  >> drwxr-xr-x 20 root root 4096 2008-04-22 20:54
  linux-headers-2.6.24-16
  >> drwxr-xr-x 6 root root 4096 2008-04-22 20:54
  >> linux-headers-2.6.24-16-generic
  >> drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6.24
  >> -rw-r--r-- 1 root root 46914792 2008-04-10 19:38
  linux-source-2.6.24.tar.bz2
  >> bvidinli@bvidinli-desktop:/usr/src$
  >>
  >> Attention :
  >> should these be applied on 2.6.26.rc2 or 2.6.25 ?
  >> i applied to 2.6.24, which is current kernel for ubuntu 8.04...
  >>
  >>
  >>
  >> ------------------------------
  >>
  >> _______________________________________________
  >> linux-dvb mailing list
  >> linux-dvb@linuxtv.org
  >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
  >>
  >> End of linux-dvb Digest, Vol 40, Issue 64
  >> *****************************************
  >>
  >> --
  >> See Exclusive Video: 10th Annual Young Hollywood Awards
  >>
  >
  >
  >
  > --
  > =DD.Bahattin Vidinli
  > Elk-Elektronik M=FCh.
  > -------------------
  > iletisim bilgileri (Tercih sirasina gore):
  > skype: bvidinli (sesli gorusme icin, www.skype.com)
  > msn: bvidinli@iyibirisi.com
  > yahoo: bvidinli
  >
  > +90.532.7990607
  > +90.505.5667711
  >



  --
  =DD.Bahattin Vidinli
  Elk-Elektronik M=FCh.
  -------------------
  iletisim bilgileri (Tercih sirasina gore):
  skype: bvidinli (sesli gorusme icin, www.skype.com)
  msn: bvidinli@iyibirisi.com
  yahoo: bvidinli

  +90.532.7990607
  +90.505.5667711

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_121140610563310
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-9"


<div><br>With ubuntu 8.04 they made a copy of some of the drivers (I had th=
e directory structure wrong in my previous email as I have already removed =
mine), check in:<br>/lib/modules/`uname
-r`/ubuntu/media/<br><br>for any folders relating to cx* and saa* and remov=
e them as Ubuntu checks here first for the modules instead of the new fresh=
ly compiled ones.<br>the run depmod -a and try again.<br><br>Regards,<br><b=
r>Stephen.<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: bvidinli <bvidinli@gmail.com><br>
To: stev391@email.com, linux-dvb@linuxtv.org<br>
Subject: fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel 2.6.24-=
16-generic (bvidinli)<br>
Date: Wed, 21 May 2008 16:10:08 +0300<br>
<br>
This problem persists, continues,<br>
does anybody have suggestions ?<br>
<br>
i continue on my search of this problem...<br>
<br>
thanks.<br>
<br>
<br>
2008/5/21 bvidinli <bvidinli@gmail.com>:<br>
&gt; i did your suggestions, but result is same.<br>
&gt;<br>
&gt; there was no file at locations you specified, (/lib/modules/`uname<br>
&gt; -r`/ubuntu/media/common/)<br>
&gt; instead i removed files on :<br>
&gt; rm -rvf /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/<br>
&gt; dvb, video, etc...<br>
&gt;<br>
&gt; if you/anybody may help me, please do..<br>
&gt;<br>
&gt;<br>
&gt; root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134 i2c_sca=
n=3D1<br>
&gt; FATAL: Error inserting saa7134<br>
&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<br>
&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt; FATAL: Error running install command for saa7134<br>
&gt; root@bvidinli-desktop:/home/bvidinli/v4l-dvb#<br>
&gt;<br>
&gt;<br>
&gt; dmesg output:<br>
&gt;<br>
&gt; [ 4261.474794] Linux video capture interface: v2.00<br>
&gt; [ 4261.603077] saa7134: disagrees about version of symbol videobuf_str=
eamoff<br>
&gt; [ 4261.603104] saa7134: Unknown symbol videobuf_streamoff<br>
&gt; [ 4261.603450] saa7134: disagrees about version of symbol <br>
&gt; videobuf_poll_stream<br>
&gt; [ 4261.603459] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt; [ 4261.604240] saa7134: disagrees about version of symbol videobuf_dma=
_free<br>
&gt; [ 4261.604249] saa7134: Unknown symbol videobuf_dma_free<br>
&gt; [ 4261.604521] saa7134: disagrees about version of symbol videobuf_req=
bufs<br>
&gt; [ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt; [ 4261.605140] saa7134: disagrees about version of symbol videobuf_wai=
ton<br>
&gt; [ 4261.605148] saa7134: Unknown symbol videobuf_waiton<br>
&gt; [ 4261.605672] saa7134: disagrees about version of symbol videobuf_dqb=
uf<br>
&gt; [ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt; [ 4261.607190] saa7134: disagrees about version of symbol videobuf_sto=
p<br>
&gt; [ 4261.607199] saa7134: Unknown symbol videobuf_stop<br>
&gt; [ 4261.608245] saa7134: Unknown symbol videobuf_queue_pci_init<br>
&gt; [ 4261.608459] saa7134: disagrees about version of symbol videobuf_dma=
_unmap<br>
&gt; [ 4261.608467] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt; [ 4261.608592] saa7134: disagrees about version of symbol <br>
&gt; videobuf_read_stream<br>
&gt; [ 4261.608600] saa7134: Unknown symbol videobuf_read_stream<br>
&gt; [ 4261.608776] saa7134: disagrees about version of symbol videobuf_que=
rybuf<br>
&gt; [ 4261.608784] saa7134: Unknown symbol videobuf_querybuf<br>
&gt; [ 4261.609121] saa7134: disagrees about version of symbol<br>
&gt; video_unregister_device<br>
&gt; [ 4261.609130] saa7134: Unknown symbol video_unregister_device<br>
&gt; [ 4261.609244] saa7134: disagrees about version of symbol videobuf_qbu=
f<br>
&gt; [ 4261.609252] saa7134: Unknown symbol videobuf_qbuf<br>
&gt; [ 4261.609538] saa7134: disagrees about version of symbol video_device=
_alloc<br>
&gt; [ 4261.609547] saa7134: Unknown symbol video_device_alloc<br>
&gt; [ 4261.609660] saa7134: disagrees about version of symbol videobuf_rea=
d_one<br>
&gt; [ 4261.609668] saa7134: Unknown symbol videobuf_read_one<br>
&gt; [ 4261.609940] saa7134: disagrees about version of symbol <br>
&gt; video_register_device<br>
&gt; [ 4261.609948] saa7134: Unknown symbol video_register_device<br>
&gt; [ 4261.610871] saa7134: disagrees about version of symbol videobuf_iol=
ock<br>
&gt; [ 4261.610879] saa7134: Unknown symbol videobuf_iolock<br>
&gt; [ 4261.611139] saa7134: disagrees about version of symbol videobuf_str=
eamon<br>
&gt; [ 4261.611147] saa7134: Unknown symbol videobuf_streamon<br>
&gt; [ 4261.611941] saa7134: disagrees about version of symbol <br>
&gt; video_device_release<br>
&gt; [ 4261.611950] saa7134: Unknown symbol video_device_release<br>
&gt; [ 4261.612061] saa7134: disagrees about version of symbol <br>
&gt; videobuf_mmap_mapper<br>
&gt; [ 4261.612070] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt; [ 4261.612426] saa7134: disagrees about version of symbol videobuf_cgm=
buf<br>
&gt; [ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt; [ 4261.612908] saa7134: disagrees about version of symbol videobuf_to_=
dma<br>
&gt; [ 4261.612917] saa7134: Unknown symbol videobuf_to_dma<br>
&gt; [ 4261.613027] saa7134: disagrees about version of symbol videobuf_mma=
p_free<br>
&gt; [ 4261.613035] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; 2008/5/20  <stev391@email.com>:<br>
&gt;&gt; bvidibli,<br>
&gt;&gt;<br>
&gt;&gt; To get this working try removing all modules(all files) in the fol=
lowing<br>
&gt;&gt; directories:<br>
&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/common/<br>
&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/dvb/<br>
&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/radio/<br>
&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/video/<br>
&gt;&gt;<br>
&gt;&gt; For some reason Ubuntu decided to rearrange the module directory a=
nd broke<br>
&gt;&gt; the normal make install scripts.<br>
&gt;&gt;<br>
&gt;&gt; If this breaks something that you need, just reinstall the<br>
&gt;&gt; linux-ubuntu-modules-`uname -r` package to get them back.<br>
&gt;&gt;<br>
&gt;&gt; This solved the issues that I had with Unkown symbol and version d=
isagrees<br>
&gt;&gt; error messages.<br>
&gt;&gt;<br>
&gt;&gt; Regards,<br>
&gt;&gt; Stephen.<br>
&gt;&gt;<br>
&gt;&gt; Date: Tue, 20 May 2008 00:05:47 +0300<br>
&gt;&gt; From: bvidinli<br>
&gt;&gt; Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubu=
ntu<br>
&gt;&gt; 8.04, kernel 2.6.24-16-generic<br>
&gt;&gt; To: "Eduard Huguet" , "Matthias Schwarzott"<br>
&gt;&gt; , linux-dvb@linuxtv.org<br>
&gt;&gt; Message-ID:<br>
&gt;&gt; &lt;36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com&gt=
;<br>
&gt;&gt; Content-Type: text/plain; charset=3DISO-8859-1<br>
&gt;&gt;<br>
&gt;&gt; Unfortunately, failed,<br>
&gt;&gt; below is what i did, if you have any idea, please try to help me..=
.<br>
&gt;&gt;<br>
&gt;&gt; Thanks...<br>
&gt;&gt;<br>
&gt;&gt; on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current ker=
nel.:<br>
&gt;&gt; i got sources and headers for this kernel..<br>
&gt;&gt; (btw, i learned now that zzam =3D Matthias, thanks.. .)<br>
&gt;&gt;<br>
&gt;&gt; i got mercurial,<br>
&gt;&gt; i did: hg clone http://linuxtv.org/hg/v4l-dvb<br>
&gt;&gt; then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam=
/dvb/<br>
&gt;&gt; i did:<br>
&gt;&gt; cd v4l-dvb<br>
&gt;&gt; patch -p1 &lt; a700_full_20080519.diff<br>
&gt;&gt; make<br>
&gt;&gt; (make was successfull, without errors.. )<br>
&gt;&gt; sudo make install<br>
&gt;&gt; (install was successfull.)<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa<br>
&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod<br>
&gt;&gt; make -C /home/bvidinli/v4l-dvb/v4l rmmod<br>
&gt;&gt; make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'<br>
&gt;&gt; scripts/rmmod.pl unload<br>
&gt;&gt; found 233 modules<br>
&gt;&gt; /sbin/rmmod saa7134<br>
&gt;&gt; /sbin/rmmod videodev<br>
&gt;&gt; /sbin/rmmod videobuf_dma_sg<br>
&gt;&gt; /sbin/rmmod ir_kbd_i2c<br>
&gt;&gt; /sbin/rmmod compat_ioctl32<br>
&gt;&gt; /sbin/rmmod v4l1_compat<br>
&gt;&gt; /sbin/rmmod v4l2_common<br>
&gt;&gt; /sbin/rmmod videobuf_core<br>
&gt;&gt; /sbin/rmmod ir_common<br>
&gt;&gt; make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_sca=
n=3D1<br>
&gt;&gt; FATAL: Error inserting saa7134<br>
&gt;&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<=
br>
&gt;&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt;&gt; FATAL: Error running install command for saa7134<br>
&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; dmesg is as follows:<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; [ 48.937645] saa7134: disagrees about version of symbol videobuf_s=
treamoff<br>
&gt;&gt; [ 48.937663] saa7134: Unknown symbol videobuf_streamoff<br>
&gt;&gt; [ 48.938027] saa7134: disagrees about version of symbol videobuf_p=
oll_stream<br>
&gt;&gt; [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt;&gt; [ 48.938809] saa7134: disagrees about version of symbol videobuf_d=
ma_free<br>
&gt;&gt; [ 48.938817] saa7134: Unknown symbol videobuf_dma_free<br>
&gt;&gt; [ 48.939134] saa7134: disagrees about version of symbol videobuf_r=
eqbufs<br>
&gt;&gt; [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt;&gt; [ 48.939779] saa7134: disagrees about version of symbol videobuf_w=
aiton<br>
&gt;&gt; [ 48.939787] saa7134: Unknown symbol videobuf_waiton<br>
&gt;&gt; [ 48.940332] saa7134: disagrees about version of symbol videobuf_d=
qbuf<br>
&gt;&gt; [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt;&gt; [ 48.941669] saa7134: disagrees about version of symbol videobuf_s=
top<br>
&gt;&gt; [ 48.941677] saa7134: Unknown symbol videobuf_stop<br>
&gt;&gt; [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init<br>
&gt;&gt; [ 48.942813] saa7134: disagrees about version of symbol videobuf_d=
ma_unmap<br>
&gt;&gt; [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt;&gt; [ 48.942972] saa7134: disagrees about version of symbol videobuf_r=
ead_stream<br>
&gt;&gt; [ 48.942981] saa7134: Unknown symbol videobuf_read_stream<br>
&gt;&gt; [ 48.943162] saa7134: disagrees about version of symbol videobuf_q=
uerybuf<br>
&gt;&gt; [ 48.943170] saa7134: Unknown symbol videobuf_querybuf<br>
&gt;&gt; [ 48.943520] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_unregister_device<br>
&gt;&gt; [ 48.943529] saa7134: Unknown symbol video_unregister_device<br>
&gt;&gt; [ 48.943647] saa7134: disagrees about version of symbol videobuf_q=
buf<br>
&gt;&gt; [ 48.943655] saa7134: Unknown symbol videobuf_qbuf<br>
&gt;&gt; [ 48.943950] saa7134: disagrees about version of symbol video_devi=
ce_alloc<br>
&gt;&gt; [ 48.943958] saa7134: Unknown symbol video_device_alloc<br>
&gt;&gt; [ 48.944075] saa7134: disagrees about version of symbol videobuf_r=
ead_one<br>
&gt;&gt; [ 48.944083] saa7134: Unknown symbol videobuf_read_one<br>
&gt;&gt; [ 48.944365] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_register_device<br>
&gt;&gt; [ 48.944373] saa7134: Unknown symbol video_register_device<br>
&gt;&gt; [ 48.945156] saa7134: disagrees about version of symbol videobuf_i=
olock<br>
&gt;&gt; [ 48.945164] saa7134: Unknown symbol videobuf_iolock<br>
&gt;&gt; [ 48.945433] saa7134: disagrees about version of symbol videobuf_s=
treamon<br>
&gt;&gt; [ 48.945442] saa7134: Unknown symbol videobuf_streamon<br>
&gt;&gt; [ 48.946164] saa7134: disagrees about version of symbol video_devi=
ce_release<br>
&gt;&gt; [ 48.946172] saa7134: Unknown symbol video_device_release<br>
&gt;&gt; [ 48.946287] saa7134: disagrees about version of symbol videobuf_m=
map_mapper<br>
&gt;&gt; [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt;&gt; [ 48.946665] saa7134: disagrees about version of symbol videobuf_c=
gmbuf<br>
&gt;&gt; [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt;&gt; [ 48.947108] saa7134: disagrees about version of symbol videobuf_t=
o_dma<br>
&gt;&gt; [ 48.947116] saa7134: Unknown symbol videobuf_to_dma<br>
&gt;&gt; [ 48.947228] saa7134: disagrees about version of symbol videobuf_m=
map_free<br>
&gt;&gt; [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;&gt;<br>
&gt;&gt; i rebooted, the same..<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; i repeated same compile with patch avertv_A700_dvb_part.diff<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; result:<br>
&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_sca=
n=3D1<br>
&gt;&gt; FATAL: Error inserting saa7134<br>
&gt;&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<=
br>
&gt;&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt;&gt; FATAL: Error running install command for saa7134<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; here is dmesg related output:<br>
&gt;&gt; [ 2023.405692] Linux video capture interface: v2.00<br>
&gt;&gt; [ 2023.525841] saa7134: disagrees about version of symbol videobuf=
_streamoff<br>
&gt;&gt; [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff<br>
&gt;&gt; [ 2023.526215] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_poll_stream<br>
&gt;&gt; [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt;&gt; [ 2023.526968] saa7134: disagrees about version of symbol videobuf=
_dma_free<br>
&gt;&gt; [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free<br>
&gt;&gt; [ 2023.527249] saa7134: disagrees about version of symbol videobuf=
_reqbufs<br>
&gt;&gt; [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt;&gt; [ 2023.527904] saa7134: disagrees about version of symbol videobuf=
_waiton<br>
&gt;&gt; [ 2023.527912] saa7134: Unknown symbol videobuf_waiton<br>
&gt;&gt; [ 2023.528438] saa7134: disagrees about version of symbol videobuf=
_dqbuf<br>
&gt;&gt; [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt;&gt; [ 2023.529926] saa7134: disagrees about version of symbol videobuf=
_stop<br>
&gt;&gt; [ 2023.529935] saa7134: Unknown symbol videobuf_stop<br>
&gt;&gt; [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init<br>
&gt;&gt; [ 2023.531137] saa7134: disagrees about version of symbol videobuf=
_dma_unmap<br>
&gt;&gt; [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt;&gt; [ 2023.531271] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_read_stream<br>
&gt;&gt; [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream<br>
&gt;&gt; [ 2023.531485] saa7134: disagrees about version of symbol videobuf=
_querybuf<br>
&gt;&gt; [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf<br>
&gt;&gt; [ 2023.531832] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_unregister_device<br>
&gt;&gt; [ 2023.531841] saa7134: Unknown symbol video_unregister_device<br>
&gt;&gt; [ 2023.531956] saa7134: disagrees about version of symbol videobuf=
_qbuf<br>
&gt;&gt; [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf<br>
&gt;&gt; [ 2023.532251] saa7134: disagrees about version of symbol video_de=
vice_alloc<br>
&gt;&gt; [ 2023.532260] saa7134: Unknown symbol video_device_alloc<br>
&gt;&gt; [ 2023.532373] saa7134: disagrees about version of symbol videobuf=
_read_one<br>
&gt;&gt; [ 2023.532381] saa7134: Unknown symbol videobuf_read_one<br>
&gt;&gt; [ 2023.532655] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_register_device<br>
&gt;&gt; [ 2023.532663] saa7134: Unknown symbol video_register_device<br>
&gt;&gt; [ 2023.533561] saa7134: disagrees about version of symbol videobuf=
_iolock<br>
&gt;&gt; [ 2023.533569] saa7134: Unknown symbol videobuf_iolock<br>
&gt;&gt; [ 2023.533831] saa7134: disagrees about version of symbol videobuf=
_streamon<br>
&gt;&gt; [ 2023.533839] saa7134: Unknown symbol videobuf_streamon<br>
&gt;&gt; [ 2023.534615] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_device_release<br>
&gt;&gt; [ 2023.534624] saa7134: Unknown symbol video_device_release<br>
&gt;&gt; [ 2023.534736] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_mmap_mapper<br>
&gt;&gt; [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt;&gt; [ 2023.535101] saa7134: disagrees about version of symbol videobuf=
_cgmbuf<br>
&gt;&gt; [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt;&gt; [ 2023.535598] saa7134: disagrees about version of symbol videobuf=
_to_dma<br>
&gt;&gt; [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma<br>
&gt;&gt; [ 2023.535717] saa7134: disagrees about version of symbol videobuf=
_mmap_free<br>
&gt;&gt; [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's<br>
&gt;&gt; current kernel...<br>
&gt;&gt; i have source and header files for this kernel..<br>
&gt;&gt;<br>
&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$ uname -a<br>
&gt;&gt; Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:4=
2<br>
&gt;&gt; UTC 2008 i686 GNU/Linux<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$ ls -l<br>
&gt;&gt; total 45880<br>
&gt;&gt; lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux -&gt; linux-source=
-2.6.24<br>
&gt;&gt; drwxr-xr-x 20 root root 4096 2008-04-22 20:54 linux-headers-2.6.24=
-16<br>
&gt;&gt; drwxr-xr-x 6 root root 4096 2008-04-22 20:54<br>
&gt;&gt; linux-headers-2.6.24-16-generic<br>
&gt;&gt; drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6.24<=
br>
&gt;&gt; -rw-r--r-- 1 root root 46914792 2008-04-10 19:38 linux-source-2.6.=
24.tar.bz2<br>
&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$<br>
&gt;&gt;<br>
&gt;&gt; Attention :<br>
&gt;&gt; should these be applied on 2.6.26.rc2 or 2.6.25 ?<br>
&gt;&gt; i applied to 2.6.24, which is current kernel for ubuntu 8.04...<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; ------------------------------<br>
&gt;&gt;<br>
&gt;&gt; _______________________________________________<br>
&gt;&gt; linux-dvb mailing list<br>
&gt;&gt; linux-dvb@linuxtv.org<br>
&gt;&gt; http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br>
&gt;&gt;<br>
&gt;&gt; End of linux-dvb Digest, Vol 40, Issue 64<br>
&gt;&gt; *****************************************<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; See Exclusive Video: 10th Annual Young Hollywood Awards<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =DD.Bahattin Vidinli<br>
&gt; Elk-Elektronik M=FCh.<br>
&gt; -------------------<br>
&gt; iletisim bilgileri (Tercih sirasina gore):<br>
&gt; skype: bvidinli (sesli gorusme icin, www.skype.com)<br>
&gt; msn: bvidinli@iyibirisi.com<br>
&gt; yahoo: bvidinli<br>
&gt;<br>
&gt; +90.532.7990607<br>
&gt; +90.505.5667711<br>
&gt;<br>
<br>
<br>
<br>
--<br>
=DD.Bahattin Vidinli<br>
Elk-Elektronik M=FCh.<br>
-------------------<br>
iletisim bilgileri (Tercih sirasina gore):<br>
skype: bvidinli (sesli gorusme icin, www.skype.com)<br>
msn: bvidinli@iyibirisi.com<br>
yahoo: bvidinli<br>
<br>
+90.532.7990607<br>
+90.505.5667711<br>
</stev391@email.com></bvidinli@gmail.com></bvidinli@gmail.com></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_121140610563310--



--===============0457605682==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0457605682==--
