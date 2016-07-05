Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbcGEBb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:29 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 32/41] Documentation: buffer.rst: numerate tables and figures
Date: Mon,  4 Jul 2016 22:31:07 -0300
Message-Id: <976fdcc1adb1ec79e5e860eb94421032c0d92a3b.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx actually doesn't numerate tables nor figures. So,
let's add a subtitle before each table. That makes them
"numerated".

While here, fix the git binary that got corrupted.
Let's hope this will work, as the reason why we had
to encode them were to prevent some issues on commiting
those gif files on git.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/field-order.rst    |  14 ++++++++++----
 .../media/v4l/field-order_files/fieldseq_tb.gif     | Bin 25339 -> 25323 bytes
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/field-order.rst b/Documentation/linux_tv/media/v4l/field-order.rst
index d4e801cdae1a..979fedbb2bda 100644
--- a/Documentation/linux_tv/media/v4l/field-order.rst
+++ b/Documentation/linux_tv/media/v4l/field-order.rst
@@ -54,7 +54,10 @@ should have the value ``V4L2_FIELD_ANY`` (0).
 
 .. _v4l2-field:
 
-.. flat-table:: enum v4l2_field
+enum v4l2_field
+===============
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -183,17 +186,20 @@ should have the value ``V4L2_FIELD_ANY`` (0).
 
 .. _fieldseq-tb:
 
+Field Order, Top Field First Transmitted
+========================================
+
 .. figure::  field-order_files/fieldseq_tb.*
     :alt:    fieldseq_tb.pdf / fieldseq_tb.gif
     :align:  center
 
-    Field Order, Top Field First Transmitted
-
 
 .. _fieldseq-bt:
 
+Field Order, Bottom Field First Transmitted
+===========================================
+
 .. figure::  field-order_files/fieldseq_bt.*
     :alt:    fieldseq_bt.pdf / fieldseq_bt.gif
     :align:  center
 
-    Field Order, Bottom Field First Transmitted
diff --git a/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif b/Documentation/linux_tv/media/v4l/field-order_files/fieldseq_tb.gif
index bf1c3f1b50d5ff04b196659ca5c2629ec9deae03..718492f1cfc703e6553c3b0e2afc4b269258412b 100644
GIT binary patch
delta 41
xcmex;l=1aZ#tlL2Os*lDBiL^XF}VhAwv<ZXVsZ`GJYVI#F_UZ9<|z^BTmVl94*CE9

delta 57
zcmaETl=1gb#tlL2YzYajAqfeaL)dQ%f!KjSwxLu47l<7IWKULkZwz9G0og4P>0AJI
C85H6G

-- 
2.7.4

