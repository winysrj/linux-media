Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcGQOaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 10:30:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 2/7] [media] doc-rst: media_drivers.rst: Fix paragraph headers for MC
Date: Sun, 17 Jul 2016 11:29:59 -0300
Message-Id: <45330118e82a5816798e2200655e7f940d03dce0.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
In-Reply-To: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
References: <1ee08125cf954ca3ffd8fad633a54f4f1af28afc.1468765739.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the paragraph identation for the media controller
headers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/media_drivers.rst | 41 ++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/Documentation/media/media_drivers.rst b/Documentation/media/media_drivers.rst
index 722170cb7f40..507a40f69d05 100644
--- a/Documentation/media/media_drivers.rst
+++ b/Documentation/media/media_drivers.rst
@@ -183,7 +183,8 @@ The media controller userspace API is documented in DocBook format in
 Documentation/DocBook/media/v4l/media-controller.xml. This document focus
 on the kernel-side implementation of the media framework.
 
-* Abstract media device model:
+Abstract media device model
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Discovering a device internal topology, and configuring it at runtime, is one
 of the goals of the media framework. To achieve this, hardware devices are
@@ -205,8 +206,8 @@ A link is a point-to-point oriented connection between two pads, either
 on the same entity or on different entities. Data flows from a source
 pad to a sink pad.
 
-
-* Media device:
+Media device
+^^^^^^^^^^^^
 
 A media device is represented by a struct &media_device instance, defined in
 include/media/media-device.h. Allocation of the structure is handled by the
@@ -218,9 +219,8 @@ __media_device_register() via the macro media_device_register()
 and unregistered by calling
 media_device_unregister().
 
-* Entities, pads and links:
-
-- Entities
+Entities
+^^^^^^^^
 
 Entities are represented by a struct &media_entity instance, defined in
 include/media/media-entity.h. The structure is usually embedded into a
@@ -235,7 +235,8 @@ media_device_register_entity()
 and unregistred by calling
 media_device_unregister_entity().
 
-- Interfaces
+Interfaces
+^^^^^^^^^^
 
 Interfaces are represented by a struct &media_interface instance, defined in
 include/media/media-entity.h. Currently, only one type of interface is
@@ -247,8 +248,8 @@ media_devnode_create()
 and remove them by calling:
 media_devnode_remove().
 
-- Pads
-
+Pads
+^^^^
 Pads are represented by a struct &media_pad instance, defined in
 include/media/media-entity.h. Each entity stores its pads in a pads array
 managed by the entity driver. Drivers usually embed the array in a
@@ -267,7 +268,8 @@ Pads have flags that describe the pad capabilities and state.
 NOTE: One and only one of %MEDIA_PAD_FL_SINK and %MEDIA_PAD_FL_SOURCE must
 be set for each pad.
 
-- Links
+Links
+^^^^^
 
 Links are represented by a struct &media_link instance, defined in
 include/media/media-entity.h. There are two types of links:
@@ -289,15 +291,16 @@ Associate one interface to a Link.
 Drivers create interface to entity links by calling:
 media_create_intf_link() and remove with media_remove_intf_links().
 
-NOTE:
+.. note::
 
-Links can only be created after having both ends already created.
+   Links can only be created after having both ends already created.
 
 Links have flags that describe the link capabilities and state. The
 valid values are described at media_create_pad_link() and
 media_create_intf_link().
 
-Graph traversal:
+Graph traversal
+^^^^^^^^^^^^^^^
 
 The media framework provides APIs to iterate over entities in a graph.
 
@@ -339,7 +342,8 @@ Helper functions can be used to find a link between two given pads, or a pad
 connected to another pad through an enabled link
 media_entity_find_link() and media_entity_remote_pad()
 
-Use count and power handling:
+Use count and power handling
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Due to the wide differences between drivers regarding power management
 needs, the media controller does not implement power management. However,
@@ -351,12 +355,14 @@ The &media_entity.@use_count field is owned by media drivers and must not be
 touched by entity drivers. Access to the field must be protected by the
 &media_device.@graph_mutex lock.
 
-Links setup:
+Links setup
+^^^^^^^^^^^
 
 Link properties can be modified at runtime by calling
 media_entity_setup_link()
 
-Pipelines and media streams:
+Pipelines and media streams
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 When starting streaming, drivers must notify all entities in the pipeline to
 prevent link states from being modified during streaming by calling
@@ -392,7 +398,8 @@ changing entities configuration parameters) drivers can explicitly check the
 media_entity stream_count field to find out if an entity is streaming. This
 operation must be done with the media_device graph_mutex held.
 
-Link validation:
+Link validation
+^^^^^^^^^^^^^^^
 
 Link validation is performed by media_entity_pipeline_start() for any
 entity which has sink pads in the pipeline. The
-- 
2.7.4

