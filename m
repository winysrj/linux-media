Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37086 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdIUIkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 04:40:43 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrey Konovalov <andreyknvl@google.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, syzkaller@googlegroups.com,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: [PATCH] [media] cx231xx-cards: fix NULL-deref on missing association descriptor
Date: Thu, 21 Sep 2017 10:40:18 +0200
Message-Id: <20170921084018.30510-1-johan@kernel.org>
In-Reply-To: <20170921083739.GI3198@localhost>
References: <20170921083739.GI3198@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check that we actually have an Interface Association
Descriptor before dereferencing it during probe to avoid dereferencing a
NULL-pointer.

Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.30
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e0daa9b6c2a0..9b742d569fb5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1684,7 +1684,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	nr = dev->devno;
 
 	assoc_desc = udev->actconfig->intf_assoc[0];
-	if (assoc_desc->bFirstInterface != ifnum) {
+	if (!assoc_desc || assoc_desc->bFirstInterface != ifnum) {
 		dev_err(d, "Not found matching IAD interface\n");
 		retval = -ENODEV;
 		goto err_if;
-- 
2.14.1
