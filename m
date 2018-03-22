Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51543 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbeCVLCF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 07:02:05 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc docs: fix warning for RC_PROTO_IMON
Date: Thu, 22 Mar 2018 11:02:04 +0000
Message-Id: <20180322110204.27157-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This protocol was recently added and causes warnings.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/lirc.h.rst.exceptions | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
index c6e3a35d2c4e..984b61dc3f2e 100644
--- a/Documentation/media/lirc.h.rst.exceptions
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -57,6 +57,7 @@ ignore symbol RC_PROTO_RC6_MCE
 ignore symbol RC_PROTO_SHARP
 ignore symbol RC_PROTO_XMP
 ignore symbol RC_PROTO_CEC
+ignore symbol RC_PROTO_IMON
 
 # Undocumented macros
 
-- 
2.14.3
