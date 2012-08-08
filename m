Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab2HHNxr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 09:53:47 -0400
Received: by weyx8 with SMTP id x8so465711wey.19
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 06:53:45 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 7/8] libdvbv5: renamed registration descriptor
Date: Wed,  8 Aug 2012 15:53:16 +0200
Message-Id: <1344433997-9832-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors.h  |    2 +-
 lib/libdvbv5/descriptors.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/include/descriptors.h b/lib/include/descriptors.h
index 9e3d49b..b1a8e84 100644
--- a/lib/include/descriptors.h
+++ b/lib/include/descriptors.h
@@ -109,7 +109,7 @@ enum descriptors {
 	video_stream_descriptor				= 0x02,
 	audio_stream_descriptor				= 0x03,
 	hierarchy_descriptor				= 0x04,
-	dvbpsi_registration_descriptor			= 0x05,
+	registration_descriptor				= 0x05,
 	ds_alignment_descriptor				= 0x06,
 	target_background_grid_descriptor		= 0x07,
 	video_window_descriptor				= 0x08,
diff --git a/lib/libdvbv5/descriptors.c b/lib/libdvbv5/descriptors.c
index d4fab9a..10a61a3 100644
--- a/lib/libdvbv5/descriptors.c
+++ b/lib/libdvbv5/descriptors.c
@@ -137,7 +137,7 @@ const struct dvb_descriptor dvb_descriptors[] = {
 	[video_stream_descriptor] = { "video_stream_descriptor", NULL, NULL, NULL },
 	[audio_stream_descriptor] = { "audio_stream_descriptor", NULL, NULL, NULL },
 	[hierarchy_descriptor] = { "hierarchy_descriptor", NULL, NULL, NULL },
-	[dvbpsi_registration_descriptor] = { "dvbpsi_registration_descriptor", NULL, NULL, NULL },
+	[registration_descriptor] = { "registration_descriptor", NULL, NULL, NULL },
 	[ds_alignment_descriptor] = { "ds_alignment_descriptor", NULL, NULL, NULL },
 	[target_background_grid_descriptor] = { "target_background_grid_descriptor", NULL, NULL, NULL },
 	[video_window_descriptor] = { "video_window_descriptor", NULL, NULL, NULL },
@@ -1041,7 +1041,7 @@ void hexdump(struct dvb_v5_fe_parms *parms, const char *prefix, const unsigned c
 /* TODO: remove those stuff */
 
 case ds_alignment_descriptor:
-case dvbpsi_registration_descriptor:
+case registration_descriptor:
 case service_list_descriptor:
 case stuffing_descriptor:
 case VBI_data_descriptor:
-- 
1.7.2.5

