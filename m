Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C8CC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 15:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2D1D20C01
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551108755;
	bh=pfY3s6u0S0/xHLI3RUys44q9iwOnXb9pJ7nv3LFhoYM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=AcSN/fElI6x31kddqOVm6TqHN10uiWipYYCQU3RPtLw23K7R0W40otScKRKQ5cqJC
	 60pX9GJCuVz5hKyigyXbrh6KZ50AjSijAIZIt+bE2BS9xLGMAtZ34wT1JOlG0psxmH
	 9L5DFjgUse3VvDBtWyIIO/8YSmW/CrnONfoji7sA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfBYPca (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727515AbfBYPca (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 10:32:30 -0500
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11AA320663;
        Mon, 25 Feb 2019 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551108749;
        bh=pfY3s6u0S0/xHLI3RUys44q9iwOnXb9pJ7nv3LFhoYM=;
        h=From:To:Cc:Subject:Date:From;
        b=wgQABXObwzemiFRFP6fSPZK8lNzkysvyGjrzBBsUyzadXn1hxAJ1eclCcyyi7pWjW
         WUjJKHMnptxcCmLqg6f8q51oijCMNaoJTuAK1lOdPuvsRjH0OboCKL1XUv9I8QWCk7
         LCYB0Qdn9qVH7znTu5HEgcRAzoOTpR4ESm0a0niY=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, hans.verkuil@cisco.com, keescook@chromium.org,
        niklas.soderlund+renesas@ragnatech.se,
        sakari.ailus@linux.intel.com, shuah@kernel.org,
        colin.king@canonical.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] au0828: minor fix to a misleading comment in _close()
Date:   Mon, 25 Feb 2019 08:32:27 -0700
Message-Id: <20190225153227.13094-1-shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix a misleading comment in _close() and a spelling error.

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/media/usb/au0828/au0828-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 7876c897cc1d..e17047b94b87 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1065,7 +1065,7 @@ static int au0828_v4l2_close(struct file *filp)
 		 * streaming.
 		 *
 		 * On most USB devices  like au0828 the tuner can
-		 * be safely put in sleep stare here if ALSA isn't
+		 * be safely put in sleep state here if ALSA isn't
 		 * streaming. Exceptions are some very old USB tuner
 		 * models such as em28xx-based WinTV USB2 which have
 		 * a separate audio output jack. The devices that have
@@ -1074,7 +1074,7 @@ static int au0828_v4l2_close(struct file *filp)
 		 * so the s_power callback are silently ignored.
 		 * So, the current logic here does the following:
 		 * Disable (put tuner to sleep) when
-		 * - ALSA and DVB aren't not streaming;
+		 * - ALSA and DVB aren't streaming.
 		 * - the last V4L2 file handler is closed.
 		 *
 		 * FIXME:
-- 
2.17.1

