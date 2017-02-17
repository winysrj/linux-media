Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:40038 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932956AbdBQJ2c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 04:28:32 -0500
Date: Fri, 17 Feb 2017 10:19:16 +0100
From: Matthias Reichl <hias@horus.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] v4l-utils: fix invalid protocol in streamzap keymap
Message-ID: <20170217091916.GA24266@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir-keytable can't load the streamzap keymap because the
protocol type RC5_SZ is invalid:

./ir-keytable -w rc_keymaps/streamzap
Protocol RC5_SZ invalid
...

Fix this by changing the protocol type to RC-5-SZ which
matches the kernel protocol rc-5-sz

Signed-off-by: Matthias Reichl <hias@horus.com>
---
 utils/keytable/rc_keymaps/streamzap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/keytable/rc_keymaps/streamzap b/utils/keytable/rc_keymaps/streamzap
index 3512cd8..03d2cb8 100644
--- a/utils/keytable/rc_keymaps/streamzap
+++ b/utils/keytable/rc_keymaps/streamzap
@@ -1,4 +1,4 @@
-# table streamzap, type: RC5_SZ
+# table streamzap, type: RC-5-SZ
 0x28c0 KEY_NUMERIC_0
 0x28c1 KEY_NUMERIC_1
 0x28c2 KEY_NUMERIC_2
-- 
2.1.4
