Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbcBVTJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
Subject: [PATCH 2/9] [media] pvrusb2: don't go past buf array
Date: Mon, 22 Feb 2016 16:09:16 -0300
Message-Id: <db897cd925180ae10906f13343db31cd9cc42405.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That fixes the following smatch warning:
	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:4909 pvr2_hdw_state_log_state() error: buffer overflow 'buf' 256 <= 4294967294

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 0533ef20decf..1a093e5953fd 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -4903,6 +4903,9 @@ static void pvr2_hdw_state_log_state(struct pvr2_hdw *hdw)
 		printk(KERN_INFO "%s %.*s\n",hdw->name,ccnt,buf);
 	}
 	ccnt = pvr2_hdw_report_clients(hdw, buf, sizeof(buf));
+	if (ccnt >= sizeof(buf))
+		ccnt = sizeof(buf);
+
 	ucnt = 0;
 	while (ucnt < ccnt) {
 		lcnt = 0;
-- 
2.5.0

