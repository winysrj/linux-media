Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EEX3Si024278
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:33:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2EEWVpn013440
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 10:32:31 -0400
Date: Fri, 14 Mar 2008 15:32:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803141525500.5362@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Fix left-overs from the videobuf-dma-sg.c conversion to
 generic DMA
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

The dev element of the struct videobuf_queue is now of type struct device 
implicitly. Fix left-over casts.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Sorry... casts are evil. I'll look into making dev explicitly of type 
struct device either as an incremental patch or as a revision. You can 
test the fix so far:-)

diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 8e40c7b..74bd5bd 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -1084,7 +1084,7 @@ void cx23885_free_buffer(struct videobuf_queue *q, struct cx23885_buffer *buf)
 	videobuf_waiton(&buf->vb, 0, 0);
 	videobuf_dma_unmap(q, dma);
 	videobuf_dma_free(dma);
-	btcx_riscmem_free((struct pci_dev *)q->dev, &buf->risc);
+	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 12440b9..75b5810 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -219,7 +219,7 @@ cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf)
 	videobuf_waiton(&buf->vb,0,0);
 	videobuf_dma_unmap(q, dma);
 	videobuf_dma_free(dma);
-	btcx_riscmem_free((struct pci_dev *)q->dev, &buf->risc);
+	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
