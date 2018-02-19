Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:55723 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752939AbeBSQqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 11:46:13 -0500
From: Jacopo Mondi <jacopo@jmondi.org>
To: hverkuil@xs4all.nl
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Subject: [PATCH] v4l2-compliance: Relax g/s_parm type check
Date: Mon, 19 Feb 2018 17:46:04 +0100
Message-Id: <1519058764-30045-1-git-send-email-jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit

commit 2e564ee56978874ddd4a8d061d37be088f130fd9
Author: Hans Verkuil <hans.verkuil@cisco.com>
	vidioc-g-parm.rst: also allow _MPLANE buffer types

V4L2 allows _MPLANE buffer types for capture/output on s/g_parm
operations.

Relax v4l2-compliance check to comply with this.

Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
---
 utils/v4l2-compliance/v4l2-test-formats.cpp | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index b7a32fe..25c4da5 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -1235,9 +1235,20 @@ int testParm(struct node *node)
 			    type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 			    type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 				return fail("G/S_PARM is only allowed for video capture/output\n");
-			if (!(node->g_caps() & buftype2cap[type]))
-				return fail("%s cap not set, but G/S_PARM worked\n",
-						buftype2s(type).c_str());
+
+			if (!((node->g_caps() & V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+					node->g_caps() & V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) &&
+					((buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+					buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)))
+						return fail("%s cap not set, but G/S_PARM worked\n",
+								buftype2s(type).c_str());
+
+			if (!((node->g_caps() & V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+					node->g_caps() & V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)) &&
+					((buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+					buftype2cap[type] == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)))
+						return fail("%s cap not set, but G/S_PARM worked\n",
+								buftype2s(type).c_str());
 		}
 	}

--
2.7.4
