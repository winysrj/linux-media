Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJBfomb001449
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 06:41:50 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJBfSRL004123
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 06:41:28 -0500
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 06:39:40 -0500
Message-Id: <1229686780.3120.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, ivtv-devel@ivtvdriver.org
Subject: cs5435: break; in S_CTRL routine appears bogus
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

Hans,

The break; statement you pointed out in the cs5435 driver does appear to
be bogus.  I haven't tested removing it yet.

Unfortunately there is no history in the hg log about this particular
line.  I can rationalize how it got there from a cx18-centric testing
point of view.  But obviously this module needs to work for other
drivers in the future.

Regards,
Andy


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
