Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1413 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2E1Kqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:46:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 1/6] videodev2.h: add new hwseek capability bits.
Date: Mon, 28 May 2012 12:46:40 +0200
Message-Id: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
In-Reply-To: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tell the application whether the hardware seek is bounded and/or wraps around.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
---
 include/linux/videodev2.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 370d111..2339678 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -2039,6 +2039,8 @@ struct v4l2_modulator {
 /*  Flags for the 'capability' field */
 #define V4L2_TUNER_CAP_LOW		0x0001
 #define V4L2_TUNER_CAP_NORM		0x0002
+#define V4L2_TUNER_CAP_HWSEEK_BOUNDED	0x0004
+#define V4L2_TUNER_CAP_HWSEEK_WRAP	0x0008
 #define V4L2_TUNER_CAP_STEREO		0x0010
 #define V4L2_TUNER_CAP_LANG2		0x0020
 #define V4L2_TUNER_CAP_SAP		0x0020
-- 
1.7.10

