Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:58487 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbdITRAM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 13:00:12 -0400
Subject: [PATCH 3/5] [media] s2255drv: Improve two size determinations in
 s2255_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Message-ID: <4d151c18-662f-aabf-7f03-9c3cbb05b1ef@users.sourceforge.net>
Date: Wed, 20 Sep 2017 19:00:00 +0200
MIME-Version: 1.0
In-Reply-To: <55718a41-d76f-36bf-7197-db92014dcd3c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 16:56:20 +0200

Replace the specification of data structures by variable references
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/s2255/s2255drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index aee83bf6fa94..29bc73ad7d8a 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2237,4 +2237,4 @@ static int s2255_probe(struct usb_interface *interface,
 	/* allocate memory for our device state and initialize it to zero */
-	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
@@ -2247,4 +2247,4 @@ static int s2255_probe(struct usb_interface *interface,
 	dev->pid = id->idProduct;
-	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
+	dev->fw_data = kzalloc(sizeof(*dev->fw_data), GFP_KERNEL);
 	if (!dev->fw_data)
 		goto errorFWDATA1;
-- 
2.14.1
