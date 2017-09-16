Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:57159 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751185AbdIPKxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 06:53:44 -0400
Subject: [PATCH 3/3] [media] mr800: Delete an unnecessary variable
 initialisation in usb_amradio_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Alexey Klimov <klimov.linux@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <7efe75db-dbb4-0fe7-509d-908b81072ca1@users.sourceforge.net>
Message-ID: <89894f97-d8de-8687-0697-6e7fab1e922c@users.sourceforge.net>
Date: Sat, 16 Sep 2017 12:53:38 +0200
MIME-Version: 1.0
In-Reply-To: <7efe75db-dbb4-0fe7-509d-908b81072ca1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 11:39:50 +0200

The variable "retval" will eventually be set to an appropriate value
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/radio-mr800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 7c4554ce1cf0..a1f4dc9be284 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -511,5 +511,5 @@ static int usb_amradio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct amradio_device *radio;
-	int retval = 0;
+	int retval;
 
-- 
2.14.1
