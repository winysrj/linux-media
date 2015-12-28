Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58255 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbL1Qa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 11:30:29 -0500
Subject: [PATCH 1/2] [media] r820t: Delete an unnecessary variable
 initialisation in generic_set_freq()
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <56816256.70304@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56816395.6050707@users.sourceforge.net>
Date: Mon, 28 Dec 2015 17:30:13 +0100
MIME-Version: 1.0
In-Reply-To: <56816256.70304@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 16:36:44 +0100

The variable "rc" will be set to an appropriate value from a call of
the r820t_set_tv_standard() function.
Thus let us omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/r820t.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index a7a8452..6ab35e3 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1295,7 +1295,7 @@ static int generic_set_freq(struct dvb_frontend *fe,
 			    v4l2_std_id std, u32 delsys)
 {
 	struct r820t_priv		*priv = fe->tuner_priv;
-	int				rc = -EINVAL;
+	int				rc;
 	u32				lo_freq;
 
 	tuner_dbg("should set frequency to %d kHz, bw %d MHz\n",
-- 
2.6.3

