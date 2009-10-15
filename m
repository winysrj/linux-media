Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:52767 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395AbZJOOnW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 10:43:22 -0400
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Thu, 15 Oct 2009 08:42:52 -0600
Message-Id: <1255617772-1373-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 1/6 v5] Support for TVP7002 in v4l2 definitions
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides required chip identification definitions
within v4l2. Removed HD and control defines.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 include/media/v4l2-chip-ident.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index cf16689..691cc72 100644
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
 
@@ -147,6 +150,9 @@ enum {
 	/* module ths7303: just ident 7303 */
 	V4L2_IDENT_THS7303 = 7303,
 
+	/* module ths7353: just ident 7353 */
+	V4L2_IDENT_THS7353 = 7353,
+
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,
 
-- 
1.6.0.4

