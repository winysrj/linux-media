Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3052 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1FNHOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 03:14:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@isely.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 07/10] v4l2-subdev.h: remove unused s_mode tuner op.
Date: Tue, 14 Jun 2011 09:14:39 +0200
Message-Id: <a132d9fe538ea1168faf1c6ca432f2e4132c1f5c.1308035134.git.hans.verkuil@cisco.com>
In-Reply-To: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
References: <1308035682-20447-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
References: <eff4df001ab17e78b7413b9ed51661777523dbac.1308035134.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

s_mode is no longer used, so remove it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 1562c4f..2245020 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -173,16 +173,13 @@ struct v4l2_subdev_core_ops {
 				 struct v4l2_event_subscription *sub);
 };
 
-/* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
-
-   s_radio: v4l device was opened in Radio mode, to be replaced by s_mode.
+/* s_radio: v4l device was opened in radio mode.
 
    s_type_addr: sets tuner type and its I2C addr.
 
    s_config: sets tda9887 specific stuff, like port1, port2 and qss
  */
 struct v4l2_subdev_tuner_ops {
-	int (*s_mode)(struct v4l2_subdev *sd, enum v4l2_tuner_type);
 	int (*s_radio)(struct v4l2_subdev *sd);
 	int (*s_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
 	int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
-- 
1.7.1

