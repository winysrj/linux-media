Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC47C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D79BD21479
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfBKKOF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:14:05 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:38216 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbfBKKOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:14:04 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8b7gs8zWRO5Zt8bBg3Go0; Mon, 11 Feb 2019 11:14:02 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 4/6] videodev2.h: add V4L2_CTRL_FLAG_REQUIRES_REQUESTS
Date:   Mon, 11 Feb 2019 11:13:55 +0100
Message-Id: <20190211101357.48754-5-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfILXQ21QWdN518UubjzY7T0Hc9Ytel25nuxzv+aOnmKb0BccoT+pkCqto4R/Nb66sd0h08xYr6JhALpUkXpLKTxkq22Qg19gtdp2bictf4CL8WsJeQrr
 SuYQ73GdjoI2CrZYz2Od5Qqz+flbJWIZDuzFuYyZHYe1AUqIBpIe9p0kM+bGTDBx5e1zUF+wXqG6y1Nq9oYRs++s+HsrxNbgnDPtmbxnhBD95ep4rWa2bDWb
 T77R0tvedbHOYI6jr0KR/RgLQlown2l6KjTQO0qUNrqU3SA+0l0KcM808+xqQDnX8dG4s+vY+yZbMDmoNFCM5r2wyZwg2OLmHzgKd09gMu0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Indicate if a control can only be set through a request, as opposed
to being set directly. This is necessary for stateless codecs where
it makes no sense to set the state controls directly.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  4 ++++
 .../media/videodev2.h.rst.exceptions          |  1 +
 include/uapi/linux/videodev2.h                | 23 ++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index f824162d0ea9..b08c69cedb92 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -539,6 +539,10 @@ See also the examples in :ref:`control`.
 	``V4L2_CTRL_FLAG_GRABBED`` flag when buffers are allocated or
 	streaming is in progress since most drivers do not support changing
 	the format in that case.
+    * - ``V4L2_CTRL_FLAG_REQUIRES_REQUESTS``
+      - 0x0800
+      - This control cannot be set directly, but only through a request
+        (i.e. by setting ``which`` to ``V4L2_CTRL_WHICH_REQUEST_VAL``).
 
 
 Return Value
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 64d348e67df9..0caa72014dba 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -351,6 +351,7 @@ replace define V4L2_CTRL_FLAG_VOLATILE control-flags
 replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
 replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
 replace define V4L2_CTRL_FLAG_MODIFY_LAYOUT control-flags
+replace define V4L2_CTRL_FLAG_REQUIRES_REQUESTS control-flags
 
 replace define V4L2_CTRL_FLAG_NEXT_CTRL control
 replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 7f035d44666e..a78bfdc1df97 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1736,17 +1736,18 @@ struct v4l2_querymenu {
 } __attribute__ ((packed));
 
 /*  Control flags  */
-#define V4L2_CTRL_FLAG_DISABLED		0x0001
-#define V4L2_CTRL_FLAG_GRABBED		0x0002
-#define V4L2_CTRL_FLAG_READ_ONLY	0x0004
-#define V4L2_CTRL_FLAG_UPDATE		0x0008
-#define V4L2_CTRL_FLAG_INACTIVE		0x0010
-#define V4L2_CTRL_FLAG_SLIDER		0x0020
-#define V4L2_CTRL_FLAG_WRITE_ONLY	0x0040
-#define V4L2_CTRL_FLAG_VOLATILE		0x0080
-#define V4L2_CTRL_FLAG_HAS_PAYLOAD	0x0100
-#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE	0x0200
-#define V4L2_CTRL_FLAG_MODIFY_LAYOUT	0x0400
+#define V4L2_CTRL_FLAG_DISABLED			0x0001
+#define V4L2_CTRL_FLAG_GRABBED			0x0002
+#define V4L2_CTRL_FLAG_READ_ONLY		0x0004
+#define V4L2_CTRL_FLAG_UPDATE			0x0008
+#define V4L2_CTRL_FLAG_INACTIVE			0x0010
+#define V4L2_CTRL_FLAG_SLIDER			0x0020
+#define V4L2_CTRL_FLAG_WRITE_ONLY		0x0040
+#define V4L2_CTRL_FLAG_VOLATILE			0x0080
+#define V4L2_CTRL_FLAG_HAS_PAYLOAD		0x0100
+#define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE		0x0200
+#define V4L2_CTRL_FLAG_MODIFY_LAYOUT		0x0400
+#define V4L2_CTRL_FLAG_REQUIRES_REQUESTS	0x0800
 
 /*  Query flags, to be ORed with the control ID */
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
-- 
2.20.1

