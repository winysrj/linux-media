Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49394 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbdICUbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:31:31 -0400
Subject: [PATCH 1/7] [media] saa7164: Delete an error message for a failed
 memory allocation in saa7164_buffer_alloc()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Message-ID: <6946d617-7c6d-aff8-5267-d260b64b2085@users.sourceforge.net>
Date: Sun, 3 Sep 2017 22:31:10 +0200
MIME-Version: 1.0
In-Reply-To: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 17:47:41 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/saa7164/saa7164-buffer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
index a0d2129c6ca9..6bd665ea190d 100644
--- a/drivers/media/pci/saa7164/saa7164-buffer.c
+++ b/drivers/media/pci/saa7164/saa7164-buffer.c
@@ -102,7 +102,5 @@ struct saa7164_buffer *saa7164_buffer_alloc(struct saa7164_port *port,
-	if (!buf) {
-		log_warn("%s() SAA_ERR_NO_RESOURCES\n", __func__);
+	if (!buf)
 		goto ret;
-	}
 
 	buf->idx = -1;
 	buf->port = port;
-- 
2.14.1
