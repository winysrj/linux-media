Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44451 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbeFXNmy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Jun 2018 09:42:54 -0400
Received: by mail-wr0-f196.google.com with SMTP id p12-v6so9340701wrn.11
        for <linux-media@vger.kernel.org>; Sun, 24 Jun 2018 06:42:53 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends/tda18271c2dd: silence sparse fall through warning
Date: Sun, 24 Jun 2018 15:42:50 +0200
Message-Id: <20180624134250.8321-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add a break statement in set_params() for the SYS_DVBT(2) case to silence
this sparse warning:

    drivers/media/dvb-frontends/tda18271c2dd.c:1144:3: warning: this statement may fall through [-Wimplicit-fallthrough=]

as reported in Hans' daily media_tree builds.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/tda18271c2dd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index 2e1d36ae943b..fcffc7b4acf7 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -1154,6 +1154,7 @@ static int set_params(struct dvb_frontend *fe)
 		default:
 			return -EINVAL;
 		}
+		break;
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
 		if (bw <= 6000000)
-- 
2.16.4
