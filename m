Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38753 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbeIOO7o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 10:59:44 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: VDR User <user.vdr@gmail.com>
Subject: [PATCH v4l-utils 1/2] keytable: keymap for Network Dish
Date: Sat, 15 Sep 2018 10:41:20 +0100
Message-Id: <20180915094121.3590-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BPF keymap, see:
	https://www.mythtv.org/wiki/DISHNetworkLIRCConfiguration

Cc: VDR User <user.vdr@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 .../rc_keymaps_userspace/dish_network.toml    | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 utils/keytable/rc_keymaps_userspace/dish_network.toml

diff --git a/utils/keytable/rc_keymaps_userspace/dish_network.toml b/utils/keytable/rc_keymaps_userspace/dish_network.toml
new file mode 100644
index 00000000..9614edae
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/dish_network.toml
@@ -0,0 +1,62 @@
+# See https://www.mythtv.org/wiki/DISHNetworkLIRCConfiguration
+[[protocols]]
+name = 'Dish Network'
+protocol = 'pulse_distance'
+trailer_pulse = 450
+header_optional = 1
+header_pulse = 525
+header_space = 6045
+bits = 16
+bit_pulse = 440
+bit_1_space = 1645
+bit_0_space = 2780
+[protocols.scancodes]
+0x0400 = 'KEY_SAT'
+0xa801 = 'KEY_TV'
+0xac02 = 'KEY_DVD'
+0xb003 = 'KEY_AUX'
+0x0800 = 'KEY_POWER'
+0x2c00 = 'KEY_MENU'
+0x5c00 = 'KEY_SWITCHVIDEOMODE' # Input
+0x3c10 = 'KEY_PAGEUP'
+0x1c10 = 'KEY_PAGEDOWN'
+0x5000 = 'KEY_EPG'
+0x6800 = 'KEY_UP'
+0x7000 = 'KEY_LEFT'
+0x4000 = 'KEY_SELECT'
+0x6000 = 'KEY_RIGHT'
+0x7800 = 'KEY_DOWN'
+0x6c00 = 'KEY_LAST'
+0x0000 = 'KEY_INFO'
+0xb400 = 'KEY_SEARCH'
+0x5800 = 'KEY_TV' # View Live TV
+0x4800 = 'KEY_CANCEL'
+0x4c00 = 'KEY_RED'
+0xd400 = 'KEY_GREEN'
+0x8800 = 'KEY_YELLOW'
+0x8c00 = 'KEY_BLUE'
+0xd810 = 'KEY_PREVIOUS'
+0xe410 = 'KEY_PVR'
+0xdc10 = 'KEY_NEXT'
+0xc410 = 'KEY_REWIND'
+0x8000 = 'KEY_PAUSE'
+0xc810 = 'KEY_FASTFORWARD'
+0x8400 = 'KEY_STOP'
+0x7c00 = 'KEY_RECORD'
+0x0c10 = 'KEY_PLAY'
+0x1000 = 'KEY_NUMERIC_1'
+0x1400 = 'KEY_NUMERIC_2'
+0x1800 = 'KEY_NUMERIC_3'
+0x2000 = 'KEY_NUMERIC_4'
+0x2400 = 'KEY_NUMERIC_5'
+0x2800 = 'KEY_NUMERIC_6'
+0x3000 = 'KEY_NUMERIC_7'
+0x3400 = 'KEY_NUMERIC_8'
+0x3800 = 'KEY_NUMERIC_9'
+0x4400 = 'KEY_NUMERIC_0'
+0x9400 = 'KEY_NUMERIC_STAR'
+0x9800 = 'KEY_NUMERIC_POUND'
+0xf410 = 'KEY_AB'
+0xe810 = 'KEY_VIDEO' # PIP (Picture-in-picture)
+0xec10 = 'KEY_SCREEN' # Position
+0xd010 = 'KEY_MEDIA' # Dish
-- 
2.17.1
