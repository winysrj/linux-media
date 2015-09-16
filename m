Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34471 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbIPQeQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 12:34:16 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, corbet@lwn.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [media] dvbdev: Fix warnings while make htmldocs caused by dvbdev.h
Date: Thu, 17 Sep 2015 01:34:47 +0900
Message-Id: <1442421287-22517-1-git-send-email-standby24x7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix following warning while "make htmldocs".

.//drivers/media/dvb-core/dvbdev.h:199: warning: Excess
function parameter 'device' description in 'dvb_register_device'
.//drivers/media/dvb-core/dvbdev.h:199: warning: Excess
function parameter 'adapter_nums' description in 'dvb_register_device'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/dvb-core/dvbdev.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index c61a4f0..1069a77 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -184,10 +184,6 @@ int dvb_unregister_adapter(struct dvb_adapter *adap);
  * @pdvbdev:	pointer to the place where the new struct dvb_device will be
  *		stored
  * @template:	Template used to create &pdvbdev;
- * @device:	pointer to struct device that corresponds to the device driver
- * @adapter_nums: Array with a list of the numbers for @dvb_register_adapter;
- * 		to select among them. Typically, initialized with:
- *		DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums)
  * @priv:	private data
  * @type:	type of the device: DVB_DEVICE_SEC, DVB_DEVICE_FRONTEND,
  *		DVB_DEVICE_DEMUX, DVB_DEVICE_DVR, DVB_DEVICE_CA, DVB_DEVICE_NET
-- 
2.6.0.rc2

