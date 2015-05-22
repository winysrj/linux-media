Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49249 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782AbbEVOAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 10:00:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/11] cobalt: fix compiler warnings on 32 bit OSes
Date: Fri, 22 May 2015 15:59:36 +0200
Message-Id: <1432303184-8594-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
References: <1432303184-8594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixes these warnings:

drivers/media/pci/cobalt/cobalt-omnitek.c: In function 'omni_sg_dma_start':
drivers/media/pci/cobalt/cobalt-omnitek.c:112:28: warning: right shift count >= width of type [-Wshift-count-overflow]
  iowrite32((u32)(desc->bus >> 32), DESCRIPTOR(s->dma_channel) + 4);
                            ^
drivers/media/pci/cobalt/cobalt-omnitek.c: In function 'descriptor_list_create':
drivers/media/pci/cobalt/cobalt-omnitek.c:222:28: warning: right shift count >= width of type [-Wshift-count-overflow]
     d->next_h = (u32)(next >> 32);
                            ^
drivers/media/pci/cobalt/cobalt-omnitek.c:268:32: warning: right shift count >= width of type [-Wshift-count-overflow]
    d->next_h = (u32)(desc->bus >> 32);
                                ^
drivers/media/pci/cobalt/cobalt-omnitek.c:275:27: warning: right shift count >= width of type [-Wshift-count-overflow]
    d->next_h = (u32)(next >> 32);
                           ^
drivers/media/pci/cobalt/cobalt-omnitek.c: In function 'descriptor_list_chain':
drivers/media/pci/cobalt/cobalt-omnitek.c:293:31: warning: right shift count >= width of type [-Wshift-count-overflow]
   d->next_h = (u32)(next->bus >> 32);
                               ^
drivers/media/pci/cobalt/cobalt-omnitek.c: In function 'descriptor_list_loopback':
drivers/media/pci/cobalt/cobalt-omnitek.c:332:30: warning: right shift count >= width of type [-Wshift-count-overflow]
  d->next_h = (u32)(desc->bus >> 32);
                              ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-omnitek.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-omnitek.c b/drivers/media/pci/cobalt/cobalt-omnitek.c
index 5604458..a28a848 100644
--- a/drivers/media/pci/cobalt/cobalt-omnitek.c
+++ b/drivers/media/pci/cobalt/cobalt-omnitek.c
@@ -109,7 +109,7 @@ void omni_sg_dma_start(struct cobalt_stream *s, struct sg_dma_desc_info *desc)
 {
 	struct cobalt *cobalt = s->cobalt;
 
-	iowrite32((u32)(desc->bus >> 32), DESCRIPTOR(s->dma_channel) + 4);
+	iowrite32((u32)((u64)desc->bus >> 32), DESCRIPTOR(s->dma_channel) + 4);
 	iowrite32((u32)desc->bus & NEXT_ADRS_MSK, DESCRIPTOR(s->dma_channel));
 	iowrite32(ENABLE | SCATTER_GATHER_MODE | START, CS_REG(s->dma_channel));
 }
@@ -219,7 +219,7 @@ int descriptor_list_create(struct cobalt *cobalt,
 				offset += d->bytes;
 				addr += d->bytes;
 				next += sizeof(struct sg_dma_descriptor);
-				d->next_h = (u32)(next >> 32);
+				d->next_h = (u32)((u64)next >> 32);
 				d->next_l = (u32)next |
 					(to_pci ? WRITE_TO_PCI : 0);
 				bytes -= d->bytes;
@@ -265,14 +265,14 @@ int descriptor_list_create(struct cobalt *cobalt,
 		next += sizeof(struct sg_dma_descriptor);
 		if (size == 0) {
 			/* Loopback to the first descriptor */
-			d->next_h = (u32)(desc->bus >> 32);
+			d->next_h = (u32)((u64)desc->bus >> 32);
 			d->next_l = (u32)desc->bus |
 				(to_pci ? WRITE_TO_PCI : 0) | INTERRUPT_ENABLE;
 			if (!to_pci)
 				d->local = 0x22222222;
 			desc->last_desc_virt = d;
 		} else {
-			d->next_h = (u32)(next >> 32);
+			d->next_h = (u32)((u64)next >> 32);
 			d->next_l = (u32)next | (to_pci ? WRITE_TO_PCI : 0);
 		}
 		d++;
@@ -290,7 +290,7 @@ void descriptor_list_chain(struct sg_dma_desc_info *this,
 		d->next_h = 0;
 		d->next_l = direction | INTERRUPT_ENABLE | END_OF_CHAIN;
 	} else {
-		d->next_h = (u32)(next->bus >> 32);
+		d->next_h = (u32)((u64)next->bus >> 32);
 		d->next_l = (u32)next->bus | direction | INTERRUPT_ENABLE;
 	}
 }
@@ -329,7 +329,7 @@ void descriptor_list_loopback(struct sg_dma_desc_info *desc)
 {
 	struct sg_dma_descriptor *d = desc->last_desc_virt;
 
-	d->next_h = (u32)(desc->bus >> 32);
+	d->next_h = (u32)((u64)desc->bus >> 32);
 	d->next_l = (u32)desc->bus | (d->next_l & DESCRIPTOR_FLAG_MSK);
 }
 
-- 
2.1.4

