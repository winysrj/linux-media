Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcGRB4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kees Cook <keescook@chromium.org>, linux-doc@vger.kernel.org
Subject: [PATCH 16/36] [media] cx88.rst: Update the documentation
Date: Sun, 17 Jul 2016 22:55:59 -0300
Message-Id: <55aa32feb03fadc8779fc14e94f73f0b65c4d2f2.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This doc is outdated, and contains information that it is not
true anymore. Update it to reflect the changes that this
driver suffered since I started working on it.

While here, also update Gerd's name.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/cx88.rst | 52 +++++++++++---------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/Documentation/media/v4l-drivers/cx88.rst b/Documentation/media/v4l-drivers/cx88.rst
index f4e69306f64d..ac83292776da 100644
--- a/Documentation/media/v4l-drivers/cx88.rst
+++ b/Documentation/media/v4l-drivers/cx88.rst
@@ -1,42 +1,29 @@
 The cx88 driver
 ===============
 
-.. note::
-
-   This documentation is outdated.
-
-cx8800 release notes
---------------------
+Author:  Gerd Hoffmann
 
 This is a v4l2 device driver for the cx2388x chip.
 
 
-current status
+Current status
 --------------
 
 video
-	- Basically works.
-	- For now, only capture and read(). Overlay isn't supported.
+	- Works.
+	- Overlay isn't supported.
 
 audio
-	- The chip specs for the on-chip TV sound decoder are next
-	  to useless :-/
-	- Neverless the builtin TV sound decoder starts working now,
-	  at least for some standards.
-	  FOR ANY REPORTS ON THIS PLEASE MENTION THE TV NORM YOU ARE
-	  USING.
-	- Most tuner chips do provide mono sound, which may or may not
-	  be useable depending on the board design.  With the Hauppauge
-	  cards it works, so there is mono sound available as fallback.
+	- Works. The TV standard detection is made by the driver, as the
+	  hardware has bugs to auto-detect.
 	- audio data dma (i.e. recording without loopback cable to the
 	  sound card) is supported via cx88-alsa.
 
 vbi
-	- Code present. Works for NTSC closed caption. PAL and other
-	  TV norms may or may not work.
+	- Works.
 
 
-how to add support for new cards
+How to add support for new cards
 --------------------------------
 
 The driver needs some config info for the TV cards.  This stuff is in
@@ -53,24 +40,19 @@ like this one:
 If your card is listed as "board: UNKNOWN/GENERIC" it is unknown to
 the driver.  What to do then?
 
- (1) Try upgrading to the latest snapshot, maybe it has been added
-     meanwhile.
- (2) You can try to create a new entry yourself, have a look at
-     cx88-cards.c.  If that worked, mail me your changes as unified
-     diff ("diff -u").
- (3) Or you can mail me the config information.  I need at least the
-     following information to add the card:
+1) Try upgrading to the latest snapshot, maybe it has been added
+   meanwhile.
+2) You can try to create a new entry yourself, have a look at
+   cx88-cards.c.  If that worked, mail me your changes as unified
+   diff ("diff -u").
+3) Or you can mail me the config information.  We need at least the
+   following information to add the card:
 
-     * the PCI Subsystem ID ("0070:3400" from the line above,
+     - the PCI Subsystem ID ("0070:3400" from the line above,
        "lspci -v" output is fine too).
-     * the tuner type used by the card.  You can try to find one by
+     - the tuner type used by the card.  You can try to find one by
        trial-and-error using the tuner=<n> insmod option.  If you
        know which one the card has you can also have a look at the
        list in CARDLIST.tuner
 
-Have fun,
 
-  Gerd
-
---
-Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
-- 
2.7.4

