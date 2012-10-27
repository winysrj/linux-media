Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab2J0UmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgMFX019843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 49/68] [media] ngene: better comment unused code to avoid warnings
Date: Sat, 27 Oct 2012 18:41:07 -0200
Message-Id: <1351370486-29040-50-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get rid of a few warnings about empty body:
drivers/media/pci/ngene/ngene-core.c:756:3: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
drivers/media/pci/ngene/ngene-cards.c:429:5: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
Those are due to some commented code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/ngene/ngene-cards.c | 4 +++-
 drivers/media/pci/ngene/ngene-core.c  | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 96a13ed..b38bce5 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -425,8 +425,10 @@ static int ReadEEProm(struct i2c_adapter *adapter,
 		status = i2c_read_eeprom(adapter, 0x50, Addr, data, Length);
 		if (!status) {
 			*pLength = EETag[2];
+#if 0
 			if (Length < EETag[2])
-				; /*status=STATUS_BUFFER_OVERFLOW; */
+				status = STATUS_BUFFER_OVERFLOW;
+#endif
 		}
 	}
 	return status;
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index c8e0d5b..2c2df88 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -752,8 +752,8 @@ void set_transfer(struct ngene_channel *chan, int state)
 		if (chan->mode & NGENE_IO_TSIN)
 			chan->pBufferExchange = tsin_exchange;
 		spin_unlock_irq(&chan->state_lock);
-	} else
-		;/* printk(KERN_INFO DEVICE_NAME ": lock=%08x\n",
+	}
+		/* else printk(KERN_INFO DEVICE_NAME ": lock=%08x\n",
 			   ngreadl(0x9310)); */
 
 	ret = ngene_command_stream_control(dev, chan->number,
-- 
1.7.11.7

