Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60041 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdK2TIp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 05/22] media: radio-si476x: fix kernel-doc markups
Date: Wed, 29 Nov 2017 14:08:23 -0500
Message-Id: <13881be98ff363226541216b5f568a71af548616.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

get rid of the following warnings:
  drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'v4l2dev'
  drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'ctrl_handler'
  drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'debugfs'
  drivers/media/radio/radio-si476x.c:317: warning: No description found for parameter 'audmode'
  drivers/media/radio/radio-si476x.c:317: warning: Excess struct member 'kref' description in 'si476x_radio'
  drivers/media/radio/radio-si476x.c:317: warning: Excess struct member 'core_lock' description in 'si476x_radio'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/radio/radio-si476x.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 271f725b17e8..540ac887a63c 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -158,7 +158,7 @@ enum si476x_ctrl_idx {
 };
 static struct v4l2_ctrl_config si476x_ctrls[] = {
 
-	/**
+	/*
 	 * SI476X during its station seeking(or tuning) process uses several
 	 * parameters to detrmine if "the station" is valid:
 	 *
@@ -197,7 +197,7 @@ static struct v4l2_ctrl_config si476x_ctrls[] = {
 		.step	= 2,
 	},
 
-	/**
+	/*
 	 * #V4L2_CID_SI476X_HARMONICS_COUNT -- number of harmonics
 	 * built-in power-line noise supression filter is to reject
 	 * during AM-mode operation.
@@ -213,7 +213,7 @@ static struct v4l2_ctrl_config si476x_ctrls[] = {
 		.step	= 1,
 	},
 
-	/**
+	/*
 	 * #V4L2_CID_SI476X_DIVERSITY_MODE -- configuration which
 	 * two tuners working in diversity mode are to work in.
 	 *
@@ -237,7 +237,7 @@ static struct v4l2_ctrl_config si476x_ctrls[] = {
 		.max	= ARRAY_SIZE(phase_diversity_modes) - 1,
 	},
 
-	/**
+	/*
 	 * #V4L2_CID_SI476X_INTERCHIP_LINK -- inter-chip link in
 	 * diversity mode indicator. Allows user to determine if two
 	 * chips working in diversity mode have established a link
@@ -296,11 +296,15 @@ struct si476x_radio_ops {
 /**
  * struct si476x_radio - radio device
  *
- * @core: Pointer to underlying core device
+ * @v4l2dev: Pointer to V4L2 device created by V4L2 subsystem
  * @videodev: Pointer to video device created by V4L2 subsystem
+ * @ctrl_handler: V4L2 controls handler
+ * @core: Pointer to underlying core device
  * @ops: Vtable of functions. See struct si476x_radio_ops for details
- * @kref: Reference counter
- * @core_lock: An r/w semaphore to brebvent the deletion of underlying
+ * @debugfs: pointer to &strucd dentry for debugfs
+ * @audmode: audio mode, as defined for the rxsubchans field
+ *	     at videodev2.h
+ *
  * core structure is the radio device is being used
  */
 struct si476x_radio {
-- 
2.14.3
