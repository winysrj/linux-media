Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8492 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbdJRCwe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 22:52:34 -0400
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
To: <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, <hermit.wangheming@hisilicon.com>,
        Younian Wang <wangyounian@hisilicon.com>,
        Jiancheng Xue <xuejiancheng@hisilicon.com>
Subject: [PATCH 2/2] [media] rc/keymaps: add support for RC of hisilicon poplar board
Date: Wed, 18 Oct 2017 06:54:57 -0400
Message-ID: <1508324097-5514-3-git-send-email-xuejiancheng@hisilicon.com>
In-Reply-To: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
References: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Younian Wang <wangyounian@hisilicon.com>

This is a NEC protocol type remote controller distributed with
96boards poplar@tocoding board.

Signed-off-by: Younian Wang <wangyounian@hisilicon.com>
Signed-off-by: Jiancheng Xue <xuejiancheng@hisilicon.com>
---
 drivers/media/rc/keymaps/Makefile         |  1 +
 drivers/media/rc/keymaps/rc-hisi-poplar.c | 58 +++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-poplar.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 83ec9c3..8daabfc6 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-geekbox.o \
 			rc-genius-tvgo-a11mce.o \
 			rc-gotview7135.o \
+			rc-hisi-poplar.o \
 			rc-hisi-tv-demo.o \
 			rc-imon-mce.o \
 			rc-imon-pad.o \
diff --git a/drivers/media/rc/keymaps/rc-hisi-poplar.c b/drivers/media/rc/keymaps/rc-hisi-poplar.c
new file mode 100644
index 0000000..730d556
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-hisi-poplar.c
@@ -0,0 +1,58 @@
+#include <linux/module.h>
+#include <media/rc-map.h>
+
+static struct rc_map_table hisi_poplar_keymap[] = {
+	{ 0x0000b292, KEY_1},
+	{ 0x0000b293, KEY_2},
+	{ 0x0000b2cc, KEY_3},
+	{ 0x0000b28e, KEY_4},
+	{ 0x0000b28f, KEY_5},
+	{ 0x0000b2c8, KEY_6},
+	{ 0x0000b28a, KEY_7},
+	{ 0x0000b28b, KEY_8},
+	{ 0x0000b2c4, KEY_9},
+	{ 0x0000b287, KEY_0},
+	{ 0x0000b282, KEY_HOMEPAGE},
+	{ 0x0000b2ca, KEY_UP},
+	{ 0x0000b299, KEY_LEFT},
+	{ 0x0000b2c1, KEY_RIGHT},
+	{ 0x0000b2d2, KEY_DOWN},
+	{ 0x0000b2c5, KEY_DELETE},
+	{ 0x0000b29c, KEY_MUTE},
+	{ 0x0000b281, KEY_VOLUMEDOWN},
+	{ 0x0000b280, KEY_VOLUMEUP},
+	{ 0x0000b2dc, KEY_POWER},
+	{ 0x0000b29a, KEY_MENU},
+	{ 0x0000b28d, KEY_SETUP},
+	{ 0x0000b2c5, KEY_BACK},
+	{ 0x0000b295, KEY_PLAYPAUSE},
+	{ 0x0000b2ce, KEY_ENTER},
+	{ 0x0000b285, KEY_CHANNELUP},
+	{ 0x0000b286, KEY_CHANNELDOWN},
+	{ 0x0000b2da, KEY_NUMERIC_STAR},
+	{ 0x0000b2d0, KEY_NUMERIC_POUND},
+};
+
+static struct rc_map_list hisi_poplar_map = {
+	.map = {
+		.scan	  = hisi_poplar_keymap,
+		.size	  = ARRAY_SIZE(hisi_poplar_keymap),
+		.rc_proto = RC_PROTO_NEC,
+		.name	  = "rc-hisi-poplar",
+	}
+};
+
+static int __init init_rc_map_hisi_poplar(void)
+{
+	return rc_map_register(&hisi_poplar_map);
+}
+
+static void __exit exit_rc_map_hisi_poplar(void)
+{
+	rc_map_unregister(&hisi_poplar_map);
+}
+
+module_init(init_rc_map_hisi_poplar)
+module_exit(exit_rc_map_hisi_poplar)
+
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
