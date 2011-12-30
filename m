Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vj4009159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 75/94] [media] gp8psk-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:12 -0200
Message-Id: <1325257711-12274-76-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/gp8psk-fe.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index 6189446..c40168f 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -113,28 +113,12 @@ static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int gp8psk_fe_set_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	deb_fe("%s(..)\n", __func__);
-	return 0;
-}
-
-static int gp8psk_fe_get_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	deb_fe("%s(..)\n", __func__);
-	return 0;
-}
-
-
-static int gp8psk_fe_set_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+static int gp8psk_fe_set_frontend(struct dvb_frontend* fe)
 {
 	struct gp8psk_fe_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 cmd[10];
-	u32 freq = fep->frequency * 1000;
+	u32 freq = c->frequency * 1000;
 	int gp_product_id = le16_to_cpu(state->d->udev->descriptor.idProduct);
 
 	deb_fe("%s()\n", __func__);
@@ -342,6 +326,7 @@ success:
 
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "Genpix DVB-S",
 		.type			= FE_QPSK,
@@ -366,9 +351,7 @@ static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.init = NULL,
 	.sleep = NULL,
 
-	.set_property = gp8psk_fe_set_property,
-	.get_property = gp8psk_fe_get_property,
-	.set_frontend_legacy = gp8psk_fe_set_frontend,
+	.set_frontend = gp8psk_fe_set_frontend,
 
 	.get_tune_settings = gp8psk_fe_get_tune_settings,
 
-- 
1.7.8.352.g876a6

