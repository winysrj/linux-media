Return-path: <mchehab@pedra>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:56208 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0IXL4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 07:56:10 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v10 1/4] V4L2: Add seek spacing and RDS CAP bits.
Date: Fri, 24 Sep 2010 14:55:29 +0300
Message-Id: <1285329332-4380-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1285329332-4380-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1285329332-4380-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add spacing field to v4l2_hw_freq_seek.

Add V4L2_TUNER_CAP_RDS_BLOCK_IO, which indicates that the tuner/
transmitter if capable of transmitting/receiving RDS blocks.

Add V4L2_TUNER_CAP_RDS_CONTROLS capability, which indicates that the
RDS data is handled as values of predefined controls like radio text,
program ID and so on.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 include/linux/videodev2.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 61490c6..eadcda3 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1363,6 +1363,8 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_SAP		0x0020
 #define V4L2_TUNER_CAP_LANG1		0x0040
 #define V4L2_TUNER_CAP_RDS		0x0080
+#define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
+#define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
@@ -1392,7 +1394,8 @@ struct v4l2_hw_freq_seek {
 	enum v4l2_tuner_type  type;
 	__u32		      seek_upward;
 	__u32		      wrap_around;
-	__u32		      reserved[8];
+	__u32		      spacing;
+	__u32		      reserved[7];
 };
 
 /*
-- 
1.6.1.3

