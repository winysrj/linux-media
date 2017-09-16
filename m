Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56215 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdIPQTp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 12:19:45 -0400
Subject: [PATCH 2/2] [media] fc0012: Improve a size determination in
 fc0012_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <8f64b84d-cca0-d618-eb62-ec12f42b8c06@users.sourceforge.net>
Message-ID: <27e2548c-09cb-2adb-9f65-f06c0e4ba86d@users.sourceforge.net>
Date: Sat, 16 Sep 2017 18:19:34 +0200
MIME-Version: 1.0
In-Reply-To: <8f64b84d-cca0-d618-eb62-ec12f42b8c06@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 16 Sep 2017 17:55:27 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/fc0012.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index 7126dd1d5151..c008513bd64a 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -445,5 +445,5 @@ struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-	priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-- 
2.14.1
