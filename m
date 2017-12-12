Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:36640 "EHLO
        resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752102AbdLLBAJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 20:00:09 -0500
From: Ron Economos <w6rz@comcast.net>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND] media: dvb-frontends: Add delay to Si2168 restart.
Date: Mon, 11 Dec 2017 16:51:53 -0800
Message-Id: <1513039913-8117-1-git-send-email-w6rz@comcast.net>
In-Reply-To: <20171211144229.3002f15f@vento.lan>
References: <20171211144229.3002f15f@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On faster CPUs a delay is required after the resume command and the restart command. Without the delay, the restart command often returns -EREMOTEIO and the Si2168 does not restart.

Note that this patch fixes the same issue as https://patchwork.linuxtv.org/patch/44304/, but I believe my udelay() fix addresses the actual problem.

Signed-off-by: Ron Economos <w6rz@comcast.net>

---
 drivers/media/dvb-frontends/si2168.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 41d9c51..539399d 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -14,6 +14,8 @@
  *    GNU General Public License for more details.
  */
 
+#include <linux/delay.h>
+
 #include "si2168_priv.h"
 
 static const struct dvb_frontend_ops si2168_ops;
@@ -435,6 +437,7 @@ static int si2168_init(struct dvb_frontend *fe)
 		if (ret)
 			goto err;
 
+		udelay(100);
 		memcpy(cmd.args, "\x85", 1);
 		cmd.wlen = 1;
 		cmd.rlen = 1;
-- 
2.7.4
