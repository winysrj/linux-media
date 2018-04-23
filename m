Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58921 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754949AbeDWNOf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:14:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hansverk@cisco.com>,
        Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Subject: [PATCH] media: siano: be sure to not override devpath size
Date: Mon, 23 Apr 2018 09:14:30 -0400
Message-Id: <74e03b1c4caa132234039652646f8066fde865a5.1524489265.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, at siano driver, all places where devpath is
defined has sizeof(devpath) == 32. So, there's no practical
risc of going past devpath array anywhere.

Still, code changes might cause troubles. It also confuses
Coverity:
	CID 139059 (#1 of 1): Copy into fixed size buffer (STRING_OVERFLOW)
	9. fixed_size_dest: You might overrun the 32-character
	   fixed-size string entry->devpath by copying devpath
	   without checking the length.
	10. parameter_as_source: Note: This defect has an
	    elevated risk because the source argument
	    is a parameter of the current function.

So, explicitly limit strcmp() and strcpy() to ensure that the
devpath size (32) will be respected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/siano/smscoreapi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index b5dcc6d1fe90..1c93258a2d47 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -415,8 +415,8 @@ EXPORT_SYMBOL_GPL(smscore_get_board_id);
 
 struct smscore_registry_entry_t {
 	struct list_head entry;
-	char			devpath[32];
-	int				mode;
+	char devpath[32];
+	int mode;
 	enum sms_device_type_st	type;
 };
 
@@ -442,7 +442,7 @@ static struct smscore_registry_entry_t *smscore_find_registry(char *devpath)
 	     next != &g_smscore_registry;
 	     next = next->next) {
 		entry = (struct smscore_registry_entry_t *) next;
-		if (!strcmp(entry->devpath, devpath)) {
+		if (!strncmp(entry->devpath, devpath, sizeof(entry->devpath))) {
 			kmutex_unlock(&g_smscore_registrylock);
 			return entry;
 		}
@@ -450,7 +450,7 @@ static struct smscore_registry_entry_t *smscore_find_registry(char *devpath)
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (entry) {
 		entry->mode = default_mode;
-		strcpy(entry->devpath, devpath);
+		strlcpy(entry->devpath, devpath, sizeof(entry->devpath));
 		list_add(&entry->entry, &g_smscore_registry);
 	} else
 		pr_err("failed to create smscore_registry.\n");
@@ -733,7 +733,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	dev->postload_handler = params->postload_handler;
 
 	dev->device_flags = params->flags;
-	strcpy(dev->devpath, params->devpath);
+	strlcpy(dev->devpath, params->devpath, sizeof(dev->devpath));
 
 	smscore_registry_settype(dev->devpath, params->device_type);
 
-- 
2.14.3
