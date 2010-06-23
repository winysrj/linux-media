Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o5N5PwRN027952
	for <video4linux-list@redhat.com>; Wed, 23 Jun 2010 01:25:58 -0400
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5N5Pm1W007475
	for <video4linux-list@redhat.com>; Wed, 23 Jun 2010 01:25:49 -0400
Received: from jim.nabble.com ([192.168.236.80])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <emmanuelchanson@gmail.com>) id 1ORIAu-0006Jr-0X
	for video4linux-list@redhat.com; Tue, 22 Jun 2010 22:07:00 -0700
Date: Tue, 22 Jun 2010 22:07:00 -0700 (PDT)
From: manunc <emmanuelchanson@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <1277269620009-5211808.post@n2.nabble.com>
Subject: V4L & VLC 1.0.6 and standard selection
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


I am trying to catch my tuner card signal by using vlc and v4l

Under Fedora 12:
vlc-1.0.6-1.fc12.i686
vlc-core-1.0.6-1.fc12.i686


libv4l-0.6.4-1.fc12.i686
xorg-x11-drv-v4l-0.2.0-3.fc12.1.i686
v4l2-tool-1.0.3-5.fc12.i686


By using the cvlc command to catch the tuner card signal and setting
standard in the command line I did not see the SECAM K1, so I wonder if the
fix has been committed or not in this release or if I have to patch the
sources:

http://git.videolan.org/?p=vlc.git;a=commitdiff;h=beb5d0fdc3c4b8b12ec385f96ab8a27c342b7236

I used:

$ cvlc -vv v4l2:// :v4l2-dev=/dev/video0 :v4l2-adev=hw.1,0
:v4l2-tuner-frequency=207250 :v4l2-standard=13 ....

I dont see SECAM K1
....

[0xb7108988] v4l2 demux debug: Trying libv4l2 wrapper
[0xb7108988] v4l2 demux debug: opening device '/dev/video0'
[0xb7108988] v4l2 demux debug: V4L2 device: BT878 video (Hauppauge (bt878))
using driver: bttv (version: 0.9.18) on PCI:0000:00:0b.0
[0xb7108988] v4l2 demux debug: the device has the capabilities: (X) Video
Capure, ( ) Audio, (X) Tuner, ( ) Radio
[0xb7108988] v4l2 demux debug: supported I/O methods are: (X) Read/Write,
(X) Streaming, ( ) Asynchronous
[0xb7108988] v4l2 demux debug: device support raw VBI capture
[0xb7108988] v4l2 demux debug: video input 0 (Television) has type: Tuner
adapter *
[0xb7108988] v4l2 demux debug: video input 1 (Composite1) has type: External
analog input
[0xb7108988] v4l2 demux debug: video input 2 (S-Video) has type: External
analog input
[0xb7108988] v4l2 demux debug: video input 3 (Composite3) has type: External
analog input
[0xb7108988] v4l2 demux debug: video standard 0 is: NTSC
[0xb7108988] v4l2 demux debug: video standard 1 is: NTSC-M
[0xb7108988] v4l2 demux debug: video standard 2 is: NTSC-M-JP
[0xb7108988] v4l2 demux debug: video standard 3 is: NTSC-M-KR
[0xb7108988] v4l2 demux debug: video standard 4 is: PAL *
[0xb7108988] v4l2 demux debug: video standard 5 is: PAL-BG
[0xb7108988] v4l2 demux debug: video standard 6 is: PAL-H
[0xb7108988] v4l2 demux debug: video standard 7 is: PAL-I
[0xb7108988] v4l2 demux debug: video standard 8 is: PAL-DK
[0xb7108988] v4l2 demux debug: video standard 9 is: PAL-M
[0xb7108988] v4l2 demux debug: video standard 10 is: PAL-N
[0xb7108988] v4l2 demux debug: video standard 11 is: PAL-Nc
[0xb7108988] v4l2 demux debug: video standard 12 is: PAL-60
[0xb7108988] v4l2 demux debug: video standard 13 is: SECAM
[0xb7108988] v4l2 demux debug: video standard 14 is: SECAM-B
[0xb7108988] v4l2 demux debug: video standard 15 is: SECAM-G
[0xb7108988] v4l2 demux debug: video standard 16 is: SECAM-H
[0xb7108988] v4l2 demux debug: video standard 17 is: SECAM-DK
[0xb7108988] v4l2 demux debug: video standard 18 is: SECAM-L
[0xb7108988] v4l2 demux debug: video standard 19 is: SECAM-Lc
[0xb7108988] v4l2 demux debug: tuner 0 (Television) has type: Analog TV,
frequency range: 44000,0 kHz -> 958000,0 kHz
[0xb7108988] v4l2 demux debug: tuner 0 (Television) frequency: 207250,0 kHz
...

A developper from videolan told me this:
That list comes from the V4L2 driver for your analog TV capture card. It
does not come from VLC. So we cannot "fix" it.
In any case, SECAM-K1 is probably one of the choice, but with a different
name.

Does anyone know if some of the options can be applied to decode SECAM K1?
ou K'

Thanks by advance for you replies

BR
-- 
Emmanuel
-- 
View this message in context: http://video4linux-list.1448896.n2.nabble.com/V4L-VLC-1-0-6-and-standard-selection-tp5211808p5211808.html
Sent from the video4linux-list mailing list archive at Nabble.com.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
