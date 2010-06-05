Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab0FEAVd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:33 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LWIl010685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:33 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7p015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:31 -0400
Date: Fri, 4 Jun 2010 21:21:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] tm6000: Add a callback code for buffer fill
Message-ID: <20100604212105.12f43b08@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implements a callback to be used by tm6000-alsa, in order to allow filling
audio data packets.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index db1eef9..e71579e 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -199,6 +199,21 @@ static int snd_tm6000_close(struct snd_pcm_substream *substream)
 	return 0;
 }
 
+static int tm6000_fillbuf(struct tm6000_core *core, char *buf, int size)
+{
+	int i;
+
+	/* Need to add a real code to copy audio buffer */
+	printk("Audio (%i bytes): ", size);
+	for (i = 0; i < size - 3; i +=4)
+		printk("(0x%04x, 0x%04x), ",
+			*(u16 *)(buf + i), *(u16 *)(buf + i + 2));
+
+	printk("\n");
+
+	return 0;
+}
+
 /*
  * hw_params callback
  */
@@ -395,6 +410,7 @@ struct tm6000_ops audio_ops = {
 	.name	= "TM6000 Audio Extension",
 	.init	= tm6000_audio_init,
 	.fini	= tm6000_audio_fini,
+	.fillbuf = tm6000_fillbuf,
 };
 
 static int __init tm6000_alsa_register(void)
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 1f2765c..626b85e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -652,6 +652,23 @@ void tm6000_add_into_devlist(struct tm6000_core *dev)
 static LIST_HEAD(tm6000_extension_devlist);
 static DEFINE_MUTEX(tm6000_extension_devlist_lock);
 
+int tm6000_call_fillbuf(struct tm6000_core *dev, enum tm6000_ops_type type,
+			char *buf, int size)
+{
+	struct tm6000_ops *ops = NULL;
+
+	/* FIXME: tm6000_extension_devlist_lock should be a spinlock */
+
+	if (!list_empty(&tm6000_extension_devlist)) {
+		list_for_each_entry(ops, &tm6000_extension_devlist, next) {
+			if (ops->fillbuf && ops->type == type)
+				ops->fillbuf(dev, buf, size);
+		}
+	}
+
+	return 0;
+}
+
 int tm6000_register_extension(struct tm6000_ops *ops)
 {
 	struct tm6000_core *dev = NULL;
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 1e348ac..c0d6f6a 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -301,7 +301,7 @@ static int copy_streams(u8 *data, unsigned long len,
 					memcpy (&voutp[pos], ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_AUDIO:
-				/* Need some code to copy audio buffer */
+				tm6000_call_fillbuf(dev, TM6000_AUDIO, ptr, cpysize);
 				break;
 			case TM6000_URB_MSG_VBI:
 				/* Need some code to copy vbi buffer */
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 8fccf3e..db99959 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -229,6 +229,7 @@ struct tm6000_ops {
 	enum tm6000_ops_type	type;
 	int (*init)(struct tm6000_core *);
 	int (*fini)(struct tm6000_core *);
+	int (*fillbuf)(struct tm6000_core *, char *buf, int size);
 };
 
 struct tm6000_fh {
@@ -278,6 +279,9 @@ int tm6000_register_extension(struct tm6000_ops *ops);
 void tm6000_unregister_extension(struct tm6000_ops *ops);
 void tm6000_init_extension(struct tm6000_core *dev);
 void tm6000_close_extension(struct tm6000_core *dev);
+int tm6000_call_fillbuf(struct tm6000_core *dev, enum tm6000_ops_type type,
+			char *buf, int size);
+
 
 /* In tm6000-stds.c */
 void tm6000_get_std_res(struct tm6000_core *dev);
-- 
1.7.1


