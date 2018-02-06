Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55846 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753245AbeBFUeZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 15:34:25 -0500
Received: from localhost.localdomain ([188.110.57.104]) by mail.gmx.com
 (mrgmx003 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0MFdDB-1eXM7O2zsz-00Eckd for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018
 21:34:23 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] keytable: fix EVIOCSCLOCKID related compile failure
Date: Tue,  6 Feb 2018 21:34:23 +0100
Message-Id: <20180206203423.13776-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes:

  keytable.c: In function 'test_event':
  keytable.c:1351:12: error: 'EVIOCSCLOCKID' undeclared (first use in this function)
    ioctl(fd, EVIOCSCLOCKID, &mode);
              ^~~~~~~~~~~~~

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/keytable/keytable.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utils/keytable/keytable.c b/utils/keytable/keytable.c
index 34a1522e..925eab00 100644
--- a/utils/keytable/keytable.c
+++ b/utils/keytable/keytable.c
@@ -55,6 +55,10 @@ struct input_keymap_entry_v2 {
 	u_int8_t  scancode[32];
 };
 
+#ifndef EVIOCSCLOCKID
+#define EVIOCSCLOCKID		_IOW('E', 0xa0, int)
+#endif
+
 #ifndef EVIOCGKEYCODE_V2
 #define EVIOCGKEYCODE_V2	_IOR('E', 0x04, struct input_keymap_entry_v2)
 #define EVIOCSKEYCODE_V2	_IOW('E', 0x04, struct input_keymap_entry_v2)
-- 
2.16.1
