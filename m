Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADMvmAj026742
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 17:57:48 -0500
Received: from QMTA01.westchester.pa.mail.comcast.net
	(qmta01.westchester.pa.mail.comcast.net [76.96.62.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADMueTG024639
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 17:56:41 -0500
Message-ID: <491CB0A6.9080509@personnelware.com>
Date: Thu, 13 Nov 2008 16:56:38 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: minimum v4l2 api 
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

Apparently vivi is messed up enough that maybe it makes sense to write a new
test driver.

What is the minimum interface a v4l2 driver could have?

Something like: it registers itself as /dev/videoN, and
QueryCaps returns nothing.
It does not return any image. (yeah ?)
It can be unloaded.

and anything else that someone thinks is required for a well behaved driver that
follows the spec.

The plan is to start with that, get it and my tester working in harmony, then
start adding things to both sides of the fence.  I am thinking additional
features will be enabled via module parameters, so that it can always be dumbed
down back to it's minimum.

Carl K


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
