Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbcBEQGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:21 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hansverk@cisco.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Inki Dae <inki.dae@samsung.com>,
	Darek Zielski <dz1125tor@gmail.com>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 6/6] [media] saa7134: add media controller support
Date: Fri,  5 Feb 2016 14:05:00 -0200
Message-Id: <90683a5b5a7b46a1b5445b9b7312a17922ccdb96.1454688188.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register saa7134 at the media controller core and provide
support for both analog TV and DVB.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-core.c  | 189 +++++++++++++++++++++++++++++-
 drivers/media/pci/saa7134/saa7134-dvb.c   |   9 +-
 drivers/media/pci/saa7134/saa7134-video.c |  60 ++++++++++
 drivers/media/pci/saa7134/saa7134.h       |  13 ++
 4 files changed, 266 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 31048f9b516a..ba18459b5a87 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -806,6 +806,151 @@ static void must_configure_manually(int has_eeprom)
 	}
 }
 
+static void saa7134_unregister_media_device(struct saa7134_dev *dev)
+{
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (!dev->media_dev)
+		return;
+	media_device_unregister(dev->media_dev);
+	media_device_cleanup(dev->media_dev);
+	kfree(dev->media_dev);
+	dev->media_dev = NULL;
+#endif
+}
+
+static void saa7134_media_release(struct saa7134_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int i;
+
+	for (i = 0; i < SAA7134_INPUT_MAX + 1; i++) {
+		media_device_unregister_entity(&dev->input_ent[i]);
+	}
+#endif
+}
+
+static void saa7134_create_entities(struct saa7134_dev *dev)
+{
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	int ret, i;
+	struct media_entity *entity;
+	struct media_entity *decoder = NULL;
+
+	/* Check if it is using an external analog TV demod */
+	media_device_for_each_entity(entity, dev->media_dev) {
+		if (entity->function == MEDIA_ENT_F_ATV_DECODER)
+			decoder = entity;
+			break;
+	}
+
+	/* SAA7134 is not using an external ATV demod. Register our own */
+	if (!decoder) {
+		dev->demod.name = "saa713x";
+		dev->demod_pad[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->demod_pad[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->demod.function = MEDIA_ENT_F_ATV_DECODER;
+
+		ret = media_entity_pads_init(&dev->demod, DEMOD_NUM_PADS,
+					     dev->demod_pad);
+		if (ret < 0)
+			pr_err("failed to initialize demod pad!\n");
+
+		ret = media_device_register_entity(dev->media_dev, &dev->demod);
+		if (ret < 0)
+			pr_err("failed to register demod entity!\n");
+
+		dev->decoder = &dev->demod;
+	} else {
+		dev->decoder = decoder;
+	}
+
+	/* Initialize Video, VBI and Radio pads */
+	dev->video_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&dev->video_dev->entity, 1,
+				     &dev->video_pad);
+	if (ret < 0)
+		pr_err("failed to initialize video media entity!\n");
+
+	dev->vbi_pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&dev->vbi_dev->entity, 1,
+					&dev->vbi_pad);
+	if (ret < 0)
+		pr_err("failed to initialize vbi media entity!\n");
+
+	/* Create entities for each input connector */
+	for (i = 0; i < SAA7134_INPUT_MAX; i++) {
+		struct media_entity *ent = &dev->input_ent[i];
+		struct saa7134_input *in = &card_in(dev, i);
+
+		if (in->type == SAA7134_NO_INPUT)
+			break;
+
+		/* This input uses the S-Video connector */
+		if (in->type == SAA7134_INPUT_COMPOSITE_OVER_SVIDEO)
+			continue;
+
+		ent->name = saa7134_input_name[in->type];
+		ent->flags = MEDIA_ENT_FL_CONNECTOR;
+		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+
+		switch (in->type) {
+		case SAA7134_INPUT_COMPOSITE:
+		case SAA7134_INPUT_COMPOSITE0:
+		case SAA7134_INPUT_COMPOSITE1:
+		case SAA7134_INPUT_COMPOSITE2:
+		case SAA7134_INPUT_COMPOSITE3:
+		case SAA7134_INPUT_COMPOSITE4:
+			ent->function = MEDIA_ENT_F_CONN_COMPOSITE;
+			break;
+		case SAA7134_INPUT_SVIDEO:
+		case SAA7134_INPUT_SVIDEO0:
+		case SAA7134_INPUT_SVIDEO1:
+			ent->function = MEDIA_ENT_F_CONN_SVIDEO;
+			break;
+		default:
+			/*
+			 * SAA7134_INPUT_TV and SAA7134_INPUT_TV_MONO.
+			 *
+			 * Please notice that neither SAA7134_INPUT_MUTE or
+			 * SAA7134_INPUT_RADIO are defined at
+			 * saa7134_board.input.
+			 */
+			ent->function = MEDIA_ENT_F_CONN_RF;
+			break;
+		}
+
+		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
+		if (ret < 0)
+			pr_err("failed to initialize input pad[%d]!\n", i);
+
+		ret = media_device_register_entity(dev->media_dev, ent);
+		if (ret < 0)
+			pr_err("failed to register input entity %d!\n", i);
+	}
+
+	/* Create input for Radio RF connector */
+	if (card_has_radio(dev)) {
+		struct saa7134_input *in = &saa7134_boards[dev->board].radio;
+		struct media_entity *ent = &dev->input_ent[i];
+
+		ent->name = saa7134_input_name[in->type];
+		ent->flags = MEDIA_ENT_FL_CONNECTOR;
+		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+		ent->function = MEDIA_ENT_F_CONN_RF;
+
+		ret = media_entity_pads_init(ent, 1, &dev->input_pad[i]);
+		if (ret < 0)
+			pr_err("failed to initialize input pad[%d]!\n", i);
+
+		ret = media_device_register_entity(dev->media_dev, ent);
+		if (ret < 0)
+			pr_err("failed to register input entity %d!\n", i);
+	}
+#endif
+}
+
 static struct video_device *vdev_init(struct saa7134_dev *dev,
 				      struct video_device *template,
 				      char *type)
