Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeJaBJA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:09:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EE99C049586
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:55 +0000 (UTC)
Received: from wingsuit.redhat.com (ovpn-117-230.ams2.redhat.com [10.36.117.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8387510841E0
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2018 16:14:54 +0000 (UTC)
From: Victor Toso <victortoso@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH dvb v1 2/4] media: dvb: Use WARM definition from identify_state()
Date: Tue, 30 Oct 2018 17:14:49 +0100
Message-Id: <20181030161451.4560-3-victortoso@redhat.com>
In-Reply-To: <20181030161451.4560-1-victortoso@redhat.com>
References: <20181030161451.4560-1-victortoso@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Victor Toso <me@victortoso.com>

Device should be either COLD or WARM.
This change only make usage of the existing definition.

Signed-off-by: Victor Toso <me@victortoso.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 3b8f7931b730..d55ef016d418 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -957,9 +957,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 	if (d->props->identify_state) {
 		const char *name = NULL;
 		ret = d->props->identify_state(d, &name);
-		if (ret == 0) {
-			;
-		} else if (ret == COLD) {
+		if (ret == COLD) {
 			dev_info(&d->udev->dev,
 					"%s: found a '%s' in cold state\n",
 					KBUILD_MODNAME, d->name);
@@ -984,7 +982,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 			} else {
 				goto err_free_all;
 			}
-		} else {
+		} else if (ret != WARM) {
 			goto err_free_all;
 		}
 	}
-- 
2.17.2
