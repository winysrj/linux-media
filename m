Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:60170 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762052AbZLKBEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 20:04:55 -0500
Received: by ywh6 with SMTP id 6so410155ywh.4
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 17:05:01 -0800 (PST)
Date: Thu, 10 Dec 2009 17:04:49 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, stable@kernel.org
Subject: [PATCH] ov511: fix probe() hang due to double mutex_lock
Message-ID: <20091211010449.GV3387@jenkins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 163fe744c3283fd267268629afff4cfc846ed0e0 added a double
mutex_lock which hangs ov51x_probe(). This was clearly a typo.

Change final mutex_lock() -> mutex_unlock()

Signed-off-by: Brandon Philips <bphilips@suse.de>
---
 drivers/media/video/ov511.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 0bc2cf5..2bed9e2 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5878,7 +5878,7 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
-	mutex_lock(&ov->lock);
+	mutex_unlock(&ov->lock);
 
 	return 0;
 
-- 
1.6.4.2

