Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1BNVPq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:15:46 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1ELFk6m023366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:15:46 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TGF012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:15:45 -0500
Date: Mon, 14 Feb 2011 19:03:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/14] [media] tuner-core: dead code removal
Message-ID: <20110214190322.4a7f19be@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove the now obsolete set_freq. Also merge set_addr and set_type_addr.

In the past, it used to have two different setup calls, one to set just
the tuner type to any tuner found, and another to set the type only if
the address matches. Those two internal calls were grouped together,
but the functions weren't merged, making the code uglier.

No functional changes are done in this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 16939ca..2a0bea1 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -419,10 +419,17 @@ attach_failed:
  * it's applied. Otherwise status and type are applied only to
  * tuner with exactly the same addr.
 */
-
-static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
+static int tuner_s_type_addr(struct v4l2_subdev *sd,
+			     struct tuner_setup *tun_setup)
 {
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
+	struct tuner *t = to_tuner(sd);
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+
+	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
+			tun_setup->type,
+			tun_setup->addr,
+			tun_setup->mode_mask,
+			tun_setup->config);
 
 	if ((t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
 	    (t->mode_mask & tun_setup->mode_mask))) ||
@@ -434,20 +441,7 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 			  "Asked to change tuner at addr 0x%02x, with mask %x\n",
 			  t->type, t->mode_mask,
 			  tun_setup->addr, tun_setup->mode_mask);
-}
 
-static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
-{
-	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
-			type->type,
-			type->addr,
-			type->mode_mask,
-			type->config);
-
-	set_addr(client, type);
 	return 0;
 }
 
@@ -900,27 +894,6 @@ static int set_mode_freq(struct i2c_client *client, struct tuner *t,
 	return 0;
 }
 
-/*
- * Functions that should be broken into separate radio/TV functions
- */
-
-static void set_freq(struct i2c_client *c, unsigned long freq)
-{
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
-
-	switch (t->mode) {
-	case V4L2_TUNER_RADIO:
-		set_radio_freq(c, freq);
-		break;
-	case V4L2_TUNER_ANALOG_TV:
-	case V4L2_TUNER_DIGITAL_TV:
-		set_tv_freq(c, freq);
-		break;
-	default:
-		tuner_dbg("freq set: unknown mode: 0x%04x!\n", t->mode);
-	}
-}
-
 /**
  * tuner_status - Dumps the current tuner status at dmesg
  * @fe: pointer to struct dvb_frontend
-- 
1.7.1


