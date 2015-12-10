Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59311 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbbLJRd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 12:33:29 -0500
Date: Thu, 10 Dec 2015 15:33:23 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 07/18] [media] dvbdev: returns error if graph object
 creation fails
Message-ID: <20151210153323.74e20ee6@recife.lan>
In-Reply-To: <55F2F14F.2060203@xs4all.nl>
References: <cover.1441559233.git.mchehab@osg.samsung.com>
	<53c51b68fe6dce9073746be61a23cca30c64ac9e.1441559233.git.mchehab@osg.samsung.com>
	<55F2F14F.2060203@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Sep 2015 17:20:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> > Right now, if something gets wrong at dvb_create_media_entity()
> > or at dvb_create_media_graph(), the device will still be
> > registered.
> > 
> > Change the logic to properly handle it and free all media graph
> > objects if something goes wrong at dvb_register_device().
> > 
> > Also, change the logic at dvb_create_media_graph() to return
> > an error code if something goes wrong. It is up to the
> > caller to implement the right logic and to call
> > dvb_unregister_device() to unregister the already-created
> > objects.
> > 
> > While here, add a missing logic to unregister the created
> > interfaces.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I did a lot of tests today with KASAN and I found some issues on
this patch. So, I'm folding it with the enclosed changes:

commit e919f3fc27a329814c064b4c3f110a4a4e80284c
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Thu Dec 10 10:48:00 2015 -0200

    fixup
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 5c51084a331a..bc650c637fc0 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -187,21 +187,32 @@ static void dvb_media_device_free(struct dvb_device *dvbdev)
 {
 #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	if (dvbdev->entity) {
+		media_device_unregister_entity(dvbdev->entity);
+		kfree(dvbdev->entity);
+		kfree(dvbdev->pads);
+		dvbdev->entity = NULL;
+		dvbdev->pads = NULL;
+	}
+
+	if (dvbdev->tsout_entity) {
 		int i;
 
 		for (i = 0; i < dvbdev->tsout_num_entities; i++) {
 			media_device_unregister_entity(&dvbdev->tsout_entity[i]);
 			kfree(dvbdev->tsout_entity[i].name);
 		}
-		media_device_unregister_entity(dvbdev->entity);
-
-		kfree(dvbdev->entity);
-		kfree(dvbdev->pads);
 		kfree(dvbdev->tsout_entity);
 		kfree(dvbdev->tsout_pads);
+		dvbdev->tsout_entity = NULL;
+		dvbdev->tsout_pads = NULL;
+
+		dvbdev->tsout_num_entities = 0;
 	}
-	if (dvbdev->intf_devnode)
+
+	if (dvbdev->intf_devnode) {
 		media_devnode_remove(dvbdev->intf_devnode);
+		dvbdev->intf_devnode = NULL;
+	}
 #endif
 }
 
@@ -221,13 +232,15 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 	if (!dvbdev->tsout_entity)
 		return -ENOMEM;
 
+	dvbdev->tsout_num_entities = npads;
+
 	for (i = 0; i < npads; i++) {
 		struct media_pad *pads = &dvbdev->tsout_pads[i];
 		struct media_entity *entity = &dvbdev->tsout_entity[i];
 
 		entity->name = kasprintf(GFP_KERNEL, "%s #%d", name, i);
 		if (!entity->name)
-			return ret;
+			return -ENOMEM;
 
 		entity->type = MEDIA_ENT_T_DVB_TSOUT;
 		pads->flags = MEDIA_PAD_FL_SINK;
@@ -318,9 +331,11 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 		dvbdev->pads[1].flags = MEDIA_PAD_FL_SOURCE;
 		break;
 	default:
+		/* Should never happen, as the first switch prevents it */
 		kfree(dvbdev->entity);
 		kfree(dvbdev->pads);
 		dvbdev->entity = NULL;
+		dvbdev->pads = NULL;
 		return 0;
 	}
 
@@ -423,24 +438,13 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENFILE;
 	}
 
-	*pdvbdev = dvbdev = kmalloc(sizeof(struct dvb_device), GFP_KERNEL);
+	*pdvbdev = dvbdev = kzalloc(sizeof(*dvbdev), GFP_KERNEL);
 
 	if (!dvbdev){
 		mutex_unlock(&dvbdev_register_lock);
 		return -ENOMEM;
 	}
 
-	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
-	if (ret) {
-		printk(KERN_ERR
-		      "%s: dvb_register_media_device failed to create the mediagraph\n",
-		      __func__);
-
-		dvb_media_device_free(dvbdev);
-		mutex_unlock(&dvbdev_register_lock);
-		return ret;
-	}
-
 	dvbdevfops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
 
 	if (!dvbdevfops){
@@ -483,6 +487,20 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	dvb_minors[minor] = dvbdev;
 	up_write(&minor_rwsem);
 
+	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
+	if (ret) {
+		printk(KERN_ERR
+		      "%s: dvb_register_media_device failed to create the mediagraph\n",
+		      __func__);
+
+		dvb_media_device_free(dvbdev);
+		kfree(dvbdevfops);
+		kfree(dvbdev);
+		up_write(&minor_rwsem);
+		mutex_unlock(&dvbdev_register_lock);
+		return ret;
+	}
+
 	mutex_unlock(&dvbdev_register_lock);
 
 	clsdev = device_create(dvb_class, adap->device,
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 96700843b1e4..c7d97190a67e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -576,6 +576,10 @@ void media_device_unregister(struct media_device *mdev)
 	struct media_entity *next;
 	struct media_interface *intf, *tmp_intf;
 
+	/* Remove all entities from the media device */
+	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
+		media_device_unregister_entity(entity);
+
 	/* Remove all interfaces from the media device */
 	spin_lock(&mdev->lock);
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
@@ -586,9 +590,6 @@ void media_device_unregister(struct media_device *mdev)
 	}
 	spin_unlock(&mdev->lock);
 
-	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
-		media_device_unregister_entity(entity);
-
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
 
@@ -654,8 +655,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 	/* Remove all interface links pointing to this entity */
 	list_for_each_entry(intf, &mdev->interfaces, graph_obj.list) {
 		list_for_each_entry_safe(link, tmp, &intf->links, list) {
-			if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
-			    && link->entity == entity)
+			if (link->entity == entity)
 				__media_remove_intf_link(link);
 		}
 	}


