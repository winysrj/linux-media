Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41460 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbcGHNEF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:05 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 22/54] doc-rst: media-ioc-g-topology: Fix tables
Date: Fri,  8 Jul 2016 10:03:14 -0300
Message-Id: <8926814ec741d1dd3d2ec37fd780a2718b152a2e.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tables were not properly converted. It looked a little
ackward already at DocBook, but the conversion made it worse.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/mediactl/media-ioc-g-topology.rst        | 63 +++-------------------
 1 file changed, 6 insertions(+), 57 deletions(-)

diff --git a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
index badcdf6133e2..1f2d530aa284 100644
--- a/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
+++ b/Documentation/linux_tv/media/mediactl/media-ioc-g-topology.rst
@@ -54,6 +54,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_topology
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 2 8
 
 
     -  .. row 1
@@ -62,8 +63,6 @@ desired arrays with the media graph elements.
 
        -  ``topology_version``
 
-       -
-       -
        -  Version of the media graph topology. When the graph is created,
 	  this field starts with zero. Every time a graph element is added
 	  or removed, this field is incremented.
@@ -74,8 +73,6 @@ desired arrays with the media graph elements.
 
        -  ``num_entities``
 
-       -
-       -
        -  Number of entities in the graph
 
     -  .. row 3
@@ -84,8 +81,6 @@ desired arrays with the media graph elements.
 
        -  ``ptr_entities``
 
-       -
-       -
        -  A pointer to a memory area where the entities array will be
 	  stored, converted to a 64-bits integer. It can be zero. if zero,
 	  the ioctl won't store the entities. It will just update
@@ -97,8 +92,6 @@ desired arrays with the media graph elements.
 
        -  ``num_interfaces``
 
-       -
-       -
        -  Number of interfaces in the graph
 
     -  .. row 5
@@ -107,8 +100,6 @@ desired arrays with the media graph elements.
 
        -  ``ptr_interfaces``
 
-       -
-       -
        -  A pointer to a memory area where the interfaces array will be
 	  stored, converted to a 64-bits integer. It can be zero. if zero,
 	  the ioctl won't store the interfaces. It will just update
@@ -120,8 +111,6 @@ desired arrays with the media graph elements.
 
        -  ``num_pads``
 
-       -
-       -
        -  Total number of pads in the graph
 
     -  .. row 7
@@ -130,8 +119,6 @@ desired arrays with the media graph elements.
 
        -  ``ptr_pads``
 
-       -
-       -
        -  A pointer to a memory area where the pads array will be stored,
 	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
 	  won't store the pads. It will just update ``num_pads``
@@ -142,8 +129,6 @@ desired arrays with the media graph elements.
 
        -  ``num_links``
 
-       -
-       -
        -  Total number of data and interface links in the graph
 
     -  .. row 9
@@ -152,8 +137,6 @@ desired arrays with the media graph elements.
 
        -  ``ptr_links``
 
-       -
-       -
        -  A pointer to a memory area where the links array will be stored,
 	  converted to a 64-bits integer. It can be zero. if zero, the ioctl
 	  won't store the links. It will just update ``num_links``
@@ -165,6 +148,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_entity
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 2 8
 
 
     -  .. row 1
@@ -173,8 +157,6 @@ desired arrays with the media graph elements.
 
        -  ``id``
 
-       -
-       -
        -  Unique ID for the entity.
 
     -  .. row 2
@@ -183,8 +165,6 @@ desired arrays with the media graph elements.
 
        -  ``name``\ [64]
 
-       -
-       -
        -  Entity name as an UTF-8 NULL-terminated string.
 
     -  .. row 3
@@ -193,8 +173,6 @@ desired arrays with the media graph elements.
 
        -  ``function``
 
-       -
-       -
        -  Entity main function, see :ref:`media-entity-type` for details.
 
     -  .. row 4
@@ -213,7 +191,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
-
+    :widths: 1 2 8
 
     -  .. row 1
 
@@ -221,8 +199,6 @@ desired arrays with the media graph elements.
 
        -  ``id``
 
-       -
-       -
        -  Unique ID for the interface.
 
     -  .. row 2
@@ -231,8 +207,6 @@ desired arrays with the media graph elements.
 
        -  ``intf_type``
 
-       -
-       -
        -  Interface type, see :ref:`media-intf-type` for details.
 
     -  .. row 3
@@ -241,8 +215,6 @@ desired arrays with the media graph elements.
 
        -  ``flags``
 
-       -
-       -
        -  Interface flags. Currently unused.
 
     -  .. row 4
@@ -251,8 +223,6 @@ desired arrays with the media graph elements.
 
        -  ``reserved``\ [9]
 
-       -
-       -
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
@@ -262,8 +232,6 @@ desired arrays with the media graph elements.
 
        -  ``devnode``
 
-       -
-       -
        -  Used only for device node interfaces. See
 	  :ref:`media-v2-intf-devnode` for details..
 
@@ -274,6 +242,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_interface
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 2 8
 
 
     -  .. row 1
@@ -282,8 +251,6 @@ desired arrays with the media graph elements.
 
        -  ``major``
 
-       -
-       -
        -  Device node major number.
 
     -  .. row 2
@@ -292,8 +259,6 @@ desired arrays with the media graph elements.
 
        -  ``minor``
 
-       -
-       -
        -  Device node minor number.
 
 
@@ -303,6 +268,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 2 8
 
 
     -  .. row 1
@@ -311,8 +277,6 @@ desired arrays with the media graph elements.
 
        -  ``id``
 
-       -
-       -
        -  Unique ID for the pad.
 
     -  .. row 2
@@ -321,8 +285,6 @@ desired arrays with the media graph elements.
 
        -  ``entity_id``
 
-       -
-       -
        -  Unique ID for the entity where this pad belongs.
 
     -  .. row 3
@@ -331,8 +293,6 @@ desired arrays with the media graph elements.
 
        -  ``flags``
 
-       -
-       -
        -  Pad flags, see :ref:`media-pad-flag` for more details.
 
     -  .. row 4
@@ -341,8 +301,6 @@ desired arrays with the media graph elements.
 
        -  ``reserved``\ [9]
 
-       -
-       -
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
@@ -353,6 +311,7 @@ desired arrays with the media graph elements.
 .. flat-table:: struct media_v2_pad
     :header-rows:  0
     :stub-columns: 0
+    :widths: 1 2 8
 
 
     -  .. row 1
@@ -361,8 +320,6 @@ desired arrays with the media graph elements.
 
        -  ``id``
 
-       -
-       -
        -  Unique ID for the pad.
 
     -  .. row 2
@@ -371,8 +328,6 @@ desired arrays with the media graph elements.
 
        -  ``source_id``
 
-       -
-       -
        -  On pad to pad links: unique ID for the source pad.
 
 	  On interface to entity links: unique ID for the interface.
@@ -383,8 +338,6 @@ desired arrays with the media graph elements.
 
        -  ``sink_id``
 
-       -
-       -
        -  On pad to pad links: unique ID for the sink pad.
 
 	  On interface to entity links: unique ID for the entity.
@@ -395,8 +348,6 @@ desired arrays with the media graph elements.
 
        -  ``flags``
 
-       -
-       -
        -  Link flags, see :ref:`media-link-flag` for more details.
 
     -  .. row 5
@@ -405,8 +356,6 @@ desired arrays with the media graph elements.
 
        -  ``reserved``\ [5]
 
-       -
-       -
        -  Reserved for future extensions. Drivers and applications must set
 	  this array to zero.
 
-- 
2.7.4

