Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C9EC4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A607420857
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551423;
	bh=lmi0GidDcdK25UNC126f4I4Nt0ZHKgg5MiG33hNIlKA=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=thMjwQ+7w08+3YnzhLrpsXKJFuSzvfMS1HuP/kmIyDWmS3HFXo8/NrlqezhJAUfFm
	 j9P1xDB6outwUExTbGAsEe7eIxGZxg/R+8mu7SHLLdLR4H81e08Ip9Cl5vP17pIzyv
	 1KhuSPg6De0+YVuAicuOsLPoTo9TJNORp1dRXpAo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbfCYWDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54888 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730187AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/deS02s9ycDGmZNU04NggU6EJ76B3Vk4QaC1citBKvg=; b=sbmW4BvrsHn1UGdQngHJ6L9l2a
        9wgl8SI22Ui0WA6KlCIyrhXXXkPrjBId3rmaZvkpIHPBCvCj5fbShz+CWBr0ls1TGPNHeFK/y7ais
        B9fRcCH+bOFEVV5ekcPFxb6xOtY/iAJtw0Vm/nkkinVRaBg2llmRrmHDOWkAFSy0ajq5IiyHbHPZ5
        5ZdrPeNYU0w8a+uCIUXcsLHxE6iL7v0kLrN77q6jvLYaccSoEyP8i+KnwbZqj+MMvojfwcfFqYO6V
        4Hl+BmfwLlxiYl4+PmiprkpzHv31rJ2rpZwYk6XiGEc3O5u+eaygmOOIAg4/ig1WfDsr3HxVlTzg0
        +nEEbwjA==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xgz-0001YE-NX; Mon, 25 Mar 2019 22:03:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001ah-Gr; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/5] media: cx2341x: replace badly designed macros
Date:   Mon, 25 Mar 2019 18:03:33 -0400
Message-Id: <3d19cde7be76d4471426edc348bcf3b45c64f097.1553551369.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553551369.git.mchehab+samsung@kernel.org>
References: <cover.1553551369.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There are some macros at cx2341x_update() with seemed to
be introduced in order to ensure that lines would be less
than 80 columns.

Well, the thing is that they make the code harder to be analized,
not only by humans, but also for static code analyzers:

	drivers/media/common/cx2341x.c:1116 cx2341x_update() error: we previously assumed 'old' could be null (see line 1047)

So, remove the "force" var, and replace the NEQ macro to a
better designed one that makes clearer about what it is doing.

While here, also remove the "temporal" var, as it is just another
way of doing the same type of check as the new CMP_FIELD() macro
already does.

Finally, fix coding style at the block code.
 remove such macros.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/cx2341x.c | 151 ++++++++++++++++++++-------------
 1 file changed, 93 insertions(+), 58 deletions(-)

diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index 1dcc39b87bb7..121cda73ff88 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -1028,7 +1028,7 @@ static int cx2341x_api(void *priv, cx2341x_mbox_func func,
 	return func(priv, cmd, args, 0, data);
 }
 
-#define NEQ(field) (old->field != new->field)
+#define CMP_FIELD(__old, __new, __field) (__old->__field != __new->__field)
 
 int cx2341x_update(void *priv, cx2341x_mbox_func func,
 		   const struct cx2341x_mpeg_params *old,
@@ -1042,20 +1042,22 @@ int cx2341x_update(void *priv, cx2341x_mbox_func func,
 		11,	/* VCD */
 		12,	/* SVCD */
 	};
-
-	int err = 0;
-	int force = (old == NULL);
-	u16 temporal = new->video_temporal_filter;
+	int err;
 
 	cx2341x_api(priv, func, CX2341X_ENC_SET_OUTPUT_PORT, 2, new->port, 0);
 
-	if (force || NEQ(is_50hz)) {
+	if (!old ||
+	    CMP_FIELD(old, new, is_50hz)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_FRAME_RATE, 1,
 				  new->is_50hz);
-		if (err) return err;
+		if (err)
+			return err;
 	}
 
-	if (force || NEQ(width) || NEQ(height) || NEQ(video_encoding)) {
+	if (!old ||
+	    CMP_FIELD(old, new, width) ||
+	    CMP_FIELD(old, new, height) ||
+	    CMP_FIELD(old, new, video_encoding)) {
 		u16 w = new->width;
 		u16 h = new->height;
 
@@ -1065,94 +1067,127 @@ int cx2341x_update(void *priv, cx2341x_mbox_func func,
 		}
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_FRAME_SIZE, 2,
 				  h, w);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(stream_type)) {
+	if (!old ||
+	    CMP_FIELD(old, new, stream_type)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_STREAM_TYPE, 1,
 				  mpeg_stream_type[new->stream_type]);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_aspect)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_aspect)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_ASPECT_RATIO, 1,
 				  1 + new->video_aspect);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_b_frames) || NEQ(video_gop_size)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_b_frames) ||
