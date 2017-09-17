Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:64596 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdIQJTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 05:19:17 -0400
Subject: [PATCH 1/2] [media] airspy: Delete an error message for a failed
 memory allocation in airspy_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d4c32723-ac16-7fad-0260-f8aef7105754@users.sourceforge.net>
Message-ID: <6cb0e016-10c1-1336-a063-bf5c6f6b64dd@users.sourceforge.net>
Date: Sun, 17 Sep 2017 11:19:05 +0200
MIME-Version: 1.0
In-Reply-To: <d4c32723-ac16-7fad-0260-f8aef7105754@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 11:00:09 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/airspy/airspy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index e70c9e2f3798..72b36dbcc0ba 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -985,7 +985,5 @@ static int airspy_probe(struct usb_interface *intf,
-	if (s == NULL) {
-		dev_err(&intf->dev, "Could not allocate memory for state\n");
+	if (!s)
 		return -ENOMEM;
-	}
 
 	mutex_init(&s->v4l2_lock);
 	mutex_init(&s->vb_queue_lock);
-- 
2.14.1
