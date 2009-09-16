Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8GNW9eK020548
	for <video4linux-list@redhat.com>; Wed, 16 Sep 2009 19:32:09 -0400
Received: from wmproxy1-g27.free.fr (wmproxy1-g27.free.fr [212.27.42.91])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8GNVv7Z028312
	for <video4linux-list@redhat.com>; Wed, 16 Sep 2009 19:31:58 -0400
Received: from wmproxy1-g27.free.fr (localhost [127.0.0.1])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id 4D493337D
	for <video4linux-list@redhat.com>;
	Thu, 17 Sep 2009 01:31:57 +0200 (CEST)
Received: from UNKNOWN (imp7-g19.priv.proxad.net [172.20.243.137])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id 3A00C2E9B
	for <video4linux-list@redhat.com>;
	Thu, 17 Sep 2009 01:31:57 +0200 (CEST)
Message-ID: <1253143917.4ab1756d31f7f@imp.free.fr>
Date: Thu, 17 Sep 2009 01:31:57 +0200
From: yann.lepetitcorps@free.fr
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: v4l open/read/close "atomic" speed and S910/S510/bayer help 
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

Hi,

I have begin to work about a video mixer that use a Hercules Dj Console Rmx for
composing multiples v4l devices outputs into one X11 window (for video mixing /
composing between an Hauppauge WinTV-HVR1110 and one or two USB webcams for
example).

I have make a very basic YUYV to RGB[A] conversion routine that seem to work
with the WinTV (but only on B&W for the instant, but this isn't a problem
because I can read directely RGB values from my /dev/video2 and so, haven't to
deal with top/bottom frames entrelacement and lines inversions with the RGB
format as it's the case with the YUYV format ... and I have already a B&W video
flux with the YUYV format, so I think the color support on YUYV is really near)

This work "good" with the WinTV because I have only to make a conversion from
RGB24 (my WinTV card output) to RGB (my video card input), but when I have make
some timings, I found that the read to the /dev/video spend something like 80ms
per frame and I have only something like 12 fps on the end :(

Something like 50ms isn't normally a minimum for to have something decent ???

Is really the Hauppauge WinTV-HVR1110 driver as "slow" with open/read/close
on /dev/video ???

In first, I have think that is my RGB24 to RGB32 conversion and/or the X11
display via XImage that can spend the most of time ... but this isn't the case
(only somes very littles milliseconds, a little fraction of the total time,
something like 5%/10% at maximum)

But my problem isn't really here because I think that I use until now a very bad
v4l programming model with my open(s)/read(s)/close(s) on multiples /dev/video*
and project to use a multibuffered schema in a very near future (V4L docs say
that this can be really more speed)

But my real problem is that I don't know (and have really a lot of difficulty to
find) how to decompress the S910 or S510 video format that a lot of various
webcams that I have tested can output :(

=> where can I find simple/basic C/C++ tutorials for to make S510/S910 to RGB[A]
or YUYV conversions ???


@+
Yannoo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
