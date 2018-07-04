Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753046AbeGDJs6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 05:48:58 -0400
Date: Wed, 4 Jul 2018 12:48:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Jasmin Jessich <jasmin@anw.at>, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] media: dvb_ca_en50221: off by one in
 dvb_ca_en50221_io_do_ioctl()
Message-ID: <20180704094835.vzfqt44sqaga6aia@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The > should be >= so we don't read one element beyond the end of the
ca->slot_info[] array.  The array is allocated in dvb_ca_en50221_init().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 1310526b0d49..4d371cea0d5d 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1391,7 +1391,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 		struct dvb_ca_slot *sl;
 
 		slot = info->num;
-		if ((slot > ca->slot_count) || (slot < 0)) {
+		if ((slot >= ca->slot_count) || (slot < 0)) {
 			err = -EINVAL;
 			goto out_unlock;
 		}
