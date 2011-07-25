Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37755 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1GYSey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 14:34:54 -0400
Received: by wyg8 with SMTP id 8so2946422wyg.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 11:34:52 -0700 (PDT)
Subject: [PATCH 1/3] IT9137 driver for Kworld UB499-2T T09 (id 1b80:e409) -
 firmware details
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 19:34:45 +0100
Message-ID: <1311618885.7655.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware information for Kworld UB499-2T T09 based on IT913x series. This device
uses file dvb-usb-it9137-01.fw.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 Documentation/dvb/it9137.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dvb/it9137.txt

diff --git a/Documentation/dvb/it9137.txt b/Documentation/dvb/it9137.txt
new file mode 100644
index 0000000..9e6726e
--- /dev/null
+++ b/Documentation/dvb/it9137.txt
@@ -0,0 +1,9 @@
+To extract firmware for Kworld UB499-2T (id 1b80:e409) you need to copy the
+following file(s) to this directory.
+
+IT9135BDA.sys Dated Mon 22 Mar 2010 02:20:08 GMT
+
+extract using dd
+dd if=IT9135BDA.sys ibs=1 skip=69632 count=5731 of=dvb-usb-it9137-01.fw
+
+copy to default firmware location.
-- 
1.7.4.1




