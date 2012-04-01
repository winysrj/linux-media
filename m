Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([129.241.93.19]:40794 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DAPyD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 11:54:03 -0400
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-media@vger.kernel.org
Cc: "Steinar H. Gunderson" <sesse@samfundet.no>
Subject: [PATCH 03/11] Hack to fix a mutex issue in the DVB layer.
Date: Sun,  1 Apr 2012 17:53:43 +0200
Message-Id: <1333295631-31866-3-git-send-email-sgunderson@bigfoot.com>
In-Reply-To: <20120401155330.GA31901@uio.no>
References: <20120401155330.GA31901@uio.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Steinar H. Gunderson" <sesse@samfundet.no>

dvb_usercopy(), which is called on all ioctls, not only copies data to and from
userspace, but also takes a lock on the file descriptor, which means that only
one ioctl can run at a time. This means that if one thread of mumudvb is busy
trying to get, say, the SNR from the frontend (which can hang due to the issue
above), the CAM thread's ioctl(fd, CA_GET_SLOT_INFO, ...) will hang, even
though it doesn't need to communicate with the hardware at all.  This obviously
requires a better fix, but I don't know the generic DVB layer well enough to
say what it is. Maybe it's some sort of remnant of from when all ioctl()s took
the BKL. Note that on UMP kernels without preemption, mutex_lock is to the best
of my knowledge a no-op, so these delay issues would not show up on non-SMP.

Signed-off-by: Steinar H. Gunderson <sesse@samfundet.no>
---
 drivers/media/dvb/dvb-core/dvbdev.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 00a6732..e1217f6 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -417,10 +417,8 @@ int dvb_usercopy(struct file *file,
 	}
 
 	/* call driver */
-	mutex_lock(&dvbdev_mutex);
 	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
 		err = -EINVAL;
-	mutex_unlock(&dvbdev_mutex);
 
 	if (err < 0)
 		goto out;
-- 
1.7.9.5

