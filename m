Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60114 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0FQMHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 08:07:21 -0400
Received: by wyf23 with SMTP id 23so50992wyf.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 05:07:20 -0700 (PDT)
Date: Thu, 17 Jun 2010 14:06:53 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch] Staging: tm6000: fix problem in alsa init
Message-ID: <20100617120653.GI5483@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem is that we never passed the "idx" parameter to
tm6000_audio_init() so it's uninitialized.  In fact, the struct
tm6000_ops ->init() definition didn't have idx as a parameter.

When I added the parameter to tm6000_ops, I also added a parameter to
the ->fini() callback.  fini() is just a stub right now and it doesn't
need idx, but it's better to be symetric.

As I was updating the calls to init() I noticed that there were some
needless NULL checks.  "dev" doesn't need to be checked because it is
the list cursor and can never be null.  op->init() doesn't need to be
checked because we assumed it was non-null in the other function and
in fact it always is non-null with the current code.  I removed these
uneeded checks because it made writing this patch slightly simpler.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index ce081cd..94c9f15 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -337,7 +337,7 @@ static int __devinit snd_tm6000_pcm(struct snd_tm6000_card *chip,
  * Alsa Constructor - Component probe
  */
 
-int tm6000_audio_init(struct tm6000_core *dev, int idx)
+static int tm6000_audio_init(struct tm6000_core *dev, int idx)
 {
 	struct snd_card         *card;
 	struct snd_tm6000_card  *chip;
@@ -411,12 +411,12 @@ error:
 	return rc;
 }
 
-static int tm6000_audio_fini(struct tm6000_core *dev)
+static int tm6000_audio_fini(struct tm6000_core *dev, int idx)
 {
 	return 0;
 }
 
-struct tm6000_ops audio_ops = {
+static struct tm6000_ops audio_ops = {
 	.id	= TM6000_AUDIO,
 	.name	= "TM6000 Audio Extension",
 	.init	= tm6000_audio_init,
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 27f3f55..c71452c 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -661,13 +661,14 @@ static DEFINE_MUTEX(tm6000_extension_devlist_lock);
 int tm6000_register_extension(struct tm6000_ops *ops)
 {
 	struct tm6000_core *dev = NULL;
+	int idx = 0;
 
 	mutex_lock(&tm6000_devlist_mutex);
 	mutex_lock(&tm6000_extension_devlist_lock);
 	list_add_tail(&ops->next, &tm6000_extension_devlist);
 	list_for_each_entry(dev, &tm6000_devlist, devlist) {
-		if (dev)
-			ops->init(dev);
+		ops->init(dev, idx);
+		idx++;
 	}
 	printk(KERN_INFO "tm6000: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&tm6000_extension_devlist_lock);
@@ -679,11 +680,12 @@ EXPORT_SYMBOL(tm6000_register_extension);
 void tm6000_unregister_extension(struct tm6000_ops *ops)
 {
 	struct tm6000_core *dev = NULL;
+	int idx = 0;
 
 	mutex_lock(&tm6000_devlist_mutex);
 	list_for_each_entry(dev, &tm6000_devlist, devlist) {
-		if (dev)
-			ops->fini(dev);
+		ops->fini(dev, idx);
+		idx++;
 	}
 
 	mutex_lock(&tm6000_extension_devlist_lock);
@@ -697,12 +699,13 @@ EXPORT_SYMBOL(tm6000_unregister_extension);
 void tm6000_init_extension(struct tm6000_core *dev)
 {
 	struct tm6000_ops *ops = NULL;
+	int idx = 0;
 
 	mutex_lock(&tm6000_extension_devlist_lock);
 	if (!list_empty(&tm6000_extension_devlist)) {
 		list_for_each_entry(ops, &tm6000_extension_devlist, next) {
-			if (ops->init)
-				ops->init(dev);
+			ops->init(dev, idx);
+			idx++;
 		}
 	}
 	mutex_unlock(&tm6000_extension_devlist_lock);
@@ -711,12 +714,13 @@ void tm6000_init_extension(struct tm6000_core *dev)
 void tm6000_close_extension(struct tm6000_core *dev)
 {
 	struct tm6000_ops *ops = NULL;
+	int idx = 0;
 
 	mutex_lock(&tm6000_extension_devlist_lock);
 	if (!list_empty(&tm6000_extension_devlist)) {
 		list_for_each_entry(ops, &tm6000_extension_devlist, next) {
-			if (ops->fini)
-				ops->fini(dev);
+			ops->fini(dev, idx);
+			idx++;
 		}
 	}
 	mutex_unlock(&tm6000_extension_devlist_lock);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 7bbaf26..971a39a 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -213,8 +213,8 @@ struct tm6000_ops {
 	struct list_head	next;
 	char			*name;
 	int			id;
-	int (*init)(struct tm6000_core *);
-	int (*fini)(struct tm6000_core *);
+	int (*init)(struct tm6000_core *, int idx);
+	int (*fini)(struct tm6000_core *, int idx);
 };
 
 struct tm6000_fh {