+	    CMP_FIELD(old, new, video_gop_size)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_GOP_PROPERTIES, 2,
-				new->video_gop_size, new->video_b_frames + 1);
-		if (err) return err;
+				  new->video_gop_size, new->video_b_frames + 1);
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_gop_closure)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_gop_closure)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_GOP_CLOSURE, 1,
 				  new->video_gop_closure);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(audio_properties)) {
+	if (!old ||
+	    CMP_FIELD(old, new, audio_properties)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_AUDIO_PROPERTIES,
 				  1, new->audio_properties);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(audio_mute)) {
+	if (!old ||
+	    CMP_FIELD(old, new, audio_mute)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_MUTE_AUDIO, 1,
 				  new->audio_mute);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_bitrate_mode) || NEQ(video_bitrate) ||
-						NEQ(video_bitrate_peak)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_bitrate_mode) ||
+	    CMP_FIELD(old, new, video_bitrate) ||
+	    CMP_FIELD(old, new, video_bitrate_peak)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_BIT_RATE, 5,
-				new->video_bitrate_mode, new->video_bitrate,
-				new->video_bitrate_peak / 400, 0, 0);
-		if (err) return err;
+				  new->video_bitrate_mode, new->video_bitrate,
+				  new->video_bitrate_peak / 400, 0, 0);
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_spatial_filter_mode) ||
-		     NEQ(video_temporal_filter_mode) ||
-		     NEQ(video_median_filter_type)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_spatial_filter_mode) ||
+	    CMP_FIELD(old, new, video_temporal_filter_mode) ||
+	    CMP_FIELD(old, new, video_median_filter_type)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_DNR_FILTER_MODE,
-				  2, new->video_spatial_filter_mode |
+				  2,
+				  new->video_spatial_filter_mode |
 					(new->video_temporal_filter_mode << 1),
-				new->video_median_filter_type);
-		if (err) return err;
+				  new->video_median_filter_type);
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_luma_median_filter_bottom) ||
-		     NEQ(video_luma_median_filter_top) ||
-		     NEQ(video_chroma_median_filter_bottom) ||
-		     NEQ(video_chroma_median_filter_top)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_luma_median_filter_bottom) ||
+	    CMP_FIELD(old, new, video_luma_median_filter_top) ||
+	    CMP_FIELD(old, new, video_chroma_median_filter_bottom) ||
+	    CMP_FIELD(old, new, video_chroma_median_filter_top)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_CORING_LEVELS, 4,
-				new->video_luma_median_filter_bottom,
-				new->video_luma_median_filter_top,
-				new->video_chroma_median_filter_bottom,
-				new->video_chroma_median_filter_top);
-		if (err) return err;
+				  new->video_luma_median_filter_bottom,
+				  new->video_luma_median_filter_top,
+				  new->video_chroma_median_filter_bottom,
+				  new->video_chroma_median_filter_top);
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_luma_spatial_filter_type) ||
-		     NEQ(video_chroma_spatial_filter_type)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_luma_spatial_filter_type) ||
+	    CMP_FIELD(old, new, video_chroma_spatial_filter_type)) {
 		err = cx2341x_api(priv, func,
 				  CX2341X_ENC_SET_SPATIAL_FILTER_TYPE,
 				  2, new->video_luma_spatial_filter_type,
 				  new->video_chroma_spatial_filter_type);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_spatial_filter) ||
-		     old->video_temporal_filter != temporal) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_spatial_filter) ||
+	    CMP_FIELD(old, new, video_temporal_filter)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_DNR_FILTER_PROPS,
-				  2, new->video_spatial_filter, temporal);
-		if (err) return err;
+				  2, new->video_spatial_filter,
+				  new->video_temporal_filter);
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_temporal_decimation)) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_temporal_decimation)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_SET_FRAME_DROP_RATE,
 				  1, new->video_temporal_decimation);
-		if (err) return err;
+		if (err)
+			return err;
 	}
-	if (force || NEQ(video_mute) ||
-		(new->video_mute && NEQ(video_mute_yuv))) {
+	if (!old ||
+	    CMP_FIELD(old, new, video_mute) ||
+	    (new->video_mute && CMP_FIELD(old, new, video_mute_yuv))) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_MUTE_VIDEO, 1,
-				new->video_mute | (new->video_mute_yuv << 8));
-		if (err) return err;
+				  new->video_mute | (new->video_mute_yuv << 8));
+		if (err)
+			return err;
 	}
-	if (force || NEQ(stream_insert_nav_packets)) {
+	if (!old ||
+	    CMP_FIELD(old, new, stream_insert_nav_packets)) {
 		err = cx2341x_api(priv, func, CX2341X_ENC_MISC, 2,
-				7, new->stream_insert_nav_packets);
-		if (err) return err;
+				  7, new->stream_insert_nav_packets);
+		if (err)
+			return err;
 	}
 	return 0;
 }
-- 
2.20.1

