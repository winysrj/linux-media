Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49823 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752894AbdIROAV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 10:00:21 -0400
Subject: [PATCH 6/6] [media] go7007: Delete an unnecessary variable
 initialisation in go7007_snd_init()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Message-ID: <cce9027f-ed91-44f8-a59e-a03291d9cf2e@users.sourceforge.net>
Date: Mon, 18 Sep 2017 16:00:13 +0200
MIME-Version: 1.0
In-Reply-To: <b36ece3f-0f31-9bb6-14ae-c4abf7cd23ee@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 18 Sep 2017 14:35:43 +0200

The variable "ret" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/go7007/snd-go7007.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index 7ae4d03ed3f7..27c09fd44657 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -227,7 +227,7 @@ int go7007_snd_init(struct go7007 *go)
 {
 	static int dev;
 	struct go7007_snd *gosnd;
-	int ret = 0;
+	int ret;
 
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
-- 
2.14.1
