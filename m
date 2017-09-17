Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:51566 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdIQJUl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 05:20:41 -0400
Subject: [PATCH 2/2] [media] airspy: Improve a size determination in
 airspy_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d4c32723-ac16-7fad-0260-f8aef7105754@users.sourceforge.net>
Message-ID: <27a527c5-8d41-f54d-6d1d-132f0b37acbb@users.sourceforge.net>
Date: Sun, 17 Sep 2017 11:20:28 +0200
MIME-Version: 1.0
In-Reply-To: <d4c32723-ac16-7fad-0260-f8aef7105754@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 11:03:21 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/airspy/airspy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 72b36dbcc0ba..5810c05f6300 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -981,5 +981,5 @@ static int airspy_probe(struct usb_interface *intf,
 	int ret;
 	u8 u8tmp, buf[BUF_SIZE];
 
-	s = kzalloc(sizeof(struct airspy), GFP_KERNEL);
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s)
-- 
2.14.1
