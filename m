Return-Path: <SRS0=n2cC=R2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278F8C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 02:46:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5CDA21900
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 02:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="JUNGUJtL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfCWCqY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 22:46:24 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:52296 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728115AbfCWCqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 22:46:24 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id D0D6BE25
        for <linux-media@vger.kernel.org>; Sat, 23 Mar 2019 02:46:22 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WyNYtbzqOlha for <linux-media@vger.kernel.org>;
        Fri, 22 Mar 2019 21:46:22 -0500 (CDT)
Received: from mail-it1-f199.google.com (mail-it1-f199.google.com [209.85.166.199])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 9AA1EE28
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 21:46:22 -0500 (CDT)
Received: by mail-it1-f199.google.com with SMTP id h82so3947234ita.7
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 19:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nurTLZi7ZZTrj3Ks+uFfVRbQaS2Tt+sCNdUD/Hv/o9Q=;
        b=JUNGUJtLZUBeVEan8WJJBefh26iJoBoPz5fD9erfqLHOrEAMv5XuVoVrn4h+rOyBWI
         6zgUJfNLFk+piU0Q89CjF1SLtI6X/OiHTqIU05ygcqhkX2ZQXD74Y2vDI7U9FPmDJ45J
         8w8oxm/Vos/Ox5xjq2tn/4zOv+W3IEOMZ00WGA7qjXuD7mrECOBd1fae0ZNxVoKiIa+9
         Taj11OBNgdwHhhfD24O2A4YPP/HB0IbZVC0wPVoedOy7/oXrHdJebnB568G8kDl25VKa
         5s67CMtmHLxmibZcanyN36a+xZz1JnDgdQbU7HjxziYii7XwQxNzNRfZoDqApaYPEY+K
         UXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nurTLZi7ZZTrj3Ks+uFfVRbQaS2Tt+sCNdUD/Hv/o9Q=;
        b=SPs0y9kCCWyAsBROoYoT8V5C+AgaVS31z/Fg3D3M2NDb7b967YKpxQuepljKXNf1BY
         UnlPTtNYSmmpjuxGm226m7ByA8Y9m8hOr5MZHMNRRl4L9kBjEo70Xu01Tlsm8BFa5oNi
         YIGeIRuSHLn1VRqIJleeSJmyS0TWdmHbzwuDX5XCK3SgcGdAb3FYtOBytFtCe8Zyh43e
         Vca4wvQ4YIydlaqDO5N/21EvY/1JDOWjOlolpSLfwd3tP6mGij2otwfj3oXDbaWxHOoH
         Kpfw0qNuVEKzne4kXG/6DYBgZo9y9KBp1vrJaHbmYqaPEQ5E/eQ+bk23bPbUVk+Hz3/3
         5V4g==
X-Gm-Message-State: APjAAAVC+I8bLONzXpV/Ioq1R/TbFE9p1xq1UOXe8/18YA0FBAuh8hKf
        C8JowdK5hrtpyiOF6WD6dTCbwaq/rIiJAjus+xDWcrRhe+KoKkqp98/RdbRLxh3z9ONOTJ9Qw5J
        nbUUE0bwjWChclI5WhQI896Ev99Q=
X-Received: by 2002:a6b:fb02:: with SMTP id h2mr9617144iog.239.1553309182241;
        Fri, 22 Mar 2019 19:46:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzziB4fDJzkDyDlx1s1sUp69LgPFZ1twEC+A5mkNFnvJUf0lBlTuxSw0DW2oj3BgmACrKjCFw==
X-Received: by 2002:a6b:fb02:: with SMTP id h2mr9617132iog.239.1553309182014;
        Fri, 22 Mar 2019 19:46:22 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id w4sm4244384ioa.38.2019.03.22.19.46.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 19:46:21 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: stv090x: add missed checks for STV090x_WRITE_DEMOD
Date:   Fri, 22 Mar 2019 21:46:13 -0500
Message-Id: <20190323024614.14883-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Conservatively check return value of STV090x_WRITE_DEMOD in case
it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/media/dvb-frontends/stv090x.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index a0622bb71803..3e2af3969e16 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -1446,14 +1446,17 @@ static int stv090x_start_search(struct stv090x_state *state)
 		/* >= Cut 3 */
 		if (state->srate <= 5000000) {
 			/* enlarge the timing bandwidth for Low SR */
-			STV090x_WRITE_DEMOD(state, RTCS2, 0x68);
+			if (STV090x_WRITE_DEMOD(state, RTCS2, 0x68) < 0)
+				goto err;
 		} else {
 			/* reduce timing bandwidth for high SR */
-			STV090x_WRITE_DEMOD(state, RTCS2, 0x44);
+			if (STV090x_WRITE_DEMOD(state, RTCS2, 0x44) < 0)
+				goto err;
 		}
 
 		/* Set CFR min and max to manual mode */
-		STV090x_WRITE_DEMOD(state, CARCFG, 0x46);
+		if (STV090x_WRITE_DEMOD(state, CARCFG, 0x46) < 0)
+			goto err;
 
 		if (state->algo == STV090x_WARM_SEARCH) {
 			/* WARM Start
@@ -2604,7 +2607,8 @@ static enum stv090x_signal_state stv090x_get_sig_params(struct stv090x_state *st
 
 	if (state->algo == STV090x_BLIND_SEARCH) {
 		tmg = STV090x_READ_DEMOD(state, TMGREG2);
-		STV090x_WRITE_DEMOD(state, SFRSTEP, 0x5c);
+		if (STV090x_WRITE_DEMOD(state, SFRSTEP, 0x5c) < 0)
+			goto err;
 		while ((i <= 50) && (tmg != 0) && (tmg != 0xff)) {
 			tmg = STV090x_READ_DEMOD(state, TMGREG2);
 			msleep(5);
@@ -2910,7 +2914,9 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 			pilots = STV090x_GETFIELD_Px(reg, DEMOD_TYPE_FIELD) & 0x01;
 			aclc = stv090x_optimize_carloop(state, modcod, pilots);
 			if (modcod <= STV090x_QPSK_910) {
-				STV090x_WRITE_DEMOD(state, ACLC2S2Q, aclc);
+				if (STV090x_WRITE_DEMOD(state, ACLC2S2Q, aclc)
+						< 0)
+					goto err;
 			} else if (modcod <= STV090x_8PSK_910) {
 				if (STV090x_WRITE_DEMOD(state, ACLC2S2Q, 0x2a) < 0)
 					goto err;
@@ -2972,7 +2978,8 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 	reg = STV090x_READ_DEMOD(state, TMGOBS);
 
 	if (state->algo == STV090x_BLIND_SEARCH) {
-		STV090x_WRITE_DEMOD(state, SFRSTEP, 0x00);
+		if (STV090x_WRITE_DEMOD(state, SFRSTEP, 0x00) < 0)
+			goto err;
 		reg = STV090x_READ_DEMOD(state, DMDCFGMD);
 		STV090x_SETFIELD_Px(reg, SCAN_ENABLE_FIELD, 0x00);
 		STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 0x00);
-- 
2.17.1

