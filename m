Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o5I0BOvO004728
	for <video4linux-list@redhat.com>; Thu, 17 Jun 2010 20:11:24 -0400
Received: from web82204.mail.mud.yahoo.com (web82204.mail.mud.yahoo.com
	[209.191.86.99])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o5I0BDT5001412
	for <video4linux-list@redhat.com>; Thu, 17 Jun 2010 20:11:13 -0400
Message-ID: <238416.59894.qm@web82204.mail.mud.yahoo.com>
Date: Thu, 17 Jun 2010 17:11:12 -0700 (PDT)
From: David Milici <davemilici@sbcglobal.net>
Subject: USB audio / video sync question
To: video4linux-list@redhat.com
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

Hi all--

I'm working with Pixart USB camera, using Video4Linux for video capture and ALSA for audio capture. I'm having trouble establishing sync between audio and video streams during capture sessions. Sometimes sync is acceptable, and other times audio leads video.

I tried enabling timestamps on ALSA PCM updates to compare with V4L timestamps, and for 20 FPS camera input see that video frames and audio blocks are typically within 50 msec of each other.

What happens on some sessions is that audio blocks show up sooner than the first video frame, like 3 blocks will be delivered ~150 msec earlier. Some other saved capture sessions are out of sync by even more time.

This makes me wonder if the audio and video input streams could be running at their respective driver's pace, and "sync" happens to be incidental from the streams running concurrently.

What then is the recommended method(s) for capturing audio and video streams in sync? Is there an example available for a USB camera?

Thanks for any help you could offer,
--Dave Milici

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
