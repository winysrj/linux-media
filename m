Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbcGEBb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 38/41] Documentation: dev-sliced-vbi.rst: convert table captions into headers
Date: Mon,  4 Jul 2016 22:31:13 -0300
Message-Id: <c30b6538dcdf973f49c8e08758ef4de5eee99b04.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx doesn't format nice table captions, nor auto-numberate
them. So, convert tables into chapters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/v4l/dev-sliced-vbi.rst          | 45 +++++++++++++++++-----
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
index 8821e7c3c26c..fbd04fee0484 100644
--- a/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
+++ b/Documentation/linux_tv/media/v4l/dev-sliced-vbi.rst
@@ -102,7 +102,10 @@ which may return ``EBUSY`` can be the
 
 .. _v4l2-sliced-vbi-format:
 
-.. flat-table:: struct v4l2_sliced_vbi_format
+struct v4l2_sliced_vbi_format
+-----------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 3 2 2 2
@@ -244,7 +247,10 @@ which may return ``EBUSY`` can be the
 
 .. _vbi-services2:
 
-.. flat-table:: Sliced VBI services
+Sliced VBI services
+-------------------
+
+.. flat-table::
     :header-rows:  1
     :stub-columns: 0
     :widths:       2 1 1 2 2
@@ -362,7 +368,10 @@ of one video frame. The ``id`` of unused
 
 .. _v4l2-sliced-vbi-data:
 
-.. flat-table:: struct v4l2_sliced_vbi_data
+struct v4l2_sliced_vbi_data
+---------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -544,7 +553,10 @@ number).
 
 .. _v4l2-mpeg-vbi-fmt-ivtv:
 
-.. flat-table:: struct v4l2_mpeg_vbi_fmt_ivtv
+struct v4l2_mpeg_vbi_fmt_ivtv
+-----------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 1 2
@@ -596,7 +608,10 @@ number).
 
 .. _v4l2-mpeg-vbi-fmt-ivtv-magic:
 
-.. flat-table:: Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
+Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
+-------------------------------------------------------------
+
+.. flat-table::
     :header-rows:  1
     :stub-columns: 0
     :widths:       3 1 4
@@ -634,7 +649,10 @@ number).
 
 .. _v4l2-mpeg-vbi-itv0:
 
-.. flat-table:: struct v4l2_mpeg_vbi_itv0
+struct v4l2_mpeg_vbi_itv0
+-------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 2
@@ -688,7 +706,10 @@ number).
 
 .. _v4l2-mpeg-vbi-itv0-1:
 
-.. flat-table:: struct v4l2_mpeg_vbi_ITV0
+struct v4l2_mpeg_vbi_ITV0
+-------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 2
@@ -710,7 +731,10 @@ number).
 
 .. _v4l2-mpeg-vbi-itv0-line:
 
-.. flat-table:: struct v4l2_mpeg_vbi_itv0_line
+struct v4l2_mpeg_vbi_itv0_line
+------------------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 2
@@ -738,7 +762,10 @@ number).
 
 .. _ITV0-Line-Identifier-Constants:
 
-.. flat-table:: Line Identifiers for struct v4l2_mpeg_vbi_itv0_line id field
+Line Identifiers for struct v4l2_mpeg_vbi_itv0_line id field
+------------------------------------------------------------
+
+.. flat-table::
     :header-rows:  1
     :stub-columns: 0
     :widths:       3 1 4
-- 
2.7.4

