Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Subject: [PATCH 15/36] [media] doc-rst: Add cx88 documentation to media book
Date: Sun, 17 Jul 2016 22:55:58 -0300
Message-Id: <c009e6819e60d50f2f84d202927eaa66f00e62a1.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the cx88 documentation to rst and add it to the v4l-devices
book

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx88.rst  | 15 ++++++++++++---
 Documentation/media/v4l-drivers/index.rst |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index b09ce36b921e..f4e69306f64d 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -1,11 +1,18 @@
+The cx88 driver
+===============
+
+.. note::
+
+   This documentation is outdated.
+
 cx8800 release notes
-====================
+--------------------
 
 This is a v4l2 device driver for the cx2388x chip.
 
 
 current status
-==============
+--------------
 
 video
 	- Basically works.
@@ -30,7 +37,7 @@ vbi
 
 
 how to add support for new cards
-================================
+--------------------------------
 
 The driver needs some config info for the TV cards.  This stuff is in
 cx88-cards.c.  If the driver doesn't work well you likely need a new
@@ -38,6 +45,8 @@ entry for your card in that file.  Check the kernel log (using dmesg)
 to see whenever the driver knows your card or not.  There is a line
 like this one:
 
+.. code-block:: none
+
 	cx8800[0]: subsystem: 0070:3400, board: Hauppauge WinTV \
 		34xxx models [card=1,autodetected]
 
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 07dc2596b0bd..839374e60280 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -23,4 +23,5 @@ License".
 	cafe_ccic
 	cpia2
 	cx18
+	cx88
 	zr364xx
-- 
2.7.4

