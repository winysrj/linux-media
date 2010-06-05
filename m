Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab0FEAVf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:35 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o550LZd5006580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:35 -0400
Received: from pedra (vpn-10-9.rdu.redhat.com [10.11.10.9])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o550LI7q015252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 4 Jun 2010 20:21:33 -0400
Date: Fri, 4 Jun 2010 21:21:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/6] tm6000: Use an emum for extension type
Message-ID: <20100604212106.67cbc5de@pedra>
In-Reply-To: <cover.1275696910.git.mchehab@redhat.com>
References: <cover.1275696910.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to better document and be sure that the values are used
at the proper places, convert extension type into an enum and
name it as "type", instead of "id".

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index ca9aec5..db1eef9 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -391,7 +391,7 @@ static int tm6000_audio_fini(struct tm6000_core *dev)
 }
 
 struct tm6000_ops audio_ops = {
-	.id	= TM6000_AUDIO,
+	.type	= TM6000_AUDIO,
 	.name	= "TM6000 Audio Extension",
 	.init	= tm6000_audio_init,
 	.fini	= tm6000_audio_fini,
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 5ee1aff..ff9cc6d 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -431,7 +431,7 @@ static int dvb_fini(struct tm6000_core *dev)
 }
 
 static struct tm6000_ops dvb_ops = {
-	.id	= TM6000_DVB,
+	.type	= TM6000_DVB,
 	.name	= "TM6000 dvb Extension",
 	.init	= dvb_init,
 	.fini	= dvb_fini,
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index a1d96d6..8fccf3e 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -218,13 +218,15 @@ struct tm6000_core {
 	spinlock_t                   slock;
 };
 
-#define TM6000_AUDIO 0x10
-#define TM6000_DVB	0x20
+enum tm6000_ops_type {
+	TM6000_AUDIO = 0x10,
+	TM6000_DVB = 0x20,
+};
 
 struct tm6000_ops {
 	struct list_head	next;
 	char			*name;
-	int			id;
+	enum tm6000_ops_type	type;
 	int (*init)(struct tm6000_core *);
 	int (*fini)(struct tm6000_core *);
 };
-- 
1.7.1


