Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:39060 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030394AbeEYVyO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 17:54:14 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, Julia Lawall <julia.lawall@lip6.fr>,
        sil2review@lists.osadl.org
Subject: [PATCH] media: tc358743: release device_node in tc358743_probe_of()
Date: Sat, 26 May 2018 00:54:00 +0300
Message-Id: <1527285240-12762-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_graph_get_next_endpoint() returns device_node with refcnt increased,
but these is no of_node_put() for it.

The patch adds one on error and normal paths.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/tc358743.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 393bbbbbaad7..44c41933415a 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1918,7 +1918,8 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
 	if (IS_ERR(endpoint)) {
 		dev_err(dev, "failed to parse endpoint\n");
-		return PTR_ERR(endpoint);
+		ret = PTR_ERR(endpoint);
+		goto put_node;
 	}
 
 	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
@@ -2013,6 +2014,8 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	clk_disable_unprepare(refclk);
 free_endpoint:
 	v4l2_fwnode_endpoint_free(endpoint);
+put_node:
+	of_node_put(ep);
 	return ret;
 }
 #else
-- 
2.7.4
