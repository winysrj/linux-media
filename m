Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51110 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcEIPpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2016 11:45:11 -0400
From: Helen Koike <helen.koike@collabora.co.uk>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: Helen Koike <helen.koike@collabora.co.uk>
Subject: [PATCH] v4l2-compliance: Improve test readability when fail
Date: Mon,  9 May 2016 12:44:31 -0300
Message-Id: <3986d5a5773ab05e01d63c54687ad6425df0f952.1462807597.git.helen.koike@collabora.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of failure, print "q.create_bufs(node, 1, &fmt) != EINVAL" instead
of "ret != EINVAL"

Signed-off-by: Helen Koike <helen.koike@collabora.co.uk>
---

Hello,

I was wondering, why the q.create_bufs is expected to should return EINVAL in this test? The height and size are set to half of the original values, and the type and memory doesn't seems to change.

Thank you

 utils/v4l2-compliance/v4l2-test-buffers.cpp | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 6c5ed55..fb14170 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -955,8 +955,7 @@ int testMmap(struct node *node, unsigned frame_count)
 				fmt.s_height(fmt.g_height() / 2);
 				for (unsigned p = 0; p < fmt.g_num_planes(); p++)
 					fmt.s_sizeimage(fmt.g_sizeimage(p) / 2, p);
-				ret = q.create_bufs(node, 1, &fmt);
-				fail_on_test(ret != EINVAL);
+				fail_on_test(q.create_bufs(node, 1, &fmt) != EINVAL);
 				fail_on_test(testQueryBuf(node, cur_fmt.type, q.g_buffers()));
 				fmt = cur_fmt;
 				for (unsigned p = 0; p < fmt.g_num_planes(); p++)
-- 
1.9.1

