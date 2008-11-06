Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6J88b9013344
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 14:08:10 -0500
Received: from QMTA06.emeryville.ca.mail.comcast.net
	(qmta06.emeryville.ca.mail.comcast.net [76.96.30.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6IdWVx029483
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 13:39:49 -0500
Message-ID: <491339D9.2010504@personnelware.com>
Date: Thu, 06 Nov 2008 12:39:21 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: weeding out v4l ver 1 stuff
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

Given v4l version 1 is being dropped in December 08, we should remove stuff that
targets that api, right?

For instance:

http://linuxtv.org/hg/v4l-dvb/file/b45ffc93fb82/v4l2-apps/test/v4lgrab.c

      94 #ifdef CONFIG_VIDEO_V4L1_COMPAT
      194 #else

      195 	fprintf(stderr, "V4L1 API is not configured!\n");

I'll let someone else figure out if the whole file should be removed, or if it
has some value to v2.

And assuming someone agrees we should week out v1 stuff, where is the right
place to log this too?  http://bugzilla.kernel.org does not seem right.

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
