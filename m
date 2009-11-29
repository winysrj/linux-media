Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:37251 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZK2QmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 11:42:13 -0500
Received: by ewy7 with SMTP id 7so3563503ewy.28
        for <linux-media@vger.kernel.org>; Sun, 29 Nov 2009 08:42:19 -0800 (PST)
Date: Sun, 29 Nov 2009 18:42:19 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: mmcclell@bigfoot.com, mchehab@infradead.org
Subject: [patch] ov511.c typo:  lock => unlock
Message-ID: <20091129164219.GQ10640@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was found with a static checker and has not been tested, but it seems                                                 
pretty clear that the mutex_lock() was supposed to be mutex_unlock()                                                       

This is a 2.6.32 candidate.                                                                                                

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/media/video/ov511.c	2009-11-29 14:44:46.000000000 +0200
+++ devel/drivers/media/video/ov511.c	2009-11-29 14:44:57.000000000 +0200
@@ -5878,7 +5878,7 @@ ov51x_probe(struct usb_interface *intf, 
 		goto error;
 	}
 
-	mutex_lock(&ov->lock);
+	mutex_unlock(&ov->lock);
 
 	return 0;
 
