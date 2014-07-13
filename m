Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.198]:59350 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaGMNwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jul 2014 09:52:47 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/6] si2168: Small typo fix (SI2157 -> SI2168)
Date: Sun, 13 Jul 2014 16:52:17 +0300
Message-Id: <1405259542-32529-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi>
References: <1405259542-32529-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168_priv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 53f7f06..97f9d87 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -36,9 +36,9 @@ struct si2168 {
 };
 
 /* firmare command struct */
-#define SI2157_ARGLEN      30
+#define SI2168_ARGLEN      30
 struct si2168_cmd {
-	u8 args[SI2157_ARGLEN];
+	u8 args[SI2168_ARGLEN];
 	unsigned wlen;
 	unsigned rlen;
 };
-- 
1.9.1

