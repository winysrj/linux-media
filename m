Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbcGEBbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 31/41] Documentation: buffer.rst: numerate tables
Date: Mon,  4 Jul 2016 22:31:06 -0300
Message-Id: <fdf854733aafa030ca10316ab52cdb6300def563.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx actually  doesn't numerate tables. So, let's add a
subtitle before each table. That makes them numerated.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/buffer.rst | 38 +++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/buffer.rst b/Documentation/linux_tv/media/v4l/buffer.rst
index 4381110e2571..b195eb5b63a1 100644
--- a/Documentation/linux_tv/media/v4l/buffer.rst
+++ b/Documentation/linux_tv/media/v4l/buffer.rst
@@ -36,6 +36,9 @@ buffer.
 
 .. _v4l2-buffer:
 
+struct v4l2_buffer
+==================
+
 .. flat-table:: struct v4l2_buffer
     :header-rows:  0
     :stub-columns: 0
@@ -273,7 +276,10 @@ buffer.
 
 .. _v4l2-plane:
 
-.. flat-table:: struct v4l2_plane
+struct v4l2_plane
+=================
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 1 2
@@ -380,7 +386,10 @@ buffer.
 
 .. _v4l2-buf-type:
 
-.. flat-table:: enum v4l2_buf_type
+enum v4l2_buf_type
+==================
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -491,7 +500,10 @@ buffer.
 
 .. _buffer-flags:
 
-.. flat-table:: Buffer Flags
+Buffer Flags
+============
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -737,7 +749,10 @@ buffer.
 
 .. _v4l2-memory:
 
-.. flat-table:: enum v4l2_memory
+enum v4l2_memory
+================
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -788,7 +803,10 @@ The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
 
 .. _v4l2-timecode:
 
-.. flat-table:: struct v4l2_timecode
+struct v4l2_timecode
+--------------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       1 1 2
@@ -855,7 +873,10 @@ The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
 
 .. _timecode-type:
 
-.. flat-table:: Timecode Types
+Timecode Types
+--------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
@@ -905,7 +926,10 @@ The :ref:`struct v4l2_timecode <v4l2-timecode>` structure is designed to hold a
 
 .. _timecode-flags:
 
-.. flat-table:: Timecode Flags
+Timecode Flags
+--------------
+
+.. flat-table::
     :header-rows:  0
     :stub-columns: 0
     :widths:       3 1 4
-- 
2.7.4

