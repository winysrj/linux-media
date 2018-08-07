Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbeHGMYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 08:24:33 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] media: v4l2-mem2mem: add descriptions to MC fields
Date: Tue,  7 Aug 2018 06:10:54 -0400
Message-Id: <b07b684930fe0b8032bddba5aa60686011932019.1533636649.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'source_pad' not described in 'v4l2_m2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'sink' not described in 'v4l2_m2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'sink_pad' not described in 'v4l2_m2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'proc' not described in 'v4l2_m2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'proc_pads' not described in 'v4l2_m2m_dev'
drivers/media/v4l2-core/v4l2-mem2mem.c:90: warning: Function parameter or member 'intf_devnode' not described in 'v4l2_m2m_dev'

Fixes: be2fff656322 ("media: add helpers for memory-to-memory media controller")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 0a93c5b173c2..ce9bd1b91210 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -66,6 +66,24 @@ static const char * const m2m_entity_name[] = {
 
 /**
  * struct v4l2_m2m_dev - per-device context
+ * @source:		&struct media_entity pointer with the source entity
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @source_pad:		&struct media_pad with the source pad.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @sink:		&struct media_entity pointer with the sink entity
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @sink_pad:		&struct media_pad with the sink pad.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @proc:		&struct media_entity pointer with the M2M device itself.
+ * @proc_pads:		&struct media_pad with the @proc pads.
+ *			Used only when the M2M device is registered via
+ *			v4l2_m2m_unregister_media_controller().
+ * @intf_devnode:	&struct media_intf devnode pointer with the interface
+ *			with controls the M2M device.
  * @curr_ctx:		currently running instance
  * @job_queue:		instances queued to run
  * @job_spinlock:	protects job_queue
-- 
2.17.1
