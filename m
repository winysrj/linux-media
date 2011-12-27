Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1L0BJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:50 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH RFC 90/91] cx23885-dvb: Remove a dirty hack that would require DVBv3
Date: Mon, 26 Dec 2011 23:09:18 -0200
Message-Id: <1324948159-23709-91-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-90-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
 <1324948159-23709-82-git-send-email-mchehab@redhat.com>
 <1324948159-23709-83-git-send-email-mchehab@redhat.com>
 <1324948159-23709-84-git-send-email-mchehab@redhat.com>
 <1324948159-23709-85-git-send-email-mchehab@redhat.com>
 <1324948159-23709-86-git-send-email-mchehab@redhat.com>
 <1324948159-23709-87-git-send-email-mchehab@redhat.com>
 <1324948159-23709-88-git-send-email-mchehab@redhat.com>
 <1324948159-23709-89-git-send-email-mchehab@redhat.com>
 <1324948159-23709-90-git-send-email-mchehab@redhat.com>
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

