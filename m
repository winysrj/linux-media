Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01CDC4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A801B2133D
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 19:16:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="om+zhDTu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfB0TQh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:16:37 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:44771 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfB0TQh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 14:16:37 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B7F345E4D8F;
        Wed, 27 Feb 2019 19:16:33 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.19.140])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 8AD155E4C4F;
        Wed, 27 Feb 2019 19:16:26 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 19:16:32 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Wide-Eyed-Shrill: 3e56662256bb50cb_1551294987025_3043302518
X-MC-Loop-Signature: 1551294987025:2484362935
X-MC-Ingress-Time: 1551294987025
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id ADA947FF1F;
        Wed, 27 Feb 2019 11:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=GcaEOVLdql7MEy27bkeLywe7ZPc=; b=om+zhDTu3w9
        mcAKNi9w1jjGmKLJt71Buu1gKNGa8OmMHMNP+m5tWC2yRNTq674FN/7xsDDcqEvq
        vi2lNt3FoboRCRDr8SB5MamPeo62vHKQLH5vkD9YSy6O7pWKjA8Wg1TgcF8/UmVI
        rYvR0O3/vZWXSwQbmdGIe6QAd3CyO5iM=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id 901B17FF21;
        Wed, 27 Feb 2019 11:16:19 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v4 2/4] pvrusb2: Add multiple dvb frontend support
Date:   Wed, 27 Feb 2019 13:16:04 -0600
Message-Id: <1551294966-12564-3-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551294966-12564-1-git-send-email-brad@nextdimension.cc>
References: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
 <1551294966-12564-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvddugdduvdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

All changes are equivalent and backwards compatible.
All current devices have been changed to use fe[0]
Cleanup has been added to dvb init to support cleanup after failure.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/usb/pvrusb2/pvrusb2-devattr.c | 36 +++++++-------
 drivers/media/usb/pvrusb2/pvrusb2-dvb.c     | 77 ++++++++++++++++++++++-------
 drivers/media/usb/pvrusb2/pvrusb2-dvb.h     |  2 +-
 3 files changed, 77 insertions(+), 38 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
