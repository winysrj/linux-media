Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbaEHTle (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 May 2014 15:41:34 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s48JfWIl027429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 8 May 2014 15:41:33 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/3] rc_keymaps: Add keymap for the remote shipped with the Wobo i5 tv box
Date: Thu,  8 May 2014 21:41:27 +0200
Message-Id: <1399578087-2365-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
References: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Wobo i5 is an allwinner based android tv box, with its own custom remote,
this adds a keymap for this remote (like all allwinner devices, the wobo i5
can run plain Linux).

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 utils/keytable/rc_keymaps/wobo_i5 | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 utils/keytable/rc_keymaps/wobo_i5

diff --git a/utils/keytable/rc_keymaps/wobo_i5 b/utils/keytable/rc_keymaps/wobo_i5
new file mode 100644
index 0000000..38362c5
--- /dev/null
+++ b/utils/keytable/rc_keymaps/wobo_i5
@@ -0,0 +1,9 @@
+# table wobo_i5, type: NEC
+0x01 KEY_POWER
+0x05 KEY_UP
+0x06 KEY_LEFT
+0x08 KEY_RIGHT
+0x09 KEY_PLAYPAUSE
+0x0a KEY_DOWN
+0x0c KEY_MENU
+0x0e KEY_BACK
-- 
1.9.0

