Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755202AbcHSPEw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 11:04:52 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 2/2] [media] Fix a few additional tables at uAPI for LaTeX output
Date: Fri, 19 Aug 2016 12:04:40 -0300
Message-Id: <3acd174d5652598c91cbf0eb4f5726c991ff77a6.1471618226.git.mchehab@s-opensource.com>
In-Reply-To: <411888a5abc400c7ca33573435d9a4bbce91a4dc.1471618226.git.mchehab@s-opensource.com>
References: <411888a5abc400c7ca33573435d9a4bbce91a4dc.1471618226.git.mchehab@s-opensource.com>
In-Reply-To: <411888a5abc400c7ca33573435d9a4bbce91a4dc.1471618226.git.mchehab@s-opensource.com>
References: <411888a5abc400c7ca33573435d9a4bbce91a4dc.1471618226.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are still a few tables with wrong columns at the uAPI
docs. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/dvb/fe-get-info.rst            | 2 +-
 Documentation/media/uapi/dvb/fe_property_parameters.rst | 5 ++---
 Documentation/media/uapi/v4l/buffer.rst                 | 2 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst             | 2 +-
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst     | 2 +-
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/media/uapi/dvb/fe-get-info.rst b/Documentation/media/uapi/dvb/fe-get-info.rst
index 85973be62b0c..87ff3f62050d 100644
--- a/Documentation/media/uapi/dvb/fe-get-info.rst
+++ b/Documentation/media/uapi/dvb/fe-get-info.rst
@@ -160,7 +160,7 @@ frontend capabilities
 Capabilities describe what a frontend can do. Some capabilities are
 supported only on some specific frontend types.
 
-.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
+.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
 .. _fe-caps:
 
diff --git a/Documentation/media/uapi/dvb/fe_property_parameters.rst b/Documentation/media/uapi/dvb/fe_property_parameters.rst
index d7acc72ebbdf..304ac1a3c2ff 100644
--- a/Documentation/media/uapi/dvb/fe_property_parameters.rst
+++ b/Documentation/media/uapi/dvb/fe_property_parameters.rst
@@ -1005,10 +1005,9 @@ Possible values: 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, -1 (AUTO)
 Note: Truth table for ``DTV_ISDBT_SOUND_BROADCASTING`` and
 ``DTV_ISDBT_PARTIAL_RECEPTION`` and ``LAYER[A-C]_SEGMENT_COUNT``
 
-
 .. _isdbt-layer_seg-cnt-table:
 
-.. flat-table::
+.. flat-table:: Truth table for ISDB-T Sound Broadcasting
     :header-rows:  0
     :stub-columns: 0
 
@@ -1101,7 +1100,7 @@ TMCC-structure, as shown in the table below.
 
 .. _isdbt-layer-interleaving-table:
 
-.. flat-table::
+.. flat-table:: ISDB-T time interleaving modes
     :header-rows:  0
     :stub-columns: 0
 
diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index 4d315b01c2a4..7bab30b59eae 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -39,7 +39,7 @@ buffer.
 struct v4l2_buffer
 ==================
 
-.. tabularcolumns:: |p{1.3cm}|p{2.5cm}|p{1.3cm}|p{12.0cm}|
+.. tabularcolumns:: |p{2.8cm}|p{2.5cm}|p{1.3cm}|p{10.5cm}|
 
 .. cssclass:: longtable
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-003.rst
index 4a2dbe1095b1..6ec8ce639764 100644
--- a/Documentation/media/uapi/v4l/pixfmt-003.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-003.rst
@@ -49,7 +49,7 @@ describing all planes of that format.
 	  applications.
 
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.4cm}|p{5.6cm}|p{7.5cm}|
 
 .. _v4l2-pix-format-mplane:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 5b80481d8734..f0d33298f329 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -229,7 +229,7 @@ still cause this situation.
 	  ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
 
 
-.. tabularcolumns:: |p{4.0cm}|p{3.0cm}|p{2.0cm}|p{8.5cm}|
+.. tabularcolumns:: |p{4.0cm}|p{2.0cm}|p{2.0cm}|p{8.5cm}|
 
 .. _v4l2-ext-controls:
 
-- 
2.7.4

