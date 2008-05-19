Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1JyCYg-0003G4-0A
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 23:06:17 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1844170wag.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 14:05:47 -0700 (PDT)
Message-ID: <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
Date: Tue, 20 May 2008 00:05:47 +0300
From: bvidinli <bvidinli@gmail.com>
To: "Eduard Huguet" <eduardhc@gmail.com>,
	"Matthias Schwarzott" <zzam@gentoo.org>, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
	kernel 2.6.24-16-generic
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

Unfortunately, failed,
below is what i did, if you have any idea, please try to help me...

Thanks...

on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current kernel.:
i got sources and headers for this kernel..
(btw, i learned now that zzam = Matthias, thanks.. .)

i got mercurial,
i did: hg clone http://linuxtv.org/hg/v4l-dvb
then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam/dvb/
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


bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1
FATAL: Error inserting saa7134
(/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error running install command for saa7134
bvidinli@bvidinli-desktop:~/v4l-dvb$



dmesg is as follows:


[   48.937645] saa7134: disagrees about version of symbol videobuf_streamoff
[   48.937663] saa7134: Unknown symbol videobuf_streamoff
[   48.938027] saa7134: disagrees about version of symbol videobuf_poll_stream
[   48.938035] saa7134: Unknown symbol videobuf_poll_stream
[   48.938809] saa7134: disagrees about version of symbol videobuf_dma_free
[   48.938817] saa7134: Unknown symbol videobuf_dma_free
[   48.939134] saa7134: disagrees about version of symbol videobuf_reqbufs
[   48.939142] saa7134: Unknown symbol videobuf_reqbufs
[   48.939779] saa7134: disagrees about version of symbol videobuf_waiton
[   48.939787] saa7134: Unknown symbol videobuf_waiton
[   48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf
[   48.940340] saa7134: Unknown symbol videobuf_dqbuf
[   48.941669] saa7134: disagrees about version of symbol videobuf_stop
[   48.941677] saa7134: Unknown symbol videobuf_stop
[   48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
[   48.942813] saa7134: disagrees about version of symbol videobuf_dma_unmap
[   48.942822] saa7134: Unknown symbol videobuf_dma_unmap
[   48.942972] saa7134: disagrees about version of symbol videobuf_read_stream
[   48.942981] saa7134: Unknown symbol videobuf_read_stream
[   48.943162] saa7134: disagrees about version of symbol videobuf_querybuf
[   48.943170] saa7134: Unknown symbol videobuf_querybuf
[   48.943520] saa7134: disagrees about version of symbol
video_unregister_device
[   48.943529] saa7134: Unknown symbol video_unregister_device
[   48.943647] saa7134: disagrees about version of symbol videobuf_qbuf
[   48.943655] saa7134: Unknown symbol videobuf_qbuf
[   48.943950] saa7134: disagrees about version of symbol video_device_alloc
[   48.943958] saa7134: Unknown symbol video_device_alloc
[   48.944075] saa7134: disagrees about version of symbol videobuf_read_one
[   48.944083] saa7134: Unknown symbol videobuf_read_one
[   48.944365] saa7134: disagrees about version of symbol video_register_device
[   48.944373] saa7134: Unknown symbol video_register_device
[   48.945156] saa7134: disagrees about version of symbol videobuf_iolock
[   48.945164] saa7134: Unknown symbol videobuf_iolock
[   48.945433] saa7134: disagrees about version of symbol videobuf_streamon
[   48.945442] saa7134: Unknown symbol videobuf_streamon
[   48.946164] saa7134: disagrees about version of symbol video_device_release
[   48.946172] saa7134: Unknown symbol video_device_release
[   48.946287] saa7134: disagrees about version of symbol videobuf_mmap_mapper
[   48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
[   48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf
[   48.946673] saa7134: Unknown symbol videobuf_cgmbuf
[   48.947108] saa7134: disagrees about version of symbol videobuf_to_dma
[   48.947116] saa7134: Unknown symbol videobuf_to_dma
[   48.947228] saa7134: disagrees about version of symbol videobuf_mmap_free
[   48.947237] saa7134: Unknown symbol videobuf_mmap_free

i rebooted, the same..


i repeated same compile with patch avertv_A700_dvb_part.diff



result:
bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=1
FATAL: Error inserting saa7134
(/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error running install command for saa7134


here is dmesg related output:
[ 2023.405692] Linux video capture interface: v2.00
[ 2023.525841] saa7134: disagrees about version of symbol videobuf_streamoff
[ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
[ 2023.526215] saa7134: disagrees about version of symbol videobuf_poll_stream
[ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
[ 2023.526968] saa7134: disagrees about version of symbol videobuf_dma_free
[ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
[ 2023.527249] saa7134: disagrees about version of symbol videobuf_reqbufs
[ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
[ 2023.527904] saa7134: disagrees about version of symbol videobuf_waiton
[ 2023.527912] saa7134: Unknown symbol videobuf_waiton
[ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf
[ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
[ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop
[ 2023.529935] saa7134: Unknown symbol videobuf_stop
[ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
[ 2023.531137] saa7134: disagrees about version of symbol videobuf_dma_unmap
[ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
[ 2023.531271] saa7134: disagrees about version of symbol videobuf_read_stream
[ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
[ 2023.531485] saa7134: disagrees about version of symbol videobuf_querybuf
[ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
[ 2023.531832] saa7134: disagrees about version of symbol
video_unregister_device
[ 2023.531841] saa7134: Unknown symbol video_unregister_device
[ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf
[ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
[ 2023.532251] saa7134: disagrees about version of symbol video_device_alloc
[ 2023.532260] saa7134: Unknown symbol video_device_alloc
[ 2023.532373] saa7134: disagrees about version of symbol videobuf_read_one
[ 2023.532381] saa7134: Unknown symbol videobuf_read_one
[ 2023.532655] saa7134: disagrees about version of symbol video_register_device
[ 2023.532663] saa7134: Unknown symbol video_register_device
[ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolock
[ 2023.533569] saa7134: Unknown symbol videobuf_iolock
[ 2023.533831] saa7134: disagrees about version of symbol videobuf_streamon
[ 2023.533839] saa7134: Unknown symbol videobuf_streamon
[ 2023.534615] saa7134: disagrees about version of symbol video_device_release
[ 2023.534624] saa7134: Unknown symbol video_device_release
[ 2023.534736] saa7134: disagrees about version of symbol videobuf_mmap_mapper
[ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
[ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmbuf
[ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
[ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_dma
[ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
[ 2023.535717] saa7134: disagrees about version of symbol videobuf_mmap_free
[ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free


my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's current kernel...
i have source and header files for this kernel..

bvidinli@bvidinli-desktop:/usr/src$ uname -a
Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42
UTC 2008 i686 GNU/Linux



bvidinli@bvidinli-desktop:/usr/src$ ls -l
total 45880
lrwxrwxrwx  1 root src        19 2008-05-19 22:14 linux -> linux-source-2.6.24
drwxr-xr-x 20 root root     4096 2008-04-22 20:54 linux-headers-2.6.24-16
drwxr-xr-x  6 root root     4096 2008-04-22 20:54
linux-headers-2.6.24-16-generic
drwxr-xr-x 23 root root     4096 2008-04-10 19:36 linux-source-2.6.24
-rw-r--r--  1 root root 46914792 2008-04-10 19:38 linux-source-2.6.24.tar.bz2
bvidinli@bvidinli-desktop:/usr/src$

Attention :
should these be applied on 2.6.26.rc2 or 2.6.25 ?
i applied to 2.6.24, which is current kernel for ubuntu 8.04...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
