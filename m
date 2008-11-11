Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABK4Y1B016058
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 15:04:34 -0500
Received: from speedy.tutby.com (mail.tut.by [195.137.160.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mABK3cLJ001681
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 15:04:18 -0500
From: "Igor M. Liplianin" <liplianin@tut.by>
To: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
Date: Tue, 11 Nov 2008 20:09:28 +0200
References: <20081111084501.38f2917a@pedra.chehab.org>
In-Reply-To: <20081111084501.38f2917a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811112009.28423.liplianin@tut.by>
Cc: 
Subject: [PATCH] Fix section mismatch warning for dm1105 during make
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--
diff -r d5e211683345 -r 71bf3108c1d2 linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c   Tue Nov 11 07:42:37 2008 -0200
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c   Tue Nov 11 19:15:27 2008 +0200
@@ -375,7 +375,7 @@
        pci_free_consistent(dm1105dvb->pdev, 6*DM1105_DMA_BYTES, dm1105dvb->ts_buf, 
dm1105dvb->dma_addr);
 }

-static void __devinit dm1105dvb_enable_irqs(struct dm1105dvb *dm1105dvb)
+static void dm1105dvb_enable_irqs(struct dm1105dvb *dm1105dvb)
 {
        outb(INTMAK_ALLMASK, dm_io_mem(DM1105_INTMAK));
        outb(1, dm_io_mem(DM1105_CR));

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
