Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36726 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729587AbeKTBls (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:41:48 -0500
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] v4l2-compliance: Remove spurious error messages
Date: Mon, 19 Nov 2018 12:17:43 -0300
Message-Id: <20181119151743.27275-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of a couple confusing error messages, namely:

	test VIDIOC_G_FMT: OK
		fail: v4l2-test-formats.cpp(464): pix_mp.plane_fmt[0].reserved not zeroed
		fail: v4l2-test-formats.cpp(752): Video Output Multiplanar is valid, but TRY_FMT failed to return a format
	test VIDIOC_TRY_FMT: FAIL
		fail: v4l2-test-formats.cpp(464): pix_mp.plane_fmt[0].reserved not zeroed
		fail: v4l2-test-formats.cpp(1017): Video Output Multiplanar is valid, but no S_FMT was implemented
	test VIDIOC_S_FMT: FAI

Where only the first message "pix_mp.plane_fmt[0].reserved not zeroed"
is accurate.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 utils/v4l2-compliance/v4l2-test-formats.cpp | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/utils/v4l2-compliance/v4l2-test-formats.cpp b/utils/v4l2-compliance/v4l2-test-formats.cpp
index 2fb811ad5eb4..006cc3222c65 100644
--- a/utils/v4l2-compliance/v4l2-test-formats.cpp
+++ b/utils/v4l2-compliance/v4l2-test-formats.cpp
@@ -748,8 +748,7 @@ int testTryFormats(struct node *node)
 		}
 		ret = testFormatsType(node, ret, type, fmt, true);
 		if (ret)
-			return fail("%s is valid, but TRY_FMT failed to return a format\n",
-					buftype2s(type).c_str());
+			return ret;
 	}
 
 	memset(&fmt, 0, sizeof(fmt));
@@ -1013,8 +1012,7 @@ int testSetFormats(struct node *node)
 		}
 		ret = testFormatsType(node, ret, type, fmt_set, true);
 		if (ret)
-			return fail("%s is valid, but no S_FMT was implemented\n",
-					buftype2s(type).c_str());
+			return ret;
 
 		fmt_set = fmt;
 		ret = doioctl(node, VIDIOC_S_FMT, &fmt_set);
-- 
2.19.1
