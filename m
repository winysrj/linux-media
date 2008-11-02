Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA2Kwv5Z020751
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 15:58:57 -0500
Received: from QMTA08.westchester.pa.mail.comcast.net
	(qmta08.westchester.pa.mail.comcast.net [76.96.62.80])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA2KwhFh008656
	for <video4linux-list@redhat.com>; Sun, 2 Nov 2008 15:58:43 -0500
Message-ID: <490E1482.7080107@personnelware.com>
Date: Sun, 02 Nov 2008 14:58:42 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: videotechmag@gmail.com, Michael H Schimek <mschimek@gmx.at>
Subject: Where do I post these bugs?
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

both are example code:  1 is from the Video for Linux v2 API spec.  2nd is
vivi.c (part of vanilla kernel)  I would post the vivi one to
http://bugzilla.kernel.org but it may really be part of capture.

1. memory leak:
valgrind ./capture --userp -d /dev/video1
==17153== malloc/free: in use at exit: 2,457,632 bytes in 5 blocks.

2. capabilities mismatch:
./capture --userp -d /dev/video1
VIDIOC_QBUF error 22, Invalid argument

details: http://linuxtv.org/v4lwiki/index.php/Test_Suite#Bugs_in_Examples

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
