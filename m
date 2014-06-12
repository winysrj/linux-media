Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22010 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaFLHCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 03:02:03 -0400
Date: Thu, 12 Jun 2014 10:01:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] davinci: vpif: missing unlocks on error
Message-ID: <20140612070145.GA18563@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8vhEyNdQRqNrzRV=t-D+uh6rCEY5-qLjTOWDfHwUai1Kg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We recently changed some locking around so we need some new unlocks on
the error paths.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: move the unlock so the list_for_each_entry_safe() loop is protected

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a7ed164..1e4ec69 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -269,6 +269,7 @@ err:
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
 	}
+	spin_unlock_irqrestore(&common->irqlock, flags);
 
 	return ret;
 }
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 5bb085b..b431b58 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -233,6 +233,7 @@ err:
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
 	}
+	spin_unlock_irqrestore(&common->irqlock, flags);
 
 	return ret;
 }
