Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:59581 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZGCQsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 12:48:36 -0400
From: Oliver Neukum <oliver@neukum.org>
To: kjsisson@bellsouth.net, mchehab@infradead.org,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: [patch]stv680: kfree called before usb_kill_urb
Date: Fri, 3 Jul 2009 18:48:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031848.49825.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The irq handler will touch memory. Even in the error case some URBs may
complete. Thus no memory must be kfreed before all URBs are killed.

Signed-off-by: Oliver Neukum <oliver@neukum.org>

--

commit e91d238d2b6f83f9b64b57b570ee150b1cd008e7
Author: Oliver Neukum <oneukum@linux-d698.(none)>
Date:   Fri Jul 3 18:18:26 2009 +0200

    stv680: fix access to freed memory in error case
    
    in the error case some URBs may be active and access memory
    URBs must be killed before any memory is freed

diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index 75f286f..58c0148 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -733,10 +733,6 @@ static int stv680_start_stream (struct usb_stv *stv680)
 	return 0;
 
  nomem_err:
-	for (i = 0; i < STV680_NUMSCRATCH; i++) {
-		kfree(stv680->scratch[i].data);
-		stv680->scratch[i].data = NULL;
-	}
 	for (i = 0; i < STV680_NUMSBUF; i++) {
 		usb_kill_urb(stv680->urb[i]);
 		usb_free_urb(stv680->urb[i]);
@@ -744,6 +740,11 @@ static int stv680_start_stream (struct usb_stv *stv680)
 		kfree(stv680->sbuf[i].data);
 		stv680->sbuf[i].data = NULL;
 	}
+	/* used in irq, free only as all URBs are dead */
+	for (i = 0; i < STV680_NUMSCRATCH; i++) {
+		kfree(stv680->scratch[i].data);
+		stv680->scratch[i].data = NULL;
+	}
 	return -ENOMEM;
 
 }

