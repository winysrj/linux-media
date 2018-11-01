Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57954 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbeKBCwQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 22:52:16 -0400
From: Guillaume Tucker <guillaume.tucker@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>
Subject: [PATCH v4l-utils] v4l2-compliance: flush stdout before calling fork()
Date: Thu,  1 Nov 2018 17:46:35 +0000
Message-Id: <e6b6c6d9cb6a8896090ea13d9e53de6034840c56.1541094092.git.guillaume.tucker@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to avoid corrupt log output, flush stdout before calling
fork() when running streaming tests.  This is to prevent any remaining
characters in the stdout buffer from being output both in the parent
and child process.

Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
---
 utils/v4l2-compliance/v4l2-test-buffers.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 6864f924daec..ee05739a2f73 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -1204,6 +1204,7 @@ static int testBlockingDQBuf(struct node *node, cv4l_queue &q)
 	 * This test checks if a blocking wait in VIDIOC_DQBUF doesn't block
 	 * other ioctls.
 	 */
+	fflush(stdout);
 	pid_dqbuf = fork();
 	fail_on_test(pid_dqbuf == -1);
 
@@ -1224,6 +1225,7 @@ static int testBlockingDQBuf(struct node *node, cv4l_queue &q)
 	/* Check that it is really blocking */
 	fail_on_test(pid);
 
+	fflush(stdout);
 	pid_streamoff = fork();
 	fail_on_test(pid_streamoff == -1);
 
-- 
2.11.0
