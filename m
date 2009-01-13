Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50582 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZAMCDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 21:03:39 -0500
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Date: Mon, 12 Jan 2009 20:03:10 -0600
Subject: [REVIEW PATCH 02/14] v4l2-int-device: add support for
 VIDIOC_QUERYMENU
Message-ID: <A24693684029E5489D1D202277BE894416429F98@dlee02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 include/media/v4l2-int-device.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-int-device.h b/include/media/v4l2-int-device.h
index 85a1834..052ffe0 100644
--- a/include/media/v4l2-int-device.h
+++ b/include/media/v4l2-int-device.h
@@ -178,6 +178,7 @@ enum v4l2_int_ioctl_num {
 	vidioc_int_s_fmt_cap_num,
 	vidioc_int_try_fmt_cap_num,
 	vidioc_int_queryctrl_num,
+	vidioc_int_querymenu_num,
 	vidioc_int_g_ctrl_num,
 	vidioc_int_s_ctrl_num,
 	vidioc_int_cropcap_num,
@@ -279,6 +280,7 @@ V4L2_INT_WRAPPER_1(g_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(s_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(try_fmt_cap, struct v4l2_format, *);
 V4L2_INT_WRAPPER_1(queryctrl, struct v4l2_queryctrl, *);
+V4L2_INT_WRAPPER_1(querymenu, struct v4l2_querymenu, *);
 V4L2_INT_WRAPPER_1(g_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(s_ctrl, struct v4l2_control, *);
 V4L2_INT_WRAPPER_1(cropcap, struct v4l2_cropcap, *);
-- 
1.5.6.5

