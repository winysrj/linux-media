Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFLFsVj010623
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 16:15:54 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBFLFeJ5011142
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 16:15:40 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1295574fga.7
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 13:15:40 -0800 (PST)
Message-ID: <412bdbff0812151315j768feb89j5deaf4db4650749e@mail.gmail.com>
Date: Mon, 15 Dec 2008 16:15:40 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: V4L <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: v4l audio enumeration API
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

Hello,

A longstanding problem with some devices that provide uncompressed
video has to do with there being no way to associate an ALSA audio
device with the video.  For example, the HVR-950 provides it's analog
video stream and has a USB audio device for the audio, and there is no
way to know the two are associated.  This isn't an issue with devices
that have an MPEG encoder, since the card multiplexes the audio into
the MPEG stream automatically.

This has lead to some pretty crazy solutions from users such as
running tvtime or xawtv and arecord/aplay or sox at the same time,
with obvious problems with synchronization.  Markus was nice enough to
hack a version of tvtime that works for certain cards, but really this
is something the device be telling the application.  Having a
situation where every application out there needs to have custom logic
for each device is less than ideal.

Has anyone proposed an API for associating a video stream with an
audio device?  Does anyone see a downside in having a call that will
tell the calling application where to find the audio stream?

If nobody has done this before, I will take a closer look at the API
and make a proposal.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
