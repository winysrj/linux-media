Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64880 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab0EEGAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 02:00:04 -0400
Received: by fxm10 with SMTP id 10so3900400fxm.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 23:00:02 -0700 (PDT)
Date: Wed, 5 May 2010 07:59:48 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch] media/ov511: cleanup: remove unneeded null check
Message-ID: <20100505055948.GE27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We dereference "ov" unconditionally throughout the function so there is
no way it can be NULL here.  This code has been around for ages so if 
it were possible for "ov" to be NULL someone would have complained.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 6085d55..a109120 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5940,7 +5940,7 @@ ov51x_disconnect(struct usb_interface *intf)
 	ov->dev = NULL;
 
 	/* Free the memory */
-	if (ov && !ov->user) {
+	if (!ov->user) {
 		mutex_lock(&ov->cbuf_lock);
 		kfree(ov->cbuf);
 		ov->cbuf = NULL;
