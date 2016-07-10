Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60610 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 5/6] [media] doc-rst: add LIRC header to the book
Date: Sun, 10 Jul 2016 07:47:44 -0300
Message-Id: <446c926f89b29c84050f20e44070df8b62ec5c62.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
In-Reply-To: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
References: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like the other parts of the document, let's add the LIRC
header, as it is part of the API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/Makefile                       | 5 ++++-
 Documentation/media/lirc.h.rst.exceptions          | 2 ++
 Documentation/media/uapi/rc/remote_controllers.rst | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/lirc.h.rst.exceptions

diff --git a/Documentation/media/Makefile b/Documentation/media/Makefile
index bcb9eb5921aa..39e2d766dbe3 100644
--- a/Documentation/media/Makefile
+++ b/Documentation/media/Makefile
@@ -6,7 +6,7 @@ KAPI = $(srctree)/include/linux
 SRC_DIR=$(srctree)/Documentation/media
 
 FILES = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
-	  videodev2.h.rst media.h.rst cec.h.rst
+	  videodev2.h.rst media.h.rst cec.h.rst lirc.h.rst
 
 TARGETS := $(addprefix $(BUILDDIR)/, $(FILES))
 
@@ -53,5 +53,8 @@ $(BUILDDIR)/media.h.rst: ${UAPI}/media.h ${PARSER} $(SRC_DIR)/media.h.rst.except
 $(BUILDDIR)/cec.h.rst: ${KAPI}/cec.h ${PARSER} $(SRC_DIR)/cec.h.rst.exceptions
 	@$($(quiet)gen_rst)
 
+$(BUILDDIR)/lirc.h.rst: ${UAPI}/lirc.h ${PARSER} $(SRC_DIR)/lirc.h.rst.exceptions
+	@$($(quiet)gen_rst)
+
 cleandocs:
 	-rm ${TARGETS}
diff --git a/Documentation/media/lirc.h.rst.exceptions b/Documentation/media/lirc.h.rst.exceptions
new file mode 100644
index 000000000000..efdcb59f3002
--- /dev/null
+++ b/Documentation/media/lirc.h.rst.exceptions
@@ -0,0 +1,2 @@
+# Ignore header name
+ignore define _LINUX_LIRC_H
diff --git a/Documentation/media/uapi/rc/remote_controllers.rst b/Documentation/media/uapi/rc/remote_controllers.rst
index 82e64e7acbe3..3e9731afedd9 100644
--- a/Documentation/media/uapi/rc/remote_controllers.rst
+++ b/Documentation/media/uapi/rc/remote_controllers.rst
@@ -24,6 +24,7 @@ Remote Controllers
     rc-tables
     rc-table-change
     lirc_device_interface
+    lirc-header
 
 
 **********************
-- 
2.7.4

