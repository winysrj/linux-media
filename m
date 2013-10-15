Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx32.cern.ch ([137.138.144.178]:2343 "EHLO CERNMX32.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933103Ab3JOPZI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 11:25:08 -0400
From: Dinesh Ram <dinesh.ram@cern.ch>
To: <linux-media@vger.kernel.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <edubezval@gmail.com>,
	<dinesh.ram086@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 9/9] si4713: si4713_set_rds_radio_text overwrites terminating \0
Date: Tue, 15 Oct 2013 17:24:45 +0200
Message-ID: <33e68401729566bf501bcd02d2b2a2fddbe6b937.1381850640.git.dinesh.ram@cern.ch>
In-Reply-To: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

si4713_set_rds_radio_text will overwrite the terminating zero at the
end of the rds radio text string in order to send out a carriage return
as per the RDS spec.

Use a separate char buffer for the CR instead of corrupting the control
string.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si4713/si4713.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 920dfa5..aadecb5 100644
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
1.7.9.5

