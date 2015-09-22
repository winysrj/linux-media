Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:33282 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752171AbbIVRYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 13:24:49 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
	tiwai@suse.de, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, perex@perex.cz,
	stefanr@s5r6.in-berlin.de, crope@iki.fi, dan.carpenter@oracle.com,
	tskd08@gmail.com, ruchandani.tina@gmail.com, arnd@arndb.de,
	chehabrafael@gmail.com, prabhakar.csengg@gmail.com,
	Julia.Lawall@lip6.fr, elfring@users.sourceforge.net,
	ricardo.ribalda@gmail.com, chris.j.arges@canonical.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, misterpib@gmail.com, takamichiho@gmail.com,
	pmatilai@laiskiainen.org, damien@zamaudio.com, daniel@zonque.org,
	vladcatoi@gmail.com, normalperson@yhbt.net, joe@oampo.co.uk,
	bugzilla.frnkcg@spamgourmet.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v3 20/21] media: media: dvb-frontend fix enable_source error legs
Date: Tue, 22 Sep 2015 11:19:39 -0600
Message-Id: <e1c8d1441a4add64e53b01899b2a9d63d1a868c6.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1442937669.git.shuahkh@osg.samsung.com>
References: <cover.1442937669.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When enable_source finds the tuner busy, do dvb_generic_release().
In addition, when dvb_frontend_start() fails, call disable_source
to release tuner.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c06dd61..67e30ae 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2503,13 +2503,13 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 			if (ret) {
 				dev_err(fe->dvb->device,
 					"Tuner is busy. Error %d\n", ret);
-				goto err1;
+				goto err2;
 			}
 		}
 #endif
 		ret = dvb_frontend_start (fe);
 		if (ret)
-			goto err2;
+			goto err3;
 
 		/*  empty event queue */
 		fepriv->events.eventr = fepriv->events.eventw = 0;
@@ -2519,6 +2519,11 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 
+err3:
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
+		fe->dvb->mdev->disable_source(dvbdev->entity);
+#endif
 err2:
 	dvb_generic_release(inode, file);
 err1:
-- 
2.1.4

