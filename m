Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52718 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806Ab2CLWWy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 18:22:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?UTF-8?q?Ji=C5=99=C3=AD=20Zelenka?= <klacek@bubakov.net>
Subject: [PATCH FOR 3.3-RC8] tda10071: BUGFIX delivery system
Date: Tue, 13 Mar 2012 00:21:20 +0200
Message-Id: <1331590880-3100-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit b2a29b578d9c21b2e5c88020f830d3c42115c51d sets accidentally supported
delivery systems as DVB-T/T2 whilst it should be DVB-S/S2. Due to that frontend
cannot be used at all.

Bug reported: Jiří Zelenka

Signed-off-by: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Reported-by: Jiří Zelenka <klacek@bubakov.net>
Cc: Jiří Zelenka <klacek@bubakov.net>
---
 drivers/media/dvb/frontends/tda10071.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10071.c b/drivers/media/dvb/frontends/tda10071.c
index a992050..c21bc92 100644
--- a/drivers/media/dvb/frontends/tda10071.c
+++ b/drivers/media/dvb/frontends/tda10071.c
@@ -1215,7 +1215,7 @@ error:
 EXPORT_SYMBOL(tda10071_attach);
 
 static struct dvb_frontend_ops tda10071_ops = {
-	.delsys = { SYS_DVBT, SYS_DVBT2 },
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
 		.name = "NXP TDA10071",
 		.frequency_min = 950000,
-- 
1.7.7.6

