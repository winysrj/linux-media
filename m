Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37141 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbcHPJKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 05:10:00 -0400
Received: by mail-wm0-f50.google.com with SMTP id i5so153124382wmg.0
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2016 02:09:59 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH] media: v4l2-ctrls: append missing h264 profile string
Date: Tue, 16 Aug 2016 12:09:42 +0300
Message-Id: <1471338582-1014-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This appends missing "Stereo High" h264 profile string. Without
it the v4l2 compliance would crash kernel with NULL pointer
dereference at:

[   26.882278] [<ffff000008685cbc>] std_validate+0x378/0x42c
[   26.886967] [<ffff000008687424>] set_ctrl+0x8c/0x134
[   26.892521] [<ffff00000868755c>] v4l2_s_ctrl+0x90/0xf4
[   26.897555] [<ffff00000867f3b0>] v4l_s_ctrl+0x4c/0x110
[   26.902503] [<ffff00000867db04>] __video_do_ioctl+0x240/0x2b4
[   26.907625] [<ffff00000867d778>] video_usercopy+0x33c/0x46c
[   26.913441] [<ffff00000867d8bc>] video_ioctl2+0x14/0x1c
[   26.918822] [<ffff000008678878>] v4l2_ioctl+0xe0/0x110
[   26.924032] [<ffff0000081da898>] do_vfs_ioctl+0xb4/0x764
[   26.929238] [<ffff0000081dafcc>] SyS_ioctl+0x84/0x98
[   26.934707] [<ffff000008082f4c>] __sys_trace_return+0x0/0x4

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f7abfad9ad23..adc2147fcff7 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -361,6 +361,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Scalable Baseline",
 		"Scalable High",
 		"Scalable High Intra",
+		"Stereo High",
 		"Multiview High",
 		NULL,
 	};
-- 
2.7.4

