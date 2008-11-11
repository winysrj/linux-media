Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mABGvQSh000505
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:57:26 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mABGuc0B002613
	for <video4linux-list@redhat.com>; Tue, 11 Nov 2008 11:56:39 -0500
Date: Tue, 11 Nov 2008 17:56:51 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
Message-ID: <Pine.LNX.4.64.0811111740110.4565@axis700.grange>
References: <Pine.LNX.4.64.0811111738010.4565@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 1/3] ipu-idmac: new channel status flag,
	more debugging output
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

The new status flag IPU_CHANNEL_FREE_PENDING is needed to prevent 
use-count underflow. Also fix missing new-line in debugging prints.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
diff --git a/arch/arm/plat-mxc/include/mach/ipu.h b/arch/arm/plat-mxc/include/mach/ipu.h
index 07939b9..b9ef451 100644
--- a/arch/arm/plat-mxc/include/mach/ipu.h
+++ b/arch/arm/plat-mxc/include/mach/ipu.h
@@ -54,6 +54,7 @@ enum ipu_channel {
 /* Order significant! */
 enum ipu_channel_status {
 	IPU_CHANNEL_FREE,
+	IPU_CHANNEL_FREE_PENDING,
 	IPU_CHANNEL_GRANTED,
 	IPU_CHANNEL_INITIALIZED,
 	IPU_CHANNEL_READY,
diff --git a/drivers/mfd/ipu/ipu_idmac.c b/drivers/mfd/ipu/ipu_idmac.c
index c7413e7..c0207b0 100644
--- a/drivers/mfd/ipu/ipu_idmac.c
+++ b/drivers/mfd/ipu/ipu_idmac.c
@@ -64,14 +64,14 @@ static void idmac_write_ipureg(struct ipu *ipu, u32 value, unsigned long reg)
 static void dump_idmac_reg(struct ipu *ipu)
 {
 	dev_dbg(ipu->dev, "IDMAC_CONF 0x%x, IC_CONF 0x%x, IDMAC_CHA_EN 0x%x, "
-		"IDMAC_CHA_PRI 0x%x, IDMAC_CHA_BUSY 0x%x",
+		"IDMAC_CHA_PRI 0x%x, IDMAC_CHA_BUSY 0x%x\n",
 		idmac_read_icreg(ipu, IDMAC_CONF),
 		idmac_read_icreg(ipu, IC_CONF),
 		idmac_read_icreg(ipu, IDMAC_CHA_EN),
 		idmac_read_icreg(ipu, IDMAC_CHA_PRI),
 		idmac_read_icreg(ipu, IDMAC_CHA_BUSY));
 	dev_dbg(ipu->dev, "BUF0_RDY 0x%x, BUF1_RDY 0x%x, CUR_BUF 0x%x, "
-		"DB_MODE 0x%x, TASKS_STAT 0x%x",
+		"DB_MODE 0x%x, TASKS_STAT 0x%x\n",
 		idmac_read_ipureg(ipu, IPU_CHA_BUF0_RDY),
 		idmac_read_ipureg(ipu, IPU_CHA_BUF1_RDY),
 		idmac_read_ipureg(ipu, IPU_CHA_CUR_BUF),
@@ -1364,8 +1364,10 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan,
 	 * Only client_count can tell us whether the channel is free. There is
 	 * no other way to find out if a client has accepted a channel offer.
 	 */
-	if (chan->client_count)
+	if (chan->client_count) {
+		dev_dbg(&chan->dev, "Channel %x busy\n", chan->chan_id);
 		return -EBUSY;
+	}
 
 	/* Now we know, that the channel is free */
 
@@ -1376,9 +1378,14 @@ static int idmac_alloc_chan_resources(struct dma_chan *chan,
 	if (!idmac_client_channel_match(ichan, client))
 		return -EINVAL;
 
-	dev_dbg(&ichan->dma_chan.dev, "Found channel 0x%x for client %p, irq %d\n",
-		ichan->dma_chan.chan_id, client, ichan->eof_irq);
+	dev_dbg(&chan->dev, "Found channel 0x%x for client %p, irq %d\n",
+		chan->chan_id, client, ichan->eof_irq);
 
+	/*
+	 * No real resource allocation here, because we do not know, whether
+	 * the client will accept our offer. Just keep a pointer to the client
+	 * as a hint.
+	 */
 	ichan->iclient = iclient;
 
 	return 0;
@@ -1400,7 +1407,13 @@ static void idmac_free_chan_resources(struct dma_chan *chan)
 
 	for (i = 0, ic = iclient->channels; i < iclient->n_channels; i++, ic++) {
 		if (ic->channel == ichan->dma_chan.chan_id) {
-			ichan->status = IPU_CHANNEL_FREE;
+			dev_dbg(&chan->dev, "Releasing channel %x status %d\n",
+				ic->channel, ichan->status);
+			/*
+			 * The client has to be able to detect when it has to
+			 * ack, that is why we need a special status here.
+			 */
+			ichan->status = IPU_CHANNEL_FREE_PENDING;
 			ic->ichannel = NULL;
 			break;
 		}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
