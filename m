Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44353 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2LQMyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 07:54:17 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3199349eek.19
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 04:54:15 -0800 (PST)
From: =?UTF-8?q?John=20T=C3=B6rnblom?= <john.tornblom@gmail.com>
To: linux-media@vger.kernel.org, john.tornblom@gmail.com
Subject: [PATCH] bttv: avoid flooding the kernel log when i2c debugging is disabled
Date: Mon, 17 Dec 2012 13:53:54 +0100
Message-Id: <1355748834-9407-1-git-send-email-john.tornblom@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the bttv driver is running without i2c_debug being set, the kernel
log is being flooded with the string ">". This string is really a part of
a debug message that is logged using several substrings protected by a
conditional check.

This patch adds the same conditional check to the leaked substring.

Signed-off-by: John Törnblom <john.tornblom@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index 580c8e6..da400db 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -173,7 +173,7 @@ bttv_i2c_sendbytes(struct bttv *btv, const struct i2c_msg *msg, int last)
 		if (i2c_debug)
 			pr_cont(" %02x", msg->buf[cnt]);
 	}
-	if (!(xmit & BT878_I2C_NOSTOP))
+	if (i2c_debug && !(xmit & BT878_I2C_NOSTOP))
 		pr_cont(">\n");
 	return msg->len;
 
-- 
1.7.8.6

