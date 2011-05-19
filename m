Return-path: <mchehab@pedra>
Received: from blu0-omc2-s25.blu0.hotmail.com ([65.55.111.100]:17537 "EHLO
	blu0-omc2-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933907Ab1ESSRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 14:17:09 -0400
Message-ID: <BLU0-SMTP25C479222362147498A619D88E0@phx.gbl>
From: Manoel PN <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: [PATCH] saa7134-dvb.c kworld_sbtvd
Date: Thu, 19 May 2011 15:16:57 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The correct place to put i2c_gate_ctrl is before calling tda18271_attach,
because the driver tda18271 will use it to enable or disable the i2c-bus
from the demodulator to the tuner.

And thus eliminate the error message: "Unknown device (255) detected
@ 1-00c0, device not supported" in the driver tda18271.

In the device kworld_sbtvd (hybrid analog and digital TV) the control
of the i2c-bus to tuner is done in the analog demodulator and not in
the digital demodulator.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>


diff --git a/drivers/media/video/saa7134/saa7134-dvb.c 
b/drivers/media/video/saa7134/saa7134-dvb.c
index f65cad2..c1a18d1 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -1666,10 +1666,10 @@ static int dvb_init(struct saa7134_dev *dev)
 			dvb_attach(tda829x_attach, fe0->dvb.frontend,
 				   &dev->i2c_adap, 0x4b,
 				   &tda829x_no_probe);
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = kworld_sbtvd_gate_ctrl;
 			dvb_attach(tda18271_attach, fe0->dvb.frontend,
 				   0x60, &dev->i2c_adap,
 				   &kworld_tda18271_config);
-			fe0->dvb.frontend->ops.i2c_gate_ctrl = kworld_sbtvd_gate_ctrl;
 		}
 
 		/* mb86a20s need to use the I2C gateway */


