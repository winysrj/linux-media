Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 02/51] Documentation: some fixups at linux_tv/index.rst
Date: Mon,  4 Jul 2016 08:46:23 -0300
Message-Id: <5d478ca0ac79daa7380d883b3cbabc984aa541d3.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some issues from the conversion and improve the documentation
a little bit, by adding two relevent keywords (SDR and DTMB).

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/index.rst | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/Documentation/linux_tv/index.rst b/Documentation/linux_tv/index.rst
index e6df371243d8..b0389cbfb1aa 100644
--- a/Documentation/linux_tv/index.rst
+++ b/Documentation/linux_tv/index.rst
@@ -12,7 +12,7 @@ Permission is granted to copy, distribute and/or modify this document
 under the terms of the GNU Free Documentation License, Version 1.1 or
 any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
-License"
+License".
 
 
 ============
@@ -21,8 +21,8 @@ Introduction
 
 This document covers the Linux Kernel to Userspace API's used by video
 and radio streaming devices, including video cameras, analog and digital
-TV receiver cards, AM/FM receiver cards, streaming capture and output
-devices, codec devices and remote controllers.
+TV receiver cards, AM/FM receiver cards, Software Defined Radio (SDR),
+streaming capture and output devices, codec devices and remote controllers.
 
 A typical media device hardware is shown at
 :ref:`typical_media_device`.
@@ -36,21 +36,17 @@ A typical media device hardware is shown at
 
     Typical Media Device
 
-    Typical Media Device Block Diagram
-
-
-
 The media infrastructure API was designed to control such devices. It is
 divided into four parts.
 
-The first part covers radio, video capture and output, cameras, analog
-TV devices and codecs.
+The first part covers radio, video capture and output,
+cameras, analog TV devices and codecs.
 
 The second part covers the API used for digital TV and Internet
 reception via one of the several digital tv standards. While it is
 called as DVB API, in fact it covers several different video standards
-including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S,etc. The
-complete list of supported standards can be found at
+including DVB-T/T2, DVB-S/S2, DVB-C, ATSC, ISDB-T, ISDB-S, DTMB, etc.
+The complete list of supported standards can be found at
 :ref:`fe-delivery-system-t`.
 
 The third part covers the Remote Controller API.
@@ -97,6 +93,3 @@ etc, please mail to:
   =========
 
   * :ref:`genindex`
-
-.. todolist::
-
-- 
2.7.4


