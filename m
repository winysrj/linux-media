Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57743 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab1IPRFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 13:05:38 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM003O9KTAZP@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:05:34 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM0032CKTAM0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:05:34 +0100 (BST)
Date: Fri, 16 Sep 2011 19:05:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/3] v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY
 control
In-reply-to: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316192730-18099-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CID_POWER_LINE_FREQUENCY control allows applications to instruct
a driver what is the power line frequency so an appropriate filter
can be used by the device to cancel flicker by compensating the light
intensity ripple. Currently in the menu we have entries for
50 and 60 Hz and for entirely disabling the anti-flicker filter.
However some devices are capable of automatically detecting the
frequency, so add V4L2_CID_POWER_LINE_FREQUENCY_AUTO entry for them.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    5 +++--
 drivers/media/video/v4l2-ctrls.c             |    1 +
 include/linux/videodev2.h                    |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index f3c6457..aff7989 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -232,8 +232,9 @@ control is deprecated. New drivers and applications should use the
 	    <entry>Enables a power line frequency filter to avoid
 flicker. Possible values for <constant>enum v4l2_power_line_frequency</constant> are:
 <constant>V4L2_CID_POWER_LINE_FREQUENCY_DISABLED</constant> (0),
-<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant> (1) and
-<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant> (2).</entry>
+<constant>V4L2_CID_POWER_LINE_FREQUENCY_50HZ</constant> (1),
+<constant>V4L2_CID_POWER_LINE_FREQUENCY_60HZ</constant> (2) and
+<constant>V4L2_CID_POWER_LINE_FREQUENCY_AUTO</constant> (3).</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_HUE_AUTO</constant></entry>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 06b6014..20abe5d 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -210,6 +210,7 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Disabled",
 		"50 Hz",
 		"60 Hz",
+		"Auto",
 		NULL
 	};
 	static const char * const camera_exposure_auto[] = {
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 5032226..ec858e7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1125,6 +1125,7 @@ enum v4l2_power_line_frequency {
 	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
 	V4L2_CID_POWER_LINE_FREQUENCY_50HZ	= 1,
 	V4L2_CID_POWER_LINE_FREQUENCY_60HZ	= 2,
+	V4L2_CID_POWER_LINE_FREQUENCY_AUTO	= 3,
 };
 #define V4L2_CID_HUE_AUTO			(V4L2_CID_BASE+25)
 #define V4L2_CID_WHITE_BALANCE_TEMPERATURE	(V4L2_CID_BASE+26)
-- 
1.7.6

