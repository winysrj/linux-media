Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58443 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbdF0QJK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 12:09:10 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/8] [media] s5p-jpeg: Handle parsing error in s5p_jpeg_parse_hdr()
Date: Tue, 27 Jun 2017 18:08:49 +0200
Message-Id: <1498579734-1594-4-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
References: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch modifies the s5p_jpeg_parse_hdr() function so it only
modifies the passed s5p_jpeg_q_data structure if the jpeg header parsing
is successful.

Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 38 ++++++++++++++++-------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0d935f5..df3e5ee 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1206,22 +1206,9 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 			break;
 		}
 	}
-	result->w = width;
-	result->h = height;
-	result->sos = sos;
-	result->dht.n = n_dht;
-	while (n_dht--) {
-		result->dht.marker[n_dht] = dht[n_dht];
-		result->dht.len[n_dht] = dht_len[n_dht];
-	}
-	result->dqt.n = n_dqt;
-	while (n_dqt--) {
-		result->dqt.marker[n_dqt] = dqt[n_dqt];
-		result->dqt.len[n_dqt] = dqt_len[n_dqt];
-	}
-	result->sof = sof;
-	result->sof_len = sof_len;
-	result->size = result->components = components;
+
+	if (notfound || !sos)
+		return false;
 
 	switch (subsampling) {
 	case 0x11:
@@ -1240,7 +1227,24 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
 		return false;
 	}
 
-	return !notfound && sos;
+	result->w = width;
+	result->h = height;
+	result->sos = sos;
+	result->dht.n = n_dht;
+	while (n_dht--) {
+		result->dht.marker[n_dht] = dht[n_dht];
+		result->dht.len[n_dht] = dht_len[n_dht];
+	}
+	result->dqt.n = n_dqt;
+	while (n_dqt--) {
+		result->dqt.marker[n_dqt] = dqt[n_dqt];
+		result->dqt.len[n_dqt] = dqt_len[n_dqt];
+	}
+	result->sof = sof;
+	result->sof_len = sof_len;
+	result->size = result->components = components;
+
+	return true;
 }
 
 static int s5p_jpeg_querycap(struct file *file, void *priv,
-- 
2.7.4
