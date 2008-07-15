Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <487D1964.7050607@simon.arlott.org.uk>
Date: Tue, 15 Jul 2008 22:40:52 +0100
From: Simon Arlott <simon@fire.lp0.eu>
MIME-Version: 1.0
To: v4l-dvb-maintainer@linuxtv.org
References: <4878F314.6090608@simon.arlott.org.uk>
	<1215919227.2662.3.camel@pc10.localdom.local>
In-Reply-To: <1215919227.2662.3.camel@pc10.localdom.local>
Cc: Linux DVB <linux-dvb@linuxtv.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [linux-dvb] [PATCH] V4L: Link tuner before saa7134
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

If saa7134_init is run before v4l2_i2c_drv_init (tuner),
then saa7134_board_init2 will try to set the tuner type
for devices that don't exist yet. This moves tuner to
before all of the device-specific drivers so that it's
loaded early enough on boot.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
Resend... I accidentally left the git-send-email headers in.

Mailman appears to be easily confused too: 
http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027205.html

 drivers/media/video/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ecbbfaa..6b0af12 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
@@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
 obj-$(CONFIG_TUNER_3036) += tuner-3036.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
-
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
-- 
1.5.6.2

-- 
Simon Arlott


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
