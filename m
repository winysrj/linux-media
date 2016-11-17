Return-path: <linux-media-owner@vger.kernel.org>
Received: from arcturus.kleine-koenig.org ([78.47.169.190]:48717 "EHLO
        arcturus.kleine-koenig.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751648AbcKQUEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Nov 2016 15:04:39 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Derek <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH] dvb: gp8psk: specify license using MODULE_LICENSE
Date: Thu, 17 Nov 2016 20:57:36 +0100
Message-Id: <20161117195736.11990-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes
	WARNING: modpost: missing MODULE_LICENSE() in drivers/media/dvb-frontends/gp8psk-fe.o
	see include/linux/module.h for more information

Fixes: 7a0786c19d65 ("gp8psk: Fix DVB frontend attach")
Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 drivers/media/dvb-frontends/gp8psk-fe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-frontends/gp8psk-fe.c b/drivers/media/dvb-frontends/gp8psk-fe.c
index be19afeed7a9..87554bcbeaeb 100644
--- a/drivers/media/dvb-frontends/gp8psk-fe.c
+++ b/drivers/media/dvb-frontends/gp8psk-fe.c
@@ -395,3 +395,5 @@ static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.dishnetwork_send_legacy_command = gp8psk_fe_send_legacy_dish_cmd,
 	.enable_high_lnb_voltage = gp8psk_fe_enable_high_lnb_voltage
 };
+
+MODULE_LICENSE("GPL v2");
-- 
2.10.2

