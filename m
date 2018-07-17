Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55805 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbeGQWHl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:07:41 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils] ir-ctl: make nec32 scancode encoding match kernel
Date: Tue, 17 Jul 2018 22:33:04 +0100
Message-Id: <20180717213306.22799-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the nec32 encoding, the kernel swaps in the "inverted" and normal
address and command. This might not be the most logical scheme.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/common/ir-encode.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/utils/common/ir-encode.c b/utils/common/ir-encode.c
index c7e319eb..ccc75032 100644
--- a/utils/common/ir-encode.c
+++ b/utils/common/ir-encode.c
@@ -64,15 +64,10 @@ static int nec_encode(enum rc_proto proto, unsigned scancode, unsigned *buf)
 		add_byte(~scancode);
 		break;
 	case RC_PROTO_NEC32:
-		/*
-		 * At the time of writing kernel software nec decoder
-		 * reverses the bit order so it will not match. Hardware
-		 * decoders do not have this issue.
-		 */
-		add_byte(scancode >> 24);
 		add_byte(scancode >> 16);
-		add_byte(scancode >> 8);
+		add_byte(scancode >> 24);
 		add_byte(scancode);
+		add_byte(scancode >> 8);
 		break;
 	}
 
-- 
2.11.0
