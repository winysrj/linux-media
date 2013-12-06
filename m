Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1926 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3LFKRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:17:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dinesh.Ram@cern.ch, edubezval@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 09/11] si4713: si4713_set_rds_radio_text overwrites terminating \0
Date: Fri,  6 Dec 2013 11:17:12 +0100
Message-Id: <1386325034-19344-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
References: <1386325034-19344-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

si4713_set_rds_radio_text will overwrite the terminating zero at the
end of the rds radio text string in order to send out a carriage return
as per the RDS spec.

Use a separate char buffer for the CR instead of corrupting the control
string.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/media/radio/si4713/si4713.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 097d4e0..17e0106 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -831,8 +831,9 @@ static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
 	return rval;
 }
 
-static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
+static int si4713_set_rds_radio_text(struct si4713_device *sdev, const char *rt)
 {
+	static const char cr[RDS_RADIOTEXT_BLK_SIZE] = { RDS_CARRIAGE_RETURN, 0 };
 	int rval = 0, i;
 	u16 t_index = 0;
 	u8 b_index = 0, cr_inserted = 0;
@@ -856,7 +857,7 @@ static int si4713_set_rds_radio_text(struct si4713_device *sdev, char *rt)
 			for (i = 0; i < RDS_RADIOTEXT_BLK_SIZE; i++) {
 				if (!rt[t_index + i] ||
 				    rt[t_index + i] == RDS_CARRIAGE_RETURN) {
-					rt[t_index + i] = RDS_CARRIAGE_RETURN;
+					rt = cr;
 					cr_inserted = 1;
 					break;
 				}
-- 
1.8.4.rc3

