Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207AbcGLMmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 08:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/20] [media] doc-rst: add media/uapi/rc/lirc-header.rst
Date: Tue, 12 Jul 2016 09:41:56 -0300
Message-Id: <2d14c31c00797f48f8938a77edc5bcd5f71e5c94.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468327191.git.mchehab@s-opensource.com>
References: <cover.1468327191.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 68cd5e0bed99 ("[media] doc-rst: add LIRC header to the book")
did everything but adding the lirc-reader.rst :-p

My fault: I forgot to do a git add for this guy on such
changeset.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/rc/lirc-header.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 Documentation/media/uapi/rc/lirc-header.rst

diff --git a/Documentation/media/uapi/rc/lirc-header.rst b/Documentation/media/uapi/rc/lirc-header.rst
new file mode 100644
index 000000000000..487fe00e5517
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-header.rst
@@ -0,0 +1,10 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_header:
+
+****************
+LIRC Header File
+****************
+
+.. kernel-include:: $BUILDDIR/lirc.h.rst
+
-- 
2.7.4


