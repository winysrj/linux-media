Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1Jyhz3-00057x-2w
	for linux-dvb@linuxtv.org; Wed, 21 May 2008 08:39:35 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2771228rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 23:39:26 -0700 (PDT)
Message-ID: <36e8a7020805202339t2f1442bu9eb4521a751ca1cd@mail.gmail.com>
Date: Wed, 21 May 2008 09:39:26 +0300
From: bvidinli <bvidinli@gmail.com>
To: stev391@email.com, linux-dvb@linuxtv.org
In-Reply-To: <20080519221519.DF911478088@ws1-5.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080519221519.DF911478088@ws1-5.us4.outblaze.com>
Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
	kernel 2.6.24-16-generic (bvidinli)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

i did your suggestions, but result is same.

there was no file at locations you specified, (/lib/modules/`uname
-r`/ubuntu/media/common/)
instead i removed files on :
rm -rvf /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/
dvb, video, etc...

if you/anybody may help me, please do..


root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134 i2c_scan=3D1
FATAL: Error inserting saa7134
(/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error running install command for saa7134
root@bvidinli-desktop:/home/bvidinli/v4l-dvb#


dmesg output:

[ 4261.474794] Linux video capture interface: v2.00
[ 4261.603077] saa7134: disagrees about version of symbol videobuf_streamoff
[ 4261.603104] saa7134: Unknown symbol videobuf_streamoff
[ 4261.603450] saa7134: disagrees about version of symbol videobuf_poll_str=
eam
[ 4261.603459] saa7134: Unknown symbol videobuf_poll_stream
[ 4261.604240] saa7134: disagrees about version of symbol videobuf_dma_free
[ 4261.604249] saa7134: Unknown symbol videobuf_dma_free
[ 4261.604521] saa7134: disagrees about version of symbol videobuf_reqbufs
[ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs
[ 4261.605140] saa7134: disagrees about version of symbol videobuf_waiton
[ 4261.605148] saa7134: Unknown symbol videobuf_waiton
[ 4261.605672] saa7134: disagrees about version of symbol videobuf_dqbuf
[ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf
[ 4261.607190] saa7134: disagrees about version of symbol videobuf_stop
[ 4261.607199] saa7134: Unknown symbol videobuf_stop
[ 4261.608245] saa7134: Unknown symbol videobuf_queue_pci_init
[ 4261.608459] saa7134: disagrees about version of symbol videobuf_dma_unmap
[ 4261.608467] saa7134: Unknown symbol videobuf_dma_unmap
[ 4261.608592] saa7134: disagrees about version of symbol videobuf_read_str=
eam
[ 4261.608600] saa7134: Unknown symbol videobuf_read_stream
[ 4261.608776] saa7134: disagrees about version of symbol videobuf_querybuf
[ 4261.608784] saa7134: Unknown symbol videobuf_querybuf
[ 4261.609121] saa7134: disagrees about version of symbol
video_unregister_device
[ 4261.609130] saa7134: Unknown symbol video_unregister_device
[ 4261.609244] saa7134: disagrees about version of symbol videobuf_qbuf
[ 4261.609252] saa7134: Unknown symbol videobuf_qbuf
[ 4261.609538] saa7134: disagrees about version of symbol video_device_alloc
[ 4261.609547] saa7134: Unknown symbol video_device_alloc
[ 4261.609660] saa7134: disagrees about version of symbol videobuf_read_one
[ 4261.609668] saa7134: Unknown symbol videobuf_read_one
[ 4261.609940] saa7134: disagrees about version of symbol video_register_de=
vice
[ 4261.609948] saa7134: Unknown symbol video_register_device
[ 4261.610871] saa7134: disagrees about version of symbol videobuf_iolock
[ 4261.610879] saa7134: Unknown symbol videobuf_iolock
[ 4261.611139] saa7134: disagrees about version of symbol videobuf_streamon
[ 4261.611147] saa7134: Unknown symbol videobuf_streamon
[ 4261.611941] saa7134: disagrees about version of symbol video_device_rele=
ase
[ 4261.611950] saa7134: Unknown symbol video_device_release
[ 4261.612061] saa7134: disagrees about version of symbol videobuf_mmap_map=
per
[ 4261.612070] saa7134: Unknown symbol videobuf_mmap_mapper
[ 4261.612426] saa7134: disagrees about version of symbol videobuf_cgmbuf
[ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf
[ 4261.612908] saa7134: disagrees about version of symbol videobuf_to_dma
[ 4261.612917] saa7134: Unknown symbol videobuf_to_dma
[ 4261.613027] saa7134: disagrees about version of symbol videobuf_mmap_free
[ 4261.613035] saa7134: Unknown symbol videobuf_mmap_free



2008/5/20  <stev391@email.com>:
> bvidibli,
>
> To get this working try removing all modules(all files) in the following
> directories:
> /lib/modules/`uname -r`/ubuntu/media/common/
> /lib/modules/`uname -r`/ubuntu/media/dvb/
> /lib/modules/`uname -r`/ubuntu/media/radio/
> /lib/modules/`uname -r`/ubuntu/media/video/
>
> For some reason Ubuntu decided to rearrange the module directory and broke
> the normal make install scripts.
>
> If this breaks something that you need, just reinstall the
> linux-ubuntu-modules-`uname -r` package to get them back.
>
> This solved the issues that I had with Unkown symbol and version disagrees
> error messages.
>
> Regards,
> Stephen.
>
> Date: Tue, 20 May 2008 00:05:47 +0300
> From: bvidinli
> Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu
> 8.04, kernel 2.6.24-16-generic
> To: "Eduard Huguet" , "Matthias Schwarzott"
> , linux-dvb@linuxtv.org
> Message-ID:
> <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
> Content-Type: text/plain; charset=3DISO-8859-1
>
> Unfortunately, failed,
> below is what i did, if you have any idea, please try to help me...
>
> Thanks...
>
> on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current kernel.:
> i got sources and headers for this kernel..
> (btw, i learned now that zzam =3D Matthias, thanks.. .)
>
> i got mercurial,
> i did: hg clone http://linuxtv.org/hg/v4l-dvb
> then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam/dvb/
> i did:
> cd v4l-dvb
> patch -p1 < a700_full_20080519.diff
> make
> (make was successfull, without errors.. )
> sudo make install
> (install was successfull.)
>
>
> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa
> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod
> make -C /home/bvidinli/v4l-dvb/v4l rmmod
> make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'
> scripts/rmmod.pl unload
> found 233 modules
> /sbin/rmmod saa7134
> /sbin/rmmod videodev
> /sbin/rmmod videobuf_dma_sg
> /sbin/rmmod ir_kbd_i2c
> /sbin/rmmod compat_ioctl32
> /sbin/rmmod v4l1_compat
> /sbin/rmmod v4l2_common
> /sbin/rmmod videobuf_core
> /sbin/rmmod ir_common
> make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'
>
>
> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
> FATAL: Error inserting saa7134
> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error running install command for saa7134
> bvidinli@bvidinli-desktop:~/v4l-dvb$
>
>
>
> dmesg is as follows:
>
>
> [ 48.937645] saa7134: disagrees about version of symbol videobuf_streamoff
> [ 48.937663] saa7134: Unknown symbol videobuf_streamoff
> [ 48.938027] saa7134: disagrees about version of symbol videobuf_poll_str=
eam
> [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream
> [ 48.938809] saa7134: disagrees about version of symbol videobuf_dma_free
> [ 48.938817] saa7134: Unknown symbol videobuf_dma_free
> [ 48.939134] saa7134: disagrees about version of symbol videobuf_reqbufs
> [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs
> [ 48.939779] saa7134: disagrees about version of symbol videobuf_waiton
> [ 48.939787] saa7134: Unknown symbol videobuf_waiton
> [ 48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf
> [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf
> [ 48.941669] saa7134: disagrees about version of symbol videobuf_stop
> [ 48.941677] saa7134: Unknown symbol videobuf_stop
> [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
> [ 48.942813] saa7134: disagrees about version of symbol videobuf_dma_unmap
> [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap
> [ 48.942972] saa7134: disagrees about version of symbol videobuf_read_str=
eam
> [ 48.942981] saa7134: Unknown symbol videobuf_read_stream
> [ 48.943162] saa7134: disagrees about version of symbol videobuf_querybuf
> [ 48.943170] saa7134: Unknown symbol videobuf_querybuf
> [ 48.943520] saa7134: disagrees about version of symbol
> video_unregister_device
> [ 48.943529] saa7134: Unknown symbol video_unregister_device
> [ 48.943647] saa7134: disagrees about version of symbol videobuf_qbuf
> [ 48.943655] saa7134: Unknown symbol videobuf_qbuf
> [ 48.943950] saa7134: disagrees about version of symbol video_device_alloc
> [ 48.943958] saa7134: Unknown symbol video_device_alloc
> [ 48.944075] saa7134: disagrees about version of symbol videobuf_read_one
> [ 48.944083] saa7134: Unknown symbol videobuf_read_one
> [ 48.944365] saa7134: disagrees about version of symbol
> video_register_device
> [ 48.944373] saa7134: Unknown symbol video_register_device
> [ 48.945156] saa7134: disagrees about version of symbol videobuf_iolock
> [ 48.945164] saa7134: Unknown symbol videobuf_iolock
> [ 48.945433] saa7134: disagrees about version of symbol videobuf_streamon
> [ 48.945442] saa7134: Unknown symbol videobuf_streamon
> [ 48.946164] saa7134: disagrees about version of symbol video_device_rele=
ase
> [ 48.946172] saa7134: Unknown symbol video_device_release
> [ 48.946287] saa7134: disagrees about version of symbol videobuf_mmap_map=
per
> [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
> [ 48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf
> [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf
> [ 48.947108] saa7134: disagrees about version of symbol videobuf_to_dma
> [ 48.947116] saa7134: Unknown symbol videobuf_to_dma
> [ 48.947228] saa7134: disagrees about version of symbol videobuf_mmap_free
> [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free
>
> i rebooted, the same..
>
>
> i repeated same compile with patch avertv_A700_dvb_part.diff
>
>
>
> result:
> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
> FATAL: Error inserting saa7134
> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error running install command for saa7134
>
>
> here is dmesg related output:
> [ 2023.405692] Linux video capture interface: v2.00
> [ 2023.525841] saa7134: disagrees about version of symbol videobuf_stream=
off
> [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
> [ 2023.526215] saa7134: disagrees about version of symbol
> videobuf_poll_stream
> [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
> [ 2023.526968] saa7134: disagrees about version of symbol videobuf_dma_fr=
ee
> [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
> [ 2023.527249] saa7134: disagrees about version of symbol videobuf_reqbufs
> [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
> [ 2023.527904] saa7134: disagrees about version of symbol videobuf_waiton
> [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
> [ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf
> [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
> [ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop
> [ 2023.529935] saa7134: Unknown symbol videobuf_stop
> [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
> [ 2023.531137] saa7134: disagrees about version of symbol videobuf_dma_un=
map
> [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
> [ 2023.531271] saa7134: disagrees about version of symbol
> videobuf_read_stream
> [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
> [ 2023.531485] saa7134: disagrees about version of symbol videobuf_queryb=
uf
> [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
> [ 2023.531832] saa7134: disagrees about version of symbol
> video_unregister_device
> [ 2023.531841] saa7134: Unknown symbol video_unregister_device
> [ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf
> [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
> [ 2023.532251] saa7134: disagrees about version of symbol video_device_al=
loc
> [ 2023.532260] saa7134: Unknown symbol video_device_alloc
> [ 2023.532373] saa7134: disagrees about version of symbol videobuf_read_o=
ne
> [ 2023.532381] saa7134: Unknown symbol videobuf_read_one
> [ 2023.532655] saa7134: disagrees about version of symbol
> video_register_device
> [ 2023.532663] saa7134: Unknown symbol video_register_device
> [ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolock
> [ 2023.533569] saa7134: Unknown symbol videobuf_iolock
> [ 2023.533831] saa7134: disagrees about version of symbol videobuf_stream=
on
> [ 2023.533839] saa7134: Unknown symbol videobuf_streamon
> [ 2023.534615] saa7134: disagrees about version of symbol
> video_device_release
> [ 2023.534624] saa7134: Unknown symbol video_device_release
> [ 2023.534736] saa7134: disagrees about version of symbol
> videobuf_mmap_mapper
> [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
> [ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmbuf
> [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
> [ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_dma
> [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
> [ 2023.535717] saa7134: disagrees about version of symbol videobuf_mmap_f=
ree
> [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free
>
>
> my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's
> current kernel...
> i have source and header files for this kernel..
>
> bvidinli@bvidinli-desktop:/usr/src$ uname -a
> Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42
> UTC 2008 i686 GNU/Linux
>
>
>
> bvidinli@bvidinli-desktop:/usr/src$ ls -l
> total 45880
> lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux -> linux-source-2.6.24
> drwxr-xr-x 20 root root 4096 2008-04-22 20:54 linux-headers-2.6.24-16
> drwxr-xr-x 6 root root 4096 2008-04-22 20:54
> linux-headers-2.6.24-16-generic
> drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6.24
> -rw-r--r-- 1 root root 46914792 2008-04-10 19:38 linux-source-2.6.24.tar.=
bz2
> bvidinli@bvidinli-desktop:/usr/src$
>
> Attention :
> should these be applied on 2.6.26.rc2 or 2.6.25 ?
> i applied to 2.6.24, which is current kernel for ubuntu 8.04...
>
>
>
> ------------------------------
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> End of linux-dvb Digest, Vol 40, Issue 64
> *****************************************
>
> --
> See Exclusive Video: 10th Annual Young Hollywood Awards
>



-- =

=DD.Bahattin Vidinli
Elk-Elektronik M=FCh.
-------------------
iletisim bilgileri (Tercih sirasina gore):
skype: bvidinli (sesli gorusme icin, www.skype.com)
msn: bvidinli@iyibirisi.com
yahoo: bvidinli

+90.532.7990607
+90.505.5667711
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
