Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33428 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729922AbeHGM2o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 08:28:44 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: sta2x11: add a missing parameter description
Date: Tue,  7 Aug 2018 06:15:04 -0400
Message-Id: <51be5a2b43f86af40b3fb78d7e4a22b5357fbc0d.1533636901.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes this warning:
	drivers/media/pci/sta2x11/sta2x11_vip.c:156: warning: Function parameter or member 'v4l_lock' not described in 'sta2x11_vip'

Fixes: cd63c0288fd7 ("media: sta2x11: Add video_device and vb2_queue locks")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index da2b2a2292d0..1858efedaf1a 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -116,6 +116,7 @@ static inline struct vip_buffer *to_vip_buffer(struct vb2_v4l2_buffer *vb2)
  * @sequence: sequence number of acquired buffer
  * @active: current active buffer
  * @lock: used in videobuf2 callback
+ * @v4l_lock: serialize its video4linux ioctls
  * @tcount: Number of top frames
  * @bcount: Number of bottom frames
  * @overflow: Number of FIFO overflows
-- 
2.17.1
