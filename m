Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbcBOVUI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 16:20:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 156E45A48
	for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 21:20:08 +0000 (UTC)
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH xawtv3 1/3] get_media_devices.c: Remove superfluous ; add end of functions
Date: Mon, 15 Feb 2016 22:20:00 +0100
Message-Id: <1455571202-5189-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 common/get_media_devices.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/get_media_devices.c b/common/get_media_devices.c
index a2d6354..619734e 100644
--- a/common/get_media_devices.c
+++ b/common/get_media_devices.c
@@ -227,7 +227,7 @@ static int add_v4l_class(struct media_device_entry *md)
 		md->type = MEDIA_V4L_SUBDEV;
 
 	return 0;
-};
+}
 
 static int add_snd_class(struct media_device_entry *md)
 {
@@ -270,7 +270,7 @@ static int add_snd_class(struct media_device_entry *md)
 	md->node = strdup(node);
 
 	return 0;
-};
+}
 
 static int add_dvb_class(struct media_device_entry *md)
 {
@@ -294,7 +294,7 @@ static int add_dvb_class(struct media_device_entry *md)
 		md->type = MEDIA_DVB_OSD;
 
 	return 0;
-};
+}
 
 static int sort_media_device_entry(const void *a, const void *b)
 {
-- 
2.7.1

