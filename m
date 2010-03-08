Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o28GCgR6012604
	for <video4linux-list@redhat.com>; Mon, 8 Mar 2010 11:12:42 -0500
Received: from mail.hidayahonline.org (hidayahonline.org [67.19.146.138])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o28GCP8Y006572
	for <video4linux-list@redhat.com>; Mon, 8 Mar 2010 11:12:26 -0500
Message-ID: <4B9521E4.9040901@hidayahonline.org>
Date: Mon, 08 Mar 2010 11:12:20 -0500
From: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: image/jpeg format with v4l2 webcam
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

Hello, everyone.  I am using gstreamer (through gst-launch) to access my
v4l2 webcam (I have two - Logitech QuickCam for Notebooks Pro & Logitech
QuickCam Pro 5000), both of which work perfectly fine when using
video/x-raw-yuv-type pixel formats.

However, when I want to capture the video using the supported image/jpeg
pixel formats, which I presume would be higher quality (if I dump
straight to JPEG/MJPEG files) as no implicit conversion is happening, I
get framerates much lower than expected.

For example, my webcams claim to support up to 30 frames per second when
capturing in the image/jpeg format.  But the resulting video is much,
much slower.  And this scales, somehow, if I change the capture
framerate.  So, for example, if I specify 25 fps, it's slower than the
30, and 15 is slower than 25, etc.  But all of these are much slower in
terms of capture than their yuv-format counterparts.

Could someone guide me as to how I can find the source of this problem
and/or test different settings that might work?

Thanks!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
