Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53503 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbcCCNr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 08:47:28 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 8E7261809C5
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2016 14:47:22 +0100 (CET)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media.h: always start with 1 for the audio entities
Message-ID: <56D84075.5080608@xs4all.nl>
Date: Thu, 3 Mar 2016 14:47:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Start the audio defines with BASE + 0x03001 instead of 0x03000. This is consistent
with the other defines, and I think it is good practice not to start with 0, just in
case we want to do something like (id & 0xfff) in the future and treat the value 0
as a special case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Suggested-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 79960ae..b133c5d 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -90,9 +90,9 @@ struct media_device_info {
 /*
  * Audio Entity Functions
  */
-#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03000)
-#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03001)
-#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03002)
+#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03001)
+#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03002)
+#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)

 /*
  * Connectors
