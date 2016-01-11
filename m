Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55316 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbcAKQrx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:47:53 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v2 2/8] [media] adv7604: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 13:47:10 -0300
Message-Id: <1452530844-30609-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

Changes in v2: None

 drivers/media/i2c/adv7604.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index f8dd7505b529..ed3eccd94285 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2799,6 +2799,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	struct device_node *endpoint;
 	struct device_node *np;
 	unsigned int flags;
+	int ret;
 	u32 v;
 
 	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
@@ -2808,7 +2809,11 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
 	if (!endpoint)
 		return -EINVAL;
 
-	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	ret = v4l2_of_parse_endpoint(endpoint, &bus_cfg);
+	if (ret) {
+		of_node_put(endpoint);
+		return ret;
+	}
 
 	if (!of_property_read_u32(endpoint, "default-input", &v))
 		state->pdata.default_input = v;
-- 
2.4.3

