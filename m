Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:16597 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731024AbeG1XwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 19:52:17 -0400
Date: Sun, 29 Jul 2018 06:24:06 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Sean Young <sean@mess.org>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Matthias Reichl <hias@horus.com>
Subject: [RFC PATCH] media: rc: repeat_period() can be static
Message-ID: <20180728222406.GA32010@lkp-wsm-ep2>
References: <20180728091115.16971-1-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180728091115.16971-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes: f52e85dbaa91 ("media: rc: read out of bounds if bpf reports high protocol number")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 rc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index a24850b..ca68e1d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -679,7 +679,7 @@ static void ir_timer_repeat(struct timer_list *t)
 	spin_unlock_irqrestore(&dev->keylock, flags);
 }
 
-unsigned int repeat_period(int protocol)
+static unsigned int repeat_period(int protocol)
 {
 	if (protocol >= ARRAY_SIZE(protocols))
 		return 100;
