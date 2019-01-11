Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A94FC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8BF20872
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 16:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="vfeOY+N/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbfAKQaz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 11:30:55 -0500
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:59150 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbfAKQay (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 11:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Message-Id:Date:Subject:Cc:To:From:Sender:
        Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X0bVWE/Kd/dEKpxGs/pTYHBBFbFVMwGHItZPFq3waOc=; b=vfeOY+N/7Q+Q8TZ2m9k/gMdJhC
        tb5Oe4y1ghYXFlTYCIOgUyQp7kvVZ73uslO1ZlA1uJ5nV9SyoRsCezrwZFCG7J83vx7QDYgQHCUHV
        csYqBIsHP/DSTxIALu6FA7krlDgF72robimb6F0UcJiXUJikvWYizGGMrgVO5lSOondY=;
Received: from [109.168.11.45] (port=39638 helo=pc-ceresoli.dev.aim)
        by hostingweb31.netsons.net with esmtpa (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1ghzhs-00CuCt-9Y; Fri, 11 Jan 2019 17:30:52 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
To:     linux-media@vger.kernel.org
Cc:     Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: imx274: remote unused function imx274_read_reg
Date:   Fri, 11 Jan 2019 17:30:42 +0100
Message-Id: <20190111163042.5737-1-luca@lucaceresoli.net>
X-Mailer: git-send-email 2.17.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

imx274_read_reg() is not used since commit ca017467c78b ("media:
imx274: add helper to read multibyte registers").

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 95e3d90309e8..c2ac2fd1b96b 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -617,24 +617,6 @@ static int imx274_write_table(struct stimx274 *priv, const struct reg_8 table[])
 	return 0;
 }
 
-static inline int imx274_read_reg(struct stimx274 *priv, u16 addr, u8 *val)
-{
-	unsigned int uint_val;
-	int err;
-
-	err = regmap_read(priv->regmap, addr, &uint_val);
-	if (err)
-		dev_err(&priv->client->dev,
-			"%s : i2c read failed, addr = %x\n", __func__, addr);
-	else
-		dev_dbg(&priv->client->dev,
-			"%s : addr 0x%x, val=0x%x\n", __func__,
-			addr, uint_val);
-
-	*val = uint_val;
-	return err;
-}
-
 static inline int imx274_write_reg(struct stimx274 *priv, u16 addr, u8 val)
 {
 	int err;
-- 
2.17.1

