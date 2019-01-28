Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93BBC282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F23C20881
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548697479;
	bh=ARWhCgiLxU6b5lsqz6SZZqHwIxGmYrxl+8tjNX4iXwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=01vEZHwJ+4Arf3wlkLzkUUkPwHlo9N+/3wduFrm3wzAZ2PGsYEKC5P6AvHd6kITCo
	 wc/VpwYW5NdYyezQNH2npt/YFdf1VgV49mImFS3ILCFwBgMscyhilGY/r08AzngDBN
	 PuPDjV9XDxqyw4NvO7MwEgeCPTH7zqq4sRhlQXeY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfA1Psz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:48:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728557AbfA1Psy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 10:48:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C3021741;
        Mon, 28 Jan 2019 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690533;
        bh=ARWhCgiLxU6b5lsqz6SZZqHwIxGmYrxl+8tjNX4iXwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg/kW1a6qGKqlfRUjb+iObTNoR/Ajz1mbROzWwyIdfQJpNkoWrJOThR8wU07jmnvU
         4cdw+N1Voh5qL4Ci/Ng8JT9nyFjjqW2pBURQqA8i9BnKFxsf0LKKEEzDwFy8+pF1wZ
         yMac7igVHegd4pNBLuTeUg+8AcHMzx/lVRKKCN+o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 114/304] media: i2c: TDA1997x: select CONFIG_HDMI
Date:   Mon, 28 Jan 2019 10:40:31 -0500
Message-Id: <20190128154341.47195-114-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
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
index 704af210e270..f4714bd6fef0 100644
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

