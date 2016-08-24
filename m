Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33129 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753968AbcHXKYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:24:42 -0400
Received: by mail-wm0-f67.google.com with SMTP id o80so1969375wme.0
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 03:24:41 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec-ctl: print correct destination address for broadcast msgs
Date: Wed, 24 Aug 2016 12:24:29 +0200
Message-Id: <1472034269-13737-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When messages are broadcast, it is not necessary to supply a --to option
to cec-ctl, but in that case the destination address was printed wrongly.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-ctl/cec-ctl.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
index 10efcbd..9db6299 100644
--- a/utils/cec-ctl/cec-ctl.cpp
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -1888,7 +1888,7 @@ int main(int argc, char **argv)
 		}
 		printf("\nTransmit from %s to %s (%d to %d):\n", la2s(from),
 		       (cec_msg_is_broadcast(&msg) || to == 0xf) ? "all" : la2s(to),
-		       from, to);
+		       from, cec_msg_is_broadcast(&msg) ? 0xf : to);
 		msg.msg[0] |= (from << 4) | (cec_msg_is_broadcast(&msg) ? 0xf : to);
 		log_msg(&msg);
 		if (doioctl(&node, CEC_TRANSMIT, &msg))
-- 
2.7.4

