Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6QD4rCu025674
	for <video4linux-list@redhat.com>; Sun, 26 Jul 2009 09:04:53 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.156])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6QD4Y50007457
	for <video4linux-list@redhat.com>; Sun, 26 Jul 2009 09:04:34 -0400
Received: by fg-out-1718.google.com with SMTP id l27so317169fgb.7
	for <video4linux-list@redhat.com>; Sun, 26 Jul 2009 06:04:33 -0700 (PDT)
From: Denis Loginov <dinvlad@gmail.com>
To: amol.debian@gmail.com
Date: Sun, 26 Jul 2009 16:04:30 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907261604.30661.dinvlad@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: driver for 041e:4055 Creative Technology, Ltd Live! Cam Video IM
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

Actually, according to http://linux-uvc.berlios.de/ , you can just try 'USB 
Video Class' Driver, i.e. Device Drivers -> Multimedia Devices -> Video 
Capture Adapters -> V4L USB Devices -> (M) USB Video Class (UVC) & (y) UVC 
input events device support 
(CONFIG_USB_VIDEO_CLASS=m & USB_VIDEO_CLASS_INPUT_EVDEV=y).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
