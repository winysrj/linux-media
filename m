Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43672 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdLUUXe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 15:23:34 -0500
Received: by mail-wr0-f196.google.com with SMTP id w68so13738366wrc.10
        for <linux-media@vger.kernel.org>; Thu, 21 Dec 2017 12:23:33 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de
Subject: [PATCH 2/2] media: dvb-frontends/stv0910: report FEC 1/4 and 1/3 in get_frontend()
Date: Thu, 21 Dec 2017 21:23:21 +0100
Message-Id: <20171221202321.30539-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171221202321.30539-1-d.scheller.oss@gmail.com>
References: <20171221202321.30539-1-d.scheller.oss@gmail.com>
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
index a8c99f41478b..7cf90d435083 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1551,7 +1551,7 @@ static int get_frontend(struct dvb_frontend *fe,
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
