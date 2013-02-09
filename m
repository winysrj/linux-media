Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3944 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab3BIKBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 21/26] cx231xx: remove bogus driver prefix in log messages.
Date: Sat,  9 Feb 2013 11:00:51 +0100
Message-Id: <fb4bcf0e6eccac9e1366351849bcfb9c3ab601ea.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The prefix is generated automatically, so no need to provide it again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-vbi.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 46e3892..1340ff2 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -70,10 +70,10 @@ static inline void print_err_status(struct cx231xx *dev, int packet, int status)
 		break;
 	}
 	if (packet < 0) {
-		cx231xx_err(DRIVER_NAME "URB status %d [%s].\n", status,
+		cx231xx_err("URB status %d [%s].\n", status,
 			    errmsg);
 	} else {
-		cx231xx_err(DRIVER_NAME "URB packet %d, status %d [%s].\n",
+		cx231xx_err("URB packet %d, status %d [%s].\n",
 			    packet, status, errmsg);
 	}
 }
@@ -317,7 +317,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:		/* error */
-		cx231xx_err(DRIVER_NAME "urb completition error %d.\n",
+		cx231xx_err("urb completition error %d.\n",
 			    urb->status);
 		break;
 	}
@@ -332,7 +332,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
 
 	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (urb->status) {
-		cx231xx_err(DRIVER_NAME "urb resubmit failed (error=%i)\n",
+		cx231xx_err("urb resubmit failed (error=%i)\n",
 			    urb->status);
 	}
 }
@@ -345,7 +345,7 @@ void cx231xx_uninit_vbi_isoc(struct cx231xx *dev)
 	struct urb *urb;
 	int i;
 
-	cx231xx_info(DRIVER_NAME "cx231xx: called cx231xx_uninit_vbi_isoc\n");
+	cx231xx_info("called cx231xx_uninit_vbi_isoc\n");
 
 	dev->vbi_mode.bulk_ctl.nfields = -1;
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
@@ -394,7 +394,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	struct urb *urb;
 	int rc;
 
-	cx231xx_info(DRIVER_NAME "cx231xx: called cx231xx_prepare_isoc\n");
+	cx231xx_info("called cx231xx_vbi_isoc\n");
 
 	/* De-allocates all pending stuff */
 	cx231xx_uninit_vbi_isoc(dev);
@@ -442,8 +442,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			cx231xx_err(DRIVER_NAME
-				    ": cannot alloc bulk_ctl.urb %i\n", i);
+			cx231xx_err("cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
@@ -453,8 +452,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 		dev->vbi_mode.bulk_ctl.transfer_buffer[i] =
 		    kzalloc(sb_size, GFP_KERNEL);
 		if (!dev->vbi_mode.bulk_ctl.transfer_buffer[i]) {
-			cx231xx_err(DRIVER_NAME
-				    ": unable to allocate %i bytes for transfer"
+			cx231xx_err("unable to allocate %i bytes for transfer"
 				    " buffer %i%s\n", sb_size, i,
 				    in_interrupt() ? " while in int" : "");
 			cx231xx_uninit_vbi_isoc(dev);
@@ -473,8 +471,7 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->vbi_mode.bulk_ctl.num_bufs; i++) {
 		rc = usb_submit_urb(dev->vbi_mode.bulk_ctl.urb[i], GFP_ATOMIC);
 		if (rc) {
-			cx231xx_err(DRIVER_NAME
-				    ": submit of urb %i failed (error=%i)\n", i,
+			cx231xx_err("submit of urb %i failed (error=%i)\n", i,
 				    rc);
 			cx231xx_uninit_vbi_isoc(dev);
 			return rc;
@@ -526,7 +523,7 @@ static inline void vbi_buffer_filled(struct cx231xx *dev,
 				     struct cx231xx_buffer *buf)
 {
 	/* Advice that buffer was filled */
-	/* cx231xx_info(DRIVER_NAME "[%p/%d] wakeup\n", buf, buf->vb.i); */
+	/* cx231xx_info("[%p/%d] wakeup\n", buf, buf->vb.i); */
 
 	buf->vb.state = VIDEOBUF_DONE;
 	buf->vb.field_count++;
@@ -618,7 +615,7 @@ static inline void get_next_vbi_buf(struct cx231xx_dmaqueue *dma_q,
 	char *outp;
 
 	if (list_empty(&dma_q->active)) {
-		cx231xx_err(DRIVER_NAME ": No active queue to serve\n");
+		cx231xx_err("No active queue to serve\n");
 		dev->vbi_mode.bulk_ctl.buf = NULL;
 		*buf = NULL;
 		return;
-- 
1.7.10.4

