Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 08/26] [media] lirc_dev.h: Make checkpatch happy
Date: Sat, 10 Oct 2015 10:35:51 -0300
Message-Id: <709641061457ee31ad9fed96798102c3326750f9.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove warnings about bad whitespacing at function
struct parameters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index abb92f879ba2..0ab59a571fee 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -196,10 +196,10 @@ struct lirc_driver {
 	void *data;
 	int min_timeout;
 	int max_timeout;
-	int (*add_to_buf) (void *data, struct lirc_buffer *buf);
+	int (*add_to_buf)(void *data, struct lirc_buffer *buf);
 	struct lirc_buffer *rbuf;
-	int (*set_use_inc) (void *data);
-	void (*set_use_dec) (void *data);
+	int (*set_use_inc)(void *data);
+	void (*set_use_dec)(void *data);
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
 	struct device *dev;
-- 
2.4.3


