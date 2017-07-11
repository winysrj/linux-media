Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36460 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755146AbdGKGav (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 02:30:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/11] linux/cec.h: add pin monitoring API support
Date: Tue, 11 Jul 2017 08:30:38 +0200
Message-Id: <20170711063044.29849-6-hverkuil@xs4all.nl>
In-Reply-To: <20170711063044.29849-1-hverkuil@xs4all.nl>
References: <20170711063044.29849-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for low-level CEC pin monitoring. This adds a new monitor
mode, a new capability and two new events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/cec.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
index 44579a24f95d..bba73f33c8aa 100644
--- a/include/uapi/linux/cec.h
+++ b/include/uapi/linux/cec.h
@@ -318,6 +318,7 @@ static inline int cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_MODE_FOLLOWER		(0x1 << 4)
 #define CEC_MODE_EXCL_FOLLOWER		(0x2 << 4)
 #define CEC_MODE_EXCL_FOLLOWER_PASSTHRU	(0x3 << 4)
+#define CEC_MODE_MONITOR_PIN		(0xd << 4)
 #define CEC_MODE_MONITOR		(0xe << 4)
 #define CEC_MODE_MONITOR_ALL		(0xf << 4)
 #define CEC_MODE_FOLLOWER_MSK		0xf0
@@ -338,6 +339,8 @@ static inline int cec_is_unconfigured(__u16 log_addr_mask)
 #define CEC_CAP_MONITOR_ALL	(1 << 5)
 /* Hardware can use CEC only if the HDMI HPD pin is high. */
 #define CEC_CAP_NEEDS_HPD	(1 << 6)
+/* Hardware can monitor CEC pin transitions */
+#define CEC_CAP_MONITOR_PIN	(1 << 7)
 
 /**
  * struct cec_caps - CEC capabilities structure.
@@ -405,6 +408,8 @@ struct cec_log_addrs {
  * didn't empty the message queue in time
  */
 #define CEC_EVENT_LOST_MSGS		2
+#define CEC_EVENT_PIN_LOW		3
+#define CEC_EVENT_PIN_HIGH		4
 
 #define CEC_EVENT_FL_INITIAL_STATE	(1 << 0)
 
-- 
2.11.0
