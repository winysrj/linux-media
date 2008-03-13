Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2DKaCMR014751
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 16:36:12 -0400
Received: from web51402.mail.re2.yahoo.com (web51402.mail.re2.yahoo.com
	[206.190.38.181])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2DKZdAH010944
	for <video4linux-list@redhat.com>; Thu, 13 Mar 2008 16:35:40 -0400
Date: Thu, 13 Mar 2008 13:35:33 -0700 (PDT)
From: Philip Kasten <pskasten@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <291552.23680.qm@web51402.mail.re2.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Subject: noob help -- Logitech Pro 9000 and streamer/XawTV problem
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

(Apologies if this has all been hashed and rehashed -- I've been googling for quite some time and haven't found any answers.)

I am running Ubuntu 7.10, and am using a Logitech Pro 9000 webcam.  Ekiga, Luvcview, ffmpeg and ucview all work fine.

However, streamer and xawtv don't work.  I need streamer to work, because it seems to be the only program that can periodically take jpeg snapshots and save them to a file (simply overwriting the previous contents).  The other programs such as ffmpeg seem to only support creating movies.

Given this command:

$ streamer -r 1 -s 320x200 -o foo.ppm -d 

I end up with an endless stream of ioctl failures, only two of which I captured below (they're all the same); here's the output:

checking writer files [multiple image files] ...
  video name=ppm ext=ppm: OK
files / video: 24 bit TrueColor (BE: rgb) / audio: none
vid-open: trying: v4l2-old... 
vid-open: failed: v4l2-old
vid-open: trying: v4l2... 
v4l2: open
v4l2: device info:
  uvcvideo 0.1.0 / UVC Camera (046d:0990) @ 0000:00:1d.7
vid-open: ok: v4l2
movie_init_writer start
setformat: 24 bit TrueColor (BE: rgb) (320x200): failed
setformat: 24 bit TrueColor (LE: bgr) (320x200): failed
setformat: 32 bit TrueColor (BE: -rgb) (320x200): failed
v4l2: new capture params (320x240, YUYV, 153600 byte)
setformat: 16 bit YUV 4:2:2 (packed, YUYV) (320x240): ok
v4l2: new capture params (320x240, YUYV, 153600 byte)
movie_init_writer end (h=0x806a6e8)
movie_writer_start
v4l2: buf 0: video-cap 0x0+153600, used 0
v4l2: buf 1: video-cap 0x26000+153600, used 0
v4l2: buf 2: video-cap 0x4c000+153600, used 0
v4l2: buf 3: video-cap 0x72000+153600, used 0
v4l2: buf 4: video-cap 0x98000+153600, used 0
v4l2: buf 5: video-cap 0xbe000+153600, used 0
v4l2: buf 6: video-cap 0xe4000+153600, used 0
v4l2: buf 7: video-cap 0x10a000+153600, used 0
v4l2: buf 8: video-cap 0x130000+153600, used 0
v4l2: buf 9: video-cap 0x156000+153600, used 0
v4l2: buf 10: video-cap 0x17c000+153600, used 0
v4l2: buf 11: video-cap 0x1a2000+153600, used 0
v4l2: buf 12: video-cap 0x1c8000+153600, used 0
v4l2: buf 13: video-cap 0x1ee000+153600, used 0
v4l2: buf 14: video-cap 0x214000+153600, used 0
v4l2: buf 15: video-cap 0x23a000+153600, used 0
writer_video_thread start [pid=15005]
convert_thread start [pid=15005]
convert-in : 320x240 16 bit YUV 4:2:2 (packed, YUYV) (size=153600)
convert-out: 320x240 24 bit TrueColor (BE: rgb) (size=230400)
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 [];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): Invalid argument
grab_put_video: grab image failed
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 [];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): Invalid argument
grab_put_video: grab image failed

Any help would be greatly appreciated.  If there is another program that provides the same (command line driven) feature set, I'd be happy to use it instead.

Thanks,
PK






      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
