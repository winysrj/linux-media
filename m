Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39189 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 09/26] [media] DocBook: document struct dvb_ca_en50221
Date: Sat, 10 Oct 2015 10:35:52 -0300
Message-Id: <d7061f836fb166467b0a39f6adec4a69a0c9b826.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This struct is already documented at the header file, but it is
not using Kernel doc-nano format. Convert to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
index aba3b4fbd704..9ec2adc3ea11 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.h
+++ b/drivers/media/dvb-core/dvb_ca_en50221.h
@@ -39,40 +39,43 @@
 
 
 
-/* Structure describing a CA interface */
+/**
+ * struct dvb_ca_en50221- Structure describing a CA interface
+ *
+ * @owner:		the module owning this structure
+ * @read_attribute_mem:	function for reading attribute memory on the CAM
+ * @write_attribute_mem: function for writing attribute memory on the CAM
+ * @read_cam_control:	function for reading the control interface on the CAM
+ * @write_cam_control:	function for reading the control interface on the CAM
+ * @slot_reset:		function to reset the CAM slot
+ * @slot_shutdown:	function to shutdown a CAM slot
+ * @slot_ts_enable:	function to enable the Transport Stream on a CAM slot
+ * @poll_slot_status:	function to poll slot status. Only necessary if
+ *			DVB_CA_FLAG_EN50221_IRQ_CAMCHANGE is not set.
+ * @data:		private data, used by caller.
+ * @private:		Opaque data used by the dvb_ca core. Do not modify!
+ *
+ * NOTE: the read_*, write_* and poll_slot_status functions will be
+ * called for different slots concurrently and need to use locks where
+ * and if appropriate. There will be no concurrent access to one slot.
+ */
 struct dvb_ca_en50221 {
 
-	/* the module owning this structure */
-	struct module* owner;
 
-	/* NOTE: the read_*, write_* and poll_slot_status functions will be
-	 * called for different slots concurrently and need to use locks where
-	 * and if appropriate. There will be no concurrent access to one slot.
-	 */
 
-	/* functions for accessing attribute memory on the CAM */
-	int (*read_attribute_mem)(struct dvb_ca_en50221* ca, int slot, int address);
 	int (*write_attribute_mem)(struct dvb_ca_en50221* ca, int slot, int address, u8 value);
 
-	/* functions for accessing the control interface on the CAM */
 	int (*read_cam_control)(struct dvb_ca_en50221* ca, int slot, u8 address);
 	int (*write_cam_control)(struct dvb_ca_en50221* ca, int slot, u8 address, u8 value);
 
-	/* Functions for controlling slots */
 	int (*slot_reset)(struct dvb_ca_en50221* ca, int slot);
 	int (*slot_shutdown)(struct dvb_ca_en50221* ca, int slot);
 	int (*slot_ts_enable)(struct dvb_ca_en50221* ca, int slot);
 
-	/*
-	* Poll slot status.
-	* Only necessary if DVB_CA_FLAG_EN50221_IRQ_CAMCHANGE is not set
-	*/
 	int (*poll_slot_status)(struct dvb_ca_en50221* ca, int slot, int open);
 
-	/* private data, used by caller */
 	void* data;
 
-	/* Opaque data used by the dvb_ca core. Do not modify! */
 	void* private;
 };
 
-- 
2.4.3


