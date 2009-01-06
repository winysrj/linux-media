Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n063Rb32004596
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 22:27:37 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n063RLPi017905
	for <video4linux-list@redhat.com>; Mon, 5 Jan 2009 22:27:21 -0500
Received: by rv-out-0506.google.com with SMTP id f6so8169111rvb.51
	for <video4linux-list@redhat.com>; Mon, 05 Jan 2009 19:27:20 -0800 (PST)
Message-ID: <5e9665e10901051927w14dbe86ftfec035cbf9a60b19@mail.gmail.com>
Date: Tue, 6 Jan 2009 12:27:19 +0900
From: "DongSoo Kim" <dongsoo.kim@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: =?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>
Subject: Some questions about v4l2 exposure control on camera device
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

Hello V4L2 people.

I'm working on camera device drivers over 5M pixel and made drivers based on
V4L2 API.

Actually I'm still working on it.

By the way, I have some questions in exposure control.

If my guess is right, V4L2_CID_EXPOSURE_* CIDs are what I'm looking for.

Control factors that I intend to handle for exposure are like following.

  1. Shutter speed
  2. Iris (F-number)
  3. ISO(sensor gain)

And found out using V4L2_CID_EXPOSURE_AUTO I could change exposure mode.

But here is the thing.

What should I supposed to do if I need to control iris F-number when I set
V4L2_EXPOSURE_MANUAL or V4L2_EXPOSURE_APARTURE_PRIORITY?

I see that it is possible to control shutter speed using
V4L2_CID_EXPOSURE_ABSOLUTE but what can I do for iris? cannot find out.

And one more thing.

If I set exposure mode to V4L2_EXPOSURE_MANUAL, it means that it is
necessary to control in manual iris, shutter, and even ISO sometimes.

According to videodev2.h I guess we have only V4L2_CID_EXPOSURE_ABSOLUTE to
control shutter speed.

Is there any cool way to set in manual way with shutter speed, iris, and
even ISO at once?

If there is no way, how about making a new API for that?

At any rate, I need an API for exposure (a exposure like a real
camera...shutter, iris things) so... I think I've gotta make something for
that.

If somebody is working on it, can we discuss together about this issue? If
you don't mind.

Regards,
Nate

-- 
========================================================
Dong Soo, Kim
Engineer
Mobile S/W Platform Lab. S/W centre
Telecommunication R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
Anycall : 010-9530-0296
Homepage : http://www.kdsoo.com
========================================================
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
