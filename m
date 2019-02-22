Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECCBC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 17:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D512070D
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550857562;
	bh=BbP4XxPOx4+LzKkZLE3NnDJBqH6XRreKtFRDYKg2mHU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=qg9qGDWFTz10kdvNL5pnBWSXnrKux0bZBOvbjxO+XYe5xnFjV05CVAIoVnxvScPYS
	 dGqN1GmI4AUkwcgsR2iyw+6NxCe6oodlAsCNwlCREc8+llXJpbQzAVLyfEASTgm1vq
	 VTPy2WgyougixD9kzfd05co2vRXKgWmH/yisjvO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfBVRqB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:46:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfBVRqB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Feb 2019 12:46:01 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3881920700;
        Fri, 22 Feb 2019 17:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550857560;
        bh=BbP4XxPOx4+LzKkZLE3NnDJBqH6XRreKtFRDYKg2mHU=;
        h=From:To:Cc:Subject:Date:From;
        b=0eZiaVYGMyjjqVUoPmCdNUJeZpdPZMvKrriDRL6IUSH1t/uHwrrA6nvkKd5/Zm/ch
         dOXa9KsDfA7OnMZgyuGkr8PKifXCh3wq/MqMSjRd5zS0PuDDLvS+uIPiw3L3JfvnkC
         mqlA7rdsjXAnSGPsXo4Rh+l/9o7XDQlaq4aEC/pE=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, hans.verkuil@cisco.com, keescook@chromium.org,
        niklas.soderlund+renesas@ragnatech.se,
        sakari.ailus@linux.intel.com, shuah@kernel.org,
        colin.king@canonical.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] au0828: minor fix to a misleading comment in _close()
Date:   Fri, 22 Feb 2019 10:45:59 -0700
Message-Id: <20190222174559.8084-1-shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix misleading comment in _close()

Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/media/usb/au0828/au0828-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 7876c897cc1d..08f566006a1f 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1074,7 +1074,7 @@ static int au0828_v4l2_close(struct file *filp)
 		 * so the s_power callback are silently ignored.
 		 * So, the current logic here does the following:
 		 * Disable (put tuner to sleep) when
-		 * - ALSA and DVB aren't not streaming;
+		 * - ALSA and DVB aren't streaming;
 		 * - the last V4L2 file handler is closed.
 		 *
 		 * FIXME:
-- 
2.17.1

