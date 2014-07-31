Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43751 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaGaWdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 18:33:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] uapi: dvb: initial support for DVB-C2 standard
Date: Fri,  1 Aug 2014 01:33:06 +0300
Message-Id: <1406845988-2871-2-git-send-email-crope@iki.fi>
In-Reply-To: <1406845988-2871-1-git-send-email-crope@iki.fi>
References: <1406845988-2871-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just add delivery system for DVB-C2 standard. Other parameters
should be added later.

Signed-off-by: Antti Palosaari <crope@iki.fi>
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
http://palosaari.fi/

