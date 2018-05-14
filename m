Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59061 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932357AbeENNNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 09:13:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] hdpvr: fix compiler warning
Date: Mon, 14 May 2018 15:13:43 +0200
Message-Id: <20180514131346.15795-5-hverkuil@xs4all.nl>
In-Reply-To: <20180514131346.15795-1-hverkuil@xs4all.nl>
References: <20180514131346.15795-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In function 'strncpy',
    inlined from 'vidioc_g_audio' at media-git/drivers/media/usb/hdpvr/hdpvr-video.c:876:2:
media-git/include/linux/string.h:246:9: warning: '__builtin_strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  return __builtin_strncpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 77c3d331ff31..1b89c77bad66 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -873,7 +873,7 @@ static int vidioc_g_audio(struct file *file, void *private_data,
 
 	audio->index = dev->options.audio_input;
 	audio->capability = V4L2_AUDCAP_STEREO;
-	strncpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
+	strlcpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
 	audio->name[sizeof(audio->name) - 1] = '\0';
 	return 0;
 }
-- 
2.17.0
