Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:53031 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbcDOPfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 11:35:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] vivid: fix smatch errors
Date: Fri, 15 Apr 2016 17:35:31 +0200
Message-Id: <1460734533-34191-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The smatch utility got really confused about the grp % 22 code. Rewrote
it so it now understands that there really isn't a buffer overwrite.

vivid-rds-gen.c:82 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 43
vivid-rds-gen.c:83 vivid_rds_generate() error: buffer overflow 'rds->psname' 9 <= 42
vivid-rds-gen.c:89 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 84
vivid-rds-gen.c:90 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 85
vivid-rds-gen.c:92 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 86
vivid-rds-gen.c:93 vivid_rds_generate() error: buffer overflow 'rds->radiotext' 65 <= 87

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-rds-gen.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
index c382343..53c7777 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.c
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -55,6 +55,7 @@ void vivid_rds_generate(struct vivid_rds_gen *rds)
 {
 	struct v4l2_rds_data *data = rds->data;
 	unsigned grp;
+	unsigned idx;
 	struct tm tm;
 	unsigned date;
 	unsigned time;
@@ -73,24 +74,26 @@ void vivid_rds_generate(struct vivid_rds_gen *rds)
 		case 0 ... 3:
 		case 22 ... 25:
 		case 44 ... 47: /* Group 0B */
+			idx = (grp % 22) % 4;
 			data[1].lsb |= (rds->ta << 4) | (rds->ms << 3);
-			data[1].lsb |= vivid_get_di(rds, grp % 22);
+			data[1].lsb |= vivid_get_di(rds, idx);
 			data[1].msb |= 1 << 3;
 			data[2].lsb = rds->picode & 0xff;
 			data[2].msb = rds->picode >> 8;
 			data[2].block = V4L2_RDS_BLOCK_C_ALT | (V4L2_RDS_BLOCK_C_ALT << 3);
-			data[3].lsb = rds->psname[2 * (grp % 22) + 1];
-			data[3].msb = rds->psname[2 * (grp % 22)];
+			data[3].lsb = rds->psname[2 * idx + 1];
+			data[3].msb = rds->psname[2 * idx];
 			break;
 		case 4 ... 19:
 		case 26 ... 41: /* Group 2A */
-			data[1].lsb |= (grp - 4) % 22;
+			idx = ((grp - 4) % 22) % 16;
+			data[1].lsb |= idx;
 			data[1].msb |= 4 << 3;
-			data[2].msb = rds->radiotext[4 * ((grp - 4) % 22)];
-			data[2].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 1];
+			data[2].msb = rds->radiotext[4 * idx];
+			data[2].lsb = rds->radiotext[4 * idx + 1];
 			data[2].block = V4L2_RDS_BLOCK_C | (V4L2_RDS_BLOCK_C << 3);
-			data[3].msb = rds->radiotext[4 * ((grp - 4) % 22) + 2];
-			data[3].lsb = rds->radiotext[4 * ((grp - 4) % 22) + 3];
+			data[3].msb = rds->radiotext[4 * idx + 2];
+			data[3].lsb = rds->radiotext[4 * idx + 3];
 			break;
 		case 56:
 			/*
-- 
2.8.0.rc3

