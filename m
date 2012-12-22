Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:49990 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LVOTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Dec 2012 09:19:50 -0500
Received: by mail-we0-f178.google.com with SMTP id x43so2585203wey.23
        for <linux-media@vger.kernel.org>; Sat, 22 Dec 2012 06:19:49 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	stable@kernel.org
Subject: [PATCH v2] em28xx: input: fix oops on device removal
Date: Sat, 22 Dec 2012 15:13:38 +0100
Message-Id: <1356185618-17799-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When em28xx_ir_init() fails due to an configuration error, it frees the memory
of struct em28xx_IR *ir, but doesn't set the corresponding pointer in the
device struct to NULL.
On device removal, em28xx_ir_fini() gets called, which then calls
rc_unregister_device() with a pointer to freed memory.

Fixes bug 26572 (http://bugzilla.kernel.org/show_bug.cgi?id=26572)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/usb/em28xx/em28xx-input.c |   11 +++++------
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 6 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 3899ea8..3598221 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -600,7 +600,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	rc = rc_allocate_device();
 	if (!ir || !rc)
-		goto err_out_free;
+		goto error;
 
 	/* record handles to ourself */
 	ir->dev = dev;
@@ -629,14 +629,14 @@ static int em28xx_ir_init(struct em28xx *dev)
 		break;
 	default:
 		err = -ENODEV;
-		goto err_out_free;
+		goto error;
 	}
 
 	/* By default, keep protocol field untouched */
 	rc_type = RC_BIT_UNKNOWN;
 	err = em28xx_ir_change_protocol(rc, &rc_type);
 	if (err)
-		goto err_out_free;
+		goto error;
 
 	/* This is how often we ask the chip for IR information */
 	ir->polling = 100; /* ms */
@@ -661,7 +661,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 	/* all done */
 	err = rc_register_device(rc);
 	if (err)
-		goto err_out_stop;
+		goto error;
 
 	em28xx_register_i2c_ir(dev);
 
@@ -674,9 +674,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	return 0;
 
-err_out_stop:
+error:
 	dev->ir = NULL;
-err_out_free:
 	rc_free_device(rc);
 	kfree(ir);
 	return err;
-- 
1.7.10.4

