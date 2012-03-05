Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39594 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998Ab2CERT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 12:19:27 -0500
Received: by eaaq12 with SMTP id q12so1511064eaa.19
        for <linux-media@vger.kernel.org>; Mon, 05 Mar 2012 09:19:26 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix "snd_aci_* undefined" warnings on kernels < 2.6.33
Date: Mon,  5 Mar 2012 18:19:07 +0100
Message-Id: <1330967947-24044-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

WARNING: "snd_aci_get_aci" [/media/linux-common/experiment/media_build/v4l/radio-miropcm20.ko] undefined!
WARNING: "snd_aci_cmd" [/media/linux-common/experiment/media_build/v4l/radio-miropcm20.ko] undefined!

due to to the radio-miropcm20 module requiring sound/aci.h introduced in 2.6.33

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/versions.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ff103bf..ad2ef2f 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -41,6 +41,8 @@ VIDEO_DT3155
 [2.6.33]
 VIDEO_AK881X
 V4L2_MEM2MEM_DEV
+# Requires sound/aci.h introduced in 2.6.33
+RADIO_MIROPCM20
 
 [2.6.32]
 # These rely on arch support that wasn't available until 2.6.32
-- 
1.7.0.4