@@ -826,6 +971,8 @@ static struct video_device *vdev_init(struct saa7134_dev *dev,
 
 static void saa7134_unregister_video(struct saa7134_dev *dev)
 {
+	saa7134_media_release(dev);
+
 	if (dev->video_dev) {
 		if (video_is_registered(dev->video_dev))
 			video_unregister_device(dev->video_dev);
@@ -889,6 +1036,18 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		return -ENOMEM;
 
+	dev->nr = saa7134_devcount;
+	sprintf(dev->name,"saa%x[%d]",pci_dev->device,dev->nr);
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dev->media_dev = v4l2_mc_pci_media_device_init(pci_dev, dev->name);
+	if (!dev->media_dev) {
+		err = -ENOMEM;
+		goto fail0;
+	}
+	dev->v4l2_dev.mdev = dev->media_dev;
+#endif
+
 	err = v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev);
 	if (err)
 		goto fail0;
@@ -900,9 +1059,6 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		goto fail1;
 	}
 
-	dev->nr = saa7134_devcount;
-	sprintf(dev->name,"saa%x[%d]",pci_dev->device,dev->nr);
-
 	/* pci quirks */
 	if (pci_pci_problems) {
 		if (pci_pci_problems & PCIPCI_TRITON)
@@ -1102,6 +1258,15 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		       dev->name, video_device_node_name(dev->radio_dev));
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	saa7134_create_entities(dev);
+
+	err = v4l2_mc_create_media_graph(dev->media_dev);
+	if (err) {
+		pr_err("failed to create media graph\n");
+		goto fail5;
+	}
+#endif
 	/* everything worked */
 	saa7134_devcount++;
 
@@ -1109,6 +1274,18 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 		saa7134_dmasound_init(dev);
 
 	request_submodules(dev);
+
+	/*
+	 * Do it at the end, to reduce dynamic configuration changes during
+	 * the device init. Yet, as request_modules() can be async, the
+	 * topology will likely change after load the saa7134 subdrivers.
+	 */
+#ifdef CONFIG_MEDIA_CONTROLLER
+	err = media_device_register(dev->media_dev);
+	if (err)
+		goto fail5;
+#endif
+
 	return 0;
 
  fail5:
@@ -1126,6 +1303,9 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
  fail1:
 	v4l2_device_unregister(&dev->v4l2_dev);
  fail0:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	kfree(dev->media_dev);
+#endif
 	kfree(dev);
 	return err;
 }
