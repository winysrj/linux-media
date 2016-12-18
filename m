Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36688 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753617AbcLRNxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Dec 2016 08:53:10 -0500
From: devendra sharma <devendra.sharma9091@gmail.com>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, arnd@arndb.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        devendra sharma <devendra.sharma9091@gmail.com>
Subject: [PATCH] media: dvb: dmx: fixed coding style issues of spacing
Date: Sun, 18 Dec 2016 19:22:55 +0530
Message-Id: <1482069175-2535-1-git-send-email-devendra.sharma9091@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed coding style issues of spacing

Signed-off-by: Devendra Sharma <devendra.sharma9091@gmail.com>
---
 drivers/media/dvb-core/dmxdev.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index efe55a3..cd240a2 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -151,6 +151,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
 		void *mem;
+
 		if (!dvbdev->readers) {
 			mutex_unlock(&dmxdev->mutex);
 			return -EBUSY;
@@ -202,6 +203,7 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 		dvbdev->readers++;
 		if (dmxdev->dvr_buffer.data) {
 			void *mem = dmxdev->dvr_buffer.data;
+			/*memory barrier*/
 			mb();
 			spin_lock_irq(&dmxdev->lock);
 			dmxdev->dvr_buffer.data = NULL;
@@ -876,7 +878,7 @@ static int dvb_dmxdev_pes_filter_set(struct dmxdev *dmxdev,
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 	dvb_dmxdev_filter_reset(dmxdevfilter);
 
-	if ((unsigned)params->pes_type > DMX_PES_OTHER)
+	if ((unsigned int)params->pes_type > DMX_PES_OTHER)
 		return -EINVAL;
 
 	dmxdevfilter->type = DMXDEV_TYPE_PES;
@@ -1125,7 +1127,7 @@ static int dvb_demux_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&dmxdev->mutex);
 	dmxdev->dvbdev->users--;
-	if(dmxdev->dvbdev->users==1 && dmxdev->exit==1) {
+	if (dmxdev->dvbdev->users == 1 && dmxdev->exit == 1) {
 		mutex_unlock(&dmxdev->mutex);
 		wake_up(&dmxdev->dvbdev->wait_queue);
 	} else
@@ -1263,14 +1265,14 @@ EXPORT_SYMBOL(dvb_dmxdev_init);
 
 void dvb_dmxdev_release(struct dmxdev *dmxdev)
 {
-	dmxdev->exit=1;
+	dmxdev->exit = 1;
 	if (dmxdev->dvbdev->users > 1) {
 		wait_event(dmxdev->dvbdev->wait_queue,
-				dmxdev->dvbdev->users==1);
+				dmxdev->dvbdev->users == 1);
 	}
 	if (dmxdev->dvr_dvbdev->users > 1) {
 		wait_event(dmxdev->dvr_dvbdev->wait_queue,
-				dmxdev->dvr_dvbdev->users==1);
+				dmxdev->dvr_dvbdev->users == 1);
 	}
 
 	dvb_unregister_device(dmxdev->dvbdev);
-- 
2.7.4

