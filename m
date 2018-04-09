Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46411 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753198AbeDIQr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:47:58 -0400
Received: by mail-wr0-f194.google.com with SMTP id d1so10239197wrj.13
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:47:58 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 02/19] [media] dvb-frontends/stv0910: fix CNR reporting in read_snr()
Date: Mon,  9 Apr 2018 18:47:35 +0200
Message-Id: <20180409164752.641-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The CNR value determined in read_snr() is reported via the wrong variable.
It uses FE_SCALE_DECIBEL, which implies the value to be reported in svalue
instead of uvalue. Fix this accordingly.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index f5b5ce971c0c..1d96ae9f9f6e 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1326,7 +1326,7 @@ static int read_snr(struct dvb_frontend *fe)
 
 	if (!get_signal_to_noise(state, &snrval)) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		p->cnr.stat[0].uvalue = 100 * snrval; /* fix scale */
+		p->cnr.stat[0].svalue = 100 * snrval; /* fix scale */
 	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
-- 
2.16.1
