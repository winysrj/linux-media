Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2NK9Nvo016392
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:09:23 -0400
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2NK8HiW024944
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 16:08:17 -0400
Received: by qw-out-2122.google.com with SMTP id 8so998023qwh.39
	for <video4linux-list@redhat.com>; Mon, 23 Mar 2009 13:08:17 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: video4linux-list@redhat.com
Date: Mon, 23 Mar 2009 17:08:08 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231708.08860.lamarque@gmail.com>
Subject: Skype and libv4l
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

	I am trying to make Skype work with my webcam (Creative PC-CAM 880, driver 
zr364xx). By what I have found Skype only supports YU12, YUYV and UYVY pixel 
formats, which libv4l supports as source formats only and not as destination 
formats. I would like to have one of those pixel formats implement as 
destination format in libv4l but I need help to understand how to convert from 
YUV 4:2:0 to one of them. I think the UYVY (AKA YUV 4:2:2) is a good choice, 
well at least their names are very similar. It must be easy to convert once 
you have the Y, U and V components separated as they are in 
libv4lconvert/libv4lconvert.c. Could somebody help with this implementation?

-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
