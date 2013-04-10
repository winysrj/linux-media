Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45641 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3DJLmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 07:42:55 -0400
Date: Wed, 10 Apr 2013 14:40:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] radio-si476x: check different function pointers
Message-ID: <20130410114051.GA21419@longonot.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a static checker where it complains if we check for one function
pointer and then call a different function on the next line.

In most cases, the code does the same thing before and after this patch.
For example, when ->phase_diversity is non-NULL then ->phase_div_status
is also non-NULL.

The one place where that's not true is when we check ->rds_blckcnt
instead of ->rsq_status.  In those cases, we would want to call
->rsq_status but we instead return -ENOENT.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Please review this carefully.  I don't have the hardware to test it.

diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9430c6a..817fc0c 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -854,7 +854,7 @@ static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_SI476X_INTERCHIP_LINK:
 		if (si476x_core_has_diversity(radio->core)) {
-			if (radio->ops->phase_diversity) {
+			if (radio->ops->phase_div_status) {
 				retval = radio->ops->phase_div_status(radio->core);
 				if (retval < 0)
 					break;
@@ -1285,7 +1285,7 @@ static ssize_t si476x_radio_read_agc_blob(struct file *file,
 	struct si476x_agc_status_report report;
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
+	if (radio->ops->agc_status)
 		err = radio->ops->agc_status(radio->core, &report);
 	else
 		err = -ENOENT;
@@ -1320,7 +1320,7 @@ static ssize_t si476x_radio_read_rsq_blob(struct file *file,
 	};
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
+	if (radio->ops->rsq_status)
 		err = radio->ops->rsq_status(radio->core, &args, &report);
 	else
 		err = -ENOENT;
@@ -1355,7 +1355,7 @@ static ssize_t si476x_radio_read_rsq_primary_blob(struct file *file,
 	};
 
 	si476x_core_lock(radio->core);
-	if (radio->ops->rds_blckcnt)
+	if (radio->ops->rsq_status)
 		err = radio->ops->rsq_status(radio->core, &args, &report);
 	else
 		err = -ENOENT;
