Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E992C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4803B20830
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 20:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfCDUpk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:45:40 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:39135 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfCDUpk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 15:45:40 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MTznQ-1gbA6M1Szq-00QywR; Mon, 04 Mar 2019 21:45:28 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Max Kellermann <max.kellermann@gmail.com>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>,
        stable@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] media: don't drop front-end reference count for ->detach
Date:   Mon,  4 Mar 2019 21:45:07 +0100
Message-Id: <20190304204525.2283399-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:iI74MnyTBaXWF8tbrf+pNC1Oojm3y2POdwWl4TEPZLyoh5CmnTP
 Nruwx81FdKEr7tPiQUdTLiorqdtpDshY82RJko3tC6QX1RrPkxgON9SSySfZx0g+bGk6v2W
 EaZzbVxlolwwhoQgU1dShBaNO+vdFEKUGUMaseLEVs24TtCcicAw+AjU3nAgNfkub4N6CI2
 YrFcGI4Na/RqzEZBHjGfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZtKn1Z0UpbU=:He3v2Sb2TeeN/7q4AkRnn1
 HHBPkv00h9vt/m7fbMgZH5yoirS6b1+CLRioRn89JApFOIl+yzUSrKLTdHU8oRBjAQU7YXCGe
 w/nQdVZjd3nywv+hbfdWVMbBGhGYkmi8L9MSbDiB/0PwTW4XV3n1pIoj7fcdmaWdkmpxh5ehy
 AwERIwynB1nVSvp+sbSu9KCEpj2keVN37PtjmaEmkgQVZYu47Nf1Lr2nD4rnjPIms4jpo66XK
 pXF0x8tMb4qw692PH90jXLrFwYwoZTaFNH0290WafyQ2fuBk2IaHCZM8jIYKTCilDKEwfjhD7
 MGnfkbbV9MRTUCwhA/SjBOIVbEYcJDGxnUEkrWu1kmwZK4mNCvi7HzQWXA2gksvMxIwMSF4Em
 ijERTOgZuexGltM+nIIprSJJ7Lwh+0P0k4rkTsGokb2NXdrs00K1es9QlhyzMShg0DxEJztwo
 WMm+yA/Aa1CSUHhuRozpZIuaRBbSRKufYsHhCaEFg05Aleq1IhOqKMQb8pnBmhwLhtRISu9Mb
 c1E1eYS+geT9p7NhJyzrB0PY+tPxOw9TKKaNB0tuLOaUvFtGP02tolTDdacnhRbi3SD1hYlUt
 KqRlYgJyro4jho4P26b6EhGge299eIw5eldXCFRx5QKpDbVGg3aFxMyKkVlV+ko2AiomiuJTk
 YyEgte0B8K1Kw7gzqyjZ6MQwvK2aA/3ofrPSiDgK8jLG8wiYpihd/ICEhkQ54QSTPUNBVHgUb
 5gZWT0xPRNvFYPOLnUYstXxs2EsfDUrvnFolfw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A bugfix introduce a link failure in configurations without CONFIG_MODULES:

In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:0:
drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak declaration of 'stb0899_attach' being applied to a already existing, static definition

The problem is that the !IS_REACHABLE() declaration of stb0899_attach()
is a 'static inline' definition that clashes with the weak definition.

I further observed that the bugfix was only done for one of the five users
of stb0899_attach(), the other four still have the problem.  This reverts
the bugfix and instead addresses the problem by not dropping the reference
count when calling '->detach()', instead we call this function directly
in dvb_frontend_put() before dropping the kref on the front-end.

I first submitted this in early 2018, and after some discussion it
was apparently discarded.  While there is a long-term plan in place,
that plan is obviously not nearing completion yet, and the current
kernel is still broken unless this patch is applied.

Cc: Max Kellermann <max.kellermann@gmail.com>
Cc: Wolfgang Rohdewald <wolfgang@rohdewald.de>
Cc: stable@vger.kernel.org
Fixes: f686c14364ad ("[media] stb0899: move code to "detach" callback")
Fixes: 6cdeaed3b142 ("media: dvb_usb_pctv452e: module refcount changes were unbalanced")
Link: https://patchwork.kernel.org/patch/10140175/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/dvb_frontend.c | 4 +++-
 drivers/media/usb/dvb-usb/pctv452e.c  | 8 --------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index fbdb4ecc7c50..eb5da50ff95e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -164,6 +164,9 @@ static void dvb_frontend_free(struct kref *ref)
 
 static void dvb_frontend_put(struct dvb_frontend *fe)
 {
+	/* call detach before dropping the reference count */
+	if (fe->ops.detach)
+		fe->ops.detach(fe);
 	/*
 	 * Check if the frontend was registered, as otherwise
 	 * kref was not initialized yet.
@@ -3038,7 +3041,6 @@ void dvb_frontend_detach(struct dvb_frontend *fe)
 	dvb_frontend_invoke_release(fe, fe->ops.release_sec);
 	dvb_frontend_invoke_release(fe, fe->ops.tuner_ops.release);
 	dvb_frontend_invoke_release(fe, fe->ops.analog_ops.release);
-	dvb_frontend_invoke_release(fe, fe->ops.detach);
 	dvb_frontend_put(fe);
 }
 EXPORT_SYMBOL(dvb_frontend_detach);
diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index 150081128196..5c653b660272 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -913,14 +913,6 @@ static int pctv452e_frontend_attach(struct dvb_usb_adapter *a)
 						&a->dev->i2c_adap);
 	if (!a->fe_adap[0].fe)
 		return -ENODEV;
-
-	/*
-	 * dvb_frontend will call dvb_detach for both stb0899_detach
-	 * and stb0899_release but we only do dvb_attach(stb0899_attach).
-	 * Increment the module refcount instead.
-	 */
-	symbol_get(stb0899_attach);
-
 	if ((dvb_attach(lnbp22_attach, a->fe_adap[0].fe,
 					&a->dev->i2c_adap)) == NULL)
 		err("Cannot attach lnbp22\n");
-- 
2.20.0

