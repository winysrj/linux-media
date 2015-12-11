Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37550 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbbLKRRM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:12 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 06/10] [media] v4l: vsp1: remove pads prefix from *_create_pads_links()
Date: Fri, 11 Dec 2015 14:16:32 -0300
Message-Id: <1449854196-13296-7-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The functions that create entities links are called *_create_pads_links()
but the "pads" prefix is redundant since the driver doesn't handle any
other kind of link so it can be removed.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>


This patch addresses an issue Laurent pointed in patch [0]:

- Could you please s/pads_links/links/ and s/pads links/links/

[0]: http://www.spinics.net/lists/linux-media/msg95316.html
END

---

 drivers/media/platform/vsp1/vsp1_drv.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_rpf.c  | 4 ++--
 drivers/media/platform/vsp1/vsp1_rwpf.h | 4 ++--
 drivers/media/platform/vsp1/vsp1_wpf.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 8f995d267646..4209d8615f72 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -261,14 +261,14 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	/* Create links. */
 	list_for_each_entry(entity, &vsp1->entities, list_dev) {
 		if (entity->type == VSP1_ENTITY_LIF) {
-			ret = vsp1_wpf_create_pads_links(vsp1, entity);
+			ret = vsp1_wpf_create_links(vsp1, entity);
 			if (ret < 0)
 				goto done;
 			continue;
 		}
 
 		if (entity->type == VSP1_ENTITY_RPF) {
-			ret = vsp1_rpf_create_pads_links(vsp1, entity);
+			ret = vsp1_rpf_create_links(vsp1, entity);
 			if (ret < 0)
 				goto done;
 			continue;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 847fb6d01a5a..924538223d3e 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -285,13 +285,13 @@ error:
 }
 
 /*
- * vsp1_rpf_create_pads_links_create_pads_links() - RPF pads links creation
+ * vsp1_rpf_create_links() - RPF pads links creation
  * @vsp1: Pointer to VSP1 device
  * @entity: Pointer to VSP1 entity
  *
  * return negative error code or zero on success
  */
-int vsp1_rpf_create_pads_links(struct vsp1_device *vsp1,
+int vsp1_rpf_create_links(struct vsp1_device *vsp1,
 			       struct vsp1_entity *entity)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 6638b3587369..731d36e5258d 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -50,9 +50,9 @@ static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
-int vsp1_rpf_create_pads_links(struct vsp1_device *vsp1,
+int vsp1_rpf_create_links(struct vsp1_device *vsp1,
 			       struct vsp1_entity *entity);
-int vsp1_wpf_create_pads_links(struct vsp1_device *vsp1,
+int vsp1_wpf_create_links(struct vsp1_device *vsp1,
 			       struct vsp1_entity *entity);
 
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 969278bc1d41..cbf514a6582d 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -285,13 +285,13 @@ error:
 }
 
 /*
- * vsp1_wpf_create_pads_links_create_pads_links() - RPF pads links creation
+ * vsp1_wpf_create_links() - RPF pads links creation
  * @vsp1: Pointer to VSP1 device
  * @entity: Pointer to VSP1 entity
  *
  * return negative error code or zero on success
  */
-int vsp1_wpf_create_pads_links(struct vsp1_device *vsp1,
+int vsp1_wpf_create_links(struct vsp1_device *vsp1,
 			       struct vsp1_entity *entity)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
-- 
2.4.3

