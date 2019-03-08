Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F740C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 22:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14C732085A
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 22:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PY9Fdfzg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCHWWF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 17:22:05 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34700 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfCHWWF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 17:22:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id f14so22929673wrg.1
        for <linux-media@vger.kernel.org>; Fri, 08 Mar 2019 14:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QlVlRzLx9a7bxc6HKvqUV7a/fOaAdDI3edwx27D4z1Q=;
        b=PY9FdfzgGxW9NXOe8j0MDHh8riRv8XekUbOY5m+ad+SIBcRw0xPeB3rXMbOQq13otU
         CvUJmeV2rDgtacbBdqYGZKpAd+/+QyV+5zM/2T7Smov1pA6WDn/BqK2Tybobd5oy9VZJ
         ZsubNoh+eDdOPJjsX1ZT2+V8ohmlM5ZZwwbR9U/cykQnYQ/mdZTdZsiAuFi4IJMpfyR0
         pWNJWFPIleH7KGiIuV98rTf0H6AMtl/X4AmUvpViOtQyAhra+60dD6fSDKniZJ7G8eZb
         mkZ4Nh6fftstwIyy4Oar4ok1g9lG+v7GzdqiWnNM5UC/Yuzr7UzefpshHNCMbKlp2e9Q
         QnCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QlVlRzLx9a7bxc6HKvqUV7a/fOaAdDI3edwx27D4z1Q=;
        b=pljYFABAm8EdCexoZnTe4n0wT1mZbMWVgvyfVJ6dNshzxJfWTFSbJ3Acflh9iZnH15
         r9JigKAqg/M7H+cOIdF3QmeY/afovyTFMLHl4hbqfYLl9FtsvBqEotpLlp0UJTc652Z0
         i5ymEO//4KA5uatd8/GNPEH0lO5SNN6XLE/JrGEEPEQbHoxsNGvgFgWii9vNUOYibDke
         uK+ofIlENEHJ6wp990KUe7xNvSJ0auBnjCibPdyZjOiY/DWBg6L5g+sAwNMuHc0gdlJ8
         6iNaQ309MRUi/1YGUqrsCnBbwj8pQbKnAJSyNLqYWW5ac4dtqzc+D2A6Morhl7Dmdq7B
         HvBw==
X-Gm-Message-State: APjAAAVTn6GRJIcmRDZFYaTTi8GjEs48rX+PvDHx0dAp8WXsChfULNj5
        LrnA+pl95VDpL9nUuugk5/zLqSbLSWQ=
X-Google-Smtp-Source: APXvYqxyxVheb4Nr4qkiedr/HoJxfwjF280YJ4z4JsteDGtJmkeLGSuDZYn8z+9gCZuc8VQOwbl+IA==
X-Received: by 2002:adf:f08b:: with SMTP id n11mr13069441wro.182.1552083722736;
        Fri, 08 Mar 2019 14:22:02 -0800 (PST)
Received: from localhost.localdomain (83-148-219-219.dynamic.lounea.fi. [83.148.219.219])
        by smtp.gmail.com with ESMTPSA id x17sm22774511wrd.95.2019.03.08.14.22.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 14:22:02 -0800 (PST)
From:   Stefan Becker <chemobejk@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stefan Becker <chemobejk@gmail.com>
Subject: [PATCH] media: si2168: add parameter to disable DVB-T support
Date:   Sat,  9 Mar 2019 00:21:48 +0200
Message-Id: <20190308222148.15194-1-chemobejk@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some DVB clients are broken and only recognize the DVB-T/T2 support in
the frontend. Thus they are unable to use the frontend in DVB-C mode.
One example is the incomplete DVBv5 API support added in mythtv 0.30:

   https://code.mythtv.org/trac/ticket/12638

The boolean module parameter "disable_dvb_t" removes DVB-T and DVB-T2
from the delsys list in dvb_frontend_ops and thus forces the client to
recognize a DVB-C frontend.

Signed-off-by: Stefan Becker <chemobejk@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 324493e05f9f..8aeb024057dc 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -14,10 +14,15 @@
  *    GNU General Public License for more details.
  */
 
+#include <linux/module.h>
 #include <linux/delay.h>
 
 #include "si2168_priv.h"
 
+static bool disable_dvb_t;
+module_param(disable_dvb_t, bool, 0644);
+MODULE_PARM_DESC(disable_dvb_t, "Disable DVB-T/T2 support (default: enabled)");
+
 static const struct dvb_frontend_ops si2168_ops;
 
 /* execute firmware command */
@@ -800,6 +805,10 @@ static int si2168_probe(struct i2c_client *client,
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
+	if (disable_dvb_t) {
+		memset(dev->fe.ops.delsys, 0, sizeof(dev->fe.ops.delsys));
+		dev->fe.ops.delsys[0] = SYS_DVBC_ANNEX_A;
+	}
 	dev->fe.demodulator_priv = client;
 	*config->i2c_adapter = dev->muxc->adapter[0];
 	*config->fe = &dev->fe;
-- 
2.20.1

