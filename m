Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57086 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031AbaKLETm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:42 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/9] mn88473: add staging TODO
Date: Wed, 12 Nov 2014 06:19:30 +0200
Message-Id: <1415765971-24378-9-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add TODO for mainlining.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/mn88473/TODO | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 drivers/staging/media/mn88473/TODO

diff --git a/drivers/staging/media/mn88473/TODO b/drivers/staging/media/mn88473/TODO
new file mode 100644
index 0000000..b90a14b
--- /dev/null
+++ b/drivers/staging/media/mn88473/TODO
@@ -0,0 +1,21 @@
+Driver general quality is not good enough for mainline. Also, other
+device drivers (USB-bridge, tuner) needed for Astrometa receiver in
+question could need some changes. However, if that driver is mainlined
+due to some other device than Astrometa, unrelated TODOs could be
+skipped. In that case rtl28xxu driver needs module parameter to prevent
+driver loading.
+
+Required TODOs:
+* missing lock flags
+* I2C errors
+* tuner sensitivity
+
+*Do not* send any patch fixing checkpatch.pl issues. Currently it passes
+checkpatch.pl tests. I don't want waste my time to review this kind of
+trivial stuff. *Do not* add missing register I/O error checks. Those are
+missing for the reason it is much easier to compare I2C data sniffs when
+there is less lines. Those error checks are about the last thing to be added.
+
+Patches should be submitted to:
+linux-media@vger.kernel.org and Antti Palosaari <crope@iki.fi>
+
-- 
http://palosaari.fi/

