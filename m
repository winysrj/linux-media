Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab1L3PJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCHv2 90/94] cx23885-dvb: Remove a dirty hack that would require DVBv3
Date: Fri, 30 Dec 2011 13:08:27 -0200
Message-Id: <1325257711-12274-91-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx23885-dvb driver has a dirty hack:
	1) it hooks the DVBv3 legacy call to FE_SET_FRONTEND;
	2) it uses internally the DVBv3 struct to decide some
	   configs.

Replace it by a change during the gate control. This will
likely work, but requires testing. Anyway, the current way
will break, as soon as we stop copying data for DVBv3 for
pure DVBv5 calls.

Compile-tested only.

Cc: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/cx23885/cx23885-dvb.c |   41 ++++++++--------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index bcb45be..28d51d8 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -111,6 +111,8 @@ static void dvb_buf_release(struct videobuf_queue *q,
 	cx23885_free_buffer(q, (struct cx23885_buffer *)vb);
 }
 
+static int cx23885_dvb_set_frontend(struct dvb_frontend *fe);
+
 static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
 {
 	struct videobuf_dvb_frontends *f;
@@ -125,6 +127,12 @@ static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
 
 	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
 		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
+
+	/*
+	 * FIXME: Improve this path to avoid calling the
+	 * cx23885_dvb_set_frontend() every time it passes here.
+	 */
+	cx23885_dvb_set_frontend(fe->dvb.frontend);
 }
 
 static struct videobuf_queue_ops dvb_qops = {
@@ -479,15 +487,15 @@ static struct xc5000_config mygica_x8506_xc5000_config = {
 	.if_khz = 5380,
 };
 
-static int cx23885_dvb_set_frontend(struct dvb_frontend *fe,
-				    struct dvb_frontend_parameters *param)
+static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx23885_tsport *port = fe->dvb->priv;
 	struct cx23885_dev *dev = port->dev;
 
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
-		switch (param->u.vsb.modulation) {
+		switch (p->modulation) {
 		case VSB_8:
 			cx23885_gpio_clear(dev, GPIO_5);
 			break;
@@ -507,31 +515,6 @@ static int cx23885_dvb_set_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int cx23885_dvb_fe_ioctl_override(struct dvb_frontend *fe,
-					 unsigned int cmd, void *parg,
-					 unsigned int stage)
-{
-	int err = 0;
-
-	switch (stage) {
-	case DVB_FE_IOCTL_PRE:
-
-		switch (cmd) {
-		case FE_SET_FRONTEND:
-			err = cx23885_dvb_set_frontend(fe,
-				(struct dvb_frontend_parameters *) parg);
-			break;
-		}
-		break;
-
-	case DVB_FE_IOCTL_POST:
-		/* no post-ioctl handling required */
-		break;
-	}
-	return err;
-};
-
-
 static struct lgs8gxx_config magicpro_prohdtve2_lgs8g75_config = {
 	.prod = LGS8GXX_PROD_LGS8G75,
 	.demod_address = 0x19,
@@ -1151,7 +1134,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	/* register everything */
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
 					&dev->pci->dev, adapter_nr, mfe_shared,
-					cx23885_dvb_fe_ioctl_override);
+					NULL);
 	if (ret)
 		goto frontend_detach;
 
-- 
1.7.8.352.g876a6

