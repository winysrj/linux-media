Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42931 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab1EZIzd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:55:33 -0400
Date: Thu, 26 May 2011 11:55:08 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] rc/redrat3: dereferencing null pointer
Message-ID: <20110526085508.GG14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In the original code, if the allocation failed we dereference "rr3"
when it was NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 5147767..4582ef7 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1186,7 +1186,7 @@ static int __devinit redrat3_dev_probe(struct usb_interface *intf,
 	rr3 = kzalloc(sizeof(*rr3), GFP_KERNEL);
 	if (rr3 == NULL) {
 		dev_err(dev, "Memory allocation failure\n");
-		goto error;
+		goto no_endpoints;
 	}
 
 	rr3->dev = &intf->dev;
