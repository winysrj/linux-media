Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55027 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932863AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 01/12] [media] cx231xx: don't return error on success
Date: Mon,  5 Sep 2016 07:32:29 -0300
Message-Id: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The cx231xx_set_agc_analog_digital_mux_select() callers
expect it to return 0 or an error. That makes the first
attempt to switch between analog/digital to fail.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 491913778bcc..2f52d66b4dae 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1264,7 +1264,10 @@ int cx231xx_set_agc_analog_digital_mux_select(struct cx231xx *dev,
 				   dev->board.agc_analog_digital_select_gpio,
 				   analog_or_digital);
 
-	return status;
+	if (status < 0)
+		return status;
+
+	return 0;
 }
 
 int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
-- 
2.7.4


