Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60546 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcGQRHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 13:07:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 09/15] [media] doc-rst: convert DVB FAQ to ReST format
Date: Sun, 17 Jul 2016 14:07:04 -0300
Message-Id: <c0be9f7952c2abb5a87c17305761b8453f212493.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
In-Reply-To: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
References: <fcbf5ca0b870c26e1c2d89a31c87e65d952dc253.1468775054.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the DVB FAQ to ReST format and add a note that this is
outdated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/faq.rst   | 18 +++++++++++++-----
 Documentation/media/dvb-drivers/index.rst |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/dvb-drivers/faq.rst b/Documentation/media/dvb-drivers/faq.rst
index a0be92012877..a8593d3792fa 100644
--- a/Documentation/media/dvb-drivers/faq.rst
+++ b/Documentation/media/dvb-drivers/faq.rst
@@ -1,3 +1,11 @@
+FAQ
+===
+
+.. note::
+
+   This documentation is outdated. Please check at the DVB wiki
+   at https://linuxtv.org/wiki for more updated info.
+
 Some very frequently asked questions about linuxtv-dvb
 
 1. The signal seems to die a few seconds after tuning.
@@ -71,8 +79,7 @@ Some very frequently asked questions about linuxtv-dvb
 	http://www.dbox2.info/
 		LinuxDVB on the dBox2
 
-	http://www.tuxbox.org/
-	http://cvs.tuxbox.org/
+	http://www.tuxbox.org/ and http://cvs.tuxbox.org/
 		the TuxBox CVS many interesting DVB applications and the dBox2
 		DVB source
 
@@ -85,8 +92,7 @@ Some very frequently asked questions about linuxtv-dvb
 	http://mplayerhq.hu/
 		mplayer
 
-	http://xine.sourceforge.net/
-	http://xinehq.de/
+	http://xine.sourceforge.net/ and http://xinehq.de/
 		xine
 
 	http://www.mythtv.org/
@@ -125,6 +131,9 @@ Some very frequently asked questions about linuxtv-dvb
 	Check your routes if they include the multicast address range.
 	Additionally make sure that "source validation by reversed path
 	lookup" is disabled:
+
+.. code-block:: none
+
 	  $ "echo 0 > /proc/sys/net/ipv4/conf/dvb0/rp_filter"
 
 7. What the hell are all those modules that need to be loaded?
@@ -156,4 +165,3 @@ Some very frequently asked questions about linuxtv-dvb
 	- dvb-ttpci: The main driver for AV7110 based, full-featured
 	  DVB-S/C/T cards
 
-eof
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 2ec80b9e70b5..12e0d4b16baa 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -24,4 +24,5 @@ License".
 	cards
 	ci
 	dvb-usb
+	faq
 	contributors
-- 
2.7.4

