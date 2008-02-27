Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1R8DK6X005254
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 03:13:20 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1R8ChIf028702
	for <video4linux-list@redhat.com>; Wed, 27 Feb 2008 03:12:43 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <54fa1a0d9c5bcdfcb2ba.1204098881@localhost>
Date: Tue, 26 Feb 2008 23:54:41 -0800
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1204098775 28800
# Node ID 54fa1a0d9c5bcdfcb2ba70be2fc68d51a1ab7b9c
# Parent  9756fb75295872570d1fa49b4bcf5d0967ecedaa
v4l: Deadlock in videobuf-core for DQBUF waiting on QBUF

Avoid a deadlock where DQBUF is holding the vb_lock while waiting on a QBUF
which also needs the vb_lock.  Reported by Hans Verkuil <hverkuil@xs4all.nl>.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
Pull from: http://ifup.org/hg/v4l-dvb

Should be merged for 2.6.25

diff --git a/linux/drivers/media/video/videobuf-core.c b/linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c
+++ b/linux/drivers/media/video/videobuf-core.c
@@ -606,7 +606,9 @@ int videobuf_dqbuf(struct videobuf_queue
 		goto done;
 	}
 	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
+	mutex_unlock(&q->vb_lock);
 	retval = videobuf_waiton(buf, nonblocking, 1);
+	mutex_lock(&q->vb_lock);
 	if (retval < 0) {
 		dprintk(1, "dqbuf: waiton returned %d\n", retval);
 		goto done;


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
