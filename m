Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:42171 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbZLPVbY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 16:31:24 -0500
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Wed, 16 Dec 2009 15:31:45 -0600
Message-Id: <1260999105-28258-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 1/4 v12] Support for TVP7002 in v4l2 definitions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides required chip identification definitions
within v4l2. Included only definitions for TVP7002.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 include/media/v4l2-chip-ident.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index cf16689..7e80c4f 100644
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
 
-- 
1.6.0.4

