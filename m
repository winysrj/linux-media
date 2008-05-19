Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JyDeI-0006fL-3Y
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 00:16:09 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	DBE8C1800D96
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 22:15:25 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: linux-dvb@linuxtv.org
Date: Tue, 20 May 2008 08:15:19 +1000
Message-Id: <20080519221519.DF911478088@ws1-5.us4.outblaze.com>
Subject: Re: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu
 8.04, kernel 2.6.24-16-generic (bvidinli)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0718808823=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0718808823==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1211235319286502"

This is a multi-part message in MIME format.

--_----------=_1211235319286502
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

bvidibli,

To get this working try removing all modules(all files) in the following
directories:
/lib/modules/`uname -r`/ubuntu/media/common/
/lib/modules/`uname -r`/ubuntu/media/dvb/
/lib/modules/`uname -r`/ubuntu/media/radio/
/lib/modules/`uname -r`/ubuntu/media/video/

For some reason Ubuntu decided to rearrange the module directory and
broke the normal make install scripts.

If this breaks something that you need, just reinstall the
linux-ubuntu-modules-`uname -r` package to get them back.

This solved the issues that I had with Unkown symbol and version
disagrees error messages.

Regards,
Stephen.

  Date: Tue, 20 May 2008 00:05:47 +0300
  From: bvidinli
  Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu
  8.04, kernel 2.6.24-16-generic
  To: "Eduard Huguet" , "Matthias Schwarzott"
  , linux-dvb@linuxtv.org
  Message-ID:
  <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
  Content-Type: text/plain; charset=3DISO-8859-1

  Unfortunately, failed,
  below is what i did, if you have any idea, please try to help me...

  Thanks...

  on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current
  kernel.:
  i got sources and headers for this kernel..
  (btw, i learned now that zzam =3D Matthias, thanks.. .)

  i got mercurial,
  i did: hg clone http://linuxtv.org/hg/v4l-dvb
  then, got a700_full_20080519.diff from
  http://dev.gentoo.org/~zzam/dvb/
  i did:
  cd v4l-dvb
  patch -p1 < a700_full_20080519.diff
  make
  (make was successfull, without errors.. )
  sudo make install
  (install was successfull.)


  bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa
  bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod
  make -C /home/bvidinli/v4l-dvb/v4l rmmod
  make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'
  scripts/rmmod.pl unload
  found 233 modules
  /sbin/rmmod saa7134
  /sbin/rmmod videodev
  /sbin/rmmod videobuf_dma_sg
  /sbin/rmmod ir_kbd_i2c
  /sbin/rmmod compat_ioctl32
  /sbin/rmmod v4l1_compat
  /sbin/rmmod v4l2_common
  /sbin/rmmod videobuf_core
  /sbin/rmmod ir_common
  make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'


  bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
  FATAL: Error inserting saa7134
  (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
  Unknown symbol in module, or unknown parameter (see dmesg)
  FATAL: Error running install command for saa7134
  bvidinli@bvidinli-desktop:~/v4l-dvb$



  dmesg is as follows:


  [ 48.937645] saa7134: disagrees about version of symbol
  videobuf_streamoff
  [ 48.937663] saa7134: Unknown symbol videobuf_streamoff
  [ 48.938027] saa7134: disagrees about version of symbol
  videobuf_poll_stream
  [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream
  [ 48.938809] saa7134: disagrees about version of symbol
  videobuf_dma_free
  [ 48.938817] saa7134: Unknown symbol videobuf_dma_free
  [ 48.939134] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs
  [ 48.939779] saa7134: disagrees about version of symbol
  videobuf_waiton
  [ 48.939787] saa7134: Unknown symbol videobuf_waiton
  [ 48.940332] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf
  [ 48.941669] saa7134: disagrees about version of symbol videobuf_stop
  [ 48.941677] saa7134: Unknown symbol videobuf_stop
  [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
  [ 48.942813] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap
  [ 48.942972] saa7134: disagrees about version of symbol
  videobuf_read_stream
  [ 48.942981] saa7134: Unknown symbol videobuf_read_stream
  [ 48.943162] saa7134: disagrees about version of symbol
  videobuf_querybuf
  [ 48.943170] saa7134: Unknown symbol videobuf_querybuf
  [ 48.943520] saa7134: disagrees about version of symbol
  video_unregister_device
  [ 48.943529] saa7134: Unknown symbol video_unregister_device
  [ 48.943647] saa7134: disagrees about version of symbol videobuf_qbuf
  [ 48.943655] saa7134: Unknown symbol videobuf_qbuf
  [ 48.943950] saa7134: disagrees about version of symbol
  video_device_alloc
  [ 48.943958] saa7134: Unknown symbol video_device_alloc
  [ 48.944075] saa7134: disagrees about version of symbol
  videobuf_read_one
  [ 48.944083] saa7134: Unknown symbol videobuf_read_one
  [ 48.944365] saa7134: disagrees about version of symbol
  video_register_device
  [ 48.944373] saa7134: Unknown symbol video_register_device
  [ 48.945156] saa7134: disagrees about version of symbol
  videobuf_iolock
  [ 48.945164] saa7134: Unknown symbol videobuf_iolock
  [ 48.945433] saa7134: disagrees about version of symbol
  videobuf_streamon
  [ 48.945442] saa7134: Unknown symbol videobuf_streamon
  [ 48.946164] saa7134: disagrees about version of symbol
  video_device_release
  [ 48.946172] saa7134: Unknown symbol video_device_release
  [ 48.946287] saa7134: disagrees about version of symbol
  videobuf_mmap_mapper
  [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
  [ 48.946665] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf
  [ 48.947108] saa7134: disagrees about version of symbol
  videobuf_to_dma
  [ 48.947116] saa7134: Unknown symbol videobuf_to_dma
  [ 48.947228] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free

  i rebooted, the same..


  i repeated same compile with patch avertv_A700_dvb_part.diff



  result:
  bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
  FATAL: Error inserting saa7134
  (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
  Unknown symbol in module, or unknown parameter (see dmesg)
  FATAL: Error running install command for saa7134


  here is dmesg related output:
  [ 2023.405692] Linux video capture interface: v2.00
  [ 2023.525841] saa7134: disagrees about version of symbol
  videobuf_streamoff
  [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
  [ 2023.526215] saa7134: disagrees about version of symbol
  videobuf_poll_stream
  [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
  [ 2023.526968] saa7134: disagrees about version of symbol
  videobuf_dma_free
  [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
  [ 2023.527249] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
  [ 2023.527904] saa7134: disagrees about version of symbol
  videobuf_waiton
  [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
  [ 2023.528438] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
  [ 2023.529926] saa7134: disagrees about version of symbol
  videobuf_stop
  [ 2023.529935] saa7134: Unknown symbol videobuf_stop
  [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
  [ 2023.531137] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
  [ 2023.531271] saa7134: disagrees about version of symbol
  videobuf_read_stream
  [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
  [ 2023.531485] saa7134: disagrees about version of symbol
  videobuf_querybuf
  [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
  [ 2023.531832] saa7134: disagrees about version of symbol
  video_unregister_device
  [ 2023.531841] saa7134: Unknown symbol video_unregister_device
  [ 2023.531956] saa7134: disagrees about version of symbol
  videobuf_qbuf
  [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
  [ 2023.532251] saa7134: disagrees about version of symbol
  video_device_alloc
  [ 2023.532260] saa7134: Unknown symbol video_device_alloc
  [ 2023.532373] saa7134: disagrees about version of symbol
  videobuf_read_one
  [ 2023.532381] saa7134: Unknown symbol videobuf_read_one
  [ 2023.532655] saa7134: disagrees about version of symbol
  video_register_device
  [ 2023.532663] saa7134: Unknown symbol video_register_device
  [ 2023.533561] saa7134: disagrees about version of symbol
  videobuf_iolock
  [ 2023.533569] saa7134: Unknown symbol videobuf_iolock
  [ 2023.533831] saa7134: disagrees about version of symbol
  videobuf_streamon
  [ 2023.533839] saa7134: Unknown symbol videobuf_streamon
  [ 2023.534615] saa7134: disagrees about version of symbol
  video_device_release
  [ 2023.534624] saa7134: Unknown symbol video_device_release
  [ 2023.534736] saa7134: disagrees about version of symbol
  videobuf_mmap_mapper
  [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
  [ 2023.535101] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
  [ 2023.535598] saa7134: disagrees about version of symbol
  videobuf_to_dma
  [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
  [ 2023.535717] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free


  my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's
  current kernel...
  i have source and header files for this kernel..

  bvidinli@bvidinli-desktop:/usr/src$ uname -a
  Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42
  UTC 2008 i686 GNU/Linux



  bvidinli@bvidinli-desktop:/usr/src$ ls -l
  total 45880
  lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux ->
  linux-source-2.6.24
  drwxr-xr-x 20 root root 4096 2008-04-22 20:54 linux-headers-2.6.24-16
  drwxr-xr-x 6 root root 4096 2008-04-22 20:54
  linux-headers-2.6.24-16-generic
  drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6.24
  -rw-r--r-- 1 root root 46914792 2008-04-10 19:38
  linux-source-2.6.24.tar.bz2
  bvidinli@bvidinli-desktop:/usr/src$

  Attention :
  should these be applied on 2.6.26.rc2 or 2.6.25 ?
  i applied to 2.6.24, which is current kernel for ubuntu 8.04...



  ------------------------------

  _______________________________________________
  linux-dvb mailing list
  linux-dvb@linuxtv.org
  http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

  End of linux-dvb Digest, Vol 40, Issue 64
  *****************************************

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1211235319286502
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"

<div><tony@tgds.net><linux-dvb@linuxtv.org><pauli@borodulin.fi><mrechberger=
@gmail.com><pauli@borodulin.fi><rscheidegger_lists@hispeed.ch><pauli@borodu=
lin.fi><pauli@borodulin.fi><pauli@borodulin.fi><sroland@tungstengraphics.co=
m><pauli@borodulin.fi><alexanderterhaar@gmail.com><d8ba26160805191256h16f5c=
760md6112dd9612f4bdd@mail.gmail.com></d8ba26160805191256h16f5c760md6112dd96=
12f4bdd@mail.gmail.com></alexanderterhaar@gmail.com></pauli@borodulin.fi></=
sroland@tungstengraphics.com></pauli@borodulin.fi></pauli@borodulin.fi></pa=
uli@borodulin.fi></rscheidegger_lists@hispeed.ch></pauli@borodulin.fi></mre=
chberger@gmail.com></pauli@borodulin.fi></linux-dvb@linuxtv.org></tony@tgds=
.net>bvidibli,<br><br>To get this working try removing all modules(all file=
s) in the following directories:<br>/lib/modules/`uname -r`/ubuntu/media/co=
mmon/<br>/lib/modules/`uname -r`/ubuntu/media/dvb/<br>/lib/modules/`uname -=
r`/ubuntu/media/radio/<br>/lib/modules/`uname -r`/ubuntu/media/video/<br><b=
r>For some reason Ubuntu decided to rearrange the module directory and brok=
e the normal make install scripts.<br><br>If this breaks something that you=
 need, just reinstall the linux-ubuntu-modules-`uname -r` package to get th=
em back.<br><br>This solved the issues that I had with Unkown symbol and ve=
rsion disagrees error messages.<br><br>Regards,<br>Stephen.<br><tony@tgds.n=
et><linux-dvb@linuxtv.org><pauli@borodulin.fi><mrechberger@gmail.com><pauli=
@borodulin.fi><rscheidegger_lists@hispeed.ch><pauli@borodulin.fi><pauli@bor=
odulin.fi><pauli@borodulin.fi><sroland@tungstengraphics.com><pauli@boroduli=
n.fi><alexanderterhaar@gmail.com><d8ba26160805191256h16f5c760md6112dd9612f4=
bdd@mail.gmail.com></d8ba26160805191256h16f5c760md6112dd9612f4bdd@mail.gmai=
l.com></alexanderterhaar@gmail.com></pauli@borodulin.fi></sroland@tungsteng=
raphics.com></pauli@borodulin.fi></pauli@borodulin.fi></pauli@borodulin.fi>=
</rscheidegger_lists@hispeed.ch></pauli@borodulin.fi></mrechberger@gmail.co=
m></pauli@borodulin.fi></linux-dvb@linuxtv.org></tony@tgds.net><blockquote =
style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: 5px; padding=
-left: 5px;"><tony@tgds.net><linux-dvb@linuxtv.org><pauli@borodulin.fi><mre=
chberger@gmail.com><pauli@borodulin.fi><rscheidegger_lists@hispeed.ch><paul=
i@borodulin.fi><pauli@borodulin.fi><pauli@borodulin.fi><sroland@tungstengra=
phics.com><pauli@borodulin.fi><alexanderterhaar@gmail.com><d8ba261608051912=
56h16f5c760md6112dd9612f4bdd@mail.gmail.com>Date: Tue, 20 May 2008 00:05:47=
 +0300<br>
From: bvidinli <bvidinli@gmail.com><br>
Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu<br>
	8.04,	kernel 2.6.24-16-generic<br>
To: "Eduard Huguet" <eduardhc@gmail.com>, 	"Matthias Schwarzott"<br>
	<zzam@gentoo.org>, linux-dvb@linuxtv.org<br>
Message-ID:<br>
	&lt;36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com&gt;<br>
Content-Type: text/plain; charset=3DISO-8859-1<br>
<br>
Unfortunately, failed,<br>
below is what i did, if you have any idea, please try to help me...<br>
<br>
Thanks...<br>
<br>
on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current kernel.:<br>
i got sources and headers for this kernel..<br>
(btw, i learned now that zzam =3D Matthias, thanks.. .)<br>
<br>
i got mercurial,<br>
i did: hg clone http://linuxtv.org/hg/v4l-dvb<br>
then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam/dvb/<br>
i did:<br>
cd v4l-dvb<br>
patch -p1 &lt; a700_full_20080519.diff<br>
make<br>
(make was successfull, without errors.. )<br>
sudo make install<br>
(install was successfull.)<br>
<br>
<br>
bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa<br>
bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod<br>
make -C /home/bvidinli/v4l-dvb/v4l rmmod<br>
make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'<br>
scripts/rmmod.pl unload<br>
found 233 modules<br>
/sbin/rmmod saa7134<br>
/sbin/rmmod videodev<br>
/sbin/rmmod videobuf_dma_sg<br>
/sbin/rmmod ir_kbd_i2c<br>
/sbin/rmmod compat_ioctl32<br>
/sbin/rmmod v4l1_compat<br>
/sbin/rmmod v4l2_common<br>
/sbin/rmmod videobuf_core<br>
/sbin/rmmod ir_common<br>
make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'<br>
<br>
<br>
bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1<br>
FATAL: Error inserting saa7134<br>
(/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<br>
Unknown symbol in module, or unknown parameter (see dmesg)<br>
FATAL: Error running install command for saa7134<br>
bvidinli@bvidinli-desktop:~/v4l-dvb$<br>
<br>
<br>
<br>
dmesg is as follows:<br>
<br>
<br>
[   48.937645] saa7134: disagrees about version of symbol videobuf_streamof=
f<br>
[   48.937663] saa7134: Unknown symbol videobuf_streamoff<br>
[   48.938027] saa7134: disagrees about version of symbol videobuf_poll_str=
eam<br>
[   48.938035] saa7134: Unknown symbol videobuf_poll_stream<br>
[   48.938809] saa7134: disagrees about version of symbol videobuf_dma_free=
<br>
[   48.938817] saa7134: Unknown symbol videobuf_dma_free<br>
[   48.939134] saa7134: disagrees about version of symbol videobuf_reqbufs<=
br>
[   48.939142] saa7134: Unknown symbol videobuf_reqbufs<br>
[   48.939779] saa7134: disagrees about version of symbol videobuf_waiton<b=
r>
[   48.939787] saa7134: Unknown symbol videobuf_waiton<br>
[   48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf<br>
[   48.940340] saa7134: Unknown symbol videobuf_dqbuf<br>
[   48.941669] saa7134: disagrees about version of symbol videobuf_stop<br>
[   48.941677] saa7134: Unknown symbol videobuf_stop<br>
[   48.942673] saa7134: Unknown symbol videobuf_queue_pci_init<br>
[   48.942813] saa7134: disagrees about version of symbol videobuf_dma_unma=
p<br>
[   48.942822] saa7134: Unknown symbol videobuf_dma_unmap<br>
[   48.942972] saa7134: disagrees about version of symbol videobuf_read_str=
eam<br>
[   48.942981] saa7134: Unknown symbol videobuf_read_stream<br>
[   48.943162] saa7134: disagrees about version of symbol videobuf_querybuf=
<br>
[   48.943170] saa7134: Unknown symbol videobuf_querybuf<br>
[   48.943520] saa7134: disagrees about version of symbol<br>
video_unregister_device<br>
[   48.943529] saa7134: Unknown symbol video_unregister_device<br>
[   48.943647] saa7134: disagrees about version of symbol videobuf_qbuf<br>
[   48.943655] saa7134: Unknown symbol videobuf_qbuf<br>
[   48.943950] saa7134: disagrees about version of symbol video_device_allo=
c<br>
[   48.943958] saa7134: Unknown symbol video_device_alloc<br>
[   48.944075] saa7134: disagrees about version of symbol videobuf_read_one=
<br>
[   48.944083] saa7134: Unknown symbol videobuf_read_one<br>
[   48.944365] saa7134: disagrees about version of symbol <br>
video_register_device<br>
[   48.944373] saa7134: Unknown symbol video_register_device<br>
[   48.945156] saa7134: disagrees about version of symbol videobuf_iolock<b=
r>
[   48.945164] saa7134: Unknown symbol videobuf_iolock<br>
[   48.945433] saa7134: disagrees about version of symbol videobuf_streamon=
<br>
[   48.945442] saa7134: Unknown symbol videobuf_streamon<br>
[   48.946164] saa7134: disagrees about version of symbol video_device_rele=
ase<br>
[   48.946172] saa7134: Unknown symbol video_device_release<br>
[   48.946287] saa7134: disagrees about version of symbol videobuf_mmap_map=
per<br>
[   48.946295] saa7134: Unknown symbol videobuf_mmap_mapper<br>
[   48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf<b=
r>
[   48.946673] saa7134: Unknown symbol videobuf_cgmbuf<br>
[   48.947108] saa7134: disagrees about version of symbol videobuf_to_dma<b=
r>
[   48.947116] saa7134: Unknown symbol videobuf_to_dma<br>
[   48.947228] saa7134: disagrees about version of symbol videobuf_mmap_fre=
e<br>
[   48.947237] saa7134: Unknown symbol videobuf_mmap_free<br>
<br>
i rebooted, the same..<br>
<br>
<br>
i repeated same compile with patch avertv_A700_dvb_part.diff<br>
<br>
<br>
<br>
result:<br>
bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1<br>
FATAL: Error inserting saa7134<br>
(/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<br>
Unknown symbol in module, or unknown parameter (see dmesg)<br>
FATAL: Error running install command for saa7134<br>
<br>
<br>
here is dmesg related output:<br>
[ 2023.405692] Linux video capture interface: v2.00<br>
[ 2023.525841] saa7134: disagrees about version of symbol videobuf_streamof=
f<br>
[ 2023.525868] saa7134: Unknown symbol videobuf_streamoff<br>
[ 2023.526215] saa7134: disagrees about version of symbol videobuf_poll_str=
eam<br>
[ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream<br>
[ 2023.526968] saa7134: disagrees about version of symbol videobuf_dma_free=
<br>
[ 2023.526976] saa7134: Unknown symbol videobuf_dma_free<br>
[ 2023.527249] saa7134: disagrees about version of symbol videobuf_reqbufs<=
br>
[ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs<br>
[ 2023.527904] saa7134: disagrees about version of symbol videobuf_waiton<b=
r>
[ 2023.527912] saa7134: Unknown symbol videobuf_waiton<br>
[ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf<br>
[ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf<br>
[ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop<br>
[ 2023.529935] saa7134: Unknown symbol videobuf_stop<br>
[ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init<br>
[ 2023.531137] saa7134: disagrees about version of symbol videobuf_dma_unma=
p<br>
[ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap<br>
[ 2023.531271] saa7134: disagrees about version of symbol videobuf_read_str=
eam<br>
[ 2023.531279] saa7134: Unknown symbol videobuf_read_stream<br>
[ 2023.531485] saa7134: disagrees about version of symbol videobuf_querybuf=
<br>
[ 2023.531494] saa7134: Unknown symbol videobuf_querybuf<br>
[ 2023.531832] saa7134: disagrees about version of symbol<br>
video_unregister_device<br>
[ 2023.531841] saa7134: Unknown symbol video_unregister_device<br>
[ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf<br>
[ 2023.531964] saa7134: Unknown symbol videobuf_qbuf<br>
[ 2023.532251] saa7134: disagrees about version of symbol video_device_allo=
c<br>
[ 2023.532260] saa7134: Unknown symbol video_device_alloc<br>
[ 2023.532373] saa7134: disagrees about version of symbol videobuf_read_one=
<br>
[ 2023.532381] saa7134: Unknown symbol videobuf_read_one<br>
[ 2023.532655] saa7134: disagrees about version of symbol <br>
video_register_device<br>
[ 2023.532663] saa7134: Unknown symbol video_register_device<br>
[ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolock<b=
r>
[ 2023.533569] saa7134: Unknown symbol videobuf_iolock<br>
[ 2023.533831] saa7134: disagrees about version of symbol videobuf_streamon=
<br>
[ 2023.533839] saa7134: Unknown symbol videobuf_streamon<br>
[ 2023.534615] saa7134: disagrees about version of symbol video_device_rele=
ase<br>
[ 2023.534624] saa7134: Unknown symbol video_device_release<br>
[ 2023.534736] saa7134: disagrees about version of symbol videobuf_mmap_map=
per<br>
[ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper<br>
[ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmbuf<b=
r>
[ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf<br>
[ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_dma<b=
r>
[ 2023.535606] saa7134: Unknown symbol videobuf_to_dma<br>
[ 2023.535717] saa7134: disagrees about version of symbol videobuf_mmap_fre=
e<br>
[ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free<br>
<br>
<br>
my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's <br>
current kernel...<br>
i have source and header files for this kernel..<br>
<br>
bvidinli@bvidinli-desktop:/usr/src$ uname -a<br>
Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42<br>
UTC 2008 i686 GNU/Linux<br>
<br>
<br>
<br>
bvidinli@bvidinli-desktop:/usr/src$ ls -l<br>
total 45880<br>
lrwxrwxrwx  1 root src        19 2008-05-19 22:14 linux -&gt; linux-source-=
2.6.24<br>
drwxr-xr-x 20 root root     4096 2008-04-22 20:54 linux-headers-2.6.24-16<b=
r>
drwxr-xr-x  6 root root     4096 2008-04-22 20:54<br>
linux-headers-2.6.24-16-generic<br>
drwxr-xr-x 23 root root     4096 2008-04-10 19:36 linux-source-2.6.24<br>
-rw-r--r--  1 root root 46914792 2008-04-10 19:38 linux-source-2.6.24.tar.b=
z2<br>
bvidinli@bvidinli-desktop:/usr/src$<br>
<br>
Attention :<br>
should these be applied on 2.6.26.rc2 or 2.6.25 ?<br>
i applied to 2.6.24, which is current kernel for ubuntu 8.04...<br>
<br>
<br>
<br>
------------------------------<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
linux-dvb@linuxtv.org<br>
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br>
<br>
End of linux-dvb Digest, Vol 40, Issue 64<br>
*****************************************<br>
</zzam@gentoo.org></eduardhc@gmail.com></bvidinli@gmail.com></d8ba261608051=
91256h16f5c760md6112dd9612f4bdd@mail.gmail.com></alexanderterhaar@gmail.com=
></pauli@borodulin.fi></sroland@tungstengraphics.com></pauli@borodulin.fi><=
/pauli@borodulin.fi></pauli@borodulin.fi></rscheidegger_lists@hispeed.ch></=
pauli@borodulin.fi></mrechberger@gmail.com></pauli@borodulin.fi></linux-dvb=
@linuxtv.org></tony@tgds.net></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1211235319286502--



--===============0718808823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0718808823==--
