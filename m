Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:55278 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968291Ab0B1Oeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 09:34:44 -0500
Message-ID: <4B8A7EFB.1090403@freemail.hu>
Date: Sun, 28 Feb 2010 15:34:35 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] nGene: use NULL when pointer is needed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Use NULL when calling a function with pointer parameter, initializing a
pointer and returning a pointer. This will remove the following sparse
warning at different locations (see "make C=1"):
 * warning: Using plain integer as NULL pointer

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 37581bb7e6f1 linux/drivers/media/dvb/ngene/ngene-core.c
--- a/linux/drivers/media/dvb/ngene/ngene-core.c	Wed Feb 24 22:48:50 2010 -0300
+++ b/linux/drivers/media/dvb/ngene/ngene-core.c	Sun Feb 28 15:28:56 2010 +0100
@@ -994,7 +994,7 @@
 					     msg[0].buf, msg[0].len))
 			goto done;
 	if (num == 1 && (msg[0].flags & I2C_M_RD))
-		if (!ngene_command_i2c_read(dev, msg[0].addr, 0, 0,
+		if (!ngene_command_i2c_read(dev, msg[0].addr, NULL, 0,
 					    msg[0].buf, msg[0].len, 0))
 			goto done;

@@ -1793,7 +1793,7 @@
 	if (chan->users > 0)
 #endif
 		dvb_dmx_swfilter(&chan->demux, buf, len);
-	return 0;
+	return NULL;
 }

 u8 fill_ts[188] = { 0x47, 0x1f, 0xff, 0x10 };
@@ -1900,7 +1900,7 @@
 		       state);
 	if (!state) {
 		spin_lock_irq(&chan->state_lock);
-		chan->pBufferExchange = 0;
+		chan->pBufferExchange = NULL;
 		dvb_ringbuffer_flush(&dev->tsout_rbuf);
 		spin_unlock_irq(&chan->state_lock);
 	}
@@ -2226,7 +2226,7 @@
 	dvbdemux->feednum = 256;
 	dvbdemux->start_feed = start_feed;
 	dvbdemux->stop_feed = stop_feed;
-	dvbdemux->write_to_decoder = 0;
+	dvbdemux->write_to_decoder = NULL;
 	dvbdemux->dmx.capabilities = (DMX_TS_FILTERING |
 				      DMX_SECTION_FILTERING |
 				      DMX_MEMORY_BASED_FILTERING);
@@ -2383,8 +2383,8 @@
 		return;
 	free_ringbuffer(dev, rb);
 	for (j = 0; j < tb->NumBuffers; j++, Cur = Cur->Next) {
-		Cur->Buffer2 = 0;
-		Cur->scList2 = 0;
+		Cur->Buffer2 = NULL;
+		Cur->scList2 = NULL;
 		Cur->ngeneBuffer.Address_of_first_entry_2 = 0;
 		Cur->ngeneBuffer.Number_of_entries_2 = 0;
 	}
@@ -2430,7 +2430,7 @@
 	u64 PARingBufferNext;
 	struct SBufferHeader *Cur, *Next;

-	descr->Head = 0;
+	descr->Head = NULL;
 	descr->MemSize = 0;
 	descr->PAHead = 0;
 	descr->NumBuffers = 0;
@@ -3619,7 +3619,7 @@
 		if (chan->fe) {
 			dvb_unregister_frontend(chan->fe);
 			dvb_frontend_detach(chan->fe);
-			chan->fe = 0;
+			chan->fe = NULL;
 		}
 		dvbdemux->dmx.close(&dvbdemux->dmx);
 		dvbdemux->dmx.remove_frontend(&dvbdemux->dmx,
@@ -3765,7 +3765,7 @@
 		release_channel(&dev->channel[i]);
 	ngene_stop(dev);
 	ngene_release_buffers(dev);
-	pci_set_drvdata(pdev, 0);
+	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 }

@@ -3840,7 +3840,7 @@
 	ngene_release_buffers(dev);
 fail0:
 	pci_disable_device(pci_dev);
-	pci_set_drvdata(pci_dev, 0);
+	pci_set_drvdata(pci_dev, NULL);
 	return stat;
 }

