Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bvidinli@gmail.com>) id 1JzARW-0004OS-B6
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 15:02:52 +0200
Received: by wr-out-0506.google.com with SMTP id c30so35553wra.14
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 06:02:44 -0700 (PDT)
Message-ID: <36e8a7020805220602j6414ec4cva355e8bf1d4cc8c2@mail.gmail.com>
Date: Thu, 22 May 2008 16:02:42 +0300
From: bvidinli <bvidinli@gmail.com>
To: stev391@email.com, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] fail2: Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04,
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

i wrote the script below, since i do many install about this,
result is same, fail,
i/we miss something on files that we should replace/edit..

i did just as you said about /lib/modules/`uname -r`/ubuntu/
i replaced files there, with script, with manual, retried but result same...
i also replaced files in /lib/modules/`uname -r`/kernel/drivers/media


is there any idea about this ?

#!/bin/bash
echo "i must run this as normal user... press enter to continue"
read

cd
#install mercurial, get v4l files, patch and compile,
sudo apt-get install mercurial linux-headers-$(uname -r) build-essential
hg clone http://linuxtv.org/hg/v4l-dvb
wget http://dev.gentoo.org/~zzam/dvb/a700_full_20080519.diff
cd ~/v4l-dvb/v4l
patch -p1 < ../a700_full_20080519.diff
make


# first, backup all
cd /lib/modules/`uname -r`/kernel/drivers/
sudo cp -rvf media media.bck

cd /lib/modules/`uname -r`/ubuntu/media
sudo cp -rvf saa7134 saa7134.bck

# goto where you got your v4l files by hg
cd ~/v4l-dvb/v4l
sudo cp -f ir-common.ko /lib/modules/`uname -r`/kernel/drivers/media/common/
sudo cp -f saa7146.ko /lib/modules/`uname -r`/kernel/drivers/media/common/
sudo cp -f saa7146_vv.ko /lib/modules/`uname -r`/kernel/drivers/media/commo=
n/

sudo cp -f dvb-core.ko /lib/modules/`uname
-r`/kernel/drivers/media/dvb/dvb-core/


sudo cp -f saa6752hs.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/saa7134/
sudo cp -f saa7134-dvb.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/saa7134/
sudo cp -f saa7134-empress.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/saa7134/
sudo cp -f saa7134.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/saa7134/

sudo cp -f cx23885.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/cx23885/
sudo cp -f cx25840.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/cx25840/

