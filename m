Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F6BC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2775F20880
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 15:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjSTYytx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2775F20880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbeLMPjP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 10:39:15 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34748 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbeLMPjP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 10:39:15 -0500
Received: by mail-lf1-f65.google.com with SMTP id p6so1917240lfc.1
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2018 07:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6dGXOF0cDB4LtShhmKT4RqvqUe3HA/a5W5ibddUw/Nc=;
        b=NjSTYytxr+2ZIVQlQ/PwWBjwn0OrkxI832PLZI4MYQvV4MLbx4IxOXCk5xduLlifLI
         UocMGpVxnNlyOiTW9lDRQsso5xFh0FoYWaBprxVQsp7JV+gst+EymyiPYVlwsTPVUl66
         A4RYBtx0xsH90uIuvGS/heJuys82jQ050qa8oq4Lw5b0+UZ5UF7eX7BwlvaJXmbJo4Gi
         d5O5TWXlmoCKqCHFeOQvZdukBIEosYUJdVT0hT7JC+ZHhZA9kOorRnXLu9vuCAtByyv1
         2ym7PpfE/dIHCQiOR12jesDE7PPhTbY3ptxkW2vLG0iyWKSY9upf9zW9cHYLzeWIdU2q
         odsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6dGXOF0cDB4LtShhmKT4RqvqUe3HA/a5W5ibddUw/Nc=;
        b=H+M8KBWLQosxckXCmpEbgjtnHS4QzWqKcaNdaVCI/TQkjIE8d0SaypovNq2QzqM9xe
         sAEmz1/uETOYsBQjLzenbe/2sxo7lYvjdZMExsoQCjiL7qrZLjUI+U7esw50DUUDx1mO
         CgY/dICILaSosW5uOQhkc1lJdNdkZMIvhQrCu8zeCUCMQ9aBSA9gax9wxO2/2GJ3sMQ5
         CFALwZ+bdBteeN3SMREwWrD3r/BphzyCW3oZ5ubVJmwsgBADkk5fvKm6Ux2MpsjdEw40
         15/xZ9VsiA560vk1gx5fy6EWUirXbKovGlOlpl1Naxh4seXjjrmQRGbVpyU6+sFHDYQL
         537w==
X-Gm-Message-State: AA+aEWZahVvBZzOFSzkpfrpCq65GcopwnsZ0Zwi6IROqXwuIqd/27Piu
        lDDx2HjWDd31CCPo65lErK3HcGdf
X-Google-Smtp-Source: AFSGD/VbHJsVyhNRLWnna0Yj04fiwSGzb7/TiLlFAAItufYEYwOAwF2j6mSIS1pjdjRtsK2J7dxabQ==
X-Received: by 2002:a19:1cb:: with SMTP id 194mr14369556lfb.61.1544715552003;
        Thu, 13 Dec 2018 07:39:12 -0800 (PST)
Received: from kontron.lan (2001-1ae9-0ff1-f191-41f2-812a-df1c-0485.ip6.tmcz.cz. [2001:1ae9:ff1:f191:41f2:812a:df1c:485])
        by smtp.gmail.com with ESMTPSA id q67sm412869lfe.19.2018.12.13.07.39.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Dec 2018 07:39:11 -0800 (PST)
From:   petrcvekcz@gmail.com
X-Google-Original-From: petrcvekcz.gmail.com
To:     hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc:     Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org,
        philipp.zabel@gmail.com, sakari.ailus@iki.fi
Subject: [PATCH v3 5/8] media: i2c: ov9640: change array index or length variables to unsigned
Date:   Thu, 13 Dec 2018 16:39:16 +0100
Message-Id: <7be67dac73289e3d6dbc25f16cdb051a53a76f2f.1544713575.git.petrcvekcz@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <cover.1544713575.git.petrcvekcz@gmail.com>
References: <cover.1544713575.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Petr Cvek <petrcvekcz@gmail.com>

The driver uses variables to store frame resolutions and to indexing
various arrays. These should be unsigned.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/ov9640.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
index 9a6fa609e8c4..08f3f8247759 100644
--- a/drivers/media/i2c/ov9640.c
+++ b/drivers/media/i2c/ov9640.c
@@ -347,10 +347,10 @@ static int ov9640_s_power(struct v4l2_subdev *sd, int on)
 /* select nearest higher resolution for capture */
 static void ov9640_res_roundup(u32 *width, u32 *height)
 {
-	int i;
+	unsigned int i;
 	enum { QQCIF, QQVGA, QCIF, QVGA, CIF, VGA, SXGA };
-	static const int res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
-	static const int res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
+	static const u32 res_x[] = { 88, 160, 176, 320, 352, 640, 1280 };
+	static const u32 res_y[] = { 72, 120, 144, 240, 288, 480, 960 };
 
 	for (i = 0; i < ARRAY_SIZE(res_x); i++) {
 		if (res_x[i] >= *width && res_y[i] >= *height) {
@@ -393,8 +393,9 @@ static int ov9640_write_regs(struct i2c_client *client, u32 width,
 		u32 code, struct ov9640_reg_alt *alts)
 {
 	const struct ov9640_reg	*ov9640_regs, *matrix_regs;
-	int			ov9640_regs_len, matrix_regs_len;
-	int			i, ret;
+	unsigned int		ov9640_regs_len, matrix_regs_len;
+	unsigned int		i;
+	int			ret;
 	u8			val;
 
 	/* select register configuration for given resolution */
@@ -479,7 +480,8 @@ static int ov9640_write_regs(struct i2c_client *client, u32 width,
 /* program default register values */
 static int ov9640_prog_dflt(struct i2c_client *client)
 {
-	int i, ret;
+	unsigned int i;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(ov9640_regs_dflt); i++) {
 		ret = ov9640_reg_write(client, ov9640_regs_dflt[i].reg,
-- 
2.20.0

