Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1LRAhM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:37:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/7] [media] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
Date: Sat, 17 Dec 2011 22:36:55 -0200
Message-Id: <1324168621-21506-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324168621-21506-1-git-send-email-mchehab@redhat.com>
References: <1324168621-21506-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Manu Abraham <abraham.manu@gmail.com>

Use a unique delivery system identifier for DVBC_ANNEX_C, just like any
other.

DVBC_ANNEX_A and DVBC_ANNEX_C have slightly different parameters
and are used in 2 geographically different locations.

Signed-off-by: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/dvb/frontend.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index cb114f5..b2a939f8 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -337,7 +337,7 @@ typedef enum fe_rolloff {
 
 typedef enum fe_delivery_system {
 	SYS_UNDEFINED,
-	SYS_DVBC_ANNEX_AC,
+	SYS_DVBC_ANNEX_A,
 	SYS_DVBC_ANNEX_B,
 	SYS_DVBT,
 	SYS_DSS,
@@ -354,8 +354,13 @@ typedef enum fe_delivery_system {
 	SYS_DAB,
 	SYS_DVBT2,
 	SYS_TURBO,
+	SYS_DVBC_ANNEX_C,
 } fe_delivery_system_t;
 
+
+#define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
+
+
 struct dtv_cmds_h {
 	char	*name;		/* A display name for debugging purposes */
 
-- 
1.7.8

