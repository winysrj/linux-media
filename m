Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3HHQxd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 12:53:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 1/3] cx23885-dvb: use a better approach to hook set_frontend
Date: Thu,  8 Aug 2013 13:51:50 -0300
Message-Id: <1375980712-9349-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
References: <1375980712-9349-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the frontend drivers got converted to DVBv5 API, the original
hook that tracked when a frontend is set got removed, being replaced
by an approach that would use the gate control. That doesn't work
fine with some boards. Also, the code were called more times than
desired.

Replace it by a logic that will hook the dvb set_frontend ops,
with works with both DVBv3 and DVBv5 calls.

Tested on a Mygica X8502 OEM board.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 25 +++++++++++++++++--------
 drivers/media/pci/cx23885/cx23885.h     |  2 ++
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index bb291c6..c0613fb 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -119,8 +119,6 @@ static void dvb_buf_release(struct videobuf_queue *q,
 	cx23885_free_buffer(q, (struct cx23885_buffer *)vb);
 }
 
-static int cx23885_dvb_set_frontend(struct dvb_frontend *fe);
-
 static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
 {
 	struct videobuf_dvb_frontends *f;
@@ -135,12 +133,6 @@ static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
 
 	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
 		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
-
-	/*
-	 * FIXME: Improve this path to avoid calling the
-	 * cx23885_dvb_set_frontend() every time it passes here.
-	 */
-	cx23885_dvb_set_frontend(fe->dvb.frontend);
 }
 
 static struct videobuf_queue_ops dvb_qops = {
@@ -561,9 +553,21 @@ static int cx23885_dvb_set_frontend(struct dvb_frontend *fe)
 		cx23885_gpio_set(dev, GPIO_0);
 		break;
 	}
+
+	/* Call the real set_frontend */
+	if (port->set_frontend)
+		return port->set_frontend(fe);
+
 	return 0;
 }
 
+static void cx23885_set_frontend_hook(struct cx23885_tsport *port,
+				     struct dvb_frontend *fe)
+{
+	port->set_frontend = fe->ops.set_frontend;
+	fe->ops.set_frontend = cx23885_dvb_set_frontend;
+}
+
 static struct lgs8gxx_config magicpro_prohdtve2_lgs8g75_config = {
 	.prod = LGS8GXX_PROD_LGS8G75,
 	.demod_address = 0x19,
@@ -771,6 +775,8 @@ static int dvb_register(struct cx23885_tsport *port)
 				   0x60, &dev->i2c_bus[1].i2c_adap,
 				   &hauppauge_hvr127x_config);
 		}
+		if (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1275)
+			cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
@@ -1106,6 +1112,8 @@ static int dvb_register(struct cx23885_tsport *port)
 				&i2c_bus2->i2c_adap,
 				&mygica_x8506_xc5000_config);
 		}
+		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
+		break;
 		break;
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		i2c_bus = &dev->i2c_bus[0];
@@ -1119,6 +1127,7 @@ static int dvb_register(struct cx23885_tsport *port)
 				&i2c_bus2->i2c_adap,
 				&magicpro_prohdtve2_xc5000_config);
 		}
+		cx23885_set_frontend_hook(port, fe0->dvb.frontend);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		i2c_bus = &dev->i2c_bus[0];
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 5687d3f..038caf5 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -320,6 +320,8 @@ struct cx23885_tsport {
 
 	/* Workaround for a temp dvb_frontend that the tuner can attached to */
 	struct dvb_frontend analog_fe;
+
+	int (*set_frontend)(struct dvb_frontend *fe);
 };
 
 struct cx23885_kernel_ir {
-- 
1.8.3.1

