Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46229 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbbCNQtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 12:49:13 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl28xxu: return success for unimplemented FE callback
Date: Sat, 14 Mar 2015 18:48:54 +0200
Message-Id: <1426351734-30836-2-git-send-email-crope@iki.fi>
In-Reply-To: <1426351734-30836-1-git-send-email-crope@iki.fi>
References: <1426351734-30836-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return success for FE callback on case we don't have any special
implementation. fc0013 tuner driver calls that callback in order to
switch antenna input, even we don't provide antenna switch.
Returning error caused fc0013 driver given up tuning.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 77dcfdf..87fc0fe 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -780,8 +780,6 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
 		case TUNER_RTL2832_TUA9001:
 			return rtl2832u_tua9001_tuner_callback(d, cmd, arg);
 		}
-	default:
-		return -EINVAL;
 	}
 
 	return 0;
-- 
http://palosaari.fi/

