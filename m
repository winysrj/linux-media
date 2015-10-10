Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbbJJNgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 13/26] [media] dvb: don't keep support for undocumented features
Date: Sat, 10 Oct 2015 10:35:56 -0300
Message-Id: <1e92bbe08ad9fc0d5ec05174c176a9bc54921733.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two DVB demux callbacks and ioctls that aren't documented
and aren't used at all by the DVB core or by any DVB driver upstream.

Let's comment out the code for those two ioctls and remove on some
future version.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index ca56d1cc57bd..53c82514ede5 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -411,10 +411,12 @@ struct dmx_demux {
 
 	int (*get_pes_pids) (struct dmx_demux* demux, u16 *pids);
 
+	/* private: Not used upstream and never documented */
+#if 0
 	int (*get_caps) (struct dmx_demux* demux, struct dmx_caps *caps);
-
 	int (*set_source) (struct dmx_demux* demux, const dmx_source_t *src);
-
+#endif
+	/* public: */
 	int (*get_stc) (struct dmx_demux* demux, unsigned int num,
 			u64 *stc, unsigned int *base);
 };
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d0e3f9d85f34..86a987ef13e1 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1023,6 +1023,9 @@ static int dvb_demux_do_ioctl(struct file *file,
 		dmxdev->demux->get_pes_pids(dmxdev->demux, parg);
 		break;
 
+#if 0
+	/* Not used upstream and never documented */
+
 	case DMX_GET_CAPS:
 		if (!dmxdev->demux->get_caps) {
 			ret = -EINVAL;
@@ -1038,6 +1041,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 		}
 		ret = dmxdev->demux->set_source(dmxdev->demux, parg);
 		break;
+#endif
 
 	case DMX_GET_STC:
 		if (!dmxdev->demux->get_stc) {
-- 
2.4.3


