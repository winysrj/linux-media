Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51372 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KCAgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:36:21 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1VclUQ-0001qW-7t
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:24:26 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id A94AA140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:24:25 +0100 (CET)
Date: Sun, 3 Nov 2013 01:24:25 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 01/12] dvb-frontends: Support for DVB-C2 to DVB frontends
Message-ID: <20131103002425.GE7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added support for DVB-C2 to DVB frontends. It will be required
by cxd2843 and tda18212dd (Digital Devices) frontends.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 include/uapi/linux/dvb/frontend.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index c56d77c..98648eb 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -410,6 +410,7 @@ typedef enum fe_delivery_system {
 	SYS_DVBT2,
 	SYS_TURBO,
 	SYS_DVBC_ANNEX_C,
+	SYS_DVBC2,
 } fe_delivery_system_t;
 
 /* backward compatibility */
-- 
1.8.4.2
