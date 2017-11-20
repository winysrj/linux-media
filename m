Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41958 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751158AbdKTNlf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 08:41:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Martin Bugge <marbugge@cisco.com>
Subject: [PATCH 2/2] hdmi: audio infoframe log: corrected channel count
Date: Mon, 20 Nov 2017 14:41:29 +0100
Message-Id: <20171120134129.26161-3-hverkuil@xs4all.nl>
In-Reply-To: <20171120134129.26161-1-hverkuil@xs4all.nl>
References: <20171120134129.26161-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Audio channel count should start from 2.

Reference: CEA-861-F Table 27.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: Ahung Cheng <ahcheng@nvidia.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/video/hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index 61f803f75a47..5f78b254dd59 100644
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
2.14.1
