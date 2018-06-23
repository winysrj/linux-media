Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34537 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbeFWPgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:20 -0400
Received: by mail-wm0-f65.google.com with SMTP id l15-v6so8645518wmc.1
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:20 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 01/19] [media] dvb-frontends/mxl5xx: add break to case DVBS2 in get_frontend()
Date: Sat, 23 Jun 2018 17:35:57 +0200
Message-Id: <20180623153615.27630-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fix one sparse warning:

    drivers/media/dvb-frontends/mxl5xx.c:731:3: warning: this statement may fall through [-Wimplicit-fallthrough=]

as seen in Hans' daily media_tree builds.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/mxl5xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 274d8fca0763..a7d08ace11ba 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -739,6 +739,7 @@ static int get_frontend(struct dvb_frontend *fe,
 		default:
 			break;
 		}
+		break;
 	case SYS_DVBS:
 		switch ((enum MXL_HYDRA_MODULATION_E)
 			reg_data[DMD_MODULATION_SCHEME_ADDR]) {
-- 
2.16.4
