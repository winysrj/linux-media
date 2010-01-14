Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:42157 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0ANPYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 10:24:32 -0500
Received: by ewy1 with SMTP id 1so6924ewy.28
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 07:24:28 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Jan 2010 10:24:24 -0500
Message-ID: <9006a0b61001140724v565d71fbtf9e40228102669e4@mail.gmail.com>
Subject: [PATCH] saa7134-empress: remove unlock_kernel() without lock_kernel()
From: Will Tate <willytate@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call to unlock_kernel() made without previous call to lock_kernel() in
ts_open() function of saa7134-empress.c.

Signed-off-by: William J. Tate <willytate@gmail.com>

--- a//drivers/media/video/saa7134/saa7134-empress.c	2010-01-14
10:18:51.000000000 -0500
+++ b//drivers/media/video/saa7134/saa7134-empress.c	2010-01-14
10:19:36.000000000 -0500
@@ -108,7 +108,6 @@
 done_up:
 	mutex_unlock(&dev->empress_tsq.vb_lock);
 done:
-	unlock_kernel();
 	return err;
 }
