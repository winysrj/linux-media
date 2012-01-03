Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab2ACRrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 12:47:39 -0500
Received: by eekc4 with SMTP id c4so16075723eek.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 09:47:38 -0800 (PST)
Message-ID: <4F033F37.3030301@gmail.com>
Date: Tue, 03 Jan 2012 18:47:35 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] af9013: Fix typo in get_frontend() function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes an obvious typo in the get_frontend() function
of the af9013 driver, recently rewritten by Antti Palosaari.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/frontends/af9013.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/af9013.c
b/drivers/media/dvb/frontends/af9013.c
index e6ba3e0..2aedc0b 100644
--- a/drivers/media/dvb/frontends/af9013.c
+++ b/drivers/media/dvb/frontends/af9013.c
@@ -880,16 +880,16 @@ static int af9013_get_frontend(struct dvb_frontend
*fe)

 	switch ((buf[0] >> 2) & 3) {
 	case 0:
-		c->transmission_mode = GUARD_INTERVAL_1_32;
+		c->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		c->transmission_mode = GUARD_INTERVAL_1_16;
+		c->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		c->transmission_mode = GUARD_INTERVAL_1_8;
+		c->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		c->transmission_mode = GUARD_INTERVAL_1_4;
+		c->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}

-- 
1.7.5.4
