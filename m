Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51235 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3KCAdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:33:55 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1Vclda-0001sY-QV
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:33:54 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 3B323140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:33:54 +0100 (CET)
Date: Sun, 3 Nov 2013 01:33:54 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/12] dvb-core: export dvb_usercopy and new DVB device
 constants
Message-ID: <20131103003354.GJ7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added EXPORT_SYMBOL(dvb_usercopy) to allow new ddbridge driver to
use it. It is questionable if I should use it in this way or not.
If not I will fix it.

Added two new DVB device constants DVB_DEVICE_CI and DVB_DEVICE_MOD
required by newer ddbridge driver. Again it is questionable to use
them or modify ddbridge driver.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/dvb-core/dvbdev.c | 1 +
 drivers/media/dvb-core/dvbdev.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 401ef64..e451e9e 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -438,6 +438,7 @@ out:
 	kfree(mbuf);
 	return err;
 }
+EXPORT_SYMBOL(dvb_usercopy);
 
 static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 93a9470..016c46e 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -47,6 +47,8 @@
 #define DVB_DEVICE_CA         6
 #define DVB_DEVICE_NET        7
 #define DVB_DEVICE_OSD        8
+#define DVB_DEVICE_CI         9
+#define DVB_DEVICE_MOD       10
 
 #define DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr) \
 	static short adapter_nr[] = \
-- 
1.8.4.2
