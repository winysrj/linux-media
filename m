Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35665 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755282AbdGWOpN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 10:45:13 -0400
Received: by mail-wm0-f67.google.com with SMTP id m75so5923097wmb.2
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 07:45:13 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, aospan@netup.ru, serjk@netup.ru
Cc: mchehab@kernel.org
Subject: [PATCH] [media] dvb-frontends/cxd2841er: update moddesc wrt new chip support
Date: Sun, 23 Jul 2017 16:45:09 +0200
Message-Id: <20170723144509.508-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since the driver now recognizes and supports more chip variants, reflect
this fact in the module description accordingly.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 0ab1fc845927..48ee9bc00c06 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -3999,6 +3999,6 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
 	.get_frontend_algo = cxd2841er_get_algo
 };
 
-MODULE_DESCRIPTION("Sony CXD2841ER/CXD2854ER DVB-C/C2/T/T2/S/S2 demodulator driver");
+MODULE_DESCRIPTION("Sony CXD2837/38/41/43/54ER DVB-C/C2/T/T2/S/S2 demodulator driver");
 MODULE_AUTHOR("Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>");
 MODULE_LICENSE("GPL");
-- 
2.13.0
