Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:36620 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbbGOAe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 20:34:27 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de, perex@perex.cz,
	crope@iki.fi, sakari.ailus@linux.intel.com, arnd@arndb.de,
	stefanr@s5r6.in-berlin.de, ruchandani.tina@gmail.com,
	chehabrafael@gmail.com, dan.carpenter@oracle.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com,
	agoode@google.com, pierre-louis.bossart@linux.intel.com,
	gtmkramer@xs4all.nl, clemens@ladisch.de, daniel@zonque.org,
	vladcatoi@gmail.com, misterpib@gmail.com, damien@zamaudio.com,
	pmatilai@laiskiainen.org, takamichiho@gmail.com,
	normalperson@yhbt.net, bugzilla.frnkcg@spamgourmet.com,
	joe@oampo.co.uk, calcprogrammer1@gmail.com, jussi@sonarnerd.net
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH 4/7] media: change dvb-frontend to honor MC tuner enable error
Date: Tue, 14 Jul 2015 18:34:03 -0600
Message-Id: <3fd487dbc197e7bcba390dc0d820b4264f426ff0.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1436917513.git.shuahkh@osg.samsung.com>
References: <cover.1436917513.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change dvb_frontend_thread() to honor MC tuner enable error and
return as opposed to ignoring the error and continuing to use it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8..5a86211 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -713,9 +713,8 @@ static int dvb_frontend_thread(void *data)
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	ret = dvb_enable_media_tuner(fe);
 	if (ret) {
-		/* FIXME: return an error if it fails */
-		dev_info(fe->dvb->device,
-			"proceeding with FE task\n");
+		dev_err(fe->dvb->device, "Tuner is busy. Error %d\n", ret);
+		return ret;
 	} else if (fepriv->pipe_start_entity) {
 		ret = media_entity_pipeline_start(fepriv->pipe_start_entity,
 						  &fepriv->pipe);
-- 
2.1.4

