Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK0o3Nq013941
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:50:03 -0500
Received: from smtp-vbr8.xs4all.nl (smtp-vbr8.xs4all.nl [194.109.24.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK0nngI022303
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:49:49 -0500
Received: from durdane.lan (marune.xs4all.nl [82.95.89.49])
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id mBK0nj93084346
	for <video4linux-list@redhat.com>; Sat, 20 Dec 2008 01:49:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Sat, 20 Dec 2008 01:49:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812200149.45272.hverkuil@xs4all.nl>
Subject: [REVIEW] Please review V4 of v4l2-dev.c
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

I've improved comments and naming consistencies.

In addition I fixed race conditions in the register function (these have 
been there for a very long time) and improved robustness a bit.

I think I've now gone over every single line of this code and it's looking 
good IMHO.

As always, the change is in my ~hverkuil/v4l-dvb tree.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
