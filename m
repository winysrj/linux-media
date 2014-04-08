Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:65157 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHNFS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 09:05:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3P00EP9R0SZV40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Apr 2014 22:05:16 +0900 (KST)
Content-transfer-encoding: 8BIT
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5c73m3: Add missing rename of v4l2_of_get_next_endpoint()
 function
Date: Tue, 08 Apr 2014 15:05:03 +0200
Message-id: <1396962303-412-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes following build error:

  CC      drivers/media/i2c/s5c73m3/s5c73m3-core.o
  CC      drivers/md/dm-ioctl.o
  CC      net/ipv4/inet_lro.o
drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function ‘s5c73m3_get_platform_data’:
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:2: error: implicit declaration of function ‘v4l2_of_get_next_endpoint’ [-Werror=implicit-function-declaration]
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1619:10: warning: assignment makes pointer from integer without a cast [enabled by default]

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index a445930..ee0f57e 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1616,7 +1616,7 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 	if (ret < 0)
 		return -EINVAL;
 
-	node_ep = v4l2_of_get_next_endpoint(node, NULL);
+	node_ep = of_graph_get_next_endpoint(node, NULL);
 	if (!node_ep) {
 		dev_warn(dev, "no endpoint defined for node: %s\n",
 						node->full_name);
-- 
1.7.9.5

