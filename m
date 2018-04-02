Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54309 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753252AbeDBSYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:34 -0400
Received: by mail-wm0-f65.google.com with SMTP id h76so27540829wme.4
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:34 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 03/20] [media] dvb-frontends/stv0910: fix CNR reporting in read_snr()
Date: Mon,  2 Apr 2018 20:24:10 +0200
Message-Id: <20180402182427.20918-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
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
index 0d6130f97c36..e3d939933d6e 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1324,7 +1324,7 @@ static int read_snr(struct dvb_frontend *fe)
 
 	if (!get_signal_to_noise(state, &snrval)) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		p->cnr.stat[0].uvalue = 100 * snrval; /* fix scale */
+		p->cnr.stat[0].svalue = 100 * snrval; /* fix scale */
 	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
-- 
2.16.1
