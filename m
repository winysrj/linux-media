Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37781 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3AMN4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 08:56:36 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so770072wib.3
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 05:56:35 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 13 Jan 2013 14:56:34 +0100
Message-ID: <CACaVWbRLLp-JTouWPu7esEdpm-+rGnMgBHCe2w4U5sYYgZVonA@mail.gmail.com>
Subject: [PATCH] hvr930c-drxk.fw new md5sum
From: Marc Sowen <marc.sowen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

the md5sum of the Hauppauge zip file containing the hvr930c-drxk.fw
file has changed. Here is a patch to fix this.

Cheers,
 Marc

---
diff -uprN linux-3.8-rc3/Documentation/dvb/get_dvb_firmware.orig
linux-3.8-rc3/Documentation/dvb/get_dvb_firmware
--- linux-3.8-rc3/Documentation/dvb/get_dvb_firmware.orig
2013-01-13 14:41:57.610368692 +0100
+++ linux-3.8-rc3/Documentation/dvb/get_dvb_firmware    2013-01-13
14:42:27.690367506 +0100
@@ -648,7 +648,7 @@ sub drxk {
 sub drxk_hauppauge_hvr930c {
     my $url = "http://www.wintvcd.co.uk/drivers/";
     my $zipfile = "HVR-9x0_5_10_325_28153_SIGNED.zip";
-    my $hash = "83ab82e7e9480ec8bf1ae0155ca63c88";
+    my $hash = "7fca8187946b003d02228c2b785413c4";
     my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
     my $drvfile = "HVR-900/emOEM.sys";
     my $fwfile = "dvb-usb-hauppauge-hvr930c-drxk.fw";
