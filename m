Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 5 Jan 2009 18:09:50 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20090105170950.GA7131@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Manu Abraham <manu@linuxtv.org>
Subject: [linux-dvb] [PATCH] saa716x: don't cast pointers to 32bit int
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Pointers may be 64bit long, casting them to u32 is wrong.
For doing math on the address unsigned long is guaranteed to have to correct
size to hold the value of the pointer.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 Patch applies to HG repo.

 linux/drivers/media/dvb/saa716x/saa716x_dma.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: saa716x/linux/drivers/media/dvb/saa716x/saa716x_dma.c
===================================================================
--- saa716x.orig/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2008-12-27 21:35:04.000000000 +0100
+++ saa716x/linux/drivers/media/dvb/saa716x/saa716x_dma.c	2008-12-27 21:35:28.000000000 +0100
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
Porc i' mond che cio' sott i piedi!
V. Catozzo

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
