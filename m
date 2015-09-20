Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:48661 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbbITOWq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 10:22:46 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@stlinux.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 2/2] [media] c8sectpfe: forward err instead of returning an uninitialized variable
Date: Sun, 20 Sep 2015 16:14:07 +0200
Message-Id: <1442758447-1474-2-git-send-email-nicolas.iooss_linux@m4x.org>
In-Reply-To: <1442758447-1474-1-git-send-email-nicolas.iooss_linux@m4x.org>
References: <1442758447-1474-1-git-send-email-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When load_c8sectpfe_fw_step1() tests whether the return value of
request_firmware_nowait(), stored in variable err, indicates an error,
it then returns the value hold by uninitialized variable ret, which
seems incorrect.

Fix this by forwarding the error returned by request_firmware_nowait()
to the caller of load_c8sectpfe_fw_step1().

Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index a424339b18bc..c25a1172bcf5 100644
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
2.5.2

