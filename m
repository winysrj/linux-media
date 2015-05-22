Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34491 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbbEVU3G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 16:29:06 -0400
Received: by wicmc15 with SMTP id mc15so364879wic.1
        for <linux-media@vger.kernel.org>; Fri, 22 May 2015 13:29:04 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, patrick.boettcher@posteo.de,
	Jemma Denson <jdenson@gmail.com>
Subject: [PATCH 4/4] b2c2: Always turn off receive stream
Date: Fri, 22 May 2015 21:28:28 +0100
Message-Id: <1432326508-6825-5-git-send-email-jdenson@gmail.com>
In-Reply-To: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When letting an external device control the receive stream, it won't
know when there's demand for any feeds, so won't be turning off our
receive stream. This patch bring back control of turning it off in
this sitation.

The demod can still delay turning it on until it has data to send,
and still turn it off temporarily whilst it knows there's no
stream, such as whilst tuning.

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/common/b2c2/flexcop-hw-filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/b2c2/flexcop-hw-filter.c b/drivers/media/common/b2c2/flexcop-hw-filter.c
index eceb9c5..8926c82 100644
--- a/drivers/media/common/b2c2/flexcop-hw-filter.c
+++ b/drivers/media/common/b2c2/flexcop-hw-filter.c
@@ -206,7 +206,7 @@ int flexcop_pid_feed_control(struct flexcop_device *fc,
 
 	/* if it was the first or last feed request change the stream-status */
 	if (fc->feedcount == onoff) {
-		if (!fc->external_stream_control)
+		if (!fc->external_stream_control || onoff == 0)
 			flexcop_rcv_data_ctrl(fc, onoff);
 
 		if (fc->stream_control) /* device specific stream control */
-- 
2.1.0

