Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbcA2MML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 07:12:11 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/13] [media] v4l2-mc: add analog TV demodulator pad index macros
Date: Fri, 29 Jan 2016 10:10:58 -0200
Message-Id: <3f19cf1824edb0cd5577616f93968cc9ddf149d6.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454067262.git.mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We also need to standardize the PAD index macros for demods,
as they all should look the same in a media graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/v4l2-mc.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 6a6ef5bc767e..df115195690e 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -74,3 +74,18 @@ enum if_aud_dec_pad_index {
 	IF_AUD_DEC_PAD_OUT,
 	IF_AUD_DEC_PAD_NUM_PADS
 };
+
+/**
+ * enum demod_pad_index - analog TV pad index for MEDIA_ENT_F_ATV_DECODER
+ *
+ * @DEMOD_PAD_IF_INPUT:	IF input sink pad.
+ * @DEMOD_PAD_VID_OUT:	Video output source pad.
+ * @DEMOD_PAD_VBI_OUT:	Vertical Blank Interface (VBI) output source pad.
+ * @DEMOD_NUM_PADS:	Maximum number of output pads.
+ */
+enum demod_pad_index {
+	DEMOD_PAD_IF_INPUT,
+	DEMOD_PAD_VID_OUT,
+	DEMOD_PAD_VBI_OUT,
+	DEMOD_NUM_PADS
+};
-- 
2.5.0


