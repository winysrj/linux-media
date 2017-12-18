Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45228 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936376AbdLRRc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 12:32:29 -0500
Received: by mail-it0-f66.google.com with SMTP id z6so29140065iti.4
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 09:32:29 -0800 (PST)
From: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin Ian King <colin.king@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Daniel Scheller <d.scheller@gmx.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb-frontends: remove extraneous parens
Date: Mon, 18 Dec 2017 09:31:52 -0800
Message-Id: <20171218173156.166041-1-ndesaulniers@google.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes 2 warnings from Clang about extra parentheses in a conditional,
that might have been meant as assignment.

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 2 +-
 drivers/media/dvb-frontends/drxk_hard.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 8cbd8cc21059..cf00a34ef0fc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -11074,7 +11074,7 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 		}
 	}
 
-	if ((*mode == DRX_POWER_UP)) {
+	if (*mode == DRX_POWER_UP) {
 		/* Restore analog & pin configuration */
 
 		/* Initialize default AFE configuration for VSB */
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index f59ac2e91c59..19cc84c69b3b 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6062,7 +6062,7 @@ static int init_drxk(struct drxk_state *state)
 	u16 driver_version;
 
 	dprintk(1, "\n");
-	if ((state->m_drxk_state == DRXK_UNINITIALIZED)) {
+	if (state->m_drxk_state == DRXK_UNINITIALIZED) {
 		drxk_i2c_lock(state);
 		status = power_up_device(state);
 		if (status < 0)
-- 
2.15.1.504.g5279b80103-goog
