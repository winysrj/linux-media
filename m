Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60592 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbbJAR0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 13:26:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/5] [media] dvbdev: Remove two cut-and-paste errors
Date: Thu,  1 Oct 2015 14:25:59 -0300
Message-Id: <5a11cb1cd4cb7fe9cf44ca62bd9b472254f6e5b2.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two came from dvb_register_adapter cut-and-paste:

	.//drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'device' description in 'dvb_register_device'
	.//drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'adapter_nums' description in 'dvb_register_device'

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index c61a4f03a66f..1069a776bbdb 100644
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
2.4.3

