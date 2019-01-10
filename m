Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4579C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD68206B6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 09:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iik2xhKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfAJJ5m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:57:42 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32906 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbfAJJ5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 04:57:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id z23so4990910plo.0
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 01:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FiLXrKo+Zzrkoq2af51uCtgLWmaTIzQmW9evzGgiK+U=;
        b=iik2xhKY7cgwIY+S7A5c/IgaKP19qe63hg3i54BUwGoYav0rWz9HmGgrOOMhv7L0yY
         We2Gkyhb4jfBMLdK9aJiIKCb4Z6OuuCHKCUgHF1+sMOE9fxorv9X+VZ8fpYHbOGie9to
         Ih1vh6hfQjuCSj9af2vWS+S8urtxkIKFDSsNpu+a1KrEi50SizQUd3/JiJiT0tl96OmF
         aAEWvtm8jdIfw7bK80FWrlzp1Xg7A4vA5XOKcUyfV9QhStNLRYy6QWj+Kq4FH2eMHfHQ
         cCqWhBzG9KuZmN/6OExCqJ7qePw9YHEDxKMpsHkIrY6ghzdNnWMJKkM+SqNYQIjYMpGY
         lSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FiLXrKo+Zzrkoq2af51uCtgLWmaTIzQmW9evzGgiK+U=;
        b=Fk4kojGe5a7ni5uvjP05xLH28ZlGjX+6jBh8YvXHnX4ipxiNENI2TflTgnb3nL90lH
         MOKKVgGDCxvZnrjX5b//SDQjmjnedtr5WKqskPsZJJg0dxDodOgP7iWljnJSYpkO/BxW
         DfopaxP3lkCG1u0S8L+TL3X7rzko5B0NTwwpxJgn5Vcz4zFXr9ONp6Mkzatmw0JfMILy
         sG53Jb9WOh/ROWt+wjMR2d5z6H/5xyxP/fzGgNEwWv2T0du1m1d94YdE2TjllNF9KTML
         uUMHOUO09FpbutPUk3cTWOUvL+bbsGatV6Gq7Md4fcQcov0hgAo5f0h3SMWu5wZOL3VQ
         U/vQ==
X-Gm-Message-State: AJcUukdR1MaEbCxTgHmZakXJkZ3IYTD3codgWAWDcXVFXJnD2ih6qV3M
        QdiGuozim/nJg10B0aqp5wrsXrfK
X-Google-Smtp-Source: ALg8bN4lQsTiZZuwU4jHKoWoxixqajHfNmw9O5G/xk8E+TNKfbjkTU7GGHqaIOq5TIap1Ho3S2WPFw==
X-Received: by 2002:a17:902:6b83:: with SMTP id p3mr9610305plk.118.1547114261321;
        Thu, 10 Jan 2019 01:57:41 -0800 (PST)
Received: from localhost.localdomain (softbank219203027033.bbtec.net. [219.203.27.33])
        by smtp.googlemail.com with ESMTPSA id d11sm103129866pgi.25.2019.01.10.01.57.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 01:57:40 -0800 (PST)
From:   tskd08@gmail.com
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] media: dvb/earth-pt1: fix wrong initialization for demod blocks
Date:   Thu, 10 Jan 2019 18:56:23 +0900
Message-Id: <20190110095623.28070-1-tskd08@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Akihiro Tsukada <tskd08@gmail.com>

earth-pt1 driver was decomposed/restructured by the commit: b732539efdba
("media: dvb: earth-pt1: decompose pt1 driver into sub drivers"),
but it introduced a problem regarding concurrent streaming:
Opening a new terrestial stream stops the reception of an existing,
already-opened satellite stream.

The demod IC in earth-pt1 boards contains 2 pairs of terr. and sat. blocks,
supporting 4 concurrent demodulations, and the above problem was because
the config of a terr. block contained whole reset/init of the pair blocks,
thus each open() of a terrestrial frontend wrongly cleared the config of
its peer satellite block of the demod.
This whole/pair reset should be executed earlier and not on each open().

Fixes: b732539efdba ("media: dvb: earth-pt1: decompose pt1 driver into sub drivers")
Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/pci/pt1/pt1.c | 54 ++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index f4b8030e236..403f88ee3d9 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -200,16 +200,10 @@ static const u8 va1j5jf8007t_25mhz_configs[][2] = {
 static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
 {
 	int ret;
-	u8 buf[2] = {0x01, 0x80};
 	bool is_sat;
 	const u8 (*cfg_data)[2];
 	int i, len;
 
-	ret = i2c_master_send(cl, buf, 2);
-	if (ret < 0)
-		return ret;
-	usleep_range(30000, 50000);
-
 	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT,
 			  strlen(TC90522_I2C_DEV_SAT));
 	if (is_sat) {
@@ -260,6 +254,46 @@ static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
 	return 0;
 }
 
+/*
+ * Init registers for (each pair of) terrestrial/satellite block in demod.
+ * Note that resetting terr. block also resets its peer sat. block as well.
+ * This function must be called before configuring any demod block
+ * (before pt1_wakeup(), fe->ops.init()).
+ */
+static int pt1_demod_block_init(struct pt1 *pt1)
+{
+	struct i2c_client *cl;
+	u8 buf[2] = {0x01, 0x80};
+	int ret;
+	int i;
+
+	/* reset all terr. & sat. pairs first */
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		cl = pt1->adaps[i]->demod_i2c_client;
+		if (strncmp(cl->name, TC90522_I2C_DEV_TER,
+			     strlen(TC90522_I2C_DEV_TER)))
+			continue;
+
+		ret = i2c_master_send(cl, buf, 2);
+		if (ret < 0)
+			return ret;
+		usleep_range(30000, 50000);
+	}
+
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		cl = pt1->adaps[i]->demod_i2c_client;
+		if (strncmp(cl->name, TC90522_I2C_DEV_SAT,
+			     strlen(TC90522_I2C_DEV_SAT)))
+			continue;
+
+		ret = i2c_master_send(cl, buf, 2);
+		if (ret < 0)
+			return ret;
+		usleep_range(30000, 50000);
+	}
+	return 0;
+}
+
 static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
 {
 	writel(data, pt1->regs + reg * 4);
@@ -987,6 +1021,10 @@ static int pt1_init_frontends(struct pt1 *pt1)
 			goto tuner_release;
 	}
 
+	ret = pt1_demod_block_init(pt1);
+	if (ret < 0)
+		goto fe_unregister;
+
 	return 0;
 
 tuner_release:
@@ -1245,6 +1283,10 @@ static int pt1_resume(struct device *dev)
 	pt1_update_power(pt1);
 	usleep_range(1000, 2000);
 
+	ret = pt1_demod_block_init(pt1);
+	if (ret < 0)
+		goto resume_err;
+
 	for (i = 0; i < PT1_NR_ADAPS; i++)
 		dvb_frontend_reinitialise(pt1->adaps[i]->fe);
 
-- 
2.20.1

