Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3Gec03002624
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 11:40:38 -0500
Received: from lim.nl (93-125-163-97.dsl.alice.nl [93.125.163.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3GeQEe032335
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 11:40:26 -0500
Received: from [192.168.1.2] (ariel [192.168.1.2])
	by venus (Postfix) with ESMTP id 32B455C1D
	for <video4linux-list@redhat.com>; Mon,  3 Nov 2008 17:30:30 +0100 (CET)
Message-ID: <490F2730.9090703@lim.nl>
Date: Mon, 03 Nov 2008 17:30:40 +0100
From: Colin Brace <cb@lim.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: xawtv 'webcam' & uvcvideo webcam: ioctl error
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

I am trying to get the 'webcam' utility of xwatv working with my uvcvide 
webcam, a Creative Optia. My Fedora 9 system recognizes the webcam fine; 
here is the dmesg line:

uvcvideo: Found UVC 1.00 device Live! Cam Optia (041e:4057)

The webcam works with apps like Skype.

I'd like to configure it to upload images periodically to my website 
using the xawtv 'webcam' utility. I create ~/.webcamrc as indicated in 
the man page, but when I run it, it return an error message:

$ webcam
reading config file: /home/colin/.webcamrc
video4linux webcam v1.5 - (c) 1998-2002 Gerd Knorr
grabber config:
  size 320x240 [16 bit YUV 4:2:2 (packed, YUYV)]
  input Camera 1, norm (null), jpeg quality 75
  rotate=0, top=0, left=0, bottom=240, right=320
write config [ftp]:
  local transfer ~/Desktop/uploading.jpeg => ~/Desktop/webcam.jpeg
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Invalid argument
capturing image failed

Any ideas what is going wrong here?

TIA

-- 
  Colin Brace
  Amsterdam
  http://www.lim.nl


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
