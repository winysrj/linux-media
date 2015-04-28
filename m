Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030960AbbD1XEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:04:41 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 02/13] benq: fix indentation
Date: Tue, 28 Apr 2015 20:04:24 -0300
Message-Id: <c113b1801dafaa9ff1d7728aa8c253cd37af04f2.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262253.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/gspca/benq.c:239 sd_isoc_irq() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/benq.c b/drivers/media/usb/gspca/benq.c
index 05f406deae13..790baed33963 100644
--- a/drivers/media/usb/gspca/benq.c
+++ b/drivers/media/usb/gspca/benq.c
@@ -236,8 +236,8 @@ static void sd_isoc_irq(struct urb *urb)
 		}
 		data = (u8 *) urb->transfer_buffer
 					+ urb->iso_frame_desc[i].offset;
-			gspca_frame_add(gspca_dev, INTER_PACKET,
-					data, SD_PKT_SZ);
+		gspca_frame_add(gspca_dev, INTER_PACKET,
+				data, SD_PKT_SZ);
 	}
 
 	/* resubmit the URBs */
-- 
2.1.0

