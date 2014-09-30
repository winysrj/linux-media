Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48499 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaI3PR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 11:17:29 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so5207296wgh.17
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 08:17:28 -0700 (PDT)
From: Gregor Jasny <gjasny@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>
Subject: [PATCH 1/3] libdvbv5: Add todo file
Date: Tue, 30 Sep 2014 17:17:06 +0200
Message-Id: <1412090228-19996-2-git-send-email-gjasny@googlemail.com>
In-Reply-To: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
References: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gregor Jasny <gjasny@googlemail.com>
---
 TODO.libdvbv5 | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 TODO.libdvbv5

diff --git a/TODO.libdvbv5 b/TODO.libdvbv5
new file mode 100644
index 0000000..21091c4
--- /dev/null
+++ b/TODO.libdvbv5
@@ -0,0 +1,2 @@
+- On next SONAME bump
+  - clean up dvb_fe_open* and re-apply 9eaa2327da63fffd0dcaaa02b7641e66f881e20d
-- 
2.1.0

