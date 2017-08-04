Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39935 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751342AbdHDLZc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 07:25:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-compat-ioctl32.c: add missing controls to,
 ctrl_is_pointer
Message-ID: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
Date: Fri, 4 Aug 2017 13:25:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to find a better method for this. But for now just add
the missing pointer controls to this list.

Also properly mask the id. The high flag bits shouldn't be used
with these ioctls, but it certainly doesn't hurt.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 90827073066f..afae914b8099 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -674,9 +674,14 @@ struct v4l2_ext_control32 {
    type STRING is a pointer type. */
 static inline int ctrl_is_pointer(u32 id)
 {
-	switch (id) {
+	switch (id & V4L2_CTRL_ID_MASK) {
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
+	case V4L2_CID_RDS_RX_PS_NAME:
+	case V4L2_CID_RDS_RX_RADIO_TEXT:
+	case V4L2_CID_DETECT_MD_REGION_GRID:
+	case V4L2_CID_DETECT_MD_THRESHOLD_GRID:
+	case V4L2_CID_RDS_TX_ALT_FREQS:
 		return 1;
 	default:
 		return 0;
-- 
2.13.2
