Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4981 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3CBXp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 17/20] solo6x10: update buffer flags to fix clash with existing flags.
Date: Sun,  3 Mar 2013 00:45:33 +0100
Message-Id: <9f8abfdfc95e256e10f084358958efa3b89e089f.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index d24b3cd..e404ec7 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -112,8 +112,8 @@
 #define SOLO_CLOCK_MHZ			108
 
 #ifndef V4L2_BUF_FLAG_MOTION_ON
-#define V4L2_BUF_FLAG_MOTION_ON		0x0400
-#define V4L2_BUF_FLAG_MOTION_DETECTED	0x0800
+#define V4L2_BUF_FLAG_MOTION_ON		0x10000
+#define V4L2_BUF_FLAG_MOTION_DETECTED	0x20000
 #endif
 
 #ifndef V4L2_CID_MOTION_ENABLE
-- 
1.7.10.4

