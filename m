Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52445 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZBOUY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 15:24:27 -0500
Subject: Re: [linux-dvb] [BUG] changeset 9029
 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <200902151336.17202@orion.escape-edv.de>
References: <4986507C.1050609@googlemail.com>
	 <200902151336.17202@orion.escape-edv.de>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 15:25:13 -0500
Message-Id: <1234729513.3172.8.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-02-15 at 13:36 +0100, Oliver Endriss wrote:
> e9hack wrote:
> > Hi,
> > 
> > this change set is wrong. The affected functions cannot be called from an interrupt
> > context, because they may process large buffers. In this case, interrupts are disabled for
> > a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> > tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> > 
> > Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> > files).
> 
> @Mauro:
> 
> This changeset _must_ be reverted! It breaks all kernels since 2.6.27
> for applications which use DVB and require a low interrupt latency.
> 
> It is a very bad idea to call the demuxer to process data buffers with
> interrupts disabled!
> 
> FYI, a LIRC problem was reported here:
>   http://vdrportal.de/board/thread.php?postid=786366#post786366
> 
> and it has been verified that changeset
>   http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833
> causes the problem:
>   http://vdrportal.de/board/thread.php?postid=791813#post791813
> 
> Please revert this changeset immediately and submit a fix to the stable
> kernels >= 2.6.27.
> 
> CU
> Oliver


The patch below is an idea for a fix that uses a module parameter to
give back right away the original behavior to those who need it, while
buying time to fix the drivers that are doing things wrong.


I don't know if this patch will be acceptable to anyone, and I suspect
there will be disagreement on the default behavior.

It compiles and comes through checkpatch.pl with only one warning about
an extern declaration I didn't know where to place.  This patch still
needs to be checked for correctness and tested.


Regards,
Andy


Signed-off-by: Andy Walls <awalls@radix.net>


diff -r 3976e528b4a6 linux/drivers/media/dvb/dvb-core/dmxdev.c
--- a/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sat Feb 14 15:08:37 2009 -0500
+++ b/linux/drivers/media/dvb/dvb-core/dmxdev.c	Sun Feb 15 14:55:49 2009 -0500
@@ -35,6 +35,17 @@
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
+
+/*
+ * FIXME - remove this conservative lock kludge, when the offending drivers
+ * that make some calls improperly from an interrupt context are fixed.
+ */
+int dmxdev_conservative_locks;
+
+module_param_named(conservative_locks, dmxdev_conservative_locks, int, 0644);
+MODULE_PARM_DESC(conservative_locks,
+		 "Work around for drivers that make calls\n"
+		 "\t\twith interrupts disabled (default:0/off).");
 
 #define dprintk	if (debug) printk
 
@@ -364,16 +375,22 @@
 				       enum dmx_success success)
 {
 	struct dmxdev_filter *dmxdevfilter = filter->priv;
-	unsigned long flags;
+	unsigned long flags = 0;
 	int ret;
 
 	if (dmxdevfilter->buffer.error) {
 		wake_up(&dmxdevfilter->buffer.queue);
 		return 0;
 	}
-	spin_lock_irqsave(&dmxdevfilter->dev->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_lock_irqsave(&dmxdevfilter->dev->lock, flags);
+	else
+		spin_lock(&dmxdevfilter->dev->lock);
 	if (dmxdevfilter->state != DMXDEV_STATE_GO) {
-		spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		if (dmxdev_conservative_locks)
+			spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		else
+			spin_unlock(&dmxdevfilter->dev->lock);
 		return 0;
 	}
 	del_timer(&dmxdevfilter->timer);
@@ -392,7 +409,10 @@
 	}
 	if (dmxdevfilter->params.sec.flags & DMX_ONESHOT)
 		dmxdevfilter->state = DMXDEV_STATE_DONE;
-	spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+	else
+		spin_unlock(&dmxdevfilter->dev->lock);
 	wake_up(&dmxdevfilter->buffer.queue);
 	return 0;
 }
