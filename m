Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:8445 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752917AbdF2R3q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 13:29:46 -0400
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] hdmi: audio infoframe log: corrected channel count
Date: Thu, 29 Jun 2017 19:19:50 +0200
Message-Id: <20170629171950.16988-1-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Audio channel count should start from 2.

Reference: CEA-861-F Table 27.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: Ahung Cheng <ahcheng@nvidia.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/video/hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 1cf907e..35c0408 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -884,7 +884,7 @@ static void hdmi_audio_infoframe_log(const char *level,
 				  (struct hdmi_any_infoframe *)frame);
 
 	if (frame->channels)
-		hdmi_log("    channels: %u\n", frame->channels - 1);
+		hdmi_log("    channels: %u\n", frame->channels + 1);
 	else
 		hdmi_log("    channels: Refer to stream header\n");
 	hdmi_log("    coding type: %s\n",
-- 
2.9.4
