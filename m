Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbaEHTlc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 15:41:32 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s48JfVsV027418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 8 May 2014 15:41:32 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/3] rc_keymaps: Add a keymap for the remote shipped with allwinner i12-a20 tv boxes
Date: Thu,  8 May 2014 21:41:26 +0200
Message-Id: <1399578087-2365-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
References: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an unbranded remote found with unbranded allwinner a20 based android
tv boxes, which are referred to as i12 tv boxes since the pcb is marked i12
(the i12 name is also used in u-boot and for the devicetree files).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box

diff --git a/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box b/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
new file mode 100644
index 0000000..edbc7a7
--- /dev/null
+++ b/utils/keytable/rc_keymaps/allwinner_i12_a20_tv_box
@@ -0,0 +1,28 @@
+# table allwinner_i12_a20_tv_box, type: NEC
+0x00 KEY_7
+0x01 KEY_4
+0x02 KEY_1
+0x03 KEY_VOLUMEDOWN
+0x04 KEY_8
+0x05 KEY_5
+0x06 KEY_2
+0x07 KEY_BACK
+0x08 KEY_9
+0x09 KEY_6
+0x0a KEY_3
+0x0b KEY_NEXTSONG
+0x0c KEY_WWW
+0x0d KEY_0
+0x0e KEY_BACKSPACE
+0x40 KEY_VOLUMEUP
+0x41 KEY_LEFT
+0x42 KEY_HOME
+0x43 KEY_POWER
+0x44 KEY_DOWN
+0x45 KEY_OK
+0x46 KEY_UP
+0x47 KEY_CONTEXT_MENU
+0x48 KEY_PREVIOUSSONG
+0x49 KEY_RIGHT
+0x4a KEY_MENU
+0x4b KEY_MUTE
-- 
1.9.0

