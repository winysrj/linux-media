Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out-1.itc.rwth-aachen.de ([134.130.5.46]:9252 "EHLO
        mail-out-1.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932186AbeAIXno (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 18:43:44 -0500
From: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To: <linux-media@vger.kernel.org>
CC: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        "Michael Krufky" <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 2/2] [media] cxusb: restore RC_MAP for MyGica T230
Date: Wed, 10 Jan 2018 00:33:39 +0100
In-Reply-To: <20180109233339.8147-1-stefan.bruens@rwth-aachen.de>
References: <20180109233339.8147-1-stefan.bruens@rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Message-ID: <c813f10e-dcfb-4eba-a173-8d4b2ff60795@rwthex-w2-a.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit f8585ce655e9cdeabc38e8e2580b05735110e4a5 ("[media] dvb-usb-cxusb:
Geniatech T230C support") sneaked in an unrelated change for the older
T230 (not C) model. As the commit was reverted this change was reverted
too, although likely correct.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>

---

 drivers/media/usb/dvb-usb/cxusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index edb7cd2e43d9..75f44b534007 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -2165,7 +2165,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 
 	.rc.core = {
 		.rc_interval	= 100,
-		.rc_codes	= RC_MAP_D680_DMB,
+		.rc_codes	= RC_MAP_TOTAL_MEDIA_IN_HAND_02,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_d680_dmb_rc_query,
 		.allowed_protos = RC_PROTO_BIT_UNKNOWN,
-- 
2.15.1
