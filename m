Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:24225 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbeJ0VCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 17:02:17 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: mxl5xx: constify dvb_frontend_ops structure
Date: Sat, 27 Oct 2018 13:46:11 +0200
Message-Id: <1540640771-25478-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_frontend_ops structure is only copied into the ops field
of a dvb_frontend structure, so it can be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/dvb-frontends/mxl5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 6191315f5970..290b9eab099f 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -781,7 +781,7 @@ static int set_input(struct dvb_frontend *fe, int input)
 	return 0;
 }
 
-static struct dvb_frontend_ops mxl_ops = {
+static const struct dvb_frontend_ops mxl_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "MaxLinear MxL5xx DVB-S/S2 tuner-demodulator",
