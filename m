Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59942 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbZARSVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 13:21:12 -0500
Received: by bwz14 with SMTP id 14so7255590bwz.13
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 10:21:10 -0800 (PST)
Date: Sun, 18 Jan 2009 19:21:26 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-media@vger.kernel.org
Cc: Manu Abraham <manu@linuxtv.org>
Subject: [PATCH] saa716x: fix pointer cast to 32bit
Message-ID: <20090118182126.GA18750@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pointers may be 64bit long, casting them to u32 is wrong.
For doing math on the address unsigned long is guaranteed to have to correct
size to hold the value of the pointer.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 linux/drivers/media/dvb/saa716x/saa716x_dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/linux/drivers/media/dvb/saa716x/saa716x_dma.c
===================================================================
--- a/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2009-01-18 19:13:35.126021813 +0100
+++ b/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2009-01-18 19:15:34.074015003 +0100
@@ -34,7 +34,7 @@
 		return -ENOMEM;
 	}
 
-	BUG_ON(!(((u32) dmabuf->mem_ptab_phys % SAA716x_PAGE_SIZE) == 0));
+	BUG_ON(!(((unsigned long) dmabuf->mem_ptab_phys % SAA716x_PAGE_SIZE) == 0));
 
 	return 0;
 }
@@ -126,9 +126,9 @@
 		}
 
 		/* align memory to page */
-		dmabuf->mem_virt = (void *) PAGE_ALIGN (((u32) dmabuf->mem_virt_noalign));
+		dmabuf->mem_virt = (void *) PAGE_ALIGN (((unsigned long) dmabuf->mem_virt_noalign));
 
-		BUG_ON(!((((u32) dmabuf->mem_virt) % SAA716x_PAGE_SIZE) == 0));
+		BUG_ON(!((((unsigned long) dmabuf->mem_virt) % SAA716x_PAGE_SIZE) == 0));
 	} else {
 		dmabuf->mem_virt = buf;
 	}

Luca
-- 
"La vita potrebbe non avere alcun significato. Oppure, ancora peggio,
 potrebbe averne uno che disapprovo". -- Ashleigh Brilliant
