Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6431 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932255AbcIKPCZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 11:02:25 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Michael Krufky <mkrufky@linuxtv.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [media] mxl111sf-tuner: constify dvb_tuner_ops structures
Date: Sun, 11 Sep 2016 16:44:14 +0200
Message-Id: <1473605054-9002-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1473605054-9002-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473605054-9002-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These structures are only used to copy into other structures, so declare
them as const.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable optional_qualifier@
identifier i;
position p;
@@
static struct dvb_tuner_ops i@p = { ... };

@ok1@
identifier r.i;
expression e;
position p;
@@
e = i@p

@ok2@
identifier r.i;
expression e1, e2;
position p;
@@
memcpy(e1, &i@p, e2)

@bad@
position p != {r.p,ok1.p,ok2.p};
identifier r.i;
struct dvb_tuner_ops e;
@@
e@i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct dvb_tuner_ops i = { ... };
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index 7d16252..f141dcc 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -466,7 +466,7 @@ static int mxl111sf_tuner_release(struct dvb_frontend *fe)
 
 /* ------------------------------------------------------------------------- */
 
-static struct dvb_tuner_ops mxl111sf_tuner_tuner_ops = {
+static const struct dvb_tuner_ops mxl111sf_tuner_tuner_ops = {
 	.info = {
 		.name = "MaxLinear MxL111SF",
 #if 0

