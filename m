Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55145 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3KJSiC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 13:38:02 -0500
Received: by mail-ee0-f47.google.com with SMTP id c13so1970970eek.6
        for <linux-media@vger.kernel.org>; Sun, 10 Nov 2013 10:38:01 -0800 (PST)
From: Michal Nazarewicz <mpn@google.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: go7007: fix use of uninitialised pointer
Date: Sun, 10 Nov 2013 19:37:57 +0100
Message-Id: <1384108677-23476-1-git-send-email-mpn@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michal Nazarewicz <mina86@mina86.com>

The go variable is declade without initialisation and invocation of
dev_dbg immediatelly tries to dereference it.
---
 drivers/staging/media/go7007/go7007-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..457ab63 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	pr_debug("probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
-- 
1.8.3.2

