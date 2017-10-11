Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37560 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757449AbdJKRwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 13:52:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH] media: dvb: do some coding style cleanup
Date: Wed, 11 Oct 2017 13:52:16 -0400
Message-Id: <01153bf04db18d5fcd30df64ffe428db7ff7bada.1507744325.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a bunch of coding style issues found by checkpatch on the
part of the code that the previous patches touched.

WARNING: please, no space before tabs
+ * ^I^Icallback.$

ERROR: space required before the open parenthesis '('
+	switch(cmd) {

WARNING: line over 80 characters
+			err = dtv_property_process_get(fe, &getp, tvp + i, file);

WARNING: line over 80 characters
+			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);

ERROR: "(foo*)" should be "(foo *)"
+			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);

WARNING: line over 80 characters
+				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.h    |  2 +-
 drivers/media/dvb-core/dvb_frontend.c | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index 9a77be02cbb1..cc048f09aa85 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -101,7 +101,7 @@ struct dvb_demux_filter {
  * @cb:		digital TV callbacks. depending on the feed type, it can be:
  *		if the feed is TS, it contains a dmx_ts_cb() @ts callback;
  *		if the feed is section, it contains a dmx_section_cb() @sec
- * 		callback.
+ *		callback.
  *
  * @demux:	pointer to &struct dvb_demux.
  * @priv:	private data that can optionally be used by a DVB driver.
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 30c7357e980b..0c7897379535 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2096,7 +2096,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	switch(cmd) {
+	switch (cmd) {
 	case FE_SET_PROPERTY: {
 		struct dtv_properties *tvps = parg;
 		struct dtv_property *tvp = NULL;
@@ -2164,7 +2164,8 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 			}
 		}
 		for (i = 0; i < tvps->num; i++) {
-			err = dtv_property_process_get(fe, &getp, tvp + i, file);
+			err = dtv_property_process_get(fe, &getp,
+						       tvp + i, file);
 			if (err < 0) {
 				kfree(tvp);
 				return err;
@@ -2296,7 +2297,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 
 	case FE_DISEQC_RECV_SLAVE_REPLY:
 		if (fe->ops.diseqc_recv_slave_reply)
-			err = fe->ops.diseqc_recv_slave_reply(fe, (struct dvb_diseqc_slave_reply*) parg);
+			err = fe->ops.diseqc_recv_slave_reply(fe, parg);
 		break;
 
 	case FE_ENABLE_HIGH_LNB_VOLTAGE:
@@ -2381,7 +2382,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	case FE_READ_BER:
 		if (fe->ops.read_ber) {
 			if (fepriv->thread)
-				err = fe->ops.read_ber(fe, (__u32 *) parg);
+				err = fe->ops.read_ber(fe, parg);
 			else
 				err = -EAGAIN;
 		}
@@ -2390,7 +2391,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	case FE_READ_SIGNAL_STRENGTH:
 		if (fe->ops.read_signal_strength) {
 			if (fepriv->thread)
-				err = fe->ops.read_signal_strength(fe, (__u16 *) parg);
+				err = fe->ops.read_signal_strength(fe, parg);
 			else
 				err = -EAGAIN;
 		}
@@ -2399,7 +2400,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	case FE_READ_SNR:
 		if (fe->ops.read_snr) {
 			if (fepriv->thread)
-				err = fe->ops.read_snr(fe, (__u16 *) parg);
+				err = fe->ops.read_snr(fe, parg);
 			else
 				err = -EAGAIN;
 		}
@@ -2408,7 +2409,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 	case FE_READ_UNCORRECTED_BLOCKS:
 		if (fe->ops.read_ucblocks) {
 			if (fepriv->thread)
-				err = fe->ops.read_ucblocks(fe, (__u32 *) parg);
+				err = fe->ops.read_ucblocks(fe, parg);
 			else
 				err = -EAGAIN;
 		}
-- 
2.13.6
