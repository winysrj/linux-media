Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752786AbeEGXIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 19:08:44 -0400
From: Colin King <colin.king@canonical.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][media-next] media: ddbridge: avoid out-of-bounds write on array demod_in_use
Date: Tue,  8 May 2018 00:08:42 +0100
Message-Id: <20180507230842.28409-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

In function stop there is a check to see if state->demod is a stopped
value of 0xff, however, later on, array demod_in_use is indexed with
this value causing an out-of-bounds write error.  Avoid this by only
writing to array demod_in_use if state->demod is not set to the stopped
sentinal value for this specific corner case.  Also, replace the magic
value 0xff with DEMOD_STOPPED to make code more readable.

Detected by CoverityScan, CID#1468550 ("Out-of-bounds write")

Fixes: daeeb1319e6f ("media: ddbridge: initial support for MCI-based MaxSX8 cards")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/ddbridge/ddbridge-mci.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-mci.c b/drivers/media/pci/ddbridge/ddbridge-mci.c
index a85ff3e6b919..1f5ed53c8d35 100644
--- a/drivers/media/pci/ddbridge/ddbridge-mci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-mci.c
@@ -20,6 +20,8 @@
 #include "ddbridge-io.h"
 #include "ddbridge-mci.h"
 
+#define DEMOD_STOPPED	(0xff)
+
 static LIST_HEAD(mci_list);
 
 static const u32 MCLK = (1550000000 / 12);
@@ -193,7 +195,7 @@ static int stop(struct dvb_frontend *fe)
 	u32 input = state->tuner;
 
 	memset(&cmd, 0, sizeof(cmd));
-	if (state->demod != 0xff) {
+	if (state->demod != DEMOD_STOPPED) {
 		cmd.command = MCI_CMD_STOP;
 		cmd.demod = state->demod;
 		mci_cmd(state, &cmd, NULL);
@@ -209,10 +211,11 @@ static int stop(struct dvb_frontend *fe)
 	state->base->tuner_use_count[input]--;
 	if (!state->base->tuner_use_count[input])
 		mci_set_tuner(fe, input, 0);
-	state->base->demod_in_use[state->demod] = 0;
+	if (state->demod != DEMOD_STOPPED)
+		state->base->demod_in_use[state->demod] = 0;
 	state->base->used_ldpc_bitrate[state->nr] = 0;
-	state->demod = 0xff;
-	state->base->assigned_demod[state->nr] = 0xff;
+	state->demod = DEMOD_STOPPED;
+	state->base->assigned_demod[state->nr] = DEMOD_STOPPED;
 	state->base->iq_mode = 0;
 	mutex_unlock(&state->base->tuner_lock);
 	state->started = 0;
-- 
2.17.0
