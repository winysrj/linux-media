Return-path: <linux-media-owner@vger.kernel.org>
Received: from blatinox.fr ([51.254.120.209]:33838 "EHLO vps202351.ovh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdJATlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 15:41:13 -0400
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Michael Krufky <mkrufky@linuxtv.org>
Cc: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] media: use ARRAY_SIZE
Date: Sun,  1 Oct 2017 15:30:41 -0400
Message-Id: <20171001193101.8898-4-jeremy.lefaure@lse.epita.fr>
In-Reply-To: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the ARRAY_SIZE macro improves the readability of the code. Also,
it is not always useful to use a variable to store this constant
calculated at compile time.

Found with Coccinelle with the following semantic patch:
@r depends on (org || report)@
type T;
T[] E;
position p;
@@
(
 (sizeof(E)@p /sizeof(*E))
|
 (sizeof(E)@p /sizeof(E[...]))
|
 (sizeof(E)@p /sizeof(T))
)

Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
---
 drivers/media/common/saa7146/saa7146_video.c | 9 ++++-----
 drivers/media/dvb-frontends/cxd2841er.c      | 7 +++----
 drivers/media/pci/saa7146/hexium_gemini.c    | 3 ++-
 drivers/media/pci/saa7146/hexium_orion.c     | 3 ++-
 drivers/media/pci/saa7146/mxb.c              | 3 ++-
 drivers/media/usb/dvb-usb/cxusb.c            | 3 ++-
 drivers/media/usb/dvb-usb/friio-fe.c         | 5 ++---
 7 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 37b4654dc21c..612aefd804f0 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -4,6 +4,7 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 static int max_memory = 32;
 
@@ -86,13 +87,11 @@ static struct saa7146_format formats[] = {
    due to this, it's impossible to provide additional *packed* formats, which are simply byte swapped
    (like V4L2_PIX_FMT_YUYV) ... 8-( */
 
-static int NUM_FORMATS = sizeof(formats)/sizeof(struct saa7146_format);
-
 struct saa7146_format* saa7146_format_by_fourcc(struct saa7146_dev *dev, int fourcc)
 {
-	int i, j = NUM_FORMATS;
+	int i;
 
-	for (i = 0; i < j; i++) {
+	for (i = 0; i < ARRAY_SIZE(formats); i++) {
 		if (formats[i].pixelformat == fourcc) {
 			return formats+i;
 		}
@@ -524,7 +523,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 {
-	if (f->index >= NUM_FORMATS)
+	if (f->index >= ARRAY_SIZE(formats))
 		return -EINVAL;
 	strlcpy((char *)f->description, formats[f->index].name,
 			sizeof(f->description));
diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 48ee9bc00c06..2cb97a3130be 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -29,6 +29,7 @@
 #include <linux/math64.h>
 #include <linux/log2.h>
 #include <linux/dynamic_debug.h>
+#include <linux/kernel.h>
 
 #include "dvb_math.h"
 #include "dvb_frontend.h"
@@ -1696,12 +1697,10 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
 		min_index = 0;
 		if (delsys == SYS_DVBS) {
 			cn_data = s_cn_data;
-			max_index = sizeof(s_cn_data) /
-				sizeof(s_cn_data[0]) - 1;
+			max_index = ARRAY_SIZE(s_cn_data) - 1;
 		} else {
 			cn_data = s2_cn_data;
-			max_index = sizeof(s2_cn_data) /
-				sizeof(s2_cn_data[0]) - 1;
+			max_index = ARRAY_SIZE(s2_cn_data) - 1;
 		}
 		if (value >= cn_data[min_index].value) {
 			res = cn_data[min_index].cnr_x1000;
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index d31a2d4494d1..39357eddee32 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -27,6 +27,7 @@
 
 #include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 static int debug;
 module_param(debug, int, 0);
@@ -388,7 +389,7 @@ static struct saa7146_ext_vv vv_data = {
 	.inputs = HEXIUM_INPUTS,
 	.capabilities = 0,
 	.stds = &hexium_standards[0],
-	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
+	.num_stds = ARRAY_SIZE(hexium_standards),
 	.std_callback = &std_callback,
 };
 
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 043318aa19e2..461e421080f3 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -27,6 +27,7 @@
 
 #include <media/drv-intf/saa7146_vv.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 static int debug;
 module_param(debug, int, 0);
@@ -460,7 +461,7 @@ static struct saa7146_ext_vv vv_data = {
 	.inputs = HEXIUM_INPUTS,
 	.capabilities = 0,
 	.stds = &hexium_standards[0],
-	.num_stds = sizeof(hexium_standards) / sizeof(struct saa7146_standard),
+	.num_stds = ARRAY_SIZE(hexium_standards),
 	.std_callback = &std_callback,
 };
 
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 930218cc2de1..0144f305ea24 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -30,6 +30,7 @@
 #include <media/v4l2-common.h>
 #include <media/i2c/saa7115.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 #include "tea6415c.h"
 #include "tea6420.h"
@@ -837,7 +838,7 @@ static struct saa7146_ext_vv vv_data = {
 	.inputs		= MXB_INPUTS,
 	.capabilities	= V4L2_CAP_TUNER | V4L2_CAP_VBI_CAPTURE | V4L2_CAP_AUDIO,
 	.stds		= &standard[0],
-	.num_stds	= sizeof(standard)/sizeof(struct saa7146_standard),
+	.num_stds	= ARRAY_SIZE(standard),
 	.std_callback	= &std_callback,
 };
 
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 37dea0adc695..9b486bb5004d 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -26,6 +26,7 @@
 #include <media/tuner.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 
 #include "cxusb.h"
 
@@ -303,7 +304,7 @@ static int cxusb_aver_power_ctrl(struct dvb_usb_device *d, int onoff)
 			0x0e, 0x2, 0x47, 0x88,
 		};
 		msleep(20);
-		for (i = 0; i < sizeof(bufs)/sizeof(u8); i += 4/sizeof(u8)) {
+		for (i = 0; i < ARRAY_SIZE(bufs); i += 4 / sizeof(u8)) {
 			ret = cxusb_ctrl_msg(d, CMD_I2C_WRITE,
 					     bufs+i, 4, &buf, 1);
 			if (ret)
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 0251a4e91d47..a6c84a4390d1 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 
 #include "friio.h"
 
@@ -362,8 +363,6 @@ static u8 init_code[][2] = {
 	{0x76, 0x0C},
 };
 
-static const int init_code_len = sizeof(init_code) / sizeof(u8[2]);
-
 static int jdvbt90502_init(struct dvb_frontend *fe)
 {
 	int i = -1;
@@ -377,7 +376,7 @@ static int jdvbt90502_init(struct dvb_frontend *fe)
 	msg.addr = state->config.demod_address;
 	msg.flags = 0;
 	msg.len = 2;
-	for (i = 0; i < init_code_len; i++) {
+	for (i = 0; i < ARRAY_SIZE(init_code); i++) {
 		msg.buf = init_code[i];
 		ret = i2c_transfer(state->i2c, &msg, 1);
 		if (ret != 1)
-- 
2.14.1
