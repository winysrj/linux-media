Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34129 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbbCIPqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/29] vivid: do not allow video loopback for SEQ_TB/BT
Date: Mon,  9 Mar 2015 16:44:30 +0100
Message-Id: <1425915891-1017-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Sequential top-bottom/bottom-top fields are not supported as video loopback.
This is too much work to implement for field settings that are rarely used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt             | 5 +++++
 drivers/media/platform/vivid/vivid-vid-common.c | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index 6cfc854..cd4b5a1 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -912,6 +912,11 @@ looped to the video input provided that:
   sequence and field counting in struct v4l2_buffer on the capture side may not
   be 100% accurate.
 
+- field settings V4L2_FIELD_SEQ_TB/BT are not supported. While it is possible to
+  implement this, it would mean a lot of work to get this right. Since these
+  field values are rarely used the decision was made not to implement this for
+  now.
+
 - on the input side the "Standard Signal Mode" for the S-Video input or the
   "DV Timings Signal Mode" for the HDMI input should be configured so that a
   valid signal is passed to the video input.
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 6bef1e6..49c9bc6 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -210,6 +210,13 @@ bool vivid_vid_can_loop(struct vivid_dev *dev)
 		return false;
 	if (dev->field_cap != dev->field_out)
 		return false;
+	/*
+	 * While this can be supported, it is just too much work
+	 * to actually implement.
+	 */
+	if (dev->field_cap == V4L2_FIELD_SEQ_TB ||
+	    dev->field_cap == V4L2_FIELD_SEQ_BT)
+		return false;
 	if (vivid_is_svid_cap(dev) && vivid_is_svid_out(dev)) {
 		if (!(dev->std_cap & V4L2_STD_525_60) !=
 		    !(dev->std_out & V4L2_STD_525_60))
-- 
2.1.4

