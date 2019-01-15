Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E2AC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DBD820656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfAOIzE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:04 -0500
Received: from shell.v3.sk ([90.176.6.54]:51308 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfAOIzE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id BDA574CC56;
        Tue, 15 Jan 2019 09:55:01 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id WUsbgX2Dr5aA; Tue, 15 Jan 2019 09:54:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 3E63E4CC79;
        Tue, 15 Jan 2019 09:54:54 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id thHpYfEl-zvy; Tue, 15 Jan 2019 09:54:53 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id E3D274C9F0;
        Tue, 15 Jan 2019 09:54:52 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH v4 1/5] ov7670: Remove useless use of a ret variable
Date:   Tue, 15 Jan 2019 09:54:44 +0100
Message-Id: <20190115085448.1400135-2-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115085448.1400135-1-lkundrak@v3.sk>
References: <20190115085448.1400135-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Instead of assigning the return value to ret and then checking and
returning it, just return the value to the caller directly. The success
value is always 0.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>

---
 drivers/media/i2c/ov7670.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 4939a83b50e4..61c47c61c693 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -859,11 +859,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *=
sd,
 	/* Recalculate frame rate */
 	ov7675_get_framerate(sd, tpf);
=20
-	ret =3D ov7670_write(sd, REG_CLKRC, info->clkrc);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ov7670_write(sd, REG_CLKRC, info->clkrc);
 }
=20
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
--=20
2.20.1

