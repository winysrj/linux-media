Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3DQAmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:54 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0grOa017443
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:53 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 14/31] [media] r820t: Show the read data in the bit-reversed order
Date: Tue, 16 Apr 2013 21:42:25 -0300
Message-Id: <1366159362-3773-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the driver's logic uses the bit-reversed order for read,
use it as well when displaying the debug messages.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/r820t.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 1880807e..bb154449 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -429,13 +429,14 @@ static int r820_read(struct r820t_priv *priv, u8 reg, u8 *val, int len)
 			return rc;
 		return -EREMOTEIO;
 	}
-	tuner_dbg("%s: i2c rd reg=%02x len=%d: %*ph\n",
-		  __func__, reg, len, len, p);
 
 	/* Copy data to the output buffer */
 	for (i = 0; i < len; i++)
 		val[i] = bitrev8(p[i]);
 
+	tuner_dbg("%s: i2c rd reg=%02x len=%d: %*ph\n",
+		  __func__, reg, len, len, val);
+
 	return 0;
 }
 
-- 
1.8.1.4

