Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1373 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3DNP1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/30] cx25821: remove unnecessary global devlist.
Date: Sun, 14 Apr 2013 17:27:04 +0200
Message-Id: <1365953246-8972-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This device list is not necessary. The kernel already has all that information,
so just use that instead.

Also remove a bogus refcount and some dead 'private_free' code in the alsa driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-alsa.c  |   79 ++++++++++-------------------
 drivers/media/pci/cx25821/cx25821-core.c  |   21 +-------
 drivers/media/pci/cx25821/cx25821-video.c |   38 ++++----------
 drivers/media/pci/cx25821/cx25821.h       |    9 ++--
 4 files changed, 41 insertions(+), 106 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index b3cac75..81361c2 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -59,7 +59,6 @@ do {									\
 	Data type declarations - Can be moded to a header file later
  ****************************************************************************/
 
-static struct snd_card *snd_cx25821_cards[SNDRV_CARDS];
 static int devno;
 
 struct cx25821_audio_buffer {
@@ -627,34 +626,6 @@ static DEFINE_PCI_DEVICE_TABLE(cx25821_audio_pci_tbl) = {
 MODULE_DEVICE_TABLE(pci, cx25821_audio_pci_tbl);
 
 /*
- * Not used in the function snd_cx25821_dev_free so removing
- * from the file.
- */
-/*
-static int snd_cx25821_free(struct cx25821_audio_dev *chip)
-{
-	if (chip->irq >= 0)
-		free_irq(chip->irq, chip);
-
-	cx25821_dev_unregister(chip->dev);
-	pci_disable_device(chip->pci);
-
-	return 0;
-}
-*/
-
-/*
- * Component Destructor
- */
-static void snd_cx25821_dev_free(struct snd_card *card)
-{
-	struct cx25821_audio_dev *chip = card->private_data;
-
-	/* snd_cx25821_free(chip); */
-	snd_card_free(chip->card);
-}
-
-/*
  * Alsa Constructor - Component probe
  */
 static int cx25821_audio_initdev(struct cx25821_dev *dev)
@@ -685,7 +656,6 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 	strcpy(card->driver, "cx25821");
 
 	/* Card "creation" */
-	card->private_free = snd_cx25821_dev_free;
 	chip = card->private_data;
 	spin_lock_init(&chip->reg_lock);
 
@@ -729,8 +699,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		goto error;
 	}
 
-	snd_cx25821_cards[devno] = card;
-
+	dev->card = card;
 	devno++;
 	return 0;
 
@@ -742,9 +711,31 @@ error:
 /****************************************************************************
 				LINUX MODULE INIT
  ****************************************************************************/
+
+static int cx25821_alsa_exit_callback(struct device *dev, void *data)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+	struct cx25821_dev *cxdev = get_cx25821(v4l2_dev);
+
+	snd_card_free(cxdev->card);
+	return 0;
+}
+
 static void cx25821_audio_fini(void)
 {
-	snd_card_free(snd_cx25821_cards[0]);
+	struct device_driver *drv = driver_find("cx25821", &pci_bus_type);
+	int ret;
+
+	ret = driver_for_each_device(drv, NULL, NULL, cx25821_alsa_exit_callback);
+}
+
+static int cx25821_alsa_init_callback(struct device *dev, void *data)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev);
+	struct cx25821_dev *cxdev = get_cx25821(v4l2_dev);
+
+	cx25821_audio_initdev(cxdev);
+	return 0;
 }
 
 /*
@@ -756,29 +747,11 @@ static void cx25821_audio_fini(void)
  */
 static int cx25821_alsa_init(void)
 {
-	struct cx25821_dev *dev = NULL;
-	struct list_head *list;
+	struct device_driver *drv = driver_find("cx25821", &pci_bus_type);
 
-	mutex_lock(&cx25821_devlist_mutex);
-	list_for_each(list, &cx25821_devlist) {
-		dev = list_entry(list, struct cx25821_dev, devlist);
-		cx25821_audio_initdev(dev);
-	}
-	mutex_unlock(&cx25821_devlist_mutex);
-
-	if (dev == NULL)
-		pr_info("ERROR ALSA: no cx25821 cards found\n");
-
-	return 0;
+	return driver_for_each_device(drv, NULL, NULL, cx25821_alsa_init_callback);
 
 }
 
 late_initcall(cx25821_alsa_init);
 module_exit(cx25821_audio_fini);
