Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:45409 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935335AbdLRRPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 12:15:09 -0500
Received: by mail-pf0-f195.google.com with SMTP id u19so9915624pfa.12
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 09:15:09 -0800 (PST)
From: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends: remove self assignments
Date: Mon, 18 Dec 2017 09:14:50 -0800
Message-Id: <20171218171454.139245-1-ndesaulniers@google.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These were leftover from:
commit 469ffe083665 ("[media] tda18271c2dd: Remove the CHK_ERROR macro")
and
commit 58d5eaec9f87 ("[media] drxd: Don't use a macro for CHK_ERROR ...")
that programmatically removed the CHK_ERROR macro, which left behind a
few self assignments that Clang warns about.  These instances aren't
errors.

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/media/dvb-frontends/drxd_hard.c    | 3 ---
 drivers/media/dvb-frontends/tda18271c2dd.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 0696bc62dcc9..ff18a0f7dc41 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2140,7 +2140,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			}
 			break;
 		}
-		status = status;
 		if (status < 0)
 			break;
 
@@ -2251,7 +2250,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			break;
 
 		}
-		status = status;
 		if (status < 0)
 			break;
 
@@ -2318,7 +2316,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
 			}
 			break;
 		}
-		status = status;
 		if (status < 0)
 			break;
 
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index 2d2778be2d2f..45cd5ba0cf8a 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -674,7 +674,6 @@ static int PowerScan(struct tda_state *state,
 			Count = 200000;
 			wait = true;
 		}
-		status = status;
 		if (status < 0)
 			break;
 		if (CID_Gain >= CID_Target) {
-- 
2.15.1.504.g5279b80103-goog
