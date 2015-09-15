Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbIOLmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 07:42:38 -0400
From: Colin King <colin.king@canonical.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] c8sectpfe: fix ininitialized error return on firmware load failure
Date: Tue, 15 Sep 2015 12:42:27 +0100
Message-Id: <1442317347-6384-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

static analysis with cppcheck detected the following error:

[drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:1210]:
  (error) Uninitialized variable: ret

ret is never initialised, so garbage is being returned. Instead
return the error return from the call of request_firmware_nowait

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 486aef5..16aa494 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -1192,7 +1192,6 @@ err:
 
 static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
 {
-	int ret;
 	int err;
 
 	dev_info(fei->dev, "Loading firmware: %s\n", FIRMWARE_MEMDMA);
@@ -1207,7 +1206,7 @@ static int load_c8sectpfe_fw_step1(struct c8sectpfei *fei)
 	if (err) {
 		dev_err(fei->dev, "request_firmware_nowait err: %d.\n", err);
 		complete_all(&fei->fw_ack);
-		return ret;
+		return err;
 	}
 
 	return 0;
-- 
2.5.0

