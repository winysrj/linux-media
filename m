Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42746 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbLLNlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/6] dvbdev: Document the new MC-related fields
Date: Sat, 12 Dec 2015 11:40:40 -0200
Message-Id: <88f43ed940fb09e7c24f62c22b51a0e87ca589e0.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Media Controller next gen patchset added several new fields
to be used with it. Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index de85ba0f570a..abee18a402e1 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -120,6 +120,11 @@ struct dvb_adapter {
  * @entity:	pointer to struct media_entity associated with the device node
  * @pads:	pointer to struct media_pad associated with @entity;
  * @priv:	private data
+ * @intf_devnode: Pointer to media_intf_devnode. Used by the dvbdev core to
+ *		store the MC device node interface
+ * @tsout_num_entities: Number of Transport Stream output entities
+ * @tsout_entity: array with MC entities associated to each TS output node
+ * @tsout_pads: array with the source pads for each @tsout_entity
  *
  * This structure is used by the DVB core (frontend, CA, net, demux) in
  * order to create the device nodes. Usually, driver should not initialize
@@ -188,8 +193,11 @@ int dvb_unregister_adapter(struct dvb_adapter *adap);
  *		stored
  * @template:	Template used to create &pdvbdev;
  * @priv:	private data
- * @type:	type of the device: DVB_DEVICE_SEC, DVB_DEVICE_FRONTEND,
- *		DVB_DEVICE_DEMUX, DVB_DEVICE_DVR, DVB_DEVICE_CA, DVB_DEVICE_NET
+ * @type:	type of the device: %DVB_DEVICE_SEC, %DVB_DEVICE_FRONTEND,
+ *		%DVB_DEVICE_DEMUX, %DVB_DEVICE_DVR, %DVB_DEVICE_CA,
+ *		%DVB_DEVICE_NET
+ * @demux_sink_pads: Number of demux outputs, to be used to create the TS
+ *		outputs via the Media Controller.
  */
 int dvb_register_device(struct dvb_adapter *adap,
 			struct dvb_device **pdvbdev,
-- 
2.5.0


