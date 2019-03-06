Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5E6C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5AA2206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfCFWnN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:43:13 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60844 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfCFWnM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:43:12 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id D72E4280377;
        Wed,  6 Mar 2019 22:43:05 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 2/8] media: vimc: stream: fix thread state before sleep
Date:   Wed,  6 Mar 2019 19:42:38 -0300
Message-Id: <20190306224244.21070-3-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190306224244.21070-1-helen.koike@collabora.com>
References: <20190306224244.21070-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The state TASK_UNINTERRUPTIBLE should be set just before
schedule_timeout() call, so it knows the sleep mode it should enter.
There is no point in setting TASK_UNINTERRUPTIBLE at the initialization
of the thread as schedule_timeout() will set the state back to
TASK_RUNNING.

This fixes a warning in __might_sleep() call, as it's expecting the
task to be in TASK_RUNNING state just before changing the state to
a sleeping state.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

 drivers/media/platform/vimc/vimc-streamer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
index fcc897fb247b..392754c18046 100644
--- a/drivers/media/platform/vimc/vimc-streamer.c
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -120,7 +120,6 @@ static int vimc_streamer_thread(void *data)
 	int i;
 
 	set_freezable();
-	set_current_state(TASK_UNINTERRUPTIBLE);
 
 	for (;;) {
 		try_to_freeze();
@@ -137,6 +136,7 @@ static int vimc_streamer_thread(void *data)
 				break;
 		}
 		//wait for 60hz
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ / 60);
 	}
 
-- 
2.20.1

