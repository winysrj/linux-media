Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2QHueFV000373
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 13:56:40 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2QHuLck023683
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 13:56:21 -0400
Received: by wf-out-1314.google.com with SMTP id 28so729942wfa.6
	for <video4linux-list@redhat.com>; Thu, 26 Mar 2009 10:56:20 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Mar 2009 14:56:20 -0300
Message-ID: <4b11e9290903261056t579ec37fw57f966fb8ed1311a@mail.gmail.com>
From: Beyonlo Beyonlo <beyonlo@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Flicker using v4l2.
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

    I'm using a BT878 chip and using a analog camera to get video. Why
when I get from v4l2 in 320x240 I have flicker?
    But if I do the same using v4l instead v4l2, getting from v4l in
320x240 I not have flicker.

    I doing testing passing my fingers with speed in front of the camera.\
    Capturing with v4l at 320x240 is perfect, but with v4l2 capturing
at 320x240 I have flicker.

    I'm using this capture card: bttv0: using: Prolink Pixelview
PV-BT878P+9B (PlayTV Pro rev.9B FM+NICAM) [card=72,autodetected]

    Any idea?

Thanks!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
