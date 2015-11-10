Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbbKJWXM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 17:23:12 -0500
Date: Wed, 11 Nov 2015 01:22:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch 1/2] [media] av7110: don't allow negative volumes
Message-ID: <20151110222249.GD30281@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The issue here is that we there is a static checker warning because we
have a user controlled volume setting and we cap the upper bound but we
allow negative numbers.  Negative volumes don't make sense, so let's
make these variables unsigned.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/ttpci/av7110_av.h b/drivers/media/pci/ttpci/av7110_av.h
index 5f02ef8..f52276f 100644
--- a/drivers/media/pci/ttpci/av7110_av.h
+++ b/drivers/media/pci/ttpci/av7110_av.h
@@ -10,7 +10,8 @@ extern int av7110_record_cb(struct dvb_filter_pes2ts *p2t, u8 *buf, size_t len);
 extern int av7110_pes_play(void *dest, struct dvb_ringbuffer *buf, int dlen);
 extern int av7110_write_to_decoder(struct dvb_demux_feed *feed, const u8 *buf, size_t len);
 
-extern int av7110_set_volume(struct av7110 *av7110, int volleft, int volright);
+extern int av7110_set_volume(struct av7110 *av7110, unsigned int volleft,
+			     unsigned int volright);
 extern int av7110_av_stop(struct av7110 *av7110, int av);
 extern int av7110_av_start_record(struct av7110 *av7110, int av,
 			  struct dvb_demux_feed *dvbdmxfeed);
diff --git a/drivers/media/pci/ttpci/av7110_av.c b/drivers/media/pci/ttpci/av7110_av.c
index 9ed1ec7..ccb3b2c 100644
--- a/drivers/media/pci/ttpci/av7110_av.c
+++ b/drivers/media/pci/ttpci/av7110_av.c
@@ -280,9 +280,11 @@ int av7110_pes_play(void *dest, struct dvb_ringbuffer *buf, int dlen)
 }
 
 
-int av7110_set_volume(struct av7110 *av7110, int volleft, int volright)
+int av7110_set_volume(struct av7110 *av7110, unsigned int volleft,
+		      unsigned int volright)
 {
-	int err, vol, val, balance = 0;
+	unsigned int vol, val, balance = 0;
+	int err;
 
 	dprintk(2, "av7110:%p, \n", av7110);
 
