Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35605 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754630AbcHSDo5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:44:57 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 10/20] [media] buffer.rst: Adjust table columns for LaTeX output
Date: Thu, 18 Aug 2016 13:15:39 -0300
Message-Id: <876cec7bec35cd23e97fffdedd595cc10ae5335d.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table columns are not properly displayed. Also, some
tables are too big to fit into just one page. So, fix them,
in order to better display the tables.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/buffer.rst | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 064bc03b7a1d..4d315b01c2a4 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -39,12 +39,14 @@ buffer.
 struct v4l2_buffer
 ==================
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+.. tabularcolumns:: |p{1.3cm}|p{2.5cm}|p{1.3cm}|p{12.0cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_buffer
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 1 2
+    :widths:       1 2 1 10
 
 
     -  .. row 1
@@ -286,6 +288,8 @@ struct v4l2_plane
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. cssclass:: longtable
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -403,12 +407,14 @@ struct v4l2_plane
 enum v4l2_buf_type
 ==================
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. cssclass:: longtable
+
+.. tabularcolumns:: |p{7.2cm}|p{0.6cm}|p{9.7cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       3 1 4
+    :widths:       4 1 9
 
 
     -  .. row 1
@@ -519,7 +525,9 @@ enum v4l2_buf_type
 Buffer Flags
 ============
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{7.0cm}|p{2.2cm}|p{8.3cm}|
+
+.. cssclass:: longtable
 
 .. flat-table::
     :header-rows:  0
@@ -953,7 +961,7 @@ Timecode Types
 Timecode Flags
 --------------
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{6.6cm}|p{1.4cm}|p{9.5cm}|
 
 .. flat-table::
     :header-rows:  0
-- 
2.7.4


