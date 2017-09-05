Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58015
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdIEMxG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 08:53:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        devendra sharma <devendra.sharma9091@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] media: get rid of removed DMX_GET_CAPS and DMX_SET_SOURCE leftovers
Date: Tue,  5 Sep 2017 08:52:59 -0400
Message-Id: <4cd7d6c957b085d319bcf97814f95854375da0a6.1504615976.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two ioctls were never used within the Kernel. Still, there
used to have compat32 code there (and an if #0 block at the core).

Get rid of them.

Fixes: 286fe1ca3fa1 ("media: dmx.h: get rid of DMX_GET_CAPS")
Fixes: 13adefbe9e56 ("media: dmx.h: get rid of DMX_SET_SOURCE")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dmxdev.c | 20 --------------------
 fs/compat_ioctl.c               |  2 --
 2 files changed, 22 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 16b0b74c3114..18e4230865be 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1025,26 +1025,6 @@ static int dvb_demux_do_ioctl(struct file *file,
 		dmxdev->demux->get_pes_pids(dmxdev->demux, parg);
 		break;
 
-#if 0
-	/* Not used upstream and never documented */
-
-	case DMX_GET_CAPS:
-		if (!dmxdev->demux->get_caps) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = dmxdev->demux->get_caps(dmxdev->demux, parg);
-		break;
-
-	case DMX_SET_SOURCE:
-		if (!dmxdev->demux->set_source) {
-			ret = -EINVAL;
-			break;
-		}
-		ret = dmxdev->demux->set_source(dmxdev->demux, parg);
-		break;
-#endif
-
 	case DMX_GET_STC:
 		if (!dmxdev->demux->get_stc) {
 			ret = -EINVAL;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 2dd4a7af7dd7..d27b326d96f4 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1331,8 +1331,6 @@ COMPATIBLE_IOCTL(DMX_SET_FILTER)
 COMPATIBLE_IOCTL(DMX_SET_PES_FILTER)
 COMPATIBLE_IOCTL(DMX_SET_BUFFER_SIZE)
 COMPATIBLE_IOCTL(DMX_GET_PES_PIDS)
-COMPATIBLE_IOCTL(DMX_GET_CAPS)
-COMPATIBLE_IOCTL(DMX_SET_SOURCE)
 COMPATIBLE_IOCTL(DMX_GET_STC)
 COMPATIBLE_IOCTL(FE_GET_INFO)
 COMPATIBLE_IOCTL(FE_DISEQC_RESET_OVERLOAD)
-- 
2.13.3
