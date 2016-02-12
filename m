Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57565 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcBLVUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 16:20:10 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] media.h: get rid of MEDIA_ENT_F_CONN_TEST
Date: Fri, 12 Feb 2016 19:18:45 -0200
Message-Id: <1ae039a008139caa409c4e20b57d2404be282f5f.1455311900.git.mchehab@osg.samsung.com>
In-Reply-To: <bddda7f5f133e3bafa89519e0c8bce832d19e6d9.1455311900.git.mchehab@osg.samsung.com>
References: <bddda7f5f133e3bafa89519e0c8bce832d19e6d9.1455311900.git.mchehab@osg.samsung.com>
In-Reply-To: <bddda7f5f133e3bafa89519e0c8bce832d19e6d9.1455311900.git.mchehab@osg.samsung.com>
References: <bddda7f5f133e3bafa89519e0c8bce832d19e6d9.1455311900.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defining it as a connector was a bad idea. Remove it while it is
not too late.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 4 ----
 drivers/media/v4l2-core/v4l2-mc.c               | 1 -
 include/uapi/linux/media.h                      | 2 --
 3 files changed, 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 751c3d027103..8b4fa39cf611 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -57,10 +57,6 @@
 	    <entry>Connector for a RGB composite signal.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>MEDIA_ENT_F_CONN_TEST</constant></entry>
-	    <entry>Connector for a test generator.</entry>
-	  </row>
-	  <row>
 	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
 	    <entry>Camera video sensor entity.</entry>
 	  </row>
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index b61f8d969958..cdf87615dc78 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -241,7 +241,6 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
 			break;
 		case MEDIA_ENT_F_CONN_SVIDEO:
 		case MEDIA_ENT_F_CONN_COMPOSITE:
-		case MEDIA_ENT_F_CONN_TEST:
 			ret = media_create_pad_link(entity, 0, decoder,
 						    DEMOD_PAD_IF_INPUT,
 						    flags);
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index c9eb42a6c021..7113b1a8cb4e 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -78,8 +78,6 @@ struct media_device_info {
 #define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 21)
 #define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 22)
 #define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 23)
-/* For internal test signal generators and other debug connectors */
-#define MEDIA_ENT_F_CONN_TEST		(MEDIA_ENT_F_BASE + 24)
 
 /*
  * I/O entities
-- 
2.5.0

