Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1BL8mlI005910
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 16:08:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m1BL8HTR023993
	for <video4linux-list@redhat.com>; Mon, 11 Feb 2008 16:08:17 -0500
Date: Mon, 11 Feb 2008 22:08:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0802112203340.8787@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Lift videobuf-dma-sg's PCI dependency, until it is fixed
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

videobuf-dma-sg.c should be converted to the generic DMA API to make it
also useful for non-PCI configurations. Even now it can be used thanks
to compatibility macros in include/asm-generic/pci-dma-compat.h. This
has been verified to work on PXA270 CPU with the pxa_camera.c soc-camera
driver. For this the following temporary work-around is needed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

Mauro, the patch, linking lib/scatterlist.o into vmlinux unconditionally 
has been sent by Andrew to Linus. So, now we are safe with the below 
patch.

 drivers/media/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8f4a453..434db75 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -150,7 +150,7 @@ config VIDEOBUF_GEN
 	tristate
 
 config VIDEOBUF_DMA_SG
-	depends on PCI
+	depends on PCI || ARCH_PXA
 	select VIDEOBUF_GEN
 	tristate
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
