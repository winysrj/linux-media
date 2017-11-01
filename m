Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58318 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933381AbdKAVGO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hansverk@cisco.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH v2 16/26] media: drxd_hard: better handle I2C errors
Date: Wed,  1 Nov 2017 17:05:53 -0400
Message-Id: <4c70e369e01853324fbe93b6da299323694d789b.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/dvb-frontends/drxd_hard.c:989 HI_Command() error: uninitialized symbol 'waitCmd'.
	drivers/media/dvb-frontends/drxd_hard.c:1306 SC_WaitForReady() error: uninitialized symbol 'curCmd'.
	drivers/media/dvb-frontends/drxd_hard.c:1322 SC_SendCommand() error: uninitialized symbol 'errCode'.
	drivers/media/dvb-frontends/drxd_hard.c:1339 SC_ProcStartCommand() error: uninitialized symbol 'scExec'.

The error handling on several places are somewhat flawed, as
they don't check if Read16() returns an error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/drxd_hard.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 3bdf9b1f4e7c..79210db117a7 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -972,7 +972,6 @@ static int DownloadMicrocode(struct drxd_state *state,
 static int HI_Command(struct drxd_state *state, u16 cmd, u16 * pResult)
 {
 	u32 nrRetries = 0;
-	u16 waitCmd;
 	int status;
 
 	status = Write16(state, HI_RA_RAM_SRV_CMD__A, cmd, 0);
@@ -985,8 +984,8 @@ static int HI_Command(struct drxd_state *state, u16 cmd, u16 * pResult)
 			status = -1;
 			break;
 		}
-		status = Read16(state, HI_RA_RAM_SRV_CMD__A, &waitCmd, 0);
-	} while (waitCmd != 0);
+		status = Read16(state, HI_RA_RAM_SRV_CMD__A, NULL, 0);
+	} while (status != 0);
 
 	if (status >= 0)
 		status = Read16(state, HI_RA_RAM_SRV_RES__A, pResult, 0);
@@ -1298,12 +1297,11 @@ static int InitFT(struct drxd_state *state)
 
 static int SC_WaitForReady(struct drxd_state *state)
 {
-	u16 curCmd;
 	int i;
 
 	for (i = 0; i < DRXD_MAX_RETRIES; i += 1) {
-		int status = Read16(state, SC_RA_RAM_CMD__A, &curCmd, 0);
-		if (status == 0 || curCmd == 0)
+		int status = Read16(state, SC_RA_RAM_CMD__A, NULL, 0);
+		if (status == 0)
 			return status;
 	}
 	return -1;
@@ -1311,15 +1309,15 @@ static int SC_WaitForReady(struct drxd_state *state)
 
 static int SC_SendCommand(struct drxd_state *state, u16 cmd)
 {
-	int status = 0;
+	int status = 0, ret;
 	u16 errCode;
 
 	Write16(state, SC_RA_RAM_CMD__A, cmd, 0);
 	SC_WaitForReady(state);
 
-	Read16(state, SC_RA_RAM_CMD_ADDR__A, &errCode, 0);
+	ret = Read16(state, SC_RA_RAM_CMD_ADDR__A, &errCode, 0);
 
-	if (errCode == 0xFFFF) {
+	if (ret < 0 || errCode == 0xFFFF) {
 		printk(KERN_ERR "Command Error\n");
 		status = -1;
 	}
@@ -1330,13 +1328,13 @@ static int SC_SendCommand(struct drxd_state *state, u16 cmd)
 static int SC_ProcStartCommand(struct drxd_state *state,
 			       u16 subCmd, u16 param0, u16 param1)
 {
-	int status = 0;
+	int ret, status = 0;
 	u16 scExec;
 
 	mutex_lock(&state->mutex);
 	do {
-		Read16(state, SC_COMM_EXEC__A, &scExec, 0);
-		if (scExec != 1) {
+		ret = Read16(state, SC_COMM_EXEC__A, &scExec, 0);
+		if (ret < 0 || scExec != 1) {
 			status = -1;
 			break;
 		}
-- 
2.13.6
