Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbbBMW6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 17:58:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>
Subject: [PATCHv4 11/25] [media] dmxdev: add support for demux/dvr nodes at media controller
Date: Fri, 13 Feb 2015 20:57:54 -0200
Message-Id: <d84db90ced312545effdea1ebcea08d8c7df9fab.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1423867976.git.mchehab@osg.samsung.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core demux support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index abff803ad69a..2835924955a4 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1136,10 +1136,13 @@ static const struct file_operations dvb_demux_fops = {
 	.llseek = default_llseek,
 };
 
-static struct dvb_device dvbdev_demux = {
+static const struct dvb_device dvbdev_demux = {
 	.priv = NULL,
 	.users = 1,
 	.writers = 1,
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	.name = "demux",
+#endif
 	.fops = &dvb_demux_fops
 };
 
@@ -1209,13 +1212,15 @@ static const struct file_operations dvb_dvr_fops = {
 	.llseek = default_llseek,
 };
 
-static struct dvb_device dvbdev_dvr = {
+static const struct dvb_device dvbdev_dvr = {
 	.priv = NULL,
 	.readers = 1,
 	.users = 1,
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	.name = "dvr",
+#endif
 	.fops = &dvb_dvr_fops
 };
-
 int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 {
 	int i;
-- 
2.1.0

