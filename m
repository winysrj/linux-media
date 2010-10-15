Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id o9FJKm8o030474
	for <video4linux-list@redhat.com>; Fri, 15 Oct 2010 15:20:48 -0400
Received: from mail-yw0-f46.google.com (mail-yw0-f46.google.com
	[209.85.213.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9FJKbYH026252
	for <video4linux-list@redhat.com>; Fri, 15 Oct 2010 15:20:38 -0400
Received: by ywi6 with SMTP id 6so653425ywi.33
	for <video4linux-list@redhat.com>; Fri, 15 Oct 2010 12:20:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Oct 2010 16:20:36 -0300
Message-ID: <AANLkTikd11YrucEOQ3ugkMY=GO4fxzAg0THMRJyCR4b5@mail.gmail.com>
Subject: Camera Configurations
From: "Marlos C. Machado" <marlos@dcc.ufmg.br>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hello,

I'm developing a game which uses a PSEye (Camera) in Ubuntu. I'm able
to play what the camera captures in the game but the camera is auto
adjusting its gain (V4L2_CID_AUTOGAIN). I don't want this behavior. I
intend to disable AUTOGAIN with v4l2 and get the frames with
gstreamer.

I've programmed this:

if((ret = query_ioctl(hdevice, currentctrl, &queryctrl)) == 0)

but this fails, meaning that "NEXT_CTRL flag not supported". How can I
easily disable autogain?

The code I tried to run is in here: http://gitorious.org/cameractls

Thanks in advance.


-- 
Marlos Cholodovskis Machado

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
