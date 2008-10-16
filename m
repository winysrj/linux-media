Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GJRZ5k018866
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:27:35 -0400
Received: from smtp.unisys.com.br (smtp.unisys.com.br [200.220.64.9])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9GJRLtc001847
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:27:22 -0400
From: danflu@uninet.com.br
To: video4linux-list@redhat.com
Date: Thu, 16 Oct 2008 16:27:20 -0300
Message-id: <48f79598.2dc.ed1.1231012865@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Subject: grabing audio from capture card
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

Hello!

I have have a capture card (Prolink Pixelview) and i'm
currently trying to grab audio samples from it. It has an
"audio input" and an "audio output" 

I tested audio using xawtv (Included a "p2 to rca adaptor"
to plug a digital camcorder in audio input.) and it worked
well using the loopback cable that conects "audio out" from
tv card to the sound card "line in" but did not work without
using this loopback cable...

My device generates the following output:

cap.driver: bttv
cap.card: BT878 video (Prolink Pixelview 
cap.bus_info: PCI:0000:05:01.0
cap.version: 2321

Printing /dev/video0 capabilities

V4L2_CAP_VIDEO_CAPTURE
V4L2_CAP_VIDEO_OVERLAY
V4L2_CAP_VBI_CAPTURE
V4L2_CAP_TUNER
V4L2_CAP_READWRITE
V4L2_CAP_STREAMING


What device should i use to grab audio samples (videox ?) ?
The usage of the v4l api is the same to grab audio ? (memory
mapping etc?)

I observed that xawtv did not playback any audio without the
loopback cable, so it seems that it is not possible to
capture audio using v4l without this cable, is it true ???

Please help !
Thank you
Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
