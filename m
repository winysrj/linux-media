Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38207 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaLOVLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 16:11:37 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH 2/3] s5p-mfc-dec: Don't use encoder stop command
Date: Mon, 15 Dec 2014 16:10:58 -0500
Message-Id: <1418677859-31440-3-git-send-email-nicolas.dufresne@collabora.com>
In-Reply-To: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The decoder should handle V4L2_DEC_CMD_STOP to trigger drain,
but it currently expecting V4L2_ENC_CMD_STOP.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 99e2e84..98304fc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -816,7 +816,7 @@ static int vidioc_decoder_cmd(struct file *file, void *priv,
 	unsigned long flags;
 
 	switch (cmd->cmd) {
-	case V4L2_ENC_CMD_STOP:
+	case V4L2_DEC_CMD_STOP:
 		if (cmd->flags != 0)
 			return -EINVAL;
 
-- 
2.1.0

