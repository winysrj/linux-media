Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0IHQQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 12:16:14 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o88GGEwX029949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 12:16:14 -0400
Received: from [10.11.11.235] (vpn-11-235.rdu.redhat.com [10.11.11.235])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o88GGBNa002755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 8 Sep 2010 12:16:13 -0400
Message-ID: <4C87B6D0.8000509@redhat.com>
Date: Wed, 08 Sep 2010 13:16:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L/DVB: rc-core: increase repeat time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

As reported by Anton Blanchard <anton@samba.org>, double IR events on
2.6.36-rc2 and a DViCO FusionHDTV DVB-T Dual Express are happening:

[ 1351.032084] ir_keydown: i2c IR (FusionHDTV): key down event, key 0x0067, scancode 0x0051
[ 1351.281284] ir_keyup: keyup key 0x0067

ie one key down event and one key up event 250ms later.

So, we need to increase the repeat timeout, to avoid this bug to hit.

As we're doing it at core, this fix is not needed anymore at dib0700 driver.

Thanks-to: Anton Blanchard <anton@samba.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 7e82a9d..d00ef19 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -510,6 +510,13 @@ int __ir_input_register(struct input_dev *input_dev,
 		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
 			" in raw mode" : "");
 
+	/*
+	 * Default delay of 250ms is too short for some protocols, expecially
+	 * since the timeout is currently set to 250ms. Increase it to 500ms,
+	 * to avoid wrong repetition of the keycodes.
+	 */
+	input_dev->rep[REP_DELAY] = 500;
+
 	return 0;
 
 out_event:
diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index fe81834..48397f1 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -673,9 +673,6 @@ static int dib0700_probe(struct usb_interface *intf,
 			else
 				dev->props.rc.core.bulk_mode = false;
 
-			/* Need a higher delay, to avoid wrong repeat */
-			dev->rc_input_dev->rep[REP_DELAY] = 500;
-
 			dib0700_rc_setup(dev);
 
 			return 0;
-- 
1.7.1

