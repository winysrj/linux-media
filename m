Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56946 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbaKDBHQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Bimow Chen <Bimow.Chen@ite.com.tw>
Subject: [PATCH 6/6] af9033: continue polling unless critical IO error
Date: Tue,  4 Nov 2014 03:07:04 +0200
Message-Id: <1415063224-28453-6-git-send-email-crope@iki.fi>
In-Reply-To: <1415063224-28453-1-git-send-email-crope@iki.fi>
References: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That case is not IO error, so better to jump out now, but still
continue polling.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index e640701..c17e34f 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -1103,7 +1103,7 @@ static void af9033_stat_work(struct work_struct *work)
 			snr_val *= 2;
 			break;
 		default:
-			goto err;
+			goto err_schedule_delayed_work;
 		}
 
 		/* read current modulation */
-- 
http://palosaari.fi/