@@ -1188,9 +1368,10 @@ static void saa7134_finidev(struct pci_dev *pci_dev)
 	release_mem_region(pci_resource_start(pci_dev,0),
 			   pci_resource_len(pci_dev,0));
 
-
 	v4l2_device_unregister(&dev->v4l2_dev);
 
+	saa7134_unregister_media_device(dev);
+
 	/* free memory */
 	kfree(dev);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index ed84f7dea94c..db987e5b93eb 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1883,8 +1883,15 @@ static int dvb_init(struct saa7134_dev *dev)
 	fe0->dvb.frontend->callback = saa7134_tuner_callback;
 
 	/* register everything else */
+#ifndef CONFIG_MEDIA_CONTROLLER_DVB
 	ret = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
-				   &dev->pci->dev, NULL, adapter_nr, 0);
+				   &dev->pci->dev, NULL,
+				   adapter_nr, 0);
+#else
+	ret = vb2_dvb_register_bus(&dev->frontends, THIS_MODULE, dev,
+				   &dev->pci->dev, dev->media_dev,
+				   adapter_nr, 0);
+#endif
 
 	/* this sequence is necessary to make the tda1004x load its firmware
 	 * and to enter analog mode of hybrid boards
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 9debfb549887..0403b34624c1 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -785,6 +785,63 @@ static int stop_preview(struct saa7134_dev *dev)
 	return 0;
 }
 
+/*
+ * Media Controller helper functions
+ */
+
+static int saa7134_enable_analog_tuner(struct saa7134_dev *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev = dev->media_dev;
+	struct media_entity *source;
+	struct media_link *link, *found_link = NULL;
+	int ret, active_links = 0;
+
+	if (!mdev || !dev->decoder)
+		return 0;
+
+	/*
+	 * This will find the tuner that is connected into the decoder.
+	 * Technically, this is not 100% correct, as the device may be
+	 * using an analog input instead of the tuner. However, as we can't
+	 * do DVB streaming while the DMA engine is being used for V4L2,
+	 * this should be enough for the actual needs.
+	 */
+	list_for_each_entry(link, &dev->decoder->links, list) {
+		if (link->sink->entity == dev->decoder) {
+			found_link = link;
+			if (link->flags & MEDIA_LNK_FL_ENABLED)
+				active_links++;
+			break;
+		}
+	}
+
+	if (active_links == 1 || !found_link)
+		return 0;
+
+	source = found_link->source->entity;
+	list_for_each_entry(link, &source->links, list) {
+		struct media_entity *sink;
+		int flags = 0;
+
+		sink = link->sink->entity;
+
+		if (sink == dev->decoder)
+			flags = MEDIA_LNK_FL_ENABLED;
+
+		ret = media_entity_setup_link(link, flags);
+		if (ret) {
+			pr_err("Couldn't change link %s->%s to %s. Error %d\n",
+			       source->name, sink->name,
+			       flags ? "enabled" : "disabled",
+			       ret);
+			return ret;
+		}
+	}
+#endif
+	return 0;
+}
+
 /* ------------------------------------------------------------------ */
 
 static int buffer_activate(struct saa7134_dev *dev,
@@ -924,6 +981,9 @@ static int queue_setup(struct vb2_queue *q,
 	*nplanes = 1;
 	sizes[0] = size;
 	alloc_ctxs[0] = dev->alloc_ctx;
+
+	saa7134_enable_analog_tuner(dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index e3e2392f87d6..8936568fab94 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -671,6 +671,19 @@ struct saa7134_dev {
 	/* I2C keyboard data */
 	struct IR_i2c_init_data    init_data;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *media_dev;
+
+	struct media_entity input_ent[SAA7134_INPUT_MAX + 1];
+	struct media_pad input_pad[SAA7134_INPUT_MAX + 1];
+
+	struct media_entity demod;
+	struct media_pad demod_pad[DEMOD_NUM_PADS];
+
+	struct media_pad video_pad, vbi_pad;
+	struct media_entity *decoder;
+#endif
+
 #if IS_ENABLED(CONFIG_VIDEO_SAA7134_DVB)
 	/* SAA7134_MPEG_DVB only */
 	struct vb2_dvb_frontends frontends;
-- 
2.5.0


