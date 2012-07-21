Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26246 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2GUIdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 04:33:21 -0400
Date: Sat, 21 Jul 2012 11:32:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	Miroslav Slugen <thunder.mmm@gmail.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] tuner-xc2028: fix "=" vs "==" typo
Message-ID: <20120721083238.GA13454@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We intended to do a compare here, not an assignment.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static analysis bug.  I don't own the hardware.

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index f88f948..9e60285 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -756,7 +756,7 @@ retry:
 	 * No need to reload base firmware if it matches and if the tuner
 	 * is not at sleep mode
 	 */
-	if ((priv->state = XC2028_ACTIVE) &&
+	if ((priv->state == XC2028_ACTIVE) &&
 	    (((BASE | new_fw.type) & BASE_TYPES) ==
 	    (priv->cur_fw.type & BASE_TYPES))) {
 		tuner_dbg("BASE firmware not changed.\n");
