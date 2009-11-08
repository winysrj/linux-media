Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:52758 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZKHMch (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 07:32:37 -0500
Message-ID: <4AF6BA67.1090700@freemail.hu>
Date: Sun, 08 Nov 2009 13:32:39 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] gspca pac7302: add debug register write interface
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add debug register write interface to pac7302 to be able to set
for example the edge detect mode (bit 2 register 0x55) or the
test pattern (bit 0..3, register 0x72) and test overlay (bit 4,
register 0x72) from the user space. Only write of register
page 0 is supported by this patch.

The patch was tested together with Labtec Webcam 2200 (USB ID
093a:2626).

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
This patch replaces http://linuxtv.org/hg/~jfrancois/v4l-dvb/rev/da22d3ea5fc7 and
http://linuxtv.org/hg/~jfrancois/v4l-dvb/rev/9b3580f8fee8 .
---
diff -upr b/linux/drivers/media/video/gspca/pac7302.c c/linux/drivers/media/video/gspca/pac7302.c
--- b/linux/drivers/media/video/gspca/pac7302.c	2009-11-08 11:39:00.000000000 +0100
+++ c/linux/drivers/media/video/gspca/pac7302.c	2009-11-08 11:59:00.000000000 +0100
@@ -53,6 +53,7 @@

 #define MODULE_NAME "pac7302"

+#include <media/v4l2-chip-ident.h>
 #include "gspca.h"

 MODULE_AUTHOR("Thomas Kaiser thomas@kaiser-linux.li");
@@ -982,6 +983,55 @@ static int sd_getvflip(struct gspca_dev
 	return 0;
 }

+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
+			struct v4l2_dbg_register *reg)
+{
+	int ret = -EINVAL;
+	__u8 index;
+	__u8 value;
+
+	/* reg->reg: bit0..15: reserved for register index (wIndex is 16bit
+			       long on the USB bus)
+	*/
+	if (reg->match.type == V4L2_CHIP_MATCH_HOST &&
+	    reg->match.addr == 0 &&
+	    (reg->reg < 0x000000ff) &&
+	    (reg->val <= 0x000000ff)
+	) {
+		/* Currently writing to page 0 is only supported. */
+		/* reg_w() only supports 8bit index */
+		index = reg->reg & 0x000000ff;
+		value = reg->val & 0x000000ff;
+
+		/* Note that there shall be no access to other page
+		   by any other function between the page swith and
+		   the actual register write */
+		ret = reg_w(gspca_dev, 0xff, 0x00);	/* page 0 */
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, index, value);
+
+		if (0 <= ret)
+			ret = reg_w(gspca_dev, 0xdc, 0x01);
+	}
+	return ret;
+}
+
+static int sd_chip_ident(struct gspca_dev *gspca_dev,
+			struct v4l2_dbg_chip_ident *chip)
+{
+	int ret = -EINVAL;
+
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
+	    chip->match.addr == 0) {
+		chip->revision = 0;
+		chip->ident = V4L2_IDENT_UNKNOWN;
+		ret = 0;
+	}
+	return ret;
+}
+#endif
+
 /* sub-driver description for pac7302 */
 static struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -994,6 +1044,10 @@ static struct sd_desc sd_desc = {
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
 	.dq_callback = do_autogain,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.set_register = sd_dbg_s_register,
+	.get_chip_ident = sd_chip_ident,
+#endif
 };

 /* -- module initialisation -- */
