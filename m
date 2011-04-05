Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55760 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1DED0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 23:26:05 -0400
Date: Mon, 4 Apr 2011 22:25:58 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 2/7] [media] cx88: fix locking of sub-driver operations
Message-ID: <20110405032558.GC4498@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110405032014.GA4498@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405032014.GA4498@elie>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The BKL conversion of this driver seems to have gone wrong.
Loading the cx88-blackbird driver deadlocks.

The cause: mpeg_ops::open in the cx2388x blackbird driver acquires the
device lock and calls the sub-driver's request_acquire, which tries to
acquire the lock again.  Fix it by clarifying the semantics of
request_acquire, request_release, advise_acquire, and advise_release:
all will require the caller to hold the device lock.

Based on a patch by Ben Hutchings <ben@decadent.org.uk>.

Reported-by: Andi Huber <hobrom@gmx.at>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=31962
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@kernel.org
---
 drivers/media/video/cx88/cx88-blackbird.c |    4 ++--
 drivers/media/video/cx88/cx88-dvb.c       |    3 +--
 drivers/media/video/cx88/cx88-mpeg.c      |    4 ----
 drivers/media/video/cx88/cx88.h           |    3 ++-
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index b93fbd3..a6f7d53 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1125,13 +1125,13 @@ static int mpeg_release(struct file *file)
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	mutex_unlock(&dev->core->lock);
-
 	if (drv)
 		drv->request_release(drv);
 
 	atomic_dec(&dev->core->mpeg_users);
 
+	mutex_unlock(&dev->core->lock);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 84002bc..c69df7e 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -135,8 +135,6 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 
 	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
-	mutex_unlock(&dev->core->lock);
-
 	if (drv) {
 		if (acquire){
 			dev->frontends.active_fe_id = fe_id;
@@ -146,6 +144,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 			dev->frontends.active_fe_id = 0;
 		}
 	}
+	mutex_unlock(&dev->core->lock);
 
 	return ret;
 }
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 918172b..9147c16 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -624,13 +624,11 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 
 	if (drv->advise_acquire)
 	{
-		mutex_lock(&drv->core->lock);
 		core->active_ref++;
 		if (core->active_type_id == CX88_BOARD_NONE) {
 			core->active_type_id = drv->type_id;
 			drv->advise_acquire(drv);
 		}
-		mutex_unlock(&drv->core->lock);
 
 		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
@@ -643,14 +641,12 @@ static int cx8802_request_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 
-	mutex_lock(&drv->core->lock);
 	if (drv->advise_release && --core->active_ref == 0)
 	{
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
 		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
-	mutex_unlock(&drv->core->lock);
 
 	return 0;
 }
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index e3d56c2..9731daa 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -510,7 +510,8 @@ struct cx8802_driver {
 	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
 
-	/* Caller must hold core->lock */
+	/* Callers to the following functions must hold core->lock */
+
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */
-- 
1.7.5.rc0