sudo cp -f cx88-blackbird.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/cx88/
sudo cp -f cx88-dvb.ko /lib/modules/`uname -r`/kernel/drivers/media/video/c=
x88/
sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname
-r`/kernel/drivers/media/video/cx88/
sudo cp -f cx88xx.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/
sudo cp -f cx8800.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/
sudo cp -f cx8802.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/



sudo cp -f saa6752hs.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/
sudo cp -f saa7134-dvb.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/
sudo cp -f saa7134-empress.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/
sudo cp -f saa7134.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/

#these two raised error, so, i left them as old.. thre is no file in
v4l dir as -alsa and -oss
sudo cp -f saa7134-alsa.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/
sudo cp -f saa7134-oss.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/



sudo cp -f cx88-blackbird.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
sudo cp -f cx88-dvb.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
sudo cp -f cx88xx.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
sudo cp -f cx8800.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
sudo cp -f cx8802.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
# below line raised error, no file -alsa.ko in v4l
sudo cp -f cx88-alsa.ko /lib/modules/`uname -r`/ubuntu/media/cx88/


echo "replacing all files in
/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/*.ko from
new compiled ones... "
 for i in `ls /lib/modules/`uname -r`/kernel/drivers/media/video/*.ko`
; do i=3D`echo $i | awk -F "/" '{print $NF}'`; ls  $i ; cp -vf $i
/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/ ; done

# remove and reinstall modules
rmmod saa7134_alsa saa7134
depmod -a
modprobe saa7134 i2c_scan=3D1





echo "finished... you may run dmesg to see result.."



result:
(note that this is without make install, before reboot)
[ 6011.912699] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 6011.914021] saa7133[0]: found at 0000:00:14.0, rev: 209, irq: 10,
latency: 32, mmio: 0xde003000
[ 6011.914045] saa7133[0]: subsystem: 1461:a7a2, board:
UNKNOWN/GENERIC [card=3D0,autodetected]
[ 6011.914069] saa7133[0]: board init: gpio is 2fe00
[ 6012.048607] saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048641] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048664] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048687] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048709] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048732] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048755] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.048777] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 6012.068598] saa7133[0]: i2c scan: found device @ 0x1c  [???]
[ 6012.088599] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[ 6012.109784] saa7133[0]: registered device video0 [v4l2]
[ 6012.111066] saa7133[0]: registered device vbi0
[ 6012.176702] saa7134 ALSA driver for DMA sound loaded
[ 6012.177925] saa7133[0]/alsa: saa7133[0] at 0xde003000 irq 10
registered as card -2



after reboot:
[   43.901412] saa7134: disagrees about version of symbol videobuf_streamoff
[   43.901425] saa7134: Unknown symbol videobuf_streamoff
[   43.901792] saa7134: disagrees about version of symbol videobuf_poll_str=
eam
[   43.901800] saa7134: Unknown symbol videobuf_poll_stream
[   43.902582] saa7134: disagrees about version of symbol videobuf_dma_free
[   43.902590] saa7134: Unknown symbol videobuf_dma_free
[   43.902875] saa7134: disagrees about version of symbol videobuf_reqbufs
[   43.902883] saa7134: Unknown symbol videobuf_reqbufs
[   43.903523] saa7134: disagrees about version of symbol videobuf_waiton
[   43.903531] saa7134: Unknown symbol videobuf_waiton
[   43.904079] saa7134: disagrees about version of symbol videobuf_dqbuf
[   43.904087] saa7134: Unknown symbol videobuf_dqbuf
[   43.905471] saa7134: disagrees about version of symbol videobuf_stop
[   43.905479] saa7134: Unknown symbol videobuf_stop
[   43.906472] saa7134: Unknown symbol videobuf_queue_pci_init
[   43.906614] saa7134: disagrees about version of symbol videobuf_dma_unmap
[   43.906623] saa7134: Unknown symbol videobuf_dma_unmap
[   43.906751] saa7134: disagrees about version of symbol videobuf_read_str=
eam
[   43.906759] saa7134: Unknown symbol videobuf_read_stream
[   43.906940] saa7134: disagrees about version of symbol videobuf_querybuf
[   43.906948] saa7134: Unknown symbol videobuf_querybuf
[   43.907300] saa7134: disagrees about version of symbol
video_unregister_device
[   43.907309] saa7134: Unknown symbol video_unregister_device
[   43.907428] saa7134: disagrees about version of symbol videobuf_qbuf
[   43.907436] saa7134: Unknown symbol videobuf_qbuf
[   43.907755] saa7134: disagrees about version of symbol video_device_alloc
[   43.907763] saa7134: Unknown symbol video_device_alloc
[   43.907882] saa7134: disagrees about version of symbol videobuf_read_one
[   43.907890] saa7134: Unknown symbol videobuf_read_one
[   43.908173] saa7134: disagrees about version of symbol video_register_de=
vice
[   43.908181] saa7134: Unknown symbol video_register_device
[   43.909011] saa7134: disagrees about version of symbol videobuf_iolock
[   43.909019] saa7134: Unknown symbol videobuf_iolock
[   43.909292] saa7134: disagrees about version of symbol videobuf_streamon
[   43.909300] saa7134: Unknown symbol videobuf_streamon
[   43.910040] saa7134: disagrees about version of symbol video_device_rele=
ase
[   43.910048] saa7134: Unknown symbol video_device_release
[   43.910164] saa7134: disagrees about version of symbol videobuf_mmap_map=
per
[   43.910173] saa7134: Unknown symbol videobuf_mmap_mapper
[   43.910548] saa7134: disagrees about version of symbol videobuf_cgmbuf
[   43.910556] saa7134: Unknown symbol videobuf_cgmbuf
[   43.910985] saa7134: disagrees about version of symbol videobuf_to_dma
[   43.910993] saa7134: Unknown symbol videobuf_to_dma
[   43.911108] saa7134: disagrees about version of symbol videobuf_mmap_free
[   43.911116] saa7134: Unknown symbol videobuf_mmap_free



the result is same after reboot,
same after reboot, make install in v4l-dvb

we are back in same point...

2008/5/22  <stev391@email.com>:
>
> With ubuntu 8.04 they made a copy of some of the drivers (I had the
> directory structure wrong in my previous email as I have already removed
> mine), check in:
> /lib/modules/`uname -r`/ubuntu/media/
>
> for any folders relating to cx* and saa* and remove them as Ubuntu checks
> here first for the modules instead of the new freshly compiled ones.
> the run depmod -a and try again.
>
> Regards,
>
> Stephen.
>
> ----- Original Message -----
> From: bvidinli
> To: stev391@email.com, linux-dvb@linuxtv.org
> Subject: fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel
> 2.6.24-16-generic (bvidinli)
> Date: Wed, 21 May 2008 16:10:08 +0300
>
> This problem persists, continues,
> does anybody have suggestions ?
>
> i continue on my search of this problem...
>
> thanks.
>
>
> 2008/5/21 bvidinli :
>> i did your suggestions, but result is same.
>>
>> there was no file at locations you specified, (/lib/modules/`uname
>> -r`/ubuntu/media/common/)
>> instead i removed files on :
>> rm -rvf /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/
>> dvb, video, etc...
>>
>> if you/anybody may help me, please do..
>>
>>
>> root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134 i2c_scan=
=3D1
>> FATAL: Error inserting saa7134
>> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
>> Unknown symbol in module, or unknown parameter (see dmesg)
>> FATAL: Error running install command for saa7134
>> root@bvidinli-desktop:/home/bvidinli/v4l-dvb#
>>
>>
>> dmesg output:
>>
>> [ 4261.474794] Linux video capture interface: v2.00
>> [ 4261.603077] saa7134: disagrees about version of symbol
>> videobuf_streamoff
>> [ 4261.603104] saa7134: Unknown symbol videobuf_streamoff
>> [ 4261.603450] saa7134: disagrees about version of symbol
>> videobuf_poll_stream
>> [ 4261.603459] saa7134: Unknown symbol videobuf_poll_stream
>> [ 4261.604240] saa7134: disagrees about version of symbol
>> videobuf_dma_free
>> [ 4261.604249] saa7134: Unknown symbol videobuf_dma_free
>> [ 4261.604521] saa7134: disagrees about version of symbol videobuf_reqbu=
fs
>> [ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs
>> [ 4261.605140] saa7134: disagrees about version of symbol videobuf_waiton
>> [ 4261.605148] saa7134: Unknown symbol videobuf_waiton
>> [ 4261.605672] saa7134: disagrees about version of symbol videobuf_dqbuf
>> [ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf
>> [ 4261.607190] saa7134: disagrees about version of symbol videobuf_stop
>> [ 4261.607199] saa7134: Unknown symbol videobuf_stop
>> [ 4261.608245] saa7134: Unknown symbol videobuf_queue_pci_init
>> [ 4261.608459] saa7134: disagrees about version of symbol
>> videobuf_dma_unmap
>> [ 4261.608467] saa7134: Unknown symbol videobuf_dma_unmap
>> [ 4261.608592] saa7134: disagrees about version of symbol
>> videobuf_read_stream
>> [ 4261.608600] saa7134: Unknown symbol videobuf_read_stream
>> [ 4261.608776] saa7134: disagrees about version of symbol
>> videobuf_querybuf
>> [ 4261.608784] saa7134: Unknown symbol videobuf_querybuf
>> [ 4261.609121] saa7134: disagrees about version of symbol
>> video_unregister_device
>> [ 4261.609130] saa7134: Unknown symbol video_unregister_device
>> [ 4261.609244] saa7134: disagrees about version of symbol videobuf_qbuf
>> [ 4261.609252] saa7134: Unknown symbol videobuf_qbuf
>> [ 4261.609538] saa7134: disagrees about version of symbol
>> video_device_alloc
>> [ 4261.609547] saa7134: Unknown symbol video_device_alloc
>> [ 4261.609660] saa7134: disagrees about version of symbol
>> videobuf_read_one
>> [ 4261.609668] saa7134: Unknown symbol videobuf_read_one
>> [ 4261.609940] saa7134: disagrees about version of symbol
>> video_register_device
>> [ 4261.609948] saa7134: Unknown symbol video_register_device
>> [ 4261.610871] saa7134: disagrees about version of symbol videobuf_iolock
>> [ 4261.610879] saa7134: Unknown symbol videobuf_iolock
>> [ 4261.611139] saa7134: disagrees about version of symbol
>> videobuf_streamon
>> [ 4261.611147] saa7134: Unknown symbol videobuf_streamon
>> [ 4261.611941] saa7134: disagrees about version of symbol
>> video_device_release
>> [ 4261.611950] saa7134: Unknown symbol video_device_release
>> [ 4261.612061] saa7134: disagrees about version of symbol
>> videobuf_mmap_mapper
>> [ 4261.612070] saa7134: Unknown symbol videobuf_mmap_mapper
>> [ 4261.612426] saa7134: disagrees about version of symbol videobuf_cgmbuf
>> [ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf
>> [ 4261.612908] saa7134: disagrees about version of symbol videobuf_to_dma
>> [ 4261.612917] saa7134: Unknown symbol videobuf_to_dma
>> [ 4261.613027] saa7134: disagrees about version of symbol
>> videobuf_mmap_free
>> [ 4261.613035] saa7134: Unknown symbol videobuf_mmap_free
>>
>>
>>
>> 2008/5/20 :
>>> bvidibli,
>>>
>>> To get this working try removing all modules(all files) in the following
>>> directories:
>>> /lib/modules/`uname -r`/ubuntu/media/common/
>>> /lib/modules/`uname -r`/ubuntu/media/dvb/
>>> /lib/modules/`uname -r`/ubuntu/media/radio/
>>> /lib/modules/`uname -r`/ubuntu/media/video/
>>>
>>> For some reason Ubuntu decided to rearrange the module directory and
>>> broke
>>> the normal make install scripts.
>>>
>>> If this breaks something that you need, just reinstall the
>>> linux-ubuntu-modules-`uname -r` package to get them back.
>>>
>>> This solved the issues that I had with Unkown symbol and version
>>> disagrees
>>> error messages.
>>>
>>> Regards,
>>> Stephen.
>>>
>>> Date: Tue, 20 May 2008 00:05:47 +0300
>>> From: bvidinli
>>> Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on ubuntu
>>> 8.04, kernel 2.6.24-16-generic
>>> To: "Eduard Huguet" , "Matthias Schwarzott"
>>> , linux-dvb@linuxtv.org
>>> Message-ID:
>>> <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
>>> Content-Type: text/plain; charset=3DISO-8859-1
>>>
>>> Unfortunately, failed,
>>> below is what i did, if you have any idea, please try to help me...
>>>
>>> Thanks...
>>>
>>> on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current kernel.:
>>> i got sources and headers for this kernel..
>>> (btw, i learned now that zzam =3D Matthias, thanks.. .)
>>>
>>> i got mercurial,
>>> i did: hg clone http://linuxtv.org/hg/v4l-dvb
>>> then, got a700_full_20080519.diff from http://dev.gentoo.org/~zzam/dvb/
>>> i did:
>>> cd v4l-dvb
>>> patch -p1 < a700_full_20080519.diff
>>> make
>>> (make was successfull, without errors.. )
>>> sudo make install
>>> (install was successfull.)
>>>
>>>
>>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa
>>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod
>>> make -C /home/bvidinli/v4l-dvb/v4l rmmod
>>> make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'
>>> scripts/rmmod.pl unload
>>> found 233 modules
>>> /sbin/rmmod saa7134
>>> /sbin/rmmod videodev
>>> /sbin/rmmod videobuf_dma_sg
>>> /sbin/rmmod ir_kbd_i2c
>>> /sbin/rmmod compat_ioctl32
>>> /sbin/rmmod v4l1_compat
>>> /sbin/rmmod v4l2_common
>>> /sbin/rmmod videobuf_core
>>> /sbin/rmmod ir_common
>>> make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'
>>>
>>>
>>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
>>> FATAL: Error inserting saa7134
>>> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
>>> Unknown symbol in module, or unknown parameter (see dmesg)
>>> FATAL: Error running install command for saa7134
>>> bvidinli@bvidinli-desktop:~/v4l-dvb$
>>>
>>>
>>>
>>> dmesg is as follows:
>>>
>>>
>>> [ 48.937645] saa7134: disagrees about version of symbol
>>> videobuf_streamoff
>>> [ 48.937663] saa7134: Unknown symbol videobuf_streamoff
>>> [ 48.938027] saa7134: disagrees about version of symbol
>>> videobuf_poll_stream
>>> [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream
>>> [ 48.938809] saa7134: disagrees about version of symbol videobuf_dma_fr=
ee
>>> [ 48.938817] saa7134: Unknown symbol videobuf_dma_free
>>> [ 48.939134] saa7134: disagrees about version of symbol videobuf_reqbufs
>>> [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs
>>> [ 48.939779] saa7134: disagrees about version of symbol videobuf_waiton
>>> [ 48.939787] saa7134: Unknown symbol videobuf_waiton
>>> [ 48.940332] saa7134: disagrees about version of symbol videobuf_dqbuf
>>> [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf
>>> [ 48.941669] saa7134: disagrees about version of symbol videobuf_stop
>>> [ 48.941677] saa7134: Unknown symbol videobuf_stop
>>> [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
>>> [ 48.942813] saa7134: disagrees about version of symbol
>>> videobuf_dma_unmap
>>> [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap
>>> [ 48.942972] saa7134: disagrees about version of symbol
>>> videobuf_read_stream
>>> [ 48.942981] saa7134: Unknown symbol videobuf_read_stream
>>> [ 48.943162] saa7134: disagrees about version of symbol videobuf_queryb=
uf
>>> [ 48.943170] saa7134: Unknown symbol videobuf_querybuf
>>> [ 48.943520] saa7134: disagrees about version of symbol
>>> video_unregister_device
>>> [ 48.943529] saa7134: Unknown symbol video_unregister_device
>>> [ 48.943647] saa7134: disagrees about version of symbol videobuf_qbuf
>>> [ 48.943655] saa7134: Unknown symbol videobuf_qbuf
>>> [ 48.943950] saa7134: disagrees about version of symbol
>>> video_device_alloc
>>> [ 48.943958] saa7134: Unknown symbol video_device_alloc
>>> [ 48.944075] saa7134: disagrees about version of symbol videobuf_read_o=
ne
>>> [ 48.944083] saa7134: Unknown symbol videobuf_read_one
>>> [ 48.944365] saa7134: disagrees about version of symbol
>>> video_register_device
>>> [ 48.944373] saa7134: Unknown symbol video_register_device
>>> [ 48.945156] saa7134: disagrees about version of symbol videobuf_iolock
>>> [ 48.945164] saa7134: Unknown symbol videobuf_iolock
>>> [ 48.945433] saa7134: disagrees about version of symbol videobuf_stream=
on
>>> [ 48.945442] saa7134: Unknown symbol videobuf_streamon
>>> [ 48.946164] saa7134: disagrees about version of symbol
>>> video_device_release
>>> [ 48.946172] saa7134: Unknown symbol video_device_release
>>> [ 48.946287] saa7134: disagrees about version of symbol
>>> videobuf_mmap_mapper
>>> [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
>>> [ 48.946665] saa7134: disagrees about version of symbol videobuf_cgmbuf
>>> [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf
>>> [ 48.947108] saa7134: disagrees about version of symbol videobuf_to_dma
>>> [ 48.947116] saa7134: Unknown symbol videobuf_to_dma
>>> [ 48.947228] saa7134: disagrees about version of symbol
>>> videobuf_mmap_free
>>> [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free
>>>
>>> i rebooted, the same..
>>>
>>>
>>> i repeated same compile with patch avertv_A700_dvb_part.diff
>>>
>>>
>>>
>>> result:
>>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c_scan=3D1
>>> FATAL: Error inserting saa7134
>>> (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):
>>> Unknown symbol in module, or unknown parameter (see dmesg)
>>> FATAL: Error running install command for saa7134
>>>
>>>
>>> here is dmesg related output:
>>> [ 2023.405692] Linux video capture interface: v2.00
>>> [ 2023.525841] saa7134: disagrees about version of symbol
>>> videobuf_streamoff
>>> [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff
>>> [ 2023.526215] saa7134: disagrees about version of symbol
>>> videobuf_poll_stream
>>> [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream
>>> [ 2023.526968] saa7134: disagrees about version of symbol
>>> videobuf_dma_free
>>> [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free
>>> [ 2023.527249] saa7134: disagrees about version of symbol
>>> videobuf_reqbufs
>>> [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs
>>> [ 2023.527904] saa7134: disagrees about version of symbol videobuf_wait=
on
>>> [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
>>> [ 2023.528438] saa7134: disagrees about version of symbol videobuf_dqbuf
>>> [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
>>> [ 2023.529926] saa7134: disagrees about version of symbol videobuf_stop
>>> [ 2023.529935] saa7134: Unknown symbol videobuf_stop
>>> [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init
>>> [ 2023.531137] saa7134: disagrees about version of symbol
>>> videobuf_dma_unmap
>>> [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap
>>> [ 2023.531271] saa7134: disagrees about version of symbol
>>> videobuf_read_stream
>>> [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream
>>> [ 2023.531485] saa7134: disagrees about version of symbol
>>> videobuf_querybuf
>>> [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf
>>> [ 2023.531832] saa7134: disagrees about version of symbol
>>> video_unregister_device
>>> [ 2023.531841] saa7134: Unknown symbol video_unregister_device
>>> [ 2023.531956] saa7134: disagrees about version of symbol videobuf_qbuf
>>> [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf
>>> [ 2023.532251] saa7134: disagrees about version of symbol
>>> video_device_alloc
>>> [ 2023.532260] saa7134: Unknown symbol video_device_alloc
>>> [ 2023.532373] saa7134: disagrees about version of symbol
>>> videobuf_read_one
>>> [ 2023.532381] saa7134: Unknown symbol videobuf_read_one
>>> [ 2023.532655] saa7134: disagrees about version of symbol
>>> video_register_device
>>> [ 2023.532663] saa7134: Unknown symbol video_register_device
>>> [ 2023.533561] saa7134: disagrees about version of symbol videobuf_iolo=
ck
>>> [ 2023.533569] saa7134: Unknown symbol videobuf_iolock
>>> [ 2023.533831] saa7134: disagrees about version of symbol
>>> videobuf_streamon
>>> [ 2023.533839] saa7134: Unknown symbol videobuf_streamon
>>> [ 2023.534615] saa7134: disagrees about version of symbol
>>> video_device_release
>>> [ 2023.534624] saa7134: Unknown symbol video_device_release
>>> [ 2023.534736] saa7134: disagrees about version of symbol
>>> videobuf_mmap_mapper
>>> [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper
>>> [ 2023.535101] saa7134: disagrees about version of symbol videobuf_cgmb=
uf
>>> [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
>>> [ 2023.535598] saa7134: disagrees about version of symbol videobuf_to_d=
ma
>>> [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma
>>> [ 2023.535717] saa7134: disagrees about version of symbol
>>> videobuf_mmap_free
>>> [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free
>>>
>>>
>>> my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's
>>> current kernel...
>>> i have source and header files for this kernel..
>>>
>>> bvidinli@bvidinli-desktop:/usr/src$ uname -a
>>> Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:23:42
>>> UTC 2008 i686 GNU/Linux
>>>
>>>
>>>
>>> bvidinli@bvidinli-desktop:/usr/src$ ls -l
>>> total 45880
>>> lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux -> linux-source-2.6.24
>>> drwxr-xr-x 20 root root 4096 2008-04-22 20:54 linux-headers-2.6.24-16
>>> drwxr-xr-x 6 root root 4096 2008-04-22 20:54
>>> linux-headers-2.6.24-16-generic
>>> drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6.24
>>> -rw-r--r-- 1 root root 46914792 2008-04-10 19:38
>>> linux-source-2.6.24.tar.bz2
>>> bvidinli@bvidinli-desktop:/usr/src$
>>>
>>> Attention :
>>> should these be applied on 2.6.26.rc2 or 2.6.25 ?
>>> i applied to 2.6.24, which is current kernel for ubuntu 8.04...
>>>
>>>
>>>
>>> ------------------------------
>>>
>>> _______________________________________________
>>> linux-dvb mailing list
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>> End of linux-dvb Digest, Vol 40, Issue 64
>>> *****************************************
>>>
>>> --
>>> See Exclusive Video: 10th Annual Young Hollywood Awards
>>>
>>
>>
>>
>> --
>> =DD.Bahattin Vidinli
>> Elk-Elektronik M=FCh.
>> -------------------
>> iletisim bilgileri (Tercih sirasina gore):
>> skype: bvidinli (sesli gorusme icin, www.skype.com)
>> msn: bvidinli@iyibirisi.com
>> yahoo: bvidinli
>>
>> +90.532.7990607
>> +90.505.5667711
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
