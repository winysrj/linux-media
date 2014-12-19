Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35447 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbaLSMOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:14:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 3/4] hdmi: rename HDMI_AUDIO_CODING_TYPE_EXT_STREAM to _EXT_CT
Date: Fri, 19 Dec 2014 13:14:22 +0100
Message-Id: <1418991263-17934-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
References: <1418991263-17934-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As per the suggestion of Thierry Reding rename
HDMI_AUDIO_CODING_TYPE_EXT_STREAM to HDMI_AUDIO_CODING_TYPE_EXT_CT to
be consistent with the CEA-861 spec.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/video/hdmi.c | 2 +-
 include/linux/hdmi.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/hdmi.c b/drivers/video/hdmi.c
index a7c6ae4..1626892 100644
--- a/drivers/video/hdmi.c
+++ b/drivers/video/hdmi.c
@@ -842,7 +842,7 @@ hdmi_audio_coding_type_ext_get_name(enum hdmi_audio_coding_type_ext ctx)
 		return "Invalid";
 
 	switch (ctx) {
-	case HDMI_AUDIO_CODING_TYPE_EXT_STREAM:
+	case HDMI_AUDIO_CODING_TYPE_EXT_CT:
 		return "Refer to CT";
 	case HDMI_AUDIO_CODING_TYPE_EXT_HE_AAC:
 		return "HE AAC";
diff --git a/include/linux/hdmi.h b/include/linux/hdmi.h
index d6dea20..d70a457 100644
--- a/include/linux/hdmi.h
+++ b/include/linux/hdmi.h
@@ -215,7 +215,8 @@ enum hdmi_audio_sample_frequency {
 };
 
 enum hdmi_audio_coding_type_ext {
-	HDMI_AUDIO_CODING_TYPE_EXT_STREAM,
+	/* Refer to Audio Coding Type (CT) field in Data Byte 1 */
+	HDMI_AUDIO_CODING_TYPE_EXT_CT,
 
 	/*
 	 * The next three CXT values are defined in CEA-861-E only.
-- 
2.1.3

