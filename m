Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B609C282CF
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40EF20855
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696257;
	bh=21PtvNerbDQN+aHUgiiVLDyRflbVL/nXsswIpEbRmp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rs19IMv2P5nzlXkaRFOFmRTxsclPOMpx4wcTq7N9ZNFD2ImzgfJ8WcH7omuwOO9P0
	 62vE//apSF3YXckHsJsCaLE8DFDfnrA+Xs9EGpd/EcasQaPPdaVptZ11aAyRWXvpep
	 bWgF624FMxnrDib8JsYw9aKT0kOm2QRkMLuJItbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfA1QBy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730467AbfA1QBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:01:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2133B21852;
        Mon, 28 Jan 2019 16:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548691313;
        bh=21PtvNerbDQN+aHUgiiVLDyRflbVL/nXsswIpEbRmp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxTcDeqMG1ttM/p7bDlJ3G/pQjzTZuc+QB6UPePwJ06ZiVlVJAnR5Yj7OYF+JkdxL
         20Eh6kyOq+CV4+aAc+Tk1tAsOj1/h3Qqwm8o/XDqsFlxYoGSiLinh+I9sKjXs9+ShS
         1ou5rvmEZmAjak/jt3iRrzrxY9Giw9k/XhTzrvrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 055/258] media: rc: ensure close() is called on rc_unregister_device
Date:   Mon, 28 Jan 2019 10:56:01 -0500
Message-Id: <20190128155924.51521-55-sashal@kernel.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 8e782fcf78275f505194e767c515202d4fd274bc ]

If userspace has an open file descriptor on the rc input device or lirc
device when rc_unregister_device() is called, then the rc close() is
never called.

This ensures that the receiver is turned off on the nuvoton-cir driver
during shutdown.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/rc-main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8b2c16dd58bd..0f218afdadaa 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1956,6 +1956,8 @@ void rc_unregister_device(struct rc_dev *dev)
 	rc_free_rx_device(dev);
 
 	mutex_lock(&dev->lock);
+	if (dev->users && dev->close)
+		dev->close(dev);
 	dev->registered = false;
 	mutex_unlock(&dev->lock);
 
-- 
2.19.1

