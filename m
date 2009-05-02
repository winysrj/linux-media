Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n426w0jl001763
	for <video4linux-list@redhat.com>; Sat, 2 May 2009 02:58:00 -0400
Received: from inblrg01.tcs.com (inblrg01.tcs.com [121.242.48.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n426vP1k013472
	for <video4linux-list@redhat.com>; Sat, 2 May 2009 02:57:47 -0400
MIME-Version: 1.0
To: video4linux-list@redhat.com
From: Mahalakshmi Gonuguntala <mahalakshmi.gonuguntala@tcs.com>
Date: Sat, 2 May 2009 12:27:22 +0530
Message-ID: <OFACFCCBF6.C089A5C3-ON652575AA.0026363F-652575AA.00263648@tcs.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Subject: V4l2 display
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

I am writing a code to display a video using V4l2 drivers (On OMAPEVM ).

When I run the code.. It is giving an error message that .. memory could
not be allocated.
This error I am getting when I am calling dispaly application from a QT
application,(QT internally uses /dev/fb0 ).
But when I run the display application directly (with out integrating with
QT).. memory allocation is proper and display is also coming.


reqbuf.type = V4L2_BUF_TYPE_VIDEO_OUTPUT; //V4L2_BUF_TYPE_VIDEO_OVERLAY
reqbuf.count = numbuffers;
reqbuf.memory = V4L2_MEMORY_USERPTR; //V4L2_MEMORY_MMAP;

printf("allocating buffers \n");
ret = ioctl(display_fd, VIDIOC_REQBUFS, &reqbuf);

I am getting the same error with V4L2_MEMORY_MMAP memory configuration
also.

Can somebody guide me .. what could be the reason for this?

Thanks,
Mahalakshmi.
__________________________________________
Experience certainty.   IT Services
                  Business Solutions
                  Outsourcing
____________________________________________

=====-----=====-----=====
Notice: The information contained in this e-mail
message and/or attachments to it may contain 
confidential or privileged information. If you are 
not the intended recipient, any dissemination, use, 
review, distribution, printing or copying of the 
information contained in this e-mail message 
and/or attachments to it are strictly prohibited. If 
you have received this communication in error, 
please notify us by reply e-mail or telephone and 
immediately and permanently delete the message 
and any attachments. Thank you



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
