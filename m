Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48075 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbCZJVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 05:21:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC] v4l2-ctl: don't exit on VIDIOC_QUERYCAP error for subdevices
Date: Thu, 26 Mar 2015 10:21:44 +0100
Message-Id: <1427361704-32456-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subdevice nodes don't implement VIDIOC_QUERYCAP. This check doesn't
allow any operations on v42-subdev nodes, such as setting EDID.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 utils/v4l2-ctl/v4l2-ctl.cpp | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index b340af7..211372b 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -1149,10 +1149,7 @@ int main(int argc, char **argv)
 	}
 
 	verbose = options[OptVerbose];
-	if (doioctl(fd, VIDIOC_QUERYCAP, &vcap)) {
-		fprintf(stderr, "%s: not a v4l2 node\n", device);
-		exit(1);
-	}
+	doioctl(fd, VIDIOC_QUERYCAP, &vcap);
 	capabilities = vcap.capabilities;
 	if (capabilities & V4L2_CAP_DEVICE_CAPS)
 		capabilities = vcap.device_caps;
-- 
2.1.4

