Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57882 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3LXLpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 06:45:35 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so6415607pbc.15
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 03:45:34 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: a.hajda@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org
Subject: [PATCH 3/3] [media] s5k5baf: Fix potential NULL pointer dereferencing
Date: Tue, 24 Dec 2013 17:12:05 +0530
Message-Id: <1387885325-17639-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
References: <1387885325-17639-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dereference 'fw' after the NULL check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/i2c/s5k5baf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 974b865c2ee1..4b8381111cbd 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -548,12 +548,14 @@ static void s5k5baf_synchronize(struct s5k5baf *state, int timeout, u16 addr)
 static u16 *s5k5baf_fw_get_seq(struct s5k5baf *state, u16 seq_id)
 {
 	struct s5k5baf_fw *fw = state->fw;
-	u16 *data = fw->data + 2 * fw->count;
+	u16 *data;
 	int i;
 
 	if (fw == NULL)
 		return NULL;
 
+	data = fw->data + 2 * fw->count;
+
 	for (i = 0; i < fw->count; ++i) {
 		if (fw->seq[i].id == seq_id)
 			return data + fw->seq[i].offset;
-- 
1.7.9.5

