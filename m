Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbaEHTlb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 15:41:31 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s48JfUuK001152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 8 May 2014 15:41:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/3] rc_keymaps: Add a keymap for the remote shipped with allwinner ba10 tv boxes
Date: Thu,  8 May 2014 21:41:25 +0200
Message-Id: <1399578087-2365-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
References: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an unbranded remote found with unbranded allwinner a10 based android
tv boxes, which are referred to as ba10 tv boxes since the pcb is marked ba10
(the ba10 name is also used in u-boot and for the devicetree files).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 utils/keytable/rc_keymaps/allwinner_ba10_tv_box | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 utils/keytable/rc_keymaps/allwinner_ba10_tv_box

diff --git a/utils/keytable/rc_keymaps/allwinner_ba10_tv_box b/utils/keytable/rc_keymaps/allwinner_ba10_tv_box
new file mode 100644
index 0000000..cfa7641
--- /dev/null
+++ b/utils/keytable/rc_keymaps/allwinner_ba10_tv_box
@@ -0,0 +1,15 @@
+# table allwinner_ba10_tv_box, type: NEC
+0x206 KEY_UP
+0x216 KEY_VOLUMEDOWN
+0x217 KEY_NEXTSONG
+0x21a KEY_POWER
+0x21b KEY_BACK
+0x21e KEY_OK
+0x21f KEY_DOWN
+0x244 KEY_VOLUMEUP
+0x254 KEY_PREVIOUSSONG
+0x255 KEY_PLAYPAUSE
+0x258 KEY_MENU
+0x259 KEY_HOME
+0x25c KEY_RIGHT
+0x25d KEY_LEFT
-- 
1.9.0

