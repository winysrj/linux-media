Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63807 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab0FZOXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jun 2010 10:23:12 -0400
Subject: Re: V4L & VLC 1.0.6 and standard selection
From: Andy Walls <awalls@md.metrocast.net>
To: manunc <emmanuelchanson@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
In-Reply-To: <1277269620009-5211808.post@n2.nabble.com>
References: <1277269620009-5211808.post@n2.nabble.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Jun 2010 10:23:29 -0400
Message-ID: <1277562210.8545.30.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-06-22 at 22:07 -0700, manunc wrote:
> I am trying to catch my tuner card signal by using vlc and v4l
> 
> Under Fedora 12:
> vlc-1.0.6-1.fc12.i686
> vlc-core-1.0.6-1.fc12.i686
> 
> 
> libv4l-0.6.4-1.fc12.i686
> xorg-x11-drv-v4l-0.2.0-3.fc12.1.i686
> v4l2-tool-1.0.3-5.fc12.i686
> 
> 
> By using the cvlc command to catch the tuner card signal and setting
> standard in the command line I did not see the SECAM K1, so I wonder if the
> fix has been committed or not in this release or if I have to patch the
> sources:
> 
> http://git.videolan.org/?p=vlc.git;a=commitdiff;h=beb5d0fdc3c4b8b12ec385f96ab8a27c342b7236
> 
> I used:
> 
> $ cvlc -vv v4l2:// :v4l2-dev=/dev/video0 :v4l2-adev=hw.1,0
> :v4l2-tuner-frequency=207250 :v4l2-standard=13 ....
> 
> I dont see SECAM K1
> ....
> 
> [0xb7108988] v4l2 demux debug: Trying libv4l2 wrapper
> [0xb7108988] v4l2 demux debug: opening device '/dev/video0'
> [0xb7108988] v4l2 demux debug: V4L2 device: BT878 video (Hauppauge (bt878))
> using driver: bttv (version: 0.9.18) on PCI:0000:00:0b.0
> [0xb7108988] v4l2 demux debug: the device has the capabilities: (X) Video
> Capure, ( ) Audio, (X) Tuner, ( ) Radio
> [0xb7108988] v4l2 demux debug: supported I/O methods are: (X) Read/Write,
> (X) Streaming, ( ) Asynchronous
> [0xb7108988] v4l2 demux debug: device support raw VBI capture
> [0xb7108988] v4l2 demux debug: video input 0 (Television) has type: Tuner
> adapter *
> [0xb7108988] v4l2 demux debug: video input 1 (Composite1) has type: External
> analog input
> [0xb7108988] v4l2 demux debug: video input 2 (S-Video) has type: External
> analog input
> [0xb7108988] v4l2 demux debug: video input 3 (Composite3) has type: External
> analog input
> [0xb7108988] v4l2 demux debug: video standard 0 is: NTSC
> [0xb7108988] v4l2 demux debug: video standard 1 is: NTSC-M
> [0xb7108988] v4l2 demux debug: video standard 2 is: NTSC-M-JP
> [0xb7108988] v4l2 demux debug: video standard 3 is: NTSC-M-KR
> [0xb7108988] v4l2 demux debug: video standard 4 is: PAL *
> [0xb7108988] v4l2 demux debug: video standard 5 is: PAL-BG
> [0xb7108988] v4l2 demux debug: video standard 6 is: PAL-H
> [0xb7108988] v4l2 demux debug: video standard 7 is: PAL-I
> [0xb7108988] v4l2 demux debug: video standard 8 is: PAL-DK
> [0xb7108988] v4l2 demux debug: video standard 9 is: PAL-M
> [0xb7108988] v4l2 demux debug: video standard 10 is: PAL-N
> [0xb7108988] v4l2 demux debug: video standard 11 is: PAL-Nc
> [0xb7108988] v4l2 demux debug: video standard 12 is: PAL-60
> [0xb7108988] v4l2 demux debug: video standard 13 is: SECAM
> [0xb7108988] v4l2 demux debug: video standard 14 is: SECAM-B
> [0xb7108988] v4l2 demux debug: video standard 15 is: SECAM-G
> [0xb7108988] v4l2 demux debug: video standard 16 is: SECAM-H
> [0xb7108988] v4l2 demux debug: video standard 17 is: SECAM-DK
> [0xb7108988] v4l2 demux debug: video standard 18 is: SECAM-L
> [0xb7108988] v4l2 demux debug: video standard 19 is: SECAM-Lc
> [0xb7108988] v4l2 demux debug: tuner 0 (Television) has type: Analog TV,
> frequency range: 44000,0 kHz -> 958000,0 kHz
> [0xb7108988] v4l2 demux debug: tuner 0 (Television) frequency: 207250,0 kHz
> ...
> 
> A developper from videolan told me this:
> That list comes from the V4L2 driver for your analog TV capture card. It
> does not come from VLC. So we cannot "fix" it.
> In any case, SECAM-K1 is probably one of the choice, but with a different
> name.


The video4linux list is effectively dead.  Use
linux-media@vger.kernel.org .

> Does anyone know if some of the options can be applied to decode SECAM K1?
> ou K'

Use SECAM-DK.  It is not significantly different from SECAM-K1:

http://www.pembers.freeserve.co.uk/World-TV-Standards/Transmission-Systems.html#CCIR


$ v4l2-ctl -d /dev/video0 --help
$ v4l2-ctl -d /dev/video0 --list-standards
$ v4l2-ctl -d /dev/video0 --list-inputs

$ v4l2-ctl -d /dev/video0 --set-standard=secam

or

$ v4l2-ctl -d /dev/video0 --set-standard=0x00320000
(SECAM-DK is defined as
  V4L2_STD_SECAM_D|V4L2_STD_SECAM_K|V4L2_STD_SECAM_K1 => 0x00320000 in
 include/linux/videodev2.h)

or

$ v4l2-ctl -d /dev/video0 --set-standard=0x00200000
(SECAM-K1 defined as 0x00200000 in include/linux/videodev2.h)

The setting should persist until you switch to another input (Tuner,
SVideo, Composite).  The Tuner input will limit what standard can
actually be set for the tuner.

Regards,
Andy

> Thanks by advance for you replies
> 
> BR
> -- 
> Emmanuel


