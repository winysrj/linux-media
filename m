Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8844 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3F1Jot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 05:44:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MP3000VBK5EM5D0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jun 2013 10:44:45 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] v4l2: added missing mutex.h include to v4l2-ctrls.h
Date: Fri, 28 Jun 2013 11:44:22 +0200
Message-id: <1372412662-7101-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following error:

include/media/v4l2-ctrls.h:193:15: error: field ‘_lock’ has incomplete type
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_lock’:
include/media/v4l2-ctrls.h:570:2: error: implicit declaration of
	function ‘mutex_lock’ [-Werror=implicit-function-declaration]
include/media/v4l2-ctrls.h: In function ‘v4l2_ctrl_unlock’:
include/media/v4l2-ctrls.h:579:2: error: implicit declaration of
	function ‘mutex_unlock’ [-Werror=implicit-function-declaration]

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/v4l2-ctrls.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 7343a27..47ada23 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -22,6 +22,7 @@
 #define _V4L2_CTRLS_H
 
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/videodev2.h>
 
 /* forward references */
-- 
1.8.1.2

