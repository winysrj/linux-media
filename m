Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPEgTa6028019
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 09:42:29 -0500
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPEgIvE029613
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 09:42:18 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1002905ywb.81
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 06:42:18 -0800 (PST)
Message-ID: <287b9de00811250642m5c731244k2c19f2c611e9eb57@mail.gmail.com>
Date: Tue, 25 Nov 2008 17:42:18 +0300
From: "=?KOI8-R?B?7cnIwcnMIPDF0sXIz8TDxdc=?=" <mumreg@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Couldn't get working streaming I/O on omap16xx camera IF
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

hi, i'm using OMAP5912 OSK kit with sensor (Micron MT9D131) attached
to camera parallel interface, kernel version - 2.6.26.
read()/write() functions works properly, but when i'm trying to use
streaming i/o (mmap buffers) using capture example from v4l2 specs i'm
getting the error 22 on VIDIOC_STREAMON ioctl request.
Any ideas ?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
