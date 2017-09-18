Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51115 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752538AbdIRNyB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:54:01 -0400
Subject: [PATCH 1/6] [media] go7007: Delete an error message for a failed
 memory allocation in go7007_load_encoder()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Message-ID: <ce46e264-73fe-4613-e1b8-79a4bccc796b@users.sourceforge.net>
Date: Mon, 18 Sep 2017 15:53:53 +0200
MIME-Version: 1.0
In-Reply-To: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 10:52:42 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/go7007/go7007-driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 05b1126f263e..222332189fa4 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -107,4 +107,3 @@ static int go7007_load_encoder(struct go7007 *go)
-			v4l2_err(go, "unable to allocate %d bytes for firmware transfer\n", fw_len);
 			release_firmware(fw_entry);
 			return -1;
 		}
-- 
2.14.1
