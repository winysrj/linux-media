Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OMAiK1018539
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:10:44 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2OMAN0n000869
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:10:23 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1301098qwh.39
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 15:10:22 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Date: Tue, 24 Mar 2009 19:09:59 -0300
References: <200903231708.08860.lamarque@gmail.com> <49C8AF04.7070208@hhs.nl>
In-Reply-To: <49C8AF04.7070208@hhs.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3oVyJtMu4iONNbv"
Message-Id: <200903241909.59494.lamarque@gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: Skype and libv4
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

--Boundary-00=_3oVyJtMu4iONNbv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

	Hi,

	Applying this patch to libv4l makes Skype works with my webcam without 
changing the driver. Do you think the patch is ok?

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--Boundary-00=_3oVyJtMu4iONNbv
Content-Type: text/x-patch;
  charset="UTF-8";
  name="libv4l-0.5.9.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="libv4l-0.5.9.patch"

*** libv4l-0.5.9/libv4lconvert/libv4lconvert.c	2009-03-13 08:05:56.000000000 -0300
--- libv4l-0.5.9-lvs/libv4lconvert/libv4lconvert.c	2009-03-24 19:07:14.000000000 -0300
*************** static int v4lconvert_do_try_format(stru
*** 307,312 ****
--- 307,315 ----
      try_fmt = *dest_fmt;
      try_fmt.fmt.pix.pixelformat = supported_src_pixfmts[i].fmt;
  
+     /* Lamarque 24/03/2009 */
+     try_fmt.fmt.pix.field = V4L2_FIELD_ANY;
+ 
      if (!syscall(SYS_ioctl, data->fd, VIDIOC_TRY_FMT, &try_fmt))
      {
        if (try_fmt.fmt.pix.pixelformat == supported_src_pixfmts[i].fmt) {

--Boundary-00=_3oVyJtMu4iONNbv
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_3oVyJtMu4iONNbv--
