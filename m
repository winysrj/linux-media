Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JzKB9-00080y-PS
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 01:26:39 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	A940F18001A0
	for <linux-dvb@linuxtv.org>; Thu, 22 May 2008 23:25:58 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: bvidinli <bvidinli@gmail.com>, stev391@email.com,
	linux-dvb@linuxtv.org
Date: Fri, 23 May 2008 09:25:58 +1000
Message-Id: <20080522232558.6591811581F@ws1-7.us4.outblaze.com>
Subject: Re: [linux-dvb] fail2: Avermedia DVB-S Hybrid+FM A700 on ubuntu
 8.04, kernel 2.6.24-16-generic (bvidinli)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1551582664=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1551582664==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1211498758135150"

This is a multi-part message in MIME format.

--_----------=_1211498758135150
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-9"

One obvious error in you script is that it just moves the old modules
around in the modules directory.  You have to move them completely out of
the modules directory, else depmod will still find them and possible use
them instead of the new ones.

  ----- Original Message -----
  From: bvidinli
  To: stev391@email.com, linux-dvb@linuxtv.org
  Subject: fail2: Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel
  2.6.24-16-generic (bvidinli)
  Date: Thu, 22 May 2008 16:02:42 +0300

  i wrote the script below, since i do many install about this,
  result is same, fail,
  i/we miss something on files that we should replace/edit..

  i did just as you said about /lib/modules/`uname -r`/ubuntu/
  i replaced files there, with script, with manual, retried but result
  same...
  i also replaced files in /lib/modules/`uname -r`/kernel/drivers/media


  is there any idea about this ?

  #!/bin/bash
  echo "i must run this as normal user... press enter to continue"
  read

  cd
  #install mercurial, get v4l files, patch and compile,
  sudo apt-get install mercurial linux-headers-$(uname -r)
  build-essential
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
  sudo cp -f ir-common.ko /lib/modules/`uname
  -r`/kernel/drivers/media/common/
  sudo cp -f saa7146.ko /lib/modules/`uname
  -r`/kernel/drivers/media/common/
  sudo cp -f saa7146_vv.ko /lib/modules/`uname
  -r`/kernel/drivers/media/common/

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
  sudo cp -f cx88-dvb.ko /lib/modules/`uname
  -r`/kernel/drivers/media/video/cx88/
  sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname
  -r`/kernel/drivers/media/video/cx88/
  sudo cp -f cx88xx.ko /lib/modules/`uname
  -r`/kernel/drivers/media/video/cx88/
  sudo cp -f cx8800.ko /lib/modules/`uname
  -r`/kernel/drivers/media/video/cx88/
  sudo cp -f cx8802.ko /lib/modules/`uname
  -r`/kernel/drivers/media/video/cx88/



  sudo cp -f saa6752hs.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/
  sudo cp -f saa7134-dvb.ko /lib/modules/`uname
  -r`/ubuntu/media/saa7134/
  sudo cp -f saa7134-empress.ko /lib/modules/`uname
  -r`/ubuntu/media/saa7134/
  sudo cp -f saa7134.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/

  #these two raised error, so, i left them as old.. thre is no file in
  v4l dir as -alsa and -oss
  sudo cp -f saa7134-alsa.ko /lib/modules/`uname
  -r`/ubuntu/media/saa7134/
  sudo cp -f saa7134-oss.ko /lib/modules/`uname
  -r`/ubuntu/media/saa7134/



  sudo cp -f cx88-blackbird.ko /lib/modules/`uname
  -r`/ubuntu/media/cx88/
  sudo cp -f cx88-dvb.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
  sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname
  -r`/ubuntu/media/cx88/
  sudo cp -f cx88xx.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
  sudo cp -f cx8800.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
  sudo cp -f cx8802.ko /lib/modules/`uname -r`/ubuntu/media/cx88/
  # below line raised error, no file -alsa.ko in v4l
  sudo cp -f cx88-alsa.ko /lib/modules/`uname -r`/ubuntu/media/cx88/


  echo "replacing all files in
  /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/*.ko from
  new compiled ones... "
  for i in `ls /lib/modules/`uname -r`/kernel/drivers/media/video/*.ko`
  ; do i=3D`echo $i | awk -F "/" '{print $NF}'`; ls $i ; cp -vf $i
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
  [ 6012.068598] saa7133[0]: i2c scan: found device @ 0x1c [???]
  [ 6012.088599] saa7133[0]: i2c scan: found device @ 0xa0 [eeprom]
  [ 6012.109784] saa7133[0]: registered device video0 [v4l2]
  [ 6012.111066] saa7133[0]: registered device vbi0
  [ 6012.176702] saa7134 ALSA driver for DMA sound loaded
  [ 6012.177925] saa7133[0]/alsa: saa7133[0] at 0xde003000 irq 10
  registered as card -2



  after reboot:
  [ 43.901412] saa7134: disagrees about version of symbol
  videobuf_streamoff
  [ 43.901425] saa7134: Unknown symbol videobuf_streamoff
  [ 43.901792] saa7134: disagrees about version of symbol
  videobuf_poll_stream
  [ 43.901800] saa7134: Unknown symbol videobuf_poll_stream
  [ 43.902582] saa7134: disagrees about version of symbol
  videobuf_dma_free
  [ 43.902590] saa7134: Unknown symbol videobuf_dma_free
  [ 43.902875] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  [ 43.902883] saa7134: Unknown symbol videobuf_reqbufs
  [ 43.903523] saa7134: disagrees about version of symbol
  videobuf_waiton
  [ 43.903531] saa7134: Unknown symbol videobuf_waiton
  [ 43.904079] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  [ 43.904087] saa7134: Unknown symbol videobuf_dqbuf
  [ 43.905471] saa7134: disagrees about version of symbol videobuf_stop
  [ 43.905479] saa7134: Unknown symbol videobuf_stop
  [ 43.906472] saa7134: Unknown symbol videobuf_queue_pci_init
  [ 43.906614] saa7134: disagrees about version of symbol
  videobuf_dma_unmap
  [ 43.906623] saa7134: Unknown symbol videobuf_dma_unmap
  [ 43.906751] saa7134: disagrees about version of symbol
  videobuf_read_stream
  [ 43.906759] saa7134: Unknown symbol videobuf_read_stream
  [ 43.906940] saa7134: disagrees about version of symbol
  videobuf_querybuf
  [ 43.906948] saa7134: Unknown symbol videobuf_querybuf
  [ 43.907300] saa7134: disagrees about version of symbol
  video_unregister_device
  [ 43.907309] saa7134: Unknown symbol video_unregister_device
  [ 43.907428] saa7134: disagrees about version of symbol videobuf_qbuf
  [ 43.907436] saa7134: Unknown symbol videobuf_qbuf
  [ 43.907755] saa7134: disagrees about version of symbol
  video_device_alloc
  [ 43.907763] saa7134: Unknown symbol video_device_alloc
  [ 43.907882] saa7134: disagrees about version of symbol
  videobuf_read_one
  [ 43.907890] saa7134: Unknown symbol videobuf_read_one
  [ 43.908173] saa7134: disagrees about version of symbol
  video_register_device
  [ 43.908181] saa7134: Unknown symbol video_register_device
  [ 43.909011] saa7134: disagrees about version of symbol
  videobuf_iolock
  [ 43.909019] saa7134: Unknown symbol videobuf_iolock
  [ 43.909292] saa7134: disagrees about version of symbol
  videobuf_streamon
  [ 43.909300] saa7134: Unknown symbol videobuf_streamon
  [ 43.910040] saa7134: disagrees about version of symbol
  video_device_release
  [ 43.910048] saa7134: Unknown symbol video_device_release
  [ 43.910164] saa7134: disagrees about version of symbol
  videobuf_mmap_mapper
  [ 43.910173] saa7134: Unknown symbol videobuf_mmap_mapper
  [ 43.910548] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  [ 43.910556] saa7134: Unknown symbol videobuf_cgmbuf
  [ 43.910985] saa7134: disagrees about version of symbol
  videobuf_to_dma
  [ 43.910993] saa7134: Unknown symbol videobuf_to_dma
  [ 43.911108] saa7134: disagrees about version of symbol
  videobuf_mmap_free
  [ 43.911116] saa7134: Unknown symbol videobuf_mmap_free



  the result is same after reboot,
  same after reboot, make install in v4l-dvb

  we are back in same point...

  2008/5/22 :
  >
  > With ubuntu 8.04 they made a copy of some of the drivers (I had the
  > directory structure wrong in my previous email as I have already
  removed
  > mine), check in:
  > /lib/modules/`uname -r`/ubuntu/media/
  >
  > for any folders relating to cx* and saa* and remove them as Ubuntu
  checks
  > here first for the modules instead of the new freshly compiled
  ones.
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
  >> root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134
  i2c_scan=3D1
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
  >> [ 4261.604521] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  >> [ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs
  >> [ 4261.605140] saa7134: disagrees about version of symbol
  videobuf_waiton
  >> [ 4261.605148] saa7134: Unknown symbol videobuf_waiton
  >> [ 4261.605672] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  >> [ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf
  >> [ 4261.607190] saa7134: disagrees about version of symbol
  videobuf_stop
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
  >> [ 4261.609244] saa7134: disagrees about version of symbol
  videobuf_qbuf
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
  >> [ 4261.610871] saa7134: disagrees about version of symbol
  videobuf_iolock
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
  >> [ 4261.612426] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  >> [ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf
  >> [ 4261.612908] saa7134: disagrees about version of symbol
  videobuf_to_dma
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
  >>> To get this working try removing all modules(all files) in the
  following
  >>> directories:
  >>> /lib/modules/`uname -r`/ubuntu/media/common/
  >>> /lib/modules/`uname -r`/ubuntu/media/dvb/
  >>> /lib/modules/`uname -r`/ubuntu/media/radio/
  >>> /lib/modules/`uname -r`/ubuntu/media/video/
  >>>
  >>> For some reason Ubuntu decided to rearrange the module directory
  and
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
  >>> Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on
  ubuntu
  >>> 8.04, kernel 2.6.24-16-generic
  >>> To: "Eduard Huguet" , "Matthias Schwarzott"
  >>> , linux-dvb@linuxtv.org
  >>> Message-ID:
  >>> <36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.com>
  >>> Content-Type: text/plain; charset=3DISO-8859-1
  >>>
  >>> Unfortunately, failed,
  >>> below is what i did, if you have any idea, please try to help
  me...
  >>>
  >>> Thanks...
  >>>
  >>> on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current
  kernel.:
  >>> i got sources and headers for this kernel..
  >>> (btw, i learned now that zzam =3D Matthias, thanks.. .)
  >>>
  >>> i got mercurial,
  >>> i did: hg clone http://linuxtv.org/hg/v4l-dvb
  >>> then, got a700_full_20080519.diff from
  http://dev.gentoo.org/~zzam/dvb/
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
  >>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134
  i2c_scan=3D1
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
  >>> [ 48.938809] saa7134: disagrees about version of symbol
  videobuf_dma_free
  >>> [ 48.938817] saa7134: Unknown symbol videobuf_dma_free
  >>> [ 48.939134] saa7134: disagrees about version of symbol
  videobuf_reqbufs
  >>> [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs
  >>> [ 48.939779] saa7134: disagrees about version of symbol
  videobuf_waiton
  >>> [ 48.939787] saa7134: Unknown symbol videobuf_waiton
  >>> [ 48.940332] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  >>> [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf
  >>> [ 48.941669] saa7134: disagrees about version of symbol
  videobuf_stop
  >>> [ 48.941677] saa7134: Unknown symbol videobuf_stop
  >>> [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init
  >>> [ 48.942813] saa7134: disagrees about version of symbol
  >>> videobuf_dma_unmap
  >>> [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap
  >>> [ 48.942972] saa7134: disagrees about version of symbol
  >>> videobuf_read_stream
  >>> [ 48.942981] saa7134: Unknown symbol videobuf_read_stream
  >>> [ 48.943162] saa7134: disagrees about version of symbol
  videobuf_querybuf
  >>> [ 48.943170] saa7134: Unknown symbol videobuf_querybuf
  >>> [ 48.943520] saa7134: disagrees about version of symbol
  >>> video_unregister_device
  >>> [ 48.943529] saa7134: Unknown symbol video_unregister_device
  >>> [ 48.943647] saa7134: disagrees about version of symbol
  videobuf_qbuf
  >>> [ 48.943655] saa7134: Unknown symbol videobuf_qbuf
  >>> [ 48.943950] saa7134: disagrees about version of symbol
  >>> video_device_alloc
  >>> [ 48.943958] saa7134: Unknown symbol video_device_alloc
  >>> [ 48.944075] saa7134: disagrees about version of symbol
  videobuf_read_one
  >>> [ 48.944083] saa7134: Unknown symbol videobuf_read_one
  >>> [ 48.944365] saa7134: disagrees about version of symbol
  >>> video_register_device
  >>> [ 48.944373] saa7134: Unknown symbol video_register_device
  >>> [ 48.945156] saa7134: disagrees about version of symbol
  videobuf_iolock
  >>> [ 48.945164] saa7134: Unknown symbol videobuf_iolock
  >>> [ 48.945433] saa7134: disagrees about version of symbol
  videobuf_streamon
  >>> [ 48.945442] saa7134: Unknown symbol videobuf_streamon
  >>> [ 48.946164] saa7134: disagrees about version of symbol
  >>> video_device_release
  >>> [ 48.946172] saa7134: Unknown symbol video_device_release
  >>> [ 48.946287] saa7134: disagrees about version of symbol
  >>> videobuf_mmap_mapper
  >>> [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper
  >>> [ 48.946665] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  >>> [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf
  >>> [ 48.947108] saa7134: disagrees about version of symbol
  videobuf_to_dma
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
  >>> bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134
  i2c_scan=3D1
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
  >>> [ 2023.527904] saa7134: disagrees about version of symbol
  videobuf_waiton
  >>> [ 2023.527912] saa7134: Unknown symbol videobuf_waiton
  >>> [ 2023.528438] saa7134: disagrees about version of symbol
  videobuf_dqbuf
  >>> [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf
  >>> [ 2023.529926] saa7134: disagrees about version of symbol
  videobuf_stop
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
  >>> [ 2023.531956] saa7134: disagrees about version of symbol
  videobuf_qbuf
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
  >>> [ 2023.533561] saa7134: disagrees about version of symbol
  videobuf_iolock
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
  >>> [ 2023.535101] saa7134: disagrees about version of symbol
  videobuf_cgmbuf
  >>> [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf
  >>> [ 2023.535598] saa7134: disagrees about version of symbol
  videobuf_to_dma
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
  >>> Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10
  13:23:42
  >>> UTC 2008 i686 GNU/Linux
  >>>
  >>>
  >>>
  >>> bvidinli@bvidinli-desktop:/usr/src$ ls -l
  >>> total 45880
  >>> lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux ->
  linux-source-2.6.24
  >>> drwxr-xr-x 20 root root 4096 2008-04-22 20:54
  linux-headers-2.6.24-16
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


--_----------=_1211498758135150
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-9"


<div>
<br>
One obvious error in you script is that it just moves the old modules aroun=
d in the modules directory.&nbsp; You have to move them completely out of t=
he modules directory, else depmod will still find them and possible use the=
m instead of the new ones.<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: bvidinli <bvidinli@gmail.com><br>
To: stev391@email.com, linux-dvb@linuxtv.org<br>
Subject: fail2: Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel 2.6.2=
4-16-generic (bvidinli)<br>
Date: Thu, 22 May 2008 16:02:42 +0300<br>
<br>
i wrote the script below, since i do many install about this,<br>
result is same, fail,<br>
i/we miss something on files that we should replace/edit..<br>
<br>
i did just as you said about /lib/modules/`uname -r`/ubuntu/<br>
i replaced files there, with script, with manual, retried but result same..=
.<br>
i also replaced files in /lib/modules/`uname -r`/kernel/drivers/media<br>
<br>
<br>
is there any idea about this ?<br>
<br>
#!/bin/bash<br>
echo "i must run this as normal user... press enter to continue"<br>
read<br>
<br>
cd<br>
#install mercurial, get v4l files, patch and compile,<br>
sudo apt-get install mercurial linux-headers-$(uname -r) build-essential<br>
hg clone http://linuxtv.org/hg/v4l-dvb<br>
wget http://dev.gentoo.org/~zzam/dvb/a700_full_20080519.diff<br>
cd ~/v4l-dvb/v4l<br>
patch -p1 &lt; ../a700_full_20080519.diff<br>
make<br>
<br>
<br>
# first, backup all<br>
cd /lib/modules/`uname -r`/kernel/drivers/<br>
sudo cp -rvf media media.bck<br>
<br>
cd /lib/modules/`uname -r`/ubuntu/media<br>
sudo cp -rvf saa7134 saa7134.bck<br>
<br>
# goto where you got your v4l files by hg<br>
cd ~/v4l-dvb/v4l<br>
sudo cp -f ir-common.ko /lib/modules/`uname -r`/kernel/drivers/media/common=
/<br>
sudo cp -f saa7146.ko /lib/modules/`uname -r`/kernel/drivers/media/common/<=
br>
sudo cp -f saa7146_vv.ko /lib/modules/`uname -r`/kernel/drivers/media/commo=
n/<br>
<br>
sudo cp -f dvb-core.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/dvb/dvb-core/<br>
<br>
<br>
sudo cp -f saa6752hs.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/saa7134/<br>
sudo cp -f saa7134-dvb.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/saa7134/<br>
sudo cp -f saa7134-empress.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/saa7134/<br>
sudo cp -f saa7134.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/saa7134/<br>
<br>
sudo cp -f cx23885.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/cx23885/<br>
sudo cp -f cx25840.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/cx25840/<br>
<br>
sudo cp -f cx88-blackbird.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/cx88/<br>
sudo cp -f cx88-dvb.ko /lib/modules/`uname <br>
-r`/kernel/drivers/media/video/cx88/<br>
sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname<br>
-r`/kernel/drivers/media/video/cx88/<br>
sudo cp -f cx88xx.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/<br>
sudo cp -f cx8800.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/<br>
sudo cp -f cx8802.ko /lib/modules/`uname -r`/kernel/drivers/media/video/cx8=
8/<br>
<br>
<br>
<br>
sudo cp -f saa6752hs.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/<br>
sudo cp -f saa7134-dvb.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/<br>
sudo cp -f saa7134-empress.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/=
<br>
sudo cp -f saa7134.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/<br>
<br>
#these two raised error, so, i left them as old.. thre is no file in<br>
v4l dir as -alsa and -oss<br>
sudo cp -f saa7134-alsa.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/<br>
sudo cp -f saa7134-oss.ko /lib/modules/`uname -r`/ubuntu/media/saa7134/<br>
<br>
<br>
<br>
sudo cp -f cx88-blackbird.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
sudo cp -f cx88-dvb.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
sudo cp -f cx88-vp3054-i2c.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
sudo cp -f cx88xx.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
sudo cp -f cx8800.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
sudo cp -f cx8802.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
# below line raised error, no file -alsa.ko in v4l<br>
sudo cp -f cx88-alsa.ko /lib/modules/`uname -r`/ubuntu/media/cx88/<br>
<br>
<br>
echo "replacing all files in<br>
/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/*.ko from<br>
new compiled ones... "<br>
  for i in `ls /lib/modules/`uname -r`/kernel/drivers/media/video/*.ko`<br>
; do i=3D`echo $i | awk -F "/" '{print $NF}'`; ls  $i ; cp -vf $i<br>
/lib/modules/2.6.24-16-generic/kernel/drivers/media/video/ ; done<br>
<br>
# remove and reinstall modules<br>
rmmod saa7134_alsa saa7134<br>
depmod -a<br>
modprobe saa7134 i2c_scan=3D1<br>
<br>
<br>
<br>
<br>
<br>
echo "finished... you may run dmesg to see result.."<br>
<br>
<br>
<br>
result:<br>
(note that this is without make install, before reboot)<br>
[ 6011.912699] saa7130/34: v4l2 driver version 0.2.14 loaded<br>
[ 6011.914021] saa7133[0]: found at 0000:00:14.0, rev: 209, irq: 10,<br>
latency: 32, mmio: 0xde003000<br>
[ 6011.914045] saa7133[0]: subsystem: 1461:a7a2, board:<br>
UNKNOWN/GENERIC [card=3D0,autodetected]<br>
[ 6011.914069] saa7133[0]: board init: gpio is 2fe00<br>
[ 6012.048607] saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048641] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048664] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048687] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048709] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048732] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048755] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.048777] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff<br>
ff ff ff ff ff ff ff<br>
[ 6012.068598] saa7133[0]: i2c scan: found device @ 0x1c  [???]<br>
[ 6012.088599] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]<br>
[ 6012.109784] saa7133[0]: registered device video0 [v4l2]<br>
[ 6012.111066] saa7133[0]: registered device vbi0<br>
[ 6012.176702] saa7134 ALSA driver for DMA sound loaded<br>
[ 6012.177925] saa7133[0]/alsa: saa7133[0] at 0xde003000 irq 10<br>
registered as card -2<br>
<br>
<br>
<br>
after reboot:<br>
[   43.901412] saa7134: disagrees about version of symbol videobuf_streamof=
f<br>
[   43.901425] saa7134: Unknown symbol videobuf_streamoff<br>
[   43.901792] saa7134: disagrees about version of symbol videobuf_poll_str=
eam<br>
[   43.901800] saa7134: Unknown symbol videobuf_poll_stream<br>
[   43.902582] saa7134: disagrees about version of symbol videobuf_dma_free=
<br>
[   43.902590] saa7134: Unknown symbol videobuf_dma_free<br>
[   43.902875] saa7134: disagrees about version of symbol videobuf_reqbufs<=
br>
[   43.902883] saa7134: Unknown symbol videobuf_reqbufs<br>
[   43.903523] saa7134: disagrees about version of symbol videobuf_waiton<b=
r>
[   43.903531] saa7134: Unknown symbol videobuf_waiton<br>
[   43.904079] saa7134: disagrees about version of symbol videobuf_dqbuf<br>
[   43.904087] saa7134: Unknown symbol videobuf_dqbuf<br>
[   43.905471] saa7134: disagrees about version of symbol videobuf_stop<br>
[   43.905479] saa7134: Unknown symbol videobuf_stop<br>
[   43.906472] saa7134: Unknown symbol videobuf_queue_pci_init<br>
[   43.906614] saa7134: disagrees about version of symbol videobuf_dma_unma=
p<br>
[   43.906623] saa7134: Unknown symbol videobuf_dma_unmap<br>
[   43.906751] saa7134: disagrees about version of symbol videobuf_read_str=
eam<br>
[   43.906759] saa7134: Unknown symbol videobuf_read_stream<br>
[   43.906940] saa7134: disagrees about version of symbol videobuf_querybuf=
<br>
[   43.906948] saa7134: Unknown symbol videobuf_querybuf<br>
[   43.907300] saa7134: disagrees about version of symbol<br>
video_unregister_device<br>
[   43.907309] saa7134: Unknown symbol video_unregister_device<br>
[   43.907428] saa7134: disagrees about version of symbol videobuf_qbuf<br>
[   43.907436] saa7134: Unknown symbol videobuf_qbuf<br>
[   43.907755] saa7134: disagrees about version of symbol video_device_allo=
c<br>
[   43.907763] saa7134: Unknown symbol video_device_alloc<br>
[   43.907882] saa7134: disagrees about version of symbol videobuf_read_one=
<br>
[   43.907890] saa7134: Unknown symbol videobuf_read_one<br>
[   43.908173] saa7134: disagrees about version of symbol <br>
video_register_device<br>
[   43.908181] saa7134: Unknown symbol video_register_device<br>
[   43.909011] saa7134: disagrees about version of symbol videobuf_iolock<b=
r>
[   43.909019] saa7134: Unknown symbol videobuf_iolock<br>
[   43.909292] saa7134: disagrees about version of symbol videobuf_streamon=
<br>
[   43.909300] saa7134: Unknown symbol videobuf_streamon<br>
[   43.910040] saa7134: disagrees about version of symbol video_device_rele=
ase<br>
[   43.910048] saa7134: Unknown symbol video_device_release<br>
[   43.910164] saa7134: disagrees about version of symbol videobuf_mmap_map=
per<br>
[   43.910173] saa7134: Unknown symbol videobuf_mmap_mapper<br>
[   43.910548] saa7134: disagrees about version of symbol videobuf_cgmbuf<b=
r>
[   43.910556] saa7134: Unknown symbol videobuf_cgmbuf<br>
[   43.910985] saa7134: disagrees about version of symbol videobuf_to_dma<b=
r>
[   43.910993] saa7134: Unknown symbol videobuf_to_dma<br>
[   43.911108] saa7134: disagrees about version of symbol videobuf_mmap_fre=
e<br>
[   43.911116] saa7134: Unknown symbol videobuf_mmap_free<br>
<br>
<br>
<br>
the result is same after reboot,<br>
same after reboot, make install in v4l-dvb<br>
<br>
we are back in same point...<br>
<br>
2008/5/22  <stev391@email.com>:<br>
&gt;<br>
&gt; With ubuntu 8.04 they made a copy of some of the drivers (I had the<br>
&gt; directory structure wrong in my previous email as I have already remov=
ed<br>
&gt; mine), check in:<br>
&gt; /lib/modules/`uname -r`/ubuntu/media/<br>
&gt;<br>
&gt; for any folders relating to cx* and saa* and remove them as Ubuntu che=
cks<br>
&gt; here first for the modules instead of the new freshly compiled ones.<b=
r>
&gt; the run depmod -a and try again.<br>
&gt;<br>
&gt; Regards,<br>
&gt;<br>
&gt; Stephen.<br>
&gt;<br>
&gt; ----- Original Message -----<br>
&gt; From: bvidinli<br>
&gt; To: stev391@email.com, linux-dvb@linuxtv.org<br>
&gt; Subject: fail:Avermedia DVB-S Hybrid+FM A700 on ubuntu 8.04, kernel<br>
&gt; 2.6.24-16-generic (bvidinli)<br>
&gt; Date: Wed, 21 May 2008 16:10:08 +0300<br>
&gt;<br>
&gt; This problem persists, continues,<br>
&gt; does anybody have suggestions ?<br>
&gt;<br>
&gt; i continue on my search of this problem...<br>
&gt;<br>
&gt; thanks.<br>
&gt;<br>
&gt;<br>
&gt; 2008/5/21 bvidinli :<br>
&gt;&gt; i did your suggestions, but result is same.<br>
&gt;&gt;<br>
&gt;&gt; there was no file at locations you specified, (/lib/modules/`uname=
<br>
&gt;&gt; -r`/ubuntu/media/common/)<br>
&gt;&gt; instead i removed files on :<br>
&gt;&gt; rm -rvf /lib/modules/2.6.24-16-generic/kernel/drivers/media/video/=
<br>
&gt;&gt; dvb, video, etc...<br>
&gt;&gt;<br>
&gt;&gt; if you/anybody may help me, please do..<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; root@bvidinli-desktop:/home/bvidinli/v4l-dvb# modprobe saa7134 i2c=
_scan=3D1<br>
&gt;&gt; FATAL: Error inserting saa7134<br>
&gt;&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.ko):<=
br>
&gt;&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt;&gt; FATAL: Error running install command for saa7134<br>
&gt;&gt; root@bvidinli-desktop:/home/bvidinli/v4l-dvb#<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; dmesg output:<br>
&gt;&gt;<br>
&gt;&gt; [ 4261.474794] Linux video capture interface: v2.00<br>
&gt;&gt; [ 4261.603077] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_streamoff<br>
&gt;&gt; [ 4261.603104] saa7134: Unknown symbol videobuf_streamoff<br>
&gt;&gt; [ 4261.603450] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_poll_stream<br>
&gt;&gt; [ 4261.603459] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt;&gt; [ 4261.604240] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_dma_free<br>
&gt;&gt; [ 4261.604249] saa7134: Unknown symbol videobuf_dma_free<br>
&gt;&gt; [ 4261.604521] saa7134: disagrees about version of symbol videobuf=
_reqbufs<br>
&gt;&gt; [ 4261.604529] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt;&gt; [ 4261.605140] saa7134: disagrees about version of symbol videobuf=
_waiton<br>
&gt;&gt; [ 4261.605148] saa7134: Unknown symbol videobuf_waiton<br>
&gt;&gt; [ 4261.605672] saa7134: disagrees about version of symbol videobuf=
_dqbuf<br>
&gt;&gt; [ 4261.605680] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt;&gt; [ 4261.607190] saa7134: disagrees about version of symbol videobuf=
_stop<br>
&gt;&gt; [ 4261.607199] saa7134: Unknown symbol videobuf_stop<br>
&gt;&gt; [ 4261.608245] saa7134: Unknown symbol videobuf_queue_pci_init<br>
&gt;&gt; [ 4261.608459] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_dma_unmap<br>
&gt;&gt; [ 4261.608467] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt;&gt; [ 4261.608592] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_read_stream<br>
&gt;&gt; [ 4261.608600] saa7134: Unknown symbol videobuf_read_stream<br>
&gt;&gt; [ 4261.608776] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_querybuf<br>
&gt;&gt; [ 4261.608784] saa7134: Unknown symbol videobuf_querybuf<br>
&gt;&gt; [ 4261.609121] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_unregister_device<br>
&gt;&gt; [ 4261.609130] saa7134: Unknown symbol video_unregister_device<br>
&gt;&gt; [ 4261.609244] saa7134: disagrees about version of symbol videobuf=
_qbuf<br>
&gt;&gt; [ 4261.609252] saa7134: Unknown symbol videobuf_qbuf<br>
&gt;&gt; [ 4261.609538] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_device_alloc<br>
&gt;&gt; [ 4261.609547] saa7134: Unknown symbol video_device_alloc<br>
&gt;&gt; [ 4261.609660] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_read_one<br>
&gt;&gt; [ 4261.609668] saa7134: Unknown symbol videobuf_read_one<br>
&gt;&gt; [ 4261.609940] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_register_device<br>
&gt;&gt; [ 4261.609948] saa7134: Unknown symbol video_register_device<br>
&gt;&gt; [ 4261.610871] saa7134: disagrees about version of symbol videobuf=
_iolock<br>
&gt;&gt; [ 4261.610879] saa7134: Unknown symbol videobuf_iolock<br>
&gt;&gt; [ 4261.611139] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_streamon<br>
&gt;&gt; [ 4261.611147] saa7134: Unknown symbol videobuf_streamon<br>
&gt;&gt; [ 4261.611941] saa7134: disagrees about version of symbol<br>
&gt;&gt; video_device_release<br>
&gt;&gt; [ 4261.611950] saa7134: Unknown symbol video_device_release<br>
&gt;&gt; [ 4261.612061] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_mmap_mapper<br>
&gt;&gt; [ 4261.612070] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt;&gt; [ 4261.612426] saa7134: disagrees about version of symbol videobuf=
_cgmbuf<br>
&gt;&gt; [ 4261.612434] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt;&gt; [ 4261.612908] saa7134: disagrees about version of symbol videobuf=
_to_dma<br>
&gt;&gt; [ 4261.612917] saa7134: Unknown symbol videobuf_to_dma<br>
&gt;&gt; [ 4261.613027] saa7134: disagrees about version of symbol<br>
&gt;&gt; videobuf_mmap_free<br>
&gt;&gt; [ 4261.613035] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; 2008/5/20 :<br>
&gt;&gt;&gt; bvidibli,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; To get this working try removing all modules(all files) in the=
 following<br>
&gt;&gt;&gt; directories:<br>
&gt;&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/common/<br>
&gt;&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/dvb/<br>
&gt;&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/radio/<br>
&gt;&gt;&gt; /lib/modules/`uname -r`/ubuntu/media/video/<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; For some reason Ubuntu decided to rearrange the module directo=
ry and<br>
&gt;&gt;&gt; broke<br>
&gt;&gt;&gt; the normal make install scripts.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; If this breaks something that you need, just reinstall the<br>
&gt;&gt;&gt; linux-ubuntu-modules-`uname -r` package to get them back.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; This solved the issues that I had with Unkown symbol and versi=
on<br>
&gt;&gt;&gt; disagrees<br>
&gt;&gt;&gt; error messages.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Regards,<br>
&gt;&gt;&gt; Stephen.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Date: Tue, 20 May 2008 00:05:47 +0300<br>
&gt;&gt;&gt; From: bvidinli<br>
&gt;&gt;&gt; Subject: [linux-dvb] Failed: Avermedia DVB-S Hybrid+FM A700 on=
 ubuntu<br>
&gt;&gt;&gt; 8.04, kernel 2.6.24-16-generic<br>
&gt;&gt;&gt; To: "Eduard Huguet" , "Matthias Schwarzott"<br>
&gt;&gt;&gt; , linux-dvb@linuxtv.org<br>
&gt;&gt;&gt; Message-ID:<br>
&gt;&gt;&gt; &lt;36e8a7020805191405r6b0d4ce6h3a53228500b20ce1@mail.gmail.co=
m&gt;<br>
&gt;&gt;&gt; Content-Type: text/plain; charset=3DISO-8859-1<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Unfortunately, failed,<br>
&gt;&gt;&gt; below is what i did, if you have any idea, please try to help =
me...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Thanks...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; on ubuntu 8.04 with kernel 2.6.24.16-generic, ubuntu's current=
 kernel.:<br>
&gt;&gt;&gt; i got sources and headers for this kernel..<br>
&gt;&gt;&gt; (btw, i learned now that zzam =3D Matthias, thanks.. .)<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; i got mercurial,<br>
&gt;&gt;&gt; i did: hg clone http://linuxtv.org/hg/v4l-dvb<br>
&gt;&gt;&gt; then, got a700_full_20080519.diff from http://dev.gentoo.org/~=
zzam/dvb/<br>
&gt;&gt;&gt; i did:<br>
&gt;&gt;&gt; cd v4l-dvb<br>
&gt;&gt;&gt; patch -p1 &lt; a700_full_20080519.diff<br>
&gt;&gt;&gt; make<br>
&gt;&gt;&gt; (make was successfull, without errors.. )<br>
&gt;&gt;&gt; sudo make install<br>
&gt;&gt;&gt; (install was successfull.)<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo rmmod saa7134_alsa<b=
r>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo make rmmod<br>
&gt;&gt;&gt; make -C /home/bvidinli/v4l-dvb/v4l rmmod<br>
&gt;&gt;&gt; make[1]: Entering directory `/home/bvidinli/v4l-dvb/v4l'<br>
&gt;&gt;&gt; scripts/rmmod.pl unload<br>
&gt;&gt;&gt; found 233 modules<br>
&gt;&gt;&gt; /sbin/rmmod saa7134<br>
&gt;&gt;&gt; /sbin/rmmod videodev<br>
&gt;&gt;&gt; /sbin/rmmod videobuf_dma_sg<br>
&gt;&gt;&gt; /sbin/rmmod ir_kbd_i2c<br>
&gt;&gt;&gt; /sbin/rmmod compat_ioctl32<br>
&gt;&gt;&gt; /sbin/rmmod v4l1_compat<br>
&gt;&gt;&gt; /sbin/rmmod v4l2_common<br>
&gt;&gt;&gt; /sbin/rmmod videobuf_core<br>
&gt;&gt;&gt; /sbin/rmmod ir_common<br>
&gt;&gt;&gt; make[1]: Leaving directory `/home/bvidinli/v4l-dvb/v4l'<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c=
_scan=3D1<br>
&gt;&gt;&gt; FATAL: Error inserting saa7134<br>
&gt;&gt;&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.k=
o):<br>
&gt;&gt;&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt;&gt;&gt; FATAL: Error running install command for saa7134<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; dmesg is as follows:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; [ 48.937645] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_streamoff<br>
&gt;&gt;&gt; [ 48.937663] saa7134: Unknown symbol videobuf_streamoff<br>
&gt;&gt;&gt; [ 48.938027] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_poll_stream<br>
&gt;&gt;&gt; [ 48.938035] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt;&gt;&gt; [ 48.938809] saa7134: disagrees about version of symbol videob=
uf_dma_free<br>
&gt;&gt;&gt; [ 48.938817] saa7134: Unknown symbol videobuf_dma_free<br>
&gt;&gt;&gt; [ 48.939134] saa7134: disagrees about version of symbol videob=
uf_reqbufs<br>
&gt;&gt;&gt; [ 48.939142] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt;&gt;&gt; [ 48.939779] saa7134: disagrees about version of symbol videob=
uf_waiton<br>
&gt;&gt;&gt; [ 48.939787] saa7134: Unknown symbol videobuf_waiton<br>
&gt;&gt;&gt; [ 48.940332] saa7134: disagrees about version of symbol videob=
uf_dqbuf<br>
&gt;&gt;&gt; [ 48.940340] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt;&gt;&gt; [ 48.941669] saa7134: disagrees about version of symbol videob=
uf_stop<br>
&gt;&gt;&gt; [ 48.941677] saa7134: Unknown symbol videobuf_stop<br>
&gt;&gt;&gt; [ 48.942673] saa7134: Unknown symbol videobuf_queue_pci_init<b=
r>
&gt;&gt;&gt; [ 48.942813] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_dma_unmap<br>
&gt;&gt;&gt; [ 48.942822] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt;&gt;&gt; [ 48.942972] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_read_stream<br>
&gt;&gt;&gt; [ 48.942981] saa7134: Unknown symbol videobuf_read_stream<br>
&gt;&gt;&gt; [ 48.943162] saa7134: disagrees about version of symbol videob=
uf_querybuf<br>
&gt;&gt;&gt; [ 48.943170] saa7134: Unknown symbol videobuf_querybuf<br>
&gt;&gt;&gt; [ 48.943520] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_unregister_device<br>
&gt;&gt;&gt; [ 48.943529] saa7134: Unknown symbol video_unregister_device<b=
r>
&gt;&gt;&gt; [ 48.943647] saa7134: disagrees about version of symbol videob=
uf_qbuf<br>
&gt;&gt;&gt; [ 48.943655] saa7134: Unknown symbol videobuf_qbuf<br>
&gt;&gt;&gt; [ 48.943950] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_device_alloc<br>
&gt;&gt;&gt; [ 48.943958] saa7134: Unknown symbol video_device_alloc<br>
&gt;&gt;&gt; [ 48.944075] saa7134: disagrees about version of symbol videob=
uf_read_one<br>
&gt;&gt;&gt; [ 48.944083] saa7134: Unknown symbol videobuf_read_one<br>
&gt;&gt;&gt; [ 48.944365] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_register_device<br>
&gt;&gt;&gt; [ 48.944373] saa7134: Unknown symbol video_register_device<br>
&gt;&gt;&gt; [ 48.945156] saa7134: disagrees about version of symbol videob=
uf_iolock<br>
&gt;&gt;&gt; [ 48.945164] saa7134: Unknown symbol videobuf_iolock<br>
&gt;&gt;&gt; [ 48.945433] saa7134: disagrees about version of symbol videob=
uf_streamon<br>
&gt;&gt;&gt; [ 48.945442] saa7134: Unknown symbol videobuf_streamon<br>
&gt;&gt;&gt; [ 48.946164] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_device_release<br>
&gt;&gt;&gt; [ 48.946172] saa7134: Unknown symbol video_device_release<br>
&gt;&gt;&gt; [ 48.946287] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_mmap_mapper<br>
&gt;&gt;&gt; [ 48.946295] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt;&gt;&gt; [ 48.946665] saa7134: disagrees about version of symbol videob=
uf_cgmbuf<br>
&gt;&gt;&gt; [ 48.946673] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt;&gt;&gt; [ 48.947108] saa7134: disagrees about version of symbol videob=
uf_to_dma<br>
&gt;&gt;&gt; [ 48.947116] saa7134: Unknown symbol videobuf_to_dma<br>
&gt;&gt;&gt; [ 48.947228] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_mmap_free<br>
&gt;&gt;&gt; [ 48.947237] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; i rebooted, the same..<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; i repeated same compile with patch avertv_A700_dvb_part.diff<b=
r>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; result:<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:~/v4l-dvb$ sudo modprobe saa7134 i2c=
_scan=3D1<br>
&gt;&gt;&gt; FATAL: Error inserting saa7134<br>
&gt;&gt;&gt; (/lib/modules/2.6.24-16-generic/ubuntu/media/saa7134/saa7134.k=
o):<br>
&gt;&gt;&gt; Unknown symbol in module, or unknown parameter (see dmesg)<br>
&gt;&gt;&gt; FATAL: Error running install command for saa7134<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; here is dmesg related output:<br>
&gt;&gt;&gt; [ 2023.405692] Linux video capture interface: v2.00<br>
&gt;&gt;&gt; [ 2023.525841] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_streamoff<br>
&gt;&gt;&gt; [ 2023.525868] saa7134: Unknown symbol videobuf_streamoff<br>
&gt;&gt;&gt; [ 2023.526215] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_poll_stream<br>
&gt;&gt;&gt; [ 2023.526223] saa7134: Unknown symbol videobuf_poll_stream<br>
&gt;&gt;&gt; [ 2023.526968] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_dma_free<br>
&gt;&gt;&gt; [ 2023.526976] saa7134: Unknown symbol videobuf_dma_free<br>
&gt;&gt;&gt; [ 2023.527249] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_reqbufs<br>
&gt;&gt;&gt; [ 2023.527257] saa7134: Unknown symbol videobuf_reqbufs<br>
&gt;&gt;&gt; [ 2023.527904] saa7134: disagrees about version of symbol vide=
obuf_waiton<br>
&gt;&gt;&gt; [ 2023.527912] saa7134: Unknown symbol videobuf_waiton<br>
&gt;&gt;&gt; [ 2023.528438] saa7134: disagrees about version of symbol vide=
obuf_dqbuf<br>
&gt;&gt;&gt; [ 2023.528446] saa7134: Unknown symbol videobuf_dqbuf<br>
&gt;&gt;&gt; [ 2023.529926] saa7134: disagrees about version of symbol vide=
obuf_stop<br>
&gt;&gt;&gt; [ 2023.529935] saa7134: Unknown symbol videobuf_stop<br>
&gt;&gt;&gt; [ 2023.530940] saa7134: Unknown symbol videobuf_queue_pci_init=
<br>
&gt;&gt;&gt; [ 2023.531137] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_dma_unmap<br>
&gt;&gt;&gt; [ 2023.531146] saa7134: Unknown symbol videobuf_dma_unmap<br>
&gt;&gt;&gt; [ 2023.531271] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_read_stream<br>
&gt;&gt;&gt; [ 2023.531279] saa7134: Unknown symbol videobuf_read_stream<br>
&gt;&gt;&gt; [ 2023.531485] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_querybuf<br>
&gt;&gt;&gt; [ 2023.531494] saa7134: Unknown symbol videobuf_querybuf<br>
&gt;&gt;&gt; [ 2023.531832] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_unregister_device<br>
&gt;&gt;&gt; [ 2023.531841] saa7134: Unknown symbol video_unregister_device=
<br>
&gt;&gt;&gt; [ 2023.531956] saa7134: disagrees about version of symbol vide=
obuf_qbuf<br>
&gt;&gt;&gt; [ 2023.531964] saa7134: Unknown symbol videobuf_qbuf<br>
&gt;&gt;&gt; [ 2023.532251] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_device_alloc<br>
&gt;&gt;&gt; [ 2023.532260] saa7134: Unknown symbol video_device_alloc<br>
&gt;&gt;&gt; [ 2023.532373] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_read_one<br>
&gt;&gt;&gt; [ 2023.532381] saa7134: Unknown symbol videobuf_read_one<br>
&gt;&gt;&gt; [ 2023.532655] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_register_device<br>
&gt;&gt;&gt; [ 2023.532663] saa7134: Unknown symbol video_register_device<b=
r>
&gt;&gt;&gt; [ 2023.533561] saa7134: disagrees about version of symbol vide=
obuf_iolock<br>
&gt;&gt;&gt; [ 2023.533569] saa7134: Unknown symbol videobuf_iolock<br>
&gt;&gt;&gt; [ 2023.533831] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_streamon<br>
&gt;&gt;&gt; [ 2023.533839] saa7134: Unknown symbol videobuf_streamon<br>
&gt;&gt;&gt; [ 2023.534615] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; video_device_release<br>
&gt;&gt;&gt; [ 2023.534624] saa7134: Unknown symbol video_device_release<br>
&gt;&gt;&gt; [ 2023.534736] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_mmap_mapper<br>
&gt;&gt;&gt; [ 2023.534745] saa7134: Unknown symbol videobuf_mmap_mapper<br>
&gt;&gt;&gt; [ 2023.535101] saa7134: disagrees about version of symbol vide=
obuf_cgmbuf<br>
&gt;&gt;&gt; [ 2023.535109] saa7134: Unknown symbol videobuf_cgmbuf<br>
&gt;&gt;&gt; [ 2023.535598] saa7134: disagrees about version of symbol vide=
obuf_to_dma<br>
&gt;&gt;&gt; [ 2023.535606] saa7134: Unknown symbol videobuf_to_dma<br>
&gt;&gt;&gt; [ 2023.535717] saa7134: disagrees about version of symbol<br>
&gt;&gt;&gt; videobuf_mmap_free<br>
&gt;&gt;&gt; [ 2023.535725] saa7134: Unknown symbol videobuf_mmap_free<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; my linux kernel is: 2.6.24-16-generic, which is ubuntu 8.04's<=
br>
&gt;&gt;&gt; current kernel...<br>
&gt;&gt;&gt; i have source and header files for this kernel..<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$ uname -a<br>
&gt;&gt;&gt; Linux bvidinli-desktop 2.6.24-16-generic #1 SMP Thu Apr 10 13:=
23:42<br>
&gt;&gt;&gt; UTC 2008 i686 GNU/Linux<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$ ls -l<br>
&gt;&gt;&gt; total 45880<br>
&gt;&gt;&gt; lrwxrwxrwx 1 root src 19 2008-05-19 22:14 linux -&gt; linux-so=
urce-2.6.24<br>
&gt;&gt;&gt; drwxr-xr-x 20 root root 4096 2008-04-22 20:54 linux-headers-2.=
6.24-16<br>
&gt;&gt;&gt; drwxr-xr-x 6 root root 4096 2008-04-22 20:54<br>
&gt;&gt;&gt; linux-headers-2.6.24-16-generic<br>
&gt;&gt;&gt; drwxr-xr-x 23 root root 4096 2008-04-10 19:36 linux-source-2.6=
.24<br>
&gt;&gt;&gt; -rw-r--r-- 1 root root 46914792 2008-04-10 19:38<br>
&gt;&gt;&gt; linux-source-2.6.24.tar.bz2<br>
&gt;&gt;&gt; bvidinli@bvidinli-desktop:/usr/src$<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Attention :<br>
&gt;&gt;&gt; should these be applied on 2.6.26.rc2 or 2.6.25 ?<br>
&gt;&gt;&gt; i applied to 2.6.24, which is current kernel for ubuntu 8.04..=
.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; ------------------------------<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; _______________________________________________<br>
&gt;&gt;&gt; linux-dvb mailing list<br>
&gt;&gt;&gt; linux-dvb@linuxtv.org<br>
&gt;&gt;&gt; http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; End of linux-dvb Digest, Vol 40, Issue 64<br>
&gt;&gt;&gt; *****************************************<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; --<br>
&gt;&gt;&gt; See Exclusive Video: 10th Annual Young Hollywood Awards<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; --<br>
&gt;&gt; =DD.Bahattin Vidinli<br>
&gt;&gt; Elk-Elektronik M=FCh.<br>
&gt;&gt; -------------------<br>
&gt;&gt; iletisim bilgileri (Tercih sirasina gore):<br>
&gt;&gt; skype: bvidinli (sesli gorusme icin, www.skype.com)<br>
&gt;&gt; msn: bvidinli@iyibirisi.com<br>
&gt;&gt; yahoo: bvidinli<br>
&gt;&gt;<br>
&gt;&gt; +90.532.7990607<br>
&gt;&gt; +90.505.5667711<br>
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
&gt; --<br>
&gt; See Exclusive Video: 10th Annual Young Hollywood Awards<br>
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
</stev391@email.com></bvidinli@gmail.com></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1211498758135150--



--===============1551582664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1551582664==--
