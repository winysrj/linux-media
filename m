Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:54208 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZD2S6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 14:58:20 -0400
Message-ID: <49F8A314.4000007@freemail.hu>
Date: Wed, 29 Apr 2009 20:57:24 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] v4l2: modify return value of VIDIOC_REQBUFS ioctl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 ioctls usually return 0 when the operation was successful
and -1 in case of error. Currently VIDIOC_REQBUFS returns the
number of buffers which is redundant because this information is
available in count field of struct v4l2_requestbuffers. The
V4L2 API specification, revision 0.24 [1] explicitly specifies for
VIDIOC_REQBUFS that the return value shall be 0 on success.

The patch was tested with v4l-test 0.13 [2] with vivi driver.

References:
[1] V4L2 API specification, revision 0.24
    http://v4l2spec.bytesex.org/spec/r13696.htm

[2] v4l-test: Test environment for Video For Linux Two API
    http://v4l-test.sourceforge.net/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.30-rc3/drivers/media/video/videobuf-core.c.orig	2009-04-22 05:07:00.000000000 +0200
+++ linux-2.6.30-rc3/drivers/media/video/videobuf-core.c	2009-04-29 18:30:15.000000000 +0200
@@ -439,6 +439,7 @@ int videobuf_reqbufs(struct videobuf_que
 	}

 	req->count = retval;
+	retval = 0;

  done:
 	mutex_unlock(&q->vb_lock);
