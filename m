Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54814 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934965AbeEIUII (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 16:08:08 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6-v6so480513wmc.4
        for <linux-media@vger.kernel.org>; Wed, 09 May 2018 13:08:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 1/4] [media] ddbridge/mci: protect against out-of-bounds array access in stop()
Date: Wed,  9 May 2018 22:08:00 +0200
Message-Id: <20180509200803.5253-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180509200803.5253-1-d.scheller.oss@gmail.com>
References: <20180509200803.5253-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In stop(), an (unlikely) out-of-bounds write error can occur when setting
the demod_in_use element indexed by state->demod to zero, as state->demod
isn't checked for being in the range of the array size of demod_in_use, and
state->demod maybe carrying the magic 0xff (demod unused) value. Prevent
this by checking state->demod not exceeding the array size before setting
the element value. To make the code a bit easier to read, replace the magic
value and the number of array elements with defines, and use them at a few
more places.

Detected by CoverityScan, CID#1468550 ("Out-of-bounds write")

Thanks to Colin for reporting the problem and providing an initial patch.

Fixes: daeeb1319e6f ("media: ddbridge: initial support for MCI-based MaxSX8 cards")
Reported-by: Colin Ian King <colin.king@canonical.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 21 +++++++++++----------
 drivers/media/pci/ddbridge/ddbridge-mci.h |  4 ++++
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index a85ff3e6b919..8d9592e75ad5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -38,10 +38,10 @@ struct mci_base {
 	struct mutex         mci_lock; /* concurrent MCI access lock */
 	int                  count;
 
-	u8                   tuner_use_count[4];
-	u8                   assigned_demod[8];
-	u32                  used_ldpc_bitrate[8];
-	u8                   demod_in_use[8];
+	u8                   tuner_use_count[MCI_TUNER_MAX];
+	u8                   assigned_demod[MCI_DEMOD_MAX];
+	u32                  used_ldpc_bitrate[MCI_DEMOD_MAX];
+	u8                   demod_in_use[MCI_DEMOD_MAX];
 	u32                  iq_mode;
 };
 
@@ -193,7 +193,7 @@ static int stop(struct dvb_frontend *fe)
 	u32 input = state->tuner;
 
 	memset(&cmd, 0, sizeof(cmd));
-	if (state->demod != 0xff) {
+	if (state->demod != DEMOD_UNUSED) {
 		cmd.command = MCI_CMD_STOP;
 		cmd.demod = state->demod;
 		mci_cmd(state, &cmd, NULL);
@@ -209,10 +209,11 @@ static int stop(struct dvb_frontend *fe)
 	state->base->tuner_use_count[input]--;
 	if (!state->base->tuner_use_count[input])
 		mci_set_tuner(fe, input, 0);
-	state->base->demod_in_use[state->demod] = 0;
+	if (state->demod < MCI_DEMOD_MAX)
+		state->base->demod_in_use[state->demod] = 0;
 	state->base->used_ldpc_bitrate[state->nr] = 0;
-	state->demod = 0xff;
-	state->base->assigned_demod[state->nr] = 0xff;
+	state->demod = DEMOD_UNUSED;
+	state->base->assigned_demod[state->nr] = DEMOD_UNUSED;
 	state->base->iq_mode = 0;
 	mutex_unlock(&state->base->tuner_lock);
 	state->started = 0;
@@ -250,7 +251,7 @@ static int start(struct dvb_frontend *fe, u32 flags, u32 modmask, u32 ts_config)
 		stat = -EBUSY;
 		goto unlock;
 	}
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < MCI_DEMOD_MAX; i++) {
 		used_ldpc_bitrate += state->base->used_ldpc_bitrate[i];
 		if (state->base->demod_in_use[i])
 			used_demods++;
@@ -342,7 +343,7 @@ static int start_iq(struct dvb_frontend *fe, u32 ts_config)
 		stat = -EBUSY;
 		goto unlock;
 	}
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < MCI_DEMOD_MAX; i++)
 		if (state->base->demod_in_use[i])
 			used_demods++;
 	if (used_demods > 0) {
diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.h b/drivers/media/pci/ddbridge/ddbridge-mci.h
index c4193c5ee095..453dcb9f8208 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.h
@@ -19,6 +19,10 @@
 #ifndef _DDBRIDGE_MCI_H_
 #define _DDBRIDGE_MCI_H_
 
+#define MCI_DEMOD_MAX                       8
+#define MCI_TUNER_MAX                       4
+#define DEMOD_UNUSED                        (0xFF)
+
 #define MCI_CONTROL                         (0x500)
 #define MCI_COMMAND                         (0x600)
 #define MCI_RESULT                          (0x680)
-- 
2.16.1
