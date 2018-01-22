Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39434 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeAVRNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 12:13:54 -0500
Received: by mail-wm0-f68.google.com with SMTP id b21so18319539wme.4
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 09:13:54 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v2 3/5] media: dvb-frontends/stv0910: report FEC 1/4 and 1/3 in get_frontend()
Date: Mon, 22 Jan 2018 18:13:44 +0100
Message-Id: <20180122171346.822-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180122171346.822-1-d.scheller.oss@gmail.com>
References: <20180122171346.822-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The first two missing FECs in the modcod2fec fe_code_rate table were 1/4
and 1/3. Add them as they're now defined by the API.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index a2f7c0c1587f..de132a85e537 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1562,7 +1562,7 @@ static int get_frontend(struct dvb_frontend *fe,
 			APSK_32,
 		};
 		const enum fe_code_rate modcod2fec[0x20] = {
-			FEC_NONE, FEC_NONE, FEC_NONE, FEC_2_5,
+			FEC_NONE, FEC_1_4, FEC_1_3, FEC_2_5,
 			FEC_1_2, FEC_3_5, FEC_2_3, FEC_3_4,
 			FEC_4_5, FEC_5_6, FEC_8_9, FEC_9_10,
 			FEC_3_5, FEC_2_3, FEC_3_4, FEC_5_6,
-- 
2.13.6
