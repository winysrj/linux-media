Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53041 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbeJIF01 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 01:26:27 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] media: tc358743: Remove unnecessary self assignment
Date: Mon,  8 Oct 2018 15:11:28 -0700
Message-Id: <20181008221128.22510-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clang warns when a variable is assigned to itself.

drivers/media/i2c/tc358743.c:1921:7: warning: explicitly assigning value
of variable of type 'int' to itself [-Wself-assign]
                ret = ret;
                ~~~ ^ ~~~
1 warning generated.

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/media/i2c/tc358743.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index ca5d92942820..41d470d9ca94 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1918,7 +1918,6 @@ static int tc358743_probe_of(struct tc358743_state *state)
 	ret = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep), &endpoint);
 	if (ret) {
 		dev_err(dev, "failed to parse endpoint\n");
-		ret = ret;
 		goto put_node;
 	}
 
-- 
2.19.0
