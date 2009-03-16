Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2GEspri000928
	for <video4linux-list@redhat.com>; Mon, 16 Mar 2009 10:54:52 -0400
Received: from node03.cambriumhosting.nl (node03.cambriumhosting.nl
	[217.19.16.164])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2GErgDx005983
	for <video4linux-list@redhat.com>; Mon, 16 Mar 2009 10:53:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id 278B0B000182
	for <video4linux-list@redhat.com>; Mon, 16 Mar 2009 15:53:42 +0100 (CET)
Received: from node03.cambriumhosting.nl ([127.0.0.1])
	by localhost (node03.cambriumhosting.nl [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id z38DyAy84Rnv for <video4linux-list@redhat.com>;
	Mon, 16 Mar 2009 15:53:40 +0100 (CET)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl
	[84.245.3.195])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id A7A2BB000084
	for <video4linux-list@redhat.com>; Mon, 16 Mar 2009 15:53:40 +0100 (CET)
Received: from [192.168.1.239] (unknown [192.168.1.239])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id 4B5A723BC415
	for <video4linux-list@redhat.com>; Mon, 16 Mar 2009 15:52:18 +0100 (CET)
Message-ID: <49BE67F2.2000402@powercraft.nl>
Date: Mon, 16 Mar 2009 15:53:38 +0100
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: how to record synchronized real time audio video from usb v4l2
 devices with generic tools.
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

Hello everybody,

I have been trying to make a high quality live recording system from an
eeepc 701 with data input from usb devices. I have used several 2+
MegaPixel UVC webcams and USB composite grabbing devices.

I have used gstreamer, vlc, and mplayer, ffmpeg and mencoder for testing.
I spent 7 days doing testing and sending messages to the mplayer,
mencoder, gstreamer and uvc mailinglists and irc channels.

The end result was negative, I have been unable to get my webcams working
with mencoder or mplayer with higher resolutions then 640x480 while it
was capable of 1600x1200@5fps and 800x600@25fps.

gstreamer had limited functionality unable to select v4l2 input sources
(i found workarounds) and has extreme high cpu requirements making it
unusable for live data.

With lower resolutions I have had issues that disk throughput was to high
for the ssd disks +15MBs or that single treaded encoders where to heavy
for the eeepc 701 (or 901 1,6GHz atom)

There were some commands that run fine with for example 320x240@30fps
with mpeg4 and mp3 in avi containers but audio and video was out of sync.

ffmpeg was unable to process from two named pipes and needed to run with
two separated instances that would mux later, but generated out of sync
video with wrong fps.

One of the major issues was instable fps form the v4l2 recourses
especially when staring the stream, i don't know why this is but it make
synchronized recording very hard.

While there are 101 different ways to do things I spent a lot of time on
trying some of these ways to work.

I have attached all my reports and info in the reports0.tar.gz that can
be found here: http://filebin.ca/swcom/reports0.tar.gz

The main file is in the doc/notes.log and test reports of various quality
can be found in the other directories.

I really hope somebody will be able to get a nice test systems working
and can show me how it can be done on low end machines/embedded systems
with usb2.0 interfaces.

I hope all the collected commands and reports can be of great value for
anybody trying to get recording and possible later live streaming possible.

Feel free to contact me when you have any questions or when you got some
nice setup working with free/libre open source software and recognize
generic tools.

It would also be nice to see some libraries for video and audio
processing that deliver advanced features found in many digital photo and
video camera's. So it would be possible to make an usable photo/video
device with free/libre open source tools.

Thanks in advance,

Best regards,

Jelle de Jong

http://filebin.ca/swcom/reports0.tar.gz

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
