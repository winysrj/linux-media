Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UgS015916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 57/94] [media] stv090x: use .delsys property, instead of get_property()
Date: Fri, 30 Dec 2011 13:07:54 -0200
Message-Id: <1325257711-12274-58-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the DVB ops struct contains the supported delivery
systems, use it, instead of adding a get_property() callback
just due to that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/stv090x.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 8a2637c..574ef67 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -4711,23 +4711,8 @@ int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio, u8 dir, u8 value,
 }
 EXPORT_SYMBOL(stv090x_set_gpio);
 
-static int stv090x_get_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DSS;
-		p->u.buffer.data[1] = SYS_DVBS;
-		p->u.buffer.data[2] = SYS_DVBS2;
-		p->u.buffer.len = 3;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static struct dvb_frontend_ops stv090x_ops = {
-
+	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV090x Multistandard",
 		.type			= FE_QPSK,
@@ -4759,8 +4744,6 @@ static struct dvb_frontend_ops stv090x_ops = {
 	.read_ber			= stv090x_read_per,
 	.read_signal_strength		= stv090x_read_signal_strength,
 	.read_snr			= stv090x_read_cnr,
-
-	.get_property			= stv090x_get_property,
 };
 
 
-- 
1.7.8.352.g876a6

