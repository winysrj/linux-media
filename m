Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:29904 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1KWGqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Nov 2011 01:46:11 -0500
Date: Wed, 23 Nov 2011 09:45:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] radio: NUL terminate a user string
Message-ID: <20111123064539.GC6871@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We pass this to fm_tx_set_radio_text() which expects a NUL terminated
string.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 4f5c43d..077d369 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -84,6 +84,7 @@ static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
 	struct fmdev *fmdev;
 
 	ret = copy_from_user(&rds, buf, sizeof(rds));
+	rds.text[sizeof(rds.text) - 1] = '\0';
 	fmdbg("(%d)type: %d, text %s, af %d\n",
 		   ret, rds.text_type, rds.text, rds.af_freq);
 	if (ret)
