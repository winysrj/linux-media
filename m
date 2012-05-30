Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58277 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab2E3JaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 05:30:17 -0400
Received: by obbtb18 with SMTP id tb18so8155948obb.19
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 02:30:16 -0700 (PDT)
Date: Wed, 30 May 2012 12:28:46 +0300
From: Janne Huttunen <jahuttun@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi
Subject: [PATCH] cxd2820r: Fix an incorrect modulation type bitmask.
Message-ID: <4fc5e84e.wuZo+kOvJkJ3ZYIx%jahuttun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fix an incorrect modulation type bitmask. This allows QAM256 also to be
correctly reported.

Signed-off-by: Janne Huttunen <jahuttun@gmail.com>
---
 drivers/media/dvb/frontends/cxd2820r_c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_c.c b/drivers/media/dvb/frontends/cxd2820r_c.c
index 9454049..ed3b0ba6 100644
--- a/drivers/media/dvb/frontends/cxd2820r_c.c
+++ b/drivers/media/dvb/frontends/cxd2820r_c.c
@@ -121,7 +121,7 @@ int cxd2820r_get_frontend_c(struct dvb_frontend *fe)
 	if (ret)
 		goto error;
 
-	switch ((buf[0] >> 0) & 0x03) {
+	switch ((buf[0] >> 0) & 0x07) {
 	case 0:
 		c->modulation = QAM_16;
 		break;
-- 
1.7.9.5

