Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m526nDL2020531
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 02:49:13 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.240])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m526n2xL010395
	for <video4linux-list@redhat.com>; Mon, 2 Jun 2008 02:49:02 -0400
Received: by an-out-0708.google.com with SMTP id d31so294947and.124
	for <video4linux-list@redhat.com>; Sun, 01 Jun 2008 23:49:02 -0700 (PDT)
Message-ID: <78877a450806012349j25cf72acm7aed866c3888ecdd@mail.gmail.com>
Date: Mon, 2 Jun 2008 16:49:02 +1000
From: "Gilles GIGAN" <gilles.gigan@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Detecting webcam unplugging
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

Hi all,
I have written a small app which uses V4L1 & V4L2 to do streaming captures
from video sources (mostly webcams).
Capture works perfectly. However, if a webcam is unplugged during the
capture, the app hangs on ioctl(VIDIOCSYNC) if the source uses a V4L1 driver
whereas, for V4L2, the ioctl(VIDIOC_DQBUF) fails instead of just hanging.
So, is there a reliable way to detect when a V4L1 video source has become
unavailable ?
I tested my app with the following V4L1 drivers:
gspca (01.00.20) and qc-usb (0.6.6)

Thanks,
Gilles
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
