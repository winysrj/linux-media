Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-155.163.com ([123.125.50.155]:48790 "EHLO m50-155.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbbIQHNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 03:13:21 -0400
From: Geliang Tang <geliangtang@163.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Geliang Tang <geliangtang@163.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: dvb-core: fix kernel-doc warnings in dvbdev.h
Date: Wed, 16 Sep 2015 23:25:21 -0700
Message-Id: <83362567862e81677c4de35b98b5eae5d8aaad72.1442499384.git.geliangtang@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the following 'make htmldocs' warnings:

  .//drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'device' description in 'dvb_register_device'
  .//drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'adapter_nums' description in 'dvb_register_device'

Signed-off-by: Geliang Tang <geliangtang@163.com>
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
1.9.1