index 06de1c8..ef36b62 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
@@ -188,10 +188,10 @@ static struct lgdt330x_config pvr2_lgdt3303_config = {
 
 static int pvr2_lgdt3303_attach(struct pvr2_dvb_adapter *adap)
 {
-	adap->fe = dvb_attach(lgdt330x_attach, &pvr2_lgdt3303_config,
-			      0x0e,
-			      &adap->channel.hdw->i2c_adap);
-	if (adap->fe)
+	adap->fe[0] = dvb_attach(lgdt330x_attach, &pvr2_lgdt3303_config,
+				 0x0e,
+				 &adap->channel.hdw->i2c_adap);
+	if (adap->fe[0])
 		return 0;
 
 	return -EIO;
@@ -199,7 +199,7 @@ static int pvr2_lgdt3303_attach(struct pvr2_dvb_adapter *adap)
 
 static int pvr2_lgh06xf_attach(struct pvr2_dvb_adapter *adap)
 {
-	dvb_attach(simple_tuner_attach, adap->fe,
+	dvb_attach(simple_tuner_attach, adap->fe[0],
 		   &adap->channel.hdw->i2c_adap, 0x61,
 		   TUNER_LG_TDVS_H06XF);
 
@@ -248,10 +248,10 @@ static struct lgdt330x_config pvr2_lgdt3302_config = {
 
 static int pvr2_lgdt3302_attach(struct pvr2_dvb_adapter *adap)
 {
-	adap->fe = dvb_attach(lgdt330x_attach, &pvr2_lgdt3302_config,
+	adap->fe[0] = dvb_attach(lgdt330x_attach, &pvr2_lgdt3302_config,
 			      0x0e,
 			      &adap->channel.hdw->i2c_adap);
-	if (adap->fe)
+	if (adap->fe[0])
 		return 0;
 
 	return -EIO;
@@ -259,7 +259,7 @@ static int pvr2_lgdt3302_attach(struct pvr2_dvb_adapter *adap)
 
 static int pvr2_fcv1236d_attach(struct pvr2_dvb_adapter *adap)
 {
-	dvb_attach(simple_tuner_attach, adap->fe,
+	dvb_attach(simple_tuner_attach, adap->fe[0],
 		   &adap->channel.hdw->i2c_adap, 0x61,
 		   TUNER_PHILIPS_FCV1236D);
 
@@ -335,9 +335,9 @@ static struct tda18271_config hauppauge_tda18271_dvb_config = {
 
 static int pvr2_tda10048_attach(struct pvr2_dvb_adapter *adap)
 {
-	adap->fe = dvb_attach(tda10048_attach, &hauppauge_tda10048_config,
+	adap->fe[0] = dvb_attach(tda10048_attach, &hauppauge_tda10048_config,
 			      &adap->channel.hdw->i2c_adap);
-	if (adap->fe)
+	if (adap->fe[0])
 		return 0;
 
 	return -EIO;
@@ -345,10 +345,10 @@ static int pvr2_tda10048_attach(struct pvr2_dvb_adapter *adap)
 
 static int pvr2_73xxx_tda18271_8295_attach(struct pvr2_dvb_adapter *adap)
 {
-	dvb_attach(tda829x_attach, adap->fe,
+	dvb_attach(tda829x_attach, adap->fe[0],
 		   &adap->channel.hdw->i2c_adap, 0x42,
 		   &tda829x_no_probe);
-	dvb_attach(tda18271_attach, adap->fe, 0x60,
+	dvb_attach(tda18271_attach, adap->fe[0], 0x60,
 		   &adap->channel.hdw->i2c_adap,
 		   &hauppauge_tda18271_dvb_config);
 
@@ -433,9 +433,9 @@ static struct tda18271_config hauppauge_tda18271_config = {
 
 static int pvr2_s5h1409_attach(struct pvr2_dvb_adapter *adap)
 {
-	adap->fe = dvb_attach(s5h1409_attach, &pvr2_s5h1409_config,
+	adap->fe[0] = dvb_attach(s5h1409_attach, &pvr2_s5h1409_config,
 			      &adap->channel.hdw->i2c_adap);
-	if (adap->fe)
+	if (adap->fe[0])
 		return 0;
 
 	return -EIO;
@@ -443,9 +443,9 @@ static int pvr2_s5h1409_attach(struct pvr2_dvb_adapter *adap)
 
 static int pvr2_s5h1411_attach(struct pvr2_dvb_adapter *adap)
 {
-	adap->fe = dvb_attach(s5h1411_attach, &pvr2_s5h1411_config,
+	adap->fe[0] = dvb_attach(s5h1411_attach, &pvr2_s5h1411_config,
 			      &adap->channel.hdw->i2c_adap);
-	if (adap->fe)
+	if (adap->fe[0])
 		return 0;
 
 	return -EIO;
@@ -453,10 +453,10 @@ static int pvr2_s5h1411_attach(struct pvr2_dvb_adapter *adap)
 
 static int pvr2_tda18271_8295_attach(struct pvr2_dvb_adapter *adap)
 {
-	dvb_attach(tda829x_attach, adap->fe,
+	dvb_attach(tda829x_attach, adap->fe[0],
 		   &adap->channel.hdw->i2c_adap, 0x42,
 		   &tda829x_no_probe);
-	dvb_attach(tda18271_attach, adap->fe, 0x60,
+	dvb_attach(tda18271_attach, adap->fe[0], 0x60,
 		   &adap->channel.hdw->i2c_adap,
 		   &hauppauge_tda18271_config);
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
index 4b32b21..cb5586b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
@@ -343,26 +343,19 @@ static int pvr2_dvb_frontend_init(struct pvr2_dvb_adapter *adap)
 		goto done;
 	}
 
-	if ((dvb_props->frontend_attach(adap) == 0) && (adap->fe)) {
-
-		if (dvb_register_frontend(&adap->dvb_adap, adap->fe)) {
+	if (dvb_props->frontend_attach(adap) == 0 && adap->fe[0]) {
+		if (dvb_register_frontend(&adap->dvb_adap, adap->fe[0])) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 				   "frontend registration failed!");
-			dvb_frontend_detach(adap->fe);
-			adap->fe = NULL;
 			ret = -ENODEV;
-			goto done;
+			goto fail_frontend0;
 		}
+		if (adap->fe[0]->ops.analog_ops.standby)
+			adap->fe[0]->ops.analog_ops.standby(adap->fe[0]);
 
-		if (dvb_props->tuner_attach)
-			dvb_props->tuner_attach(adap);
-
-		if (adap->fe->ops.analog_ops.standby)
-			adap->fe->ops.analog_ops.standby(adap->fe);
-
-		/* Ensure all frontends negotiate bus access */
-		adap->fe->ops.ts_bus_ctrl = pvr2_dvb_bus_ctrl;
-
+		pvr2_trace(PVR2_TRACE_INFO, "transferring fe[%d] ts_bus_ctrl() to pvr2_dvb_bus_ctrl()",
+				adap->fe[0]->id);
+		adap->fe[0]->ops.ts_bus_ctrl = pvr2_dvb_bus_ctrl;
 	} else {
 		pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 			   "no frontend was attached!");
@@ -370,16 +363,62 @@ static int pvr2_dvb_frontend_init(struct pvr2_dvb_adapter *adap)
 		return ret;
 	}
 
- done:
+	if (dvb_props->tuner_attach && dvb_props->tuner_attach(adap)) {
+		pvr2_trace(PVR2_TRACE_ERROR_LEGS, "tuner attach failed");
+		ret = -ENODEV;
+		goto fail_tuner;
+	}
+
+	if (adap->fe[1]) {
+		adap->fe[1]->id = 1;
+		adap->fe[1]->tuner_priv = adap->fe[0]->tuner_priv;
+		memcpy(&adap->fe[1]->ops.tuner_ops,
+			&adap->fe[0]->ops.tuner_ops,
+			sizeof(struct dvb_tuner_ops));
+
+		if (dvb_register_frontend(&adap->dvb_adap, adap->fe[1])) {
+			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
+				   "frontend registration failed!");
+			ret = -ENODEV;
+			goto fail_frontend1;
+		}
+		/* MFE lock */
+		adap->dvb_adap.mfe_shared = 1;
+
+		if (adap->fe[1]->ops.analog_ops.standby)
+			adap->fe[1]->ops.analog_ops.standby(adap->fe[1]);
+
+		pvr2_trace(PVR2_TRACE_INFO, "transferring fe[%d] ts_bus_ctrl() to pvr2_dvb_bus_ctrl()",
+				adap->fe[1]->id);
+		adap->fe[1]->ops.ts_bus_ctrl = pvr2_dvb_bus_ctrl;
+	}
+done:
 	pvr2_channel_limit_inputs(&adap->channel, 0);
 	return ret;
+
+fail_frontend1:
+	dvb_frontend_detach(adap->fe[1]);
+	adap->fe[1] = NULL;
+fail_tuner:
+	dvb_unregister_frontend(adap->fe[0]);
+fail_frontend0:
+	dvb_frontend_detach(adap->fe[0]);
+	adap->fe[0] = NULL;
+
+	return ret;
 }
 
 static int pvr2_dvb_frontend_exit(struct pvr2_dvb_adapter *adap)
 {
-	if (adap->fe != NULL) {
-		dvb_unregister_frontend(adap->fe);
-		dvb_frontend_detach(adap->fe);
+	if (adap->fe[1]) {
+		dvb_unregister_frontend(adap->fe[1]);
+		dvb_frontend_detach(adap->fe[1]);
+		adap->fe[1] = NULL;
+	}
+	if (adap->fe[0]) {
+		dvb_unregister_frontend(adap->fe[0]);
+		dvb_frontend_detach(adap->fe[0]);
+		adap->fe[0] = NULL;
 	}
 	return 0;
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
index e7f71fb..91bff57 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
+++ b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
@@ -18,7 +18,7 @@ struct pvr2_dvb_adapter {
 	struct dmxdev		dmxdev;
 	struct dvb_demux	demux;
 	struct dvb_net		dvb_net;
-	struct dvb_frontend	*fe;
+	struct dvb_frontend	*fe[2];
 
 	int			feedcount;
 	int			max_feed_count;
-- 
2.7.4

