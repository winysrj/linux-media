Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8491 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdJRCue (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 22:50:34 -0400
From: Jiancheng Xue <xuejiancheng@hisilicon.com>
To: <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shawn.guo@linaro.org>, <hermit.wangheming@hisilicon.com>,
        Younian Wang <wangyounian@hisilicon.com>,
        Jiancheng Xue <xuejiancheng@hisilicon.com>
Subject: [PATCH 1/2] [media] rc/keymaps: add support for RC of hisilicon TV demo boards
Date: Wed, 18 Oct 2017 06:54:56 -0400
Message-ID: <1508324097-5514-2-git-send-email-xuejiancheng@hisilicon.com>
In-Reply-To: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
References: <1508324097-5514-1-git-send-email-xuejiancheng@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Younian Wang <wangyounian@hisilicon.com>

This is a NEC protocol type remote controller distributed with
hisilicon TV demo boards.

Signed-off-by: Younian Wang <wangyounian@hisilicon.com>
Signed-off-by: Jiancheng Xue <xuejiancheng@hisilicon.com>
---
 drivers/media/rc/keymaps/Makefile          |  1 +
 drivers/media/rc/keymaps/rc-hisi-tv-demo.c | 70 ++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-hisi-tv-demo.c

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index af6496d..83ec9c3 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-geekbox.o \
 			rc-genius-tvgo-a11mce.o \
 			rc-gotview7135.o \
+			rc-hisi-tv-demo.o \
 			rc-imon-mce.o \
 			rc-imon-pad.o \
 			rc-iodata-bctv7e.o \
diff --git a/drivers/media/rc/keymaps/rc-hisi-tv-demo.c b/drivers/media/rc/keymaps/rc-hisi-tv-demo.c
new file mode 100644
index 0000000..410b17d
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-hisi-tv-demo.c
@@ -0,0 +1,70 @@
+#include <linux/module.h>
+#include <media/rc-map.h>
+
+static struct rc_map_table hisi_tv_demo_keymap[] = {
+	{ 0x00000092, KEY_1},
+	{ 0x00000093, KEY_2},
+	{ 0x000000cc, KEY_3},
+	{ 0x0000009f, KEY_4},
+	{ 0x0000008e, KEY_5},
+	{ 0x0000008f, KEY_6},
+	{ 0x000000c8, KEY_7},
+	{ 0x00000094, KEY_8},
+	{ 0x0000008a, KEY_9},
+	{ 0x0000008b, KEY_0},
+	{ 0x000000ce, KEY_ENTER},
+	{ 0x000000ca, KEY_UP},
+	{ 0x00000099, KEY_LEFT},
+	{ 0x00000084, KEY_PAGEUP},
+	{ 0x000000c1, KEY_RIGHT},
+	{ 0x000000d2, KEY_DOWN},
+	{ 0x00000089, KEY_PAGEDOWN},
+	{ 0x000000d1, KEY_MUTE},
+	{ 0x00000098, KEY_VOLUMEDOWN},
+	{ 0x00000090, KEY_VOLUMEUP},
+	{ 0x0000009c, KEY_POWER},
+	{ 0x000000d6, KEY_STOP},
+	{ 0x00000097, KEY_MENU},
+	{ 0x000000cb, KEY_BACK},
+	{ 0x000000da, KEY_PLAYPAUSE},
+	{ 0x00000080, KEY_INFO},
+	{ 0x000000c3, KEY_REWIND},
+	{ 0x00000087, KEY_HOMEPAGE},
+	{ 0x000000d0, KEY_FASTFORWARD},
+	{ 0x000000c4, KEY_SOUND},
+	{ 0x00000082, BTN_1},
+	{ 0x000000c7, BTN_2},
+	{ 0x00000086, KEY_PROGRAM},
+	{ 0x000000d9, KEY_SUBTITLE},
+	{ 0x00000085, KEY_ZOOM},
+	{ 0x0000009b, KEY_RED},
+	{ 0x0000009a, KEY_GREEN},
+	{ 0x000000c0, KEY_YELLOW},
+	{ 0x000000c2, KEY_BLUE},
+	{ 0x0000009d, KEY_CHANNELDOWN},
+	{ 0x000000cf, KEY_CHANNELUP},
+};
+
+static struct rc_map_list hisi_tv_demo_map = {
+	.map = {
+		.scan	  = hisi_tv_demo_keymap,
+		.size	  = ARRAY_SIZE(hisi_tv_demo_keymap),
+		.rc_proto = RC_PROTO_NEC,
+		.name	  = "rc-hisi-demo",
+	}
+};
+
+static int __init init_rc_map_hisi_tv_demo(void)
+{
+	return rc_map_register(&hisi_tv_demo_map);
+}
+
+static void __exit exit_rc_map_hisi_tv_demo(void)
+{
+	rc_map_unregister(&hisi_tv_demo_map);
+}
+
+module_init(init_rc_map_hisi_tv_demo)
+module_exit(exit_rc_map_hisi_tv_demo)
+
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
