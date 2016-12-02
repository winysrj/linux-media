Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:50127 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751070AbcLBRUW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:22 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 1/6] ir-ctl: uninitialised memory used
Date: Fri,  2 Dec 2016 17:20:16 +0000
Message-Id: <1480699221-9267-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We might end up with a corrupt rc6.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-encode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/ir-ctl/ir-encode.c b/utils/ir-ctl/ir-encode.c
index a0d2f4c..1bf0ac6 100644
--- a/utils/ir-ctl/ir-encode.c
+++ b/utils/ir-ctl/ir-encode.c
@@ -310,6 +310,7 @@ static int rc6_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 
 	buf[n++] = NS_TO_US(rc6_unit * 6);
 	buf[n++] = NS_TO_US(rc6_unit * 2);
+	buf[n] = 0;
 
 	switch (proto) {
 	default:
-- 
2.9.3

