Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2LWWWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 17:22:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com
Subject: [RFC/PATCH] v4l2-compliance: Reject invalid ioctl error codes
Date: Sun, 23 Dec 2012 23:24:04 +0100
Message-Id: <1356301444-10191-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recent uvcvideo regression that broke pulseaudio/KDE (see commit
9c016d61097cc39427a2f5025bdd97ac633d26a6 in the mainline kernel) was
caused by the uvcvideo driver returning a -ENOENT error code to
userspace by mistake.

To make sure such regressions will be caught before reaching users, test
ioctl error codes to make sure they're valid.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/v4l2-compliance/v4l2-compliance.cpp |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

A white list of valid error codes might be more appropriate. I can fix the
patch accordingly, but I'd like a general opinion first.

diff --git a/utils/v4l2-compliance/v4l2-compliance.cpp b/utils/v4l2-compliance/v4l2-compliance.cpp
index 1e4646f..ff1ad9b 100644
--- a/utils/v4l2-compliance/v4l2-compliance.cpp
+++ b/utils/v4l2-compliance/v4l2-compliance.cpp
@@ -112,6 +112,13 @@ int doioctl_name(struct node *node, unsigned long int request, void *parm, const
 		fail("%s returned %d instead of 0 or -1\n", name, retval);
 		return -1;
 	}
+
+	/* Reject invalid error codes */
+	switch (errno) {
+	case ENOENT:
+		fail("%s returned invalid error %d\n", name, errno);
+		break;
+	}
 	return e;
 }
 
-- 
Regards,

Laurent Pinchart

