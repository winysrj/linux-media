Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33432
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752367AbdI0VrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 17/17] media: media-entity.h: add kernel-doc markups for nested structs
Date: Wed, 27 Sep 2017 18:47:00 -0300
Message-Id: <f35ac48eb41b23a3f27a427d5219eb51f82e7738.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that nested structs are parsed by kernel-doc, add markups
to them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/media-entity.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 222d379960b7..d7a669058b5e 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -88,6 +88,8 @@ struct media_entity_enum {
  * @stack:		Graph traversal stack; the stack contains information
  *			on the path the media entities to be walked and the
  *			links through which they were reached.
+ * @stack.entity:	pointer to &struct media_entity at the graph.
+ * @stack.link:		pointer to &struct list_head.
  * @ent_enum:		Visited entities
  * @top:		The top of the stack
  */
@@ -247,6 +249,9 @@ enum media_entity_type {
  * @pipe:	Pipeline this entity belongs to.
  * @info:	Union with devnode information.  Kept just for backward
  *		compatibility.
+ * @info.dev:	Contains device major and minor info.
+ * @info.dev.major: device node major, if the device is a devnode.
+ * @info.dev.minor: device node minor, if the device is a devnode.
  * @major:	Devnode major number (zero if not applicable). Kept just
  *		for backward compatibility.
  * @minor:	Devnode minor number (zero if not applicable). Kept just
-- 
2.13.5
