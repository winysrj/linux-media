Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CECC282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D57520989
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696047;
	bh=e3V2iQYi92n+TqFefdoCc3GErkHwkxQYgrvUSOHzA+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BUS0ZFCzNpcKgt2i6j2RQkYv1PIhtSg3ucKQiq2MRaONKoIabBXsJYIUWHyqAbU+8
	 GqaREzLw1u/tRPPgkQPa85UG3DCFGRX/D9ly2zAAxwdzTUZSQY6YCYX7QCnttD0J15
	 rzDdeLDNRciptGyYVHNCOlXzIiuiGgkyrN8H1ZSk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731177AbfA1QEU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730856AbfA1QER (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:04:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 456B22147A;
        Mon, 28 Jan 2019 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691456;
        bh=e3V2iQYi92n+TqFefdoCc3GErkHwkxQYgrvUSOHzA+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WdIceaDuetSB7P4RECT8uuMUsExZBBgZk4dkeRRyiKq679xL6cDPjwbH+7IRRQKn
         t3pCW5amtXD0E33DvzCPRfHerhrwIl4alWqVEgXEvPdqEs66nzKx8mUxJHBnfsSqpr
         u/NqK5TH3ap3CWzlv1yRjoJ5lYodLDkyCGcaIXtQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 098/258] media: i2c: TDA1997x: select CONFIG_HDMI
Date:   Mon, 28 Jan 2019 10:56:44 -0500
Message-Id: <20190128155924.51521-98-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 79e89e36dc8a47ef965a35b484d737a5227feed1 ]

Without CONFIG_HDMI, we get a link error for this driver:

drivers/media/i2c/tda1997x.o: In function `tda1997x_parse_infoframe':
tda1997x.c:(.text+0x2195): undefined reference to `hdmi_infoframe_unpack'
tda1997x.c:(.text+0x21b6): undefined reference to `hdmi_infoframe_log'
drivers/media/i2c/tda1997x.o: In function `tda1997x_log_infoframe':
tda1997x.c:(.text.unlikely+0x13d3): undefined reference to `hdmi_infoframe_unpack'
tda1997x.c:(.text.unlikely+0x1426): undefined reference to `hdmi_infoframe_log'

All other drivers in this directory that use HDMI select CONFIG_HDMI,
so do the same here:

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 82af97430e5b..041a777dfdee 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -61,6 +61,7 @@ config VIDEO_TDA1997X
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on SND_SOC
 	select SND_PCM
+	select HDMI
 	---help---
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
-- 
2.19.1

