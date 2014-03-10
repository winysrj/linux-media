Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/15] drx-j: Don't use "state" for DVB lock state
Date: Mon, 10 Mar 2014 08:59:02 -0300
Message-Id: <1394452747-5426-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

State is already used on other places for the state struct.
Don't use it here, to avoid troubles with latter patches.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a36cfa684153..7022a69f56bd 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -8861,7 +8861,7 @@ qam64auto(struct drx_demod_instance *demod,
 	struct drx_sig_quality sig_quality;
 	struct drxj_data *ext_attr = NULL;
 	int rc;
-	u32 state = NO_LOCK;
+	u32 lck_state = NO_LOCK;
 	u32 start_time = 0;
 	u32 d_locked_time = 0;
 	u32 timeout_ofs = 0;
@@ -8871,7 +8871,7 @@ qam64auto(struct drx_demod_instance *demod,
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
-	state = NO_LOCK;
+	lck_state = NO_LOCK;
 	do {
 		rc = ctrl_lock_status(demod, lock_status);
 		if (rc != 0) {
@@ -8879,7 +8879,7 @@ qam64auto(struct drx_demod_instance *demod,
 			goto rw_error;
 		}
 
-		switch (state) {
+		switch (lck_state) {
 		case NO_LOCK:
 			if (*lock_status == DRXJ_DEMOD_LOCK) {
 				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
@@ -8888,7 +8888,7 @@ qam64auto(struct drx_demod_instance *demod,
 					goto rw_error;
 				}
 				if (sig_quality.MER > 208) {
-					state = DEMOD_LOCKED;
+					lck_state = DEMOD_LOCKED;
 					/* some delay to see if fec_lock possible TODO find the right value */
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, waiting longer */
 					d_locked_time = jiffies_to_msecs(jiffies);
@@ -8909,7 +8909,7 @@ qam64auto(struct drx_demod_instance *demod,
 					pr_err("error %d\n", rc);
 					goto rw_error;
 				}
-				state = SYNC_FLIPPED;
+				lck_state = SYNC_FLIPPED;
 				msleep(10);
 			}
 			break;
@@ -8934,7 +8934,7 @@ qam64auto(struct drx_demod_instance *demod,
 						pr_err("error %d\n", rc);
 						goto rw_error;
 					}
-					state = SPEC_MIRRORED;
+					lck_state = SPEC_MIRRORED;
 					/* reset timer TODO: still need 500ms? */
 					start_time = d_locked_time =
 					    jiffies_to_msecs(jiffies);
@@ -9008,7 +9008,7 @@ qam256auto(struct drx_demod_instance *demod,
 	struct drx_sig_quality sig_quality;
 	struct drxj_data *ext_attr = NULL;
 	int rc;
-	u32 state = NO_LOCK;
+	u32 lck_state = NO_LOCK;
 	u32 start_time = 0;
 	u32 d_locked_time = 0;
 	u32 timeout_ofs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
@@ -9017,14 +9017,14 @@ qam256auto(struct drx_demod_instance *demod,
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	*lock_status = DRX_NOT_LOCKED;
 	start_time = jiffies_to_msecs(jiffies);
-	state = NO_LOCK;
+	lck_state = NO_LOCK;
 	do {
 		rc = ctrl_lock_status(demod, lock_status);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
 			goto rw_error;
 		}
-		switch (state) {
+		switch (lck_state) {
 		case NO_LOCK:
 			if (*lock_status == DRXJ_DEMOD_LOCK) {
 				rc = ctrl_get_qam_sig_quality(demod, &sig_quality);
@@ -9033,7 +9033,7 @@ qam256auto(struct drx_demod_instance *demod,
 					goto rw_error;
 				}
 				if (sig_quality.MER > 268) {
-					state = DEMOD_LOCKED;
+					lck_state = DEMOD_LOCKED;
 					timeout_ofs += DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;	/* see something, wait longer */
 					d_locked_time = jiffies_to_msecs(jiffies);
 				}
@@ -9050,7 +9050,7 @@ qam256auto(struct drx_demod_instance *demod,
 						pr_err("error %d\n", rc);
 						goto rw_error;
 					}
-					state = SPEC_MIRRORED;
+					lck_state = SPEC_MIRRORED;
 					/* reset timer TODO: still need 300ms? */
 					start_time = jiffies_to_msecs(jiffies);
 					timeout_ofs = -DRXJ_QAM_MAX_WAITTIME / 2;
-- 
1.8.5.3