@@ -404,12 +424,18 @@
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
-	unsigned long flags;
+	unsigned long flags = 0;
 	int ret;
 
-	spin_lock_irqsave(&dmxdevfilter->dev->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_lock_irqsave(&dmxdevfilter->dev->lock, flags);
+	else
+		spin_lock(&dmxdevfilter->dev->lock);
 	if (dmxdevfilter->params.pes.output == DMX_OUT_DECODER) {
-		spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		if (dmxdev_conservative_locks)
+			spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		else
+			spin_unlock(&dmxdevfilter->dev->lock);
 		return 0;
 	}
 
@@ -419,7 +445,10 @@
 	else
 		buffer = &dmxdevfilter->dev->dvr_buffer;
 	if (buffer->error) {
-		spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		if (dmxdev_conservative_locks)
+			spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+		else
+			spin_unlock(&dmxdevfilter->dev->lock);
 		wake_up(&buffer->queue);
 		return 0;
 	}
@@ -430,7 +459,10 @@
 		dvb_ringbuffer_flush(buffer);
 		buffer->error = ret;
 	}
-	spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_unlock_irqrestore(&dmxdevfilter->dev->lock, flags);
+	else
+		spin_unlock(&dmxdevfilter->dev->lock);
 	wake_up(&buffer->queue);
 	return 0;
 }
diff -r 3976e528b4a6 linux/drivers/media/dvb/dvb-core/dvb_demux.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_demux.c	Sat Feb 14 15:08:37 2009 -0500
+++ b/linux/drivers/media/dvb/dvb-core/dvb_demux.c	Sun Feb 15 14:55:49 2009 -0500
@@ -37,6 +37,12 @@
 ** #define DVB_DEMUX_SECTION_LOSS_LOG to monitor payload loss in the syslog
 */
 // #define DVB_DEMUX_SECTION_LOSS_LOG
+
+/*
+ * FIXME - remove this conservative lock kludge, when the offending drivers
+ * that make some calls improperly from an interrupt context are fixed.
+ */
+extern int dmxdev_conservative_locks;
 
 /******************************************************************************
  * static inlined helper functions
@@ -399,9 +405,12 @@
 void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
 			      size_t count)
 {
-	unsigned long flags;
+	unsigned long flags = 0;
 
-	spin_lock_irqsave(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_lock_irqsave(&demux->lock, flags);
+	else
+		spin_lock(&demux->lock);
 
 	while (count--) {
 		if (buf[0] == 0x47)
@@ -409,17 +418,23 @@
 		buf += 188;
 	}
 
-	spin_unlock_irqrestore(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_unlock_irqrestore(&demux->lock, flags);
+	else
+		spin_unlock(&demux->lock);
 }
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
 
 void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
 {
-	unsigned long flags;
+	unsigned long flags = 0;
 	int p = 0, i, j;
 
-	spin_lock_irqsave(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_lock_irqsave(&demux->lock, flags);
+	else
+		spin_lock(&demux->lock);
 
 	if (demux->tsbufp) {
 		i = demux->tsbufp;
@@ -452,18 +467,24 @@
 	}
 
 bailout:
-	spin_unlock_irqrestore(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_unlock_irqrestore(&demux->lock, flags);
+	else
+		spin_unlock(&demux->lock);
 }
 
 EXPORT_SYMBOL(dvb_dmx_swfilter);
 
 void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
 {
-	unsigned long flags;
+	unsigned long flags = 0;
 	int p = 0, i, j;
 	u8 tmppack[188];
 
-	spin_lock_irqsave(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_lock_irqsave(&demux->lock, flags);
+	else
+		spin_lock(&demux->lock);
 
 	if (demux->tsbufp) {
 		i = demux->tsbufp;
@@ -504,7 +525,10 @@
 	}
 
 bailout:
-	spin_unlock_irqrestore(&demux->lock, flags);
+	if (dmxdev_conservative_locks)
+		spin_unlock_irqrestore(&demux->lock, flags);
+	else
+		spin_unlock(&demux->lock);
 }
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_204);



