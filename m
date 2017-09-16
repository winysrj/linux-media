Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:61148 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdIPNjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 09:39:06 -0400
Subject: [PATCH 2/3] [media] si470x: Improve a size determination in
 si470x_usb_driver_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Message-ID: <53bfd9dc-b0ba-5cf0-0aaf-0db358a10082@users.sourceforge.net>
Date: Sat, 16 Sep 2017 15:38:59 +0200
MIME-Version: 1.0
In-Reply-To: <b58222fa-99f8-f2d6-2755-5ccd4a91e783@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 14:58:06 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index af295530b20f..6fc6e8235f20 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -584,5 +584,5 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	/* private data allocation and initialization */
-	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
+	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
 	if (!radio) {
 		retval = -ENOMEM;
 		goto err_initial;
-- 
2.14.1
