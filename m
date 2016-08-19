Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43227 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754931AbcHSNFO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 11/15] [media] media-types.rst: adjust tables to fit on LaTeX output
Date: Fri, 19 Aug 2016 10:05:01 -0300
Message-Id: <4c09bcb0af4ca441e7f06dacd88dffdec4f9ef1e.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few tables at the media uAPI documentation have columns
not well dimentioned. Adjust them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index c77717b236ce..20f99301bfdb 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -5,9 +5,12 @@
 Types and flags used to represent the media graph elements
 ==========================================================
 
+..  tabularcolumns:: |p{8.0cm}|p{10.5cm}|
 
 .. _media-entity-type:
 
+.. cssclass:: longtable
+
 .. flat-table:: Media entity types
     :header-rows:  0
     :stub-columns: 0
@@ -15,10 +18,12 @@ Types and flags used to represent the media graph elements
 
     -  .. row 1
 
-       ..  _MEDIA-ENT-F-UNKNOWN:
+       .. _MEDIA-ENT-F-UNKNOWN:
        .. _MEDIA-ENT-F-V4L2-SUBDEV-UNKNOWN:
 
-       -  ``MEDIA_ENT_F_UNKNOWN`` and ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
+       -  ``MEDIA_ENT_F_UNKNOWN`` and
+
+	  ``MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN``
 
        -  Unknown entity. That generally indicates that a driver didn't
 	  initialize properly the entity, with is a Kernel bug
@@ -294,6 +299,8 @@ Types and flags used to represent the media graph elements
 	  its source pad.
 
 
+..  tabularcolumns:: |p{5.5cm}|p{12.0cm}|
+
 .. _media-entity-flag:
 
 .. flat-table:: Media entity flags
@@ -319,6 +326,7 @@ Types and flags used to represent the media graph elements
        -  The entity represents a data conector
 
 
+..  tabularcolumns:: |p{6.5cm}|p{6.0cm}|p{5.0cm}|
 
 .. _media-intf-type:
 
@@ -508,6 +516,7 @@ Types and flags used to represent the media graph elements
        -  typically, /dev/snd/timer
 
 
+.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-pad-flag:
 
@@ -551,6 +560,7 @@ Types and flags used to represent the media graph elements
 One and only one of ``MEDIA_PAD_FL_SINK`` and ``MEDIA_PAD_FL_SOURCE``
 must be set for every pad.
 
+.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
 
 .. _media-link-flag:
 
-- 
2.7.4