-
-/* ----------------------------------------------------------- */
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 48faf6f..6205ade 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -41,13 +41,6 @@ static unsigned int card[] = {[0 ... (CX25821_MAXBOARDS - 1)] = UNSET };
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
-static unsigned int cx25821_devcount;
-
-DEFINE_MUTEX(cx25821_devlist_mutex);
-EXPORT_SYMBOL(cx25821_devlist_mutex);
-LIST_HEAD(cx25821_devlist);
-EXPORT_SYMBOL(cx25821_devlist);
-
 const struct sram_channel cx25821_sram_channels[] = {
 	[SRAM_CH00] = {
 		.i = SRAM_CH00,
@@ -871,6 +864,7 @@ static void cx25821_iounmap(struct cx25821_dev *dev)
 
 static int cx25821_dev_setup(struct cx25821_dev *dev)
 {
+	static unsigned int cx25821_devcount;
 	int i;
 
 	pr_info("\n***********************************\n");
@@ -879,15 +873,9 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	mutex_init(&dev->lock);
 
-	atomic_inc(&dev->refcount);
-
 	dev->nr = ++cx25821_devcount;
 	sprintf(dev->name, "cx25821[%d]", dev->nr);
 
-	mutex_lock(&cx25821_devlist_mutex);
-	list_add_tail(&dev->devlist, &cx25821_devlist);
-	mutex_unlock(&cx25821_devlist_mutex);
-
 	if (dev->pci->device != 0x8210) {
 		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
 			__func__, dev->pci->device);
@@ -1021,9 +1009,6 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 
 	release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 
-	if (!atomic_dec_and_test(&dev->refcount))
-		return;
-
 	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
@@ -1414,10 +1399,6 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 	if (pci_dev->irq)
 		free_irq(pci_dev->irq, dev);
 
-	mutex_lock(&cx25821_devlist_mutex);
-	list_del(&dev->devlist);
-	mutex_unlock(&cx25821_devlist_mutex);
-
 	cx25821_dev_unregister(dev);
 	v4l2_device_unregister(v4l2_dev);
 	kfree(dev);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index c418e0d..a9aa096 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -654,45 +654,28 @@ static struct videobuf_queue_ops cx25821_video_qops = {
 static int video_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct cx25821_dev *h, *dev = video_drvdata(file);
+	struct cx25821_dev *dev = video_drvdata(file);
 	struct cx25821_fh *fh;
-	struct list_head *list;
-	int minor = video_devdata(file)->minor;
 	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	u32 pix_format;
-	int ch_id = 0;
-	int i;
+	int ch_id;
 
 	dprintk(1, "open dev=%s type=%s\n", video_device_node_name(vdev),
 			v4l2_type_names[type]);
 
+	for (ch_id = 0; ch_id < MAX_VID_CHANNEL_NUM - 1; ch_id++)
+		if (dev->channels[ch_id].video_dev == vdev)
+			break;
+
+	/* Can't happen */
+	if (ch_id >= MAX_VID_CHANNEL_NUM - 1)
+		return -ENODEV;
+
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
 	if (NULL == fh)
 		return -ENOMEM;
 
-	mutex_lock(&cx25821_devlist_mutex);
-
-	list_for_each(list, &cx25821_devlist)
-	{
-		h = list_entry(list, struct cx25821_dev, devlist);
-
-		for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; i++) {
-			if (h->channels[i].video_dev &&
-			    h->channels[i].video_dev->minor == minor) {
-				dev = h;
-				ch_id = i;
-				type  = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-			}
-		}
-	}
-
-	if (NULL == dev) {
-		mutex_unlock(&cx25821_devlist_mutex);
-		kfree(fh);
-		return -ENODEV;
-	}
-
 	file->private_data = fh;
 	fh->dev = dev;
 	fh->type = type;
@@ -719,7 +702,6 @@ static int video_open(struct file *file)
 			fh, NULL);
 
 	dprintk(1, "post videobuf_queue_init()\n");
-	mutex_unlock(&cx25821_devlist_mutex);
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index d7e71f4..195b004 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -238,9 +238,9 @@ struct cx25821_channel {
 	int cif_width;
 };
 
+struct snd_card;
+
 struct cx25821_dev {
-	struct list_head devlist;
-	atomic_t refcount;
 	struct v4l2_device v4l2_dev;
 
 	/* pci stuff */
@@ -252,6 +252,8 @@ struct cx25821_dev {
 	u8 __iomem *bmmio;
 	int pci_irqmask;
 	int hwrevision;
+	/* used by cx25821-alsa */
+	struct snd_card *card;
 
 	u32 clk_freq;
 
@@ -403,9 +405,6 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 #define cx25821_call_all(dev, o, f, args...) \
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
-extern struct list_head cx25821_devlist;
-extern struct mutex cx25821_devlist_mutex;
-
 extern struct cx25821_board cx25821_boards[];
 extern struct cx25821_subid cx25821_subids[];
 
-- 
1.7.10.4

