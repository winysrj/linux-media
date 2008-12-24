Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOJ6adW028054
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:06:36 -0500
Received: from mail.anno.name (baal.anno.name [92.51.131.125])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOJ6LdO013415
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 14:06:22 -0500
Received: from [192.168.178.37] (p579C26DC.dip.t-dialin.net [87.156.38.220])
	by mail.anno.name (Postfix) with ESMTPA id 9D73922C4C24E
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 20:06:20 +0100 (CET)
Message-ID: <49528845.20904@wakelift.de>
Date: Wed, 24 Dec 2008 20:06:45 +0100
From: Timo Paulssen <timo@wakelift.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: recording from a playstation eye
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

Hello folks,

I just got a Playstation Eye (yay for Jesus!), but I am struggling to
record anything with it.
My log of attempts so far:

1. mencoder.
I couldn't get mencoder to work at all, used something like this:
mencoder -cache 128 -tv
driver=v4l2:width=640:height=480:outfmt=i420:fps=60:forceaudio:adevice=/dev/dsp:immediatemode=0:forceaudio
tv:// -oac copy -ovc copy -o test.avi
which led to a "floating point exception"

2. cheese.
All i see is the gstreamer test video input signal, even though I set it
correctly in gstreamer-properties and even the preview works.

3. gstreamer.
When running gst-launch-0.10 v4l2src device="/dev/video0" ! xvimagesink
I get a nice video, but its framerate is way too low and there is a
~1sec delay; this is unacceptable. when i try to set framerate=60, it
claims to not know the framerate option, even though the documentation
clearly states its existance.

4. ffmpeg.
when running ffplay -f video4linux2 /dev/video0 -s 640x480, I get
"[video4linux2 @ 0xb801f680]The v4l2 frame is 614400 bytes, but 460800
bytes are expected" multiple times.
when using any of the two libv4l shared libraries I get half a second
worth of frames out of it, then the image freezes and i get
"[video4linux2 @ 0xb7f49680]ioctl(VIDIOC_DQBUF): Input/output error".

5. spcaview.
(when using the preloads) Video is fine, recorded from wrong microphone,
mv'd /dev/dsp1 to /dev/dsp, but now I get really bad sound - everytime
there is sound, it sounds really trashy.



I am out of ideas now. I appreciate any pointers in the right direction :)
  - Timo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
