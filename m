Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbLKNeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-doc@vger.kernel.org
Subject: [PATCH 04/10] media-entity.h: get rid of revision and group_id fields
Date: Fri, 11 Dec 2015 11:34:09 -0200
Message-Id: <434fe402a7b41a8d0b27bb5ab421a204007de4c2.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both revision and group_id fields were never used and were always
initialized to zero. Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml | 13 ++-----------
 Documentation/media-framework.txt                           | 12 +++++-------
 drivers/media/media-device.c                                |  4 ++--
 include/media/media-entity.h                                |  4 ----
 4 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 27f8817e7abe..9f7614a01234 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -59,15 +59,6 @@
     <para>Entity IDs can be non-contiguous. Applications must
     <emphasis>not</emphasis> try to enumerate entities by calling
     MEDIA_IOC_ENUM_ENTITIES with increasing id's until they get an error.</para>
-    <para>Two or more entities that share a common non-zero
-    <structfield>group_id</structfield> value are considered as logically
-    grouped. Groups are used to report
-    <itemizedlist>
-      <listitem><para>ALSA, VBI and video nodes that carry the same media
-      stream</para></listitem>
-      <listitem><para>lens and flash controllers associated with a sensor</para></listitem>
-    </itemizedlist>
-    </para>
 
     <table pgwide="1" frame="none" id="media-entity-desc">
       <title>struct <structname>media_entity_desc</structname></title>
@@ -106,7 +97,7 @@
 	    <entry><structfield>revision</structfield></entry>
 	    <entry></entry>
 	    <entry></entry>
-	    <entry>Entity revision in a driver/hardware specific format.</entry>
+	    <entry>Entity revision. Always zero (obsolete)</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -120,7 +111,7 @@
 	    <entry><structfield>group_id</structfield></entry>
 	    <entry></entry>
 	    <entry></entry>
-	    <entry>Entity group ID</entry>
+	    <entry>Entity group ID. Always zero (obsolete)</entry>
 	  </row>
 	  <row>
 	    <entry>__u16</entry>
diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 7fbfe4bd1f47..ef3663af1db3 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -110,10 +110,10 @@ If no pads are needed, drivers could directly fill entity->num_pads
 with 0 and entity->pads with NULL or to call the above function that
 will do the same.
 
-The media_entity name, type, flags, revision and group_id fields should be
-initialized before calling media_device_register_entity(). Entities embedded
-in higher-level standard structures can have some of those fields set by the
-higher-level framework.
+The media_entity name, type and flags fields should be initialized before
+calling media_device_register_entity(). Entities embedded in higher-level
+standard structures can have some of those fields set by the higher-level
+framework.
 
 As the number of pads is known in advance, the pads array is not allocated
 dynamically but is managed by the entity driver. Most drivers will embed the
@@ -164,9 +164,7 @@ Entities have flags that describe the entity capabilities and state.
 
 Logical entity groups can be defined by setting the group ID of all member
 entities to the same non-zero value. An entity group serves no purpose in the
-kernel, but is reported to userspace during entities enumeration. The group_id
-field belongs to the media device driver and must not by touched by entity
-drivers.
+kernel, but is reported to userspace during entities enumeration.
 
 Media device drivers should define groups if several entities are logically
 bound together. Example usages include reporting
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index b8cd7733a31c..537160bb461e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -109,9 +109,9 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (ent->name)
 		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
 	u_ent.type = ent->function;
-	u_ent.revision = ent->revision;
+	u_ent.revision = 0;		/* Unused */
 	u_ent.flags = ent->flags;
-	u_ent.group_id = ent->group_id;
+	u_ent.group_id = 0;		/* Unused */
 	u_ent.pads = ent->num_pads;
 	u_ent.links = ent->num_links - ent->num_backlinks;
 	memcpy(&u_ent.raw, &ent->info, sizeof(ent->info));
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 32fef503d950..031536723d8c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -153,9 +153,7 @@ struct media_entity_operations {
  * @name:	Entity name.
  * @function:	Entity main function, as defined in uapi/media.h
  *		(MEDIA_ENT_F_*)
- * @revision:	Entity revision - OBSOLETE - should be removed soon.
  * @flags:	Entity flags, as defined in uapi/media.h (MEDIA_ENT_FL_*)
- * @group_id:	Entity group ID - OBSOLETE - should be removed soon.
  * @num_pads:	Number of sink and source pads.
  * @num_links:	Total number of links, forward and back, enabled and disabled.
  * @num_backlinks: Number of backlinks
@@ -180,9 +178,7 @@ struct media_entity {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	const char *name;
 	u32 function;
-	u32 revision;
 	unsigned long flags;
-	u32 group_id;
 
 	u16 num_pads;
 	u16 num_links;
-- 
2.5.0


