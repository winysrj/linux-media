Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2T942Yn004538
	for <video4linux-list@redhat.com>; Mon, 29 Mar 2010 05:04:03 -0400
Received: from cleopatra.basesoft.com (cleopatra.basesoft.com [82.199.92.137])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2T93nwA007288
	for <video4linux-list@redhat.com>; Mon, 29 Mar 2010 05:03:50 -0400
Received: from localhost (unknown [127.0.0.1])
	by cleopatra.basesoft.com (Postfix) with ESMTP id 7FF094E4144
	for <video4linux-list@redhat.com>; Mon, 29 Mar 2010 09:03:46 +0000 (UTC)
Received: from cleopatra.basesoft.com ([127.0.0.1])
	by localhost (cleopatra.basesoft.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id rDK4w9G2UEWw for <video4linux-list@redhat.com>;
	Mon, 29 Mar 2010 11:03:43 +0200 (CEST)
Received: from [10.0.5.151] (unknown [89.137.114.41])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by cleopatra.basesoft.com (Postfix) with ESMTPSA id 9810D4DC161
	for <video4linux-list@redhat.com>;
	Mon, 29 Mar 2010 11:03:43 +0200 (CEST)
Message-ID: <4BB06CEF.9040500@basesoft.ro>
Date: Mon, 29 Mar 2010 12:03:43 +0300
From: Mircea Uifalean <mircea@basesoft.ro>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: problem with streaming from two webcams with v4l2
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

Hello guys.

I have two computers (same configuration, same operating system, same
package versions) and on each of them I have 2 webcams connected
(a4tech-pk-335e).
I'm running Mandriva, kernel 2.6.31.5 on both of them, and vlc version
1.0.5. On both computers the cameras are /dev/video0 and /dev/video1.

On one computer the streaming works perfect for both cameras, but for
the second one I can only get streaming for one or the other, never at
the same time.

The commands I use for streaming are the following (on both computers):

    |cvlc --color v4l2:///dev/video0 :v4l2-width=320 :v4l2-height=240
    --sout="#transcode{vcodec=FLV1,vb=640,width=320,height=240}:std{mux=ffmpeg{mux=flv},access=http{mime=video/x-flv},dst=0.0.0.0:9000/stream.flv}"

    cvlc --color v4l2:///dev/video1 :v4l2-width=320 :v4l2-height=240
    --sout="#transcode{vcodec=FLV1,vb=640,width=320,height=240}:std{mux=ffmpeg{mux=flv},access=http{mime=video/x-flv},dst=0.0.0.0:9001/stream.flv}"|

on the first computer, if I start both streams, I get the same output,
all is working properly, I can see both my streams. on the second
computer though, I start the first stream, output is ok, but when I'm
starting the second stream I get:

    |[webcam@computer2]$ cvlc --color v4l2:///dev/video1 :v4l2-width=320
    :v4l2-height=240
    --sout="#transcode{vcodec=FLV1,vb=640,width=320,height=240}:std{mux=ffmpeg{mux=flv},access=http{mime=video/x-flv},dst=0.0.0.0:9001/stream.flv}"
    VLC media player 1.0.4 Goldeneye
    [0x884e648] inhibit interface error: Failed to connect to the D-Bus
    session daemon: /usr/bin/dbus-launch terminated abnormally with the
    following error: No protocol specified
    Autolaunch error: X11 initialization failed.

    [0x884e648] main interface error: no suitable interface module
    [0x87bc560] main libvlc error: interface "inhibit,none"
    initialization failed
    No protocol specified
    [0x884ecc8] main interface error: no suitable interface module
    [0x87bc560] main libvlc error: interface "globalhotkeys,none"
    initialization failed
    [0x884ecc8] dummy interface: using the dummy interface module...
    [0x8868aa0] main access out: creating httpd
    [0x8865438] v4l2 demux error: VIDIOC_STREAMON failed
    [0x8865438] v4l2 demux error: cannot set input (Device or resource busy)
    [0x886c5f0] v4l2 access error: VIDIOC_STREAMON failed
    [0x886c5f0] v4l2 access error: cannot set input (Device or resource
    busy)
    [0x88556d0] main input error: open of `v4l2:///dev/video1' failed:
    (null)
    [0x88556d0] main input error: Your input can't be opened
    [0x88556d0] main input error: VLC is unable to open the MRL
    'v4l2:///dev/video1'. Check the log for details.|

On the first impression, it looks like /dev/video0 and /dev/video1 point
to the same camera, but when I start them individually, I can clearly
see the output is different, each time from the proper camera. I tried
connecting the cameras to different usb ports, but to no avail. The
problem is still there.

First place I posted my problem was on the vlc forum, but they said the
error comes from the device driver, so I thought I'd ask you guys.

Any ideas on what I could try to fix this problem ? It's really weird
that in one place it works fine and in the second it doesn't.

Any help is greatly appreciated. Thanks for any ideas.

-- 
Regards,
Mircea Uifalean


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
