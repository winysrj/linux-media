Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0F1MPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 08:15:33 -0400
From: Renzo Dani <arons7@gmail.com>
To: adams.xu@azwave.com.cn
Cc: arons7@gmail.com, mchehab@infradead.org, rdunlap@xenotime.net,
	o.endriss@gmx.de, awalls@radix.net, crope@iki.fi, manu@linuxtv.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/1] Retrieve firmware for az6027
Date: Mon, 28 Jun 2010 14:15:19 +0200
Message-Id: <1277727319-9498-1-git-send-email-arons7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 Documentation/dvb/get_dvb_firmware |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index 239cbdb..507868b 100644
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -26,7 +26,7 @@ use IO::Handle;
 		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
 		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
 		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
-		"af9015", "ngene");
+		"af9015", "ngene", "az6027");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -567,6 +567,23 @@ sub ngene {
     "$file1, $file2";
 }
 
+sub az6027{
+    my $file = "AZ6027_Linux_Driver.tar.gz";
+    my $url = "http://linux.terratec.de/files/$file";
+    my $firmware = "dvb-usb-az6027-03.fw";
+
+    wgetfile($file, $url);
+
+    #untar
+    if( system("tar xzvf $file")){
+        die "failed to untar firmware";
+    }
+    if( system("rm -rf AZ6027_Linux_Driver; rm $file")){
+        die ("unable to remove unnecessary files");
+    }
+
+    $firmware;
+}
 # ---------------------------------------------------------------
 # Utilities
 
-- 
1.7.1

