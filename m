Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61431 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3BSMKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 07:10:34 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so2228489pbc.10
        for <linux-media@vger.kernel.org>; Tue, 19 Feb 2013 04:10:34 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] [media] timblogiw: Fix sparse warning
Date: Tue, 19 Feb 2013 17:30:36 +0530
Message-Id: <1361275236-16071-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the below warning:
drivers/media/platform/timblogiw.c:81:31: warning:
symbol 'timblogiw_tvnorms' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/timblogiw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index c3a2a44..2d91eeb 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -78,7 +78,7 @@ struct timblogiw_buffer {
 	struct timblogiw_fh	*fh;
 };
 
-const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
+static const struct timblogiw_tvnorm timblogiw_tvnorms[] = {
 	{
 		.std			= V4L2_STD_PAL,
 		.width			= 720,
-- 
1.7.4.1

