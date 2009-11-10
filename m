Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:41535 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238AbZKJVt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 16:49:56 -0500
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Tue, 10 Nov 2009 15:50:05 -0600
Message-Id: <1257889805-19153-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 1/4 v7] Support for TVP7002 in v4l2 definitions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides required chip identification definitions
within v4l2.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 include/media/v4l2-chip-ident.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index cf16689..688b7ed 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -129,6 +129,9 @@ enum {
 	V4L2_IDENT_SAA6752HS = 6752,
 	V4L2_IDENT_SAA6752HS_AC3 = 6753,
 
+	/* module tvp7002: just ident 7002 */
+	V4L2_IDENT_TVP7002 = 7002,
+
 	/* module adv7170: just ident 7170 */
 	V4L2_IDENT_ADV7170 = 7170,
 
@@ -147,9 +150,15 @@ enum {
 	/* module ths7303: just ident 7303 */
 	V4L2_IDENT_THS7303 = 7303,
 
+	/* module ths7353: just ident 7353 */
+	V4L2_IDENT_THS7353 = 7353,
+
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,
 
+	/* module ths8200: just ident 8200 */
+	V4L2_IDENT_THS8200 = 8200,
+
 	/* module wm8739: just ident 8739 */
 	V4L2_IDENT_WM8739 = 8739,
 
-- 
1.6.0.4

