Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35636 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbZKRTDM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 14:03:12 -0500
Date: Wed, 18 Nov 2009 20:03:03 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/6] firedtv: remove check for interrupting signal
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.9de6666bf8c2cf11@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FCP transactions as well as CMP transactions were serialized with
mutex_lock_interruptible.  It is extremely unlikly though that a signal
will arrive while a concurrent process holds the mutex.  And even if one
does, the duration of a transaction is reasonably short (1.2 seconds if
all retries time out, usually much shorter).

Hence simplify the code to plain mutex_lock.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-avc.c |   51 ++++++++---------------
 1 file changed, 17 insertions(+), 34 deletions(-)

Index: linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux-2.6.32-rc7.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux-2.6.32-rc7/drivers/media/dvb/firewire/firedtv-avc.c
@@ -542,8 +542,7 @@ int avc_tuner_dsd(struct firedtv *fdtv,
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -584,8 +583,7 @@ int avc_tuner_set_pids(struct firedtv *f
 	if (pidc > 16 && pidc != 0xff)
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -629,8 +627,7 @@ int avc_tuner_get_ts(struct firedtv *fdt
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret, sl;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -670,8 +667,7 @@ int avc_identify_subunit(struct firedtv 
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -712,8 +708,7 @@ int avc_tuner_status(struct firedtv *fdt
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int length, ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -795,8 +790,7 @@ int avc_lnb_control(struct firedtv *fdtv
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int i, j, k, ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -844,8 +838,7 @@ int avc_register_remote_control(struct f
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -883,8 +876,7 @@ int avc_tuner_host2ca(struct firedtv *fd
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -943,8 +935,7 @@ int avc_ca_app_info(struct firedtv *fdtv
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int pos, ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -986,8 +977,7 @@ int avc_ca_info(struct firedtv *fdtv, ch
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int pos, ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1028,8 +1018,7 @@ int avc_ca_reset(struct firedtv *fdtv)
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1073,8 +1062,7 @@ int avc_ca_pmt(struct firedtv *fdtv, cha
 	if (unlikely(avc_debug & AVC_DEBUG_APPLICATION_PMT))
 		debug_pmt(msg, length);
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1196,8 +1184,7 @@ int avc_ca_get_time_date(struct firedtv 
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1233,8 +1220,7 @@ int avc_ca_enter_menu(struct firedtv *fd
 	struct avc_command_frame *c = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1267,8 +1253,7 @@ int avc_ca_get_mmi(struct firedtv *fdtv,
 	struct avc_response_frame *r = (void *)fdtv->avc_data;
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	memset(c, 0, sizeof(*c));
 
@@ -1306,8 +1291,7 @@ static int cmp_read(struct firedtv *fdtv
 {
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	ret = fdtv->backend->read(fdtv, addr, data);
 	if (ret < 0)
@@ -1322,8 +1306,7 @@ static int cmp_lock(struct firedtv *fdtv
 {
 	int ret;
 
-	if (mutex_lock_interruptible(&fdtv->avc_mutex))
-		return -EINTR;
+	mutex_lock(&fdtv->avc_mutex);
 
 	/* data[] is stack-allocated and should not be DMA-mapped. */
 	memcpy(fdtv->avc_data, data, 8);

-- 
Stefan Richter
-=====-==--= =-== =--=-
http://arcgraph.de/sr/

