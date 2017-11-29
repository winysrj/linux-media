Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:33932 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752172AbdK2TIr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 06/22] media: s5k6a3: document some fields at struct s5k6a3
Date: Wed, 29 Nov 2017 14:08:24 -0500
Message-Id: <dcdd4b5f48e6c9bd786c698215136f10ee0d2f5c.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'clock'
drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'clock_frequency'
drivers/media/i2c/s5k6a3.c:68: warning: No description found for parameter 'power_count'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/s5k6a3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 67dcca76f981..2e140272794b 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -53,6 +53,9 @@ enum {
  * @gpio_reset: GPIO connected to the sensor's reset pin
  * @lock: mutex protecting the structure's members below
  * @format: media bus format at the sensor's source pad
+ * @clock: pointer to &struct clk.
+ * @clock_frequency: clock frequency
+ * @power_count: stores state if device is powered
  */
 struct s5k6a3 {
 	struct device *dev;
-- 
2.14.3
