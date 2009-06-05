Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46133 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751235AbZFEJ5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 05:57:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ivtv: Fix PCI direction
To: torvalds@linux-foundation.org, linux-media@vger.kernel.org
Date: Fri, 05 Jun 2009 11:56:18 +0100
Message-ID: <20090605105551.20201.22179.stgit@t61.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

The ivtv stream buffers may be for receive or for send but the attached sg
handle is always destined cpu->device. We flush it correctly but the
allocation is wrongly done with the same type as the buffers.

See bug: http://bugzilla.kernel.org/show_bug.cgi?id=13385

(Note this doesn't close the bug - it fixes the ivtv part and in turn the
 logging next shows up some rather alarming DMA sg list warnings in libata)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/ivtv/ivtv-queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/media/video/ivtv/ivtv-queue.c b/drivers/media/video/ivtv/ivtv-queue.c
index ff7b7de..7fde36e 100644
--- a/drivers/media/video/ivtv/ivtv-queue.c
+++ b/drivers/media/video/ivtv/ivtv-queue.c
@@ -230,7 +230,8 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
 		return -ENOMEM;
 	}
 	if (ivtv_might_use_dma(s)) {
-		s->sg_handle = pci_map_single(itv->pdev, s->sg_dma, sizeof(struct ivtv_sg_element), s->dma);
+		s->sg_handle = pci_map_single(itv->pdev, s->sg_dma,
+				sizeof(struct ivtv_sg_element), PCI_DMA_TODEVICE);
 		ivtv_stream_sync_for_cpu(s);
 	}
 

