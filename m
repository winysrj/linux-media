Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D495C4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28563208E4
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 02:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553653510;
	bh=pBHcUcaN7ijok1Y0gk8u2m1liL7fk/GMGbChNPAlyLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SS61ldhKVwViISaodyvD9gjidH3ssENhnGrD5PAnlkVL6IJNGorLg5Aila9T1GIrY
	 WqwfdYM6i2QdjANqIBOUFLYSLLZIjsTJ4sJaVQKxTAGKqOosLR7DmqVjrWd1Vu+r6F
	 YhFn+P4Hae+dM6w4tJxMQU+5u/ArST8OAnmrh6Vw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732834AbfC0CZD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 22:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732777AbfC0CZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 22:25:01 -0400
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F7B52173C;
        Wed, 27 Mar 2019 02:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553653500;
        bh=pBHcUcaN7ijok1Y0gk8u2m1liL7fk/GMGbChNPAlyLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euBnMzJLAtS/2LlLAn5WfgiNZj9qPdVqOnLkw8CD4Ntetr9OhoFyL/A7vYpxqsjrc
         F5/0PvFJQdVNxRFupnH0KBvS/1gd2H3ayo24fUimx52gB3l6SfTmCyk/34XOL1nQWj
         hjM7jTeoz/0hvTTVuZdS1BxFTNMeqMCvk5V1wIBU=
From:   Shuah Khan <shuah@kernel.org>
To:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl
Cc:     Shuah Khan <shuah@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v12 5/5] au0828: fix enable and disable source audio and video inconsistencies
Date:   Tue, 26 Mar 2019 20:24:52 -0600
Message-Id: <d08a18b2dc399cae360844550484f2f2e4847551.1553634246.git.shuah@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1553634246.git.shuah@kernel.org>
References: <cover.1553634246.git.shuah@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Enable and disable source interfaces aren't consistent in enforcing
how video and audio share the tuner resource.

Fix these issues to enforce the following rules and allow
sharing between audio and video applications.

- When DVB is streaming, audio/video/vbi/s-video/composite
  should find the resource busy. DVB holds the tuner in
  exclusive mode.
- When video is streaming, audio can share the tuner and vice versa.
- v4l2 allows multiple applications to open video device.
- Video applications call enable source multiple times during their
  run-time. Resource should stay locked until the last application
  releases it.
- A shared resource should stay in shared state and locked when it is
  in use by audio and video. More than one video application is allowed
  to use the tuner as long as video streaming protocol allows such usage.
  Resource is released when the last video/audio application releases it.
- S-Video and Composite hold the resource in exclusive mode.
- VBI allows more than vbi applications sharing and will not share
  with another type. When resource is locked by VBI and in use by
  multiple VBI applications, it should stay locked until the last
  application disables it.

Signed-off-by: Shuah Khan <shuah@kernel.org>
---
 drivers/media/usb/au0828/au0828-core.c | 182 +++++++++++++++++++------
 drivers/media/usb/au0828/au0828.h      |   5 +-
 2 files changed, 148 insertions(+), 39 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 8167e50b7bc4..7652ddb5042a 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -272,6 +272,27 @@ static void au0828_media_graph_notify(struct media_entity *new,
 	}
 }
 
+static bool au0828_is_link_sharable(struct media_entity *owner,
+				    struct media_entity *entity)
+{
+	bool sharable = false;
+
+	/* Tuner link can be shared by audio and video */
+	switch (owner->function) {
+	case MEDIA_ENT_F_IO_V4L:
+	case MEDIA_ENT_F_AUDIO_CAPTURE:
+		if (entity->function == MEDIA_ENT_F_IO_V4L ||
+		    entity->function == MEDIA_ENT_F_AUDIO_CAPTURE)
+			sharable = true;
+		break;
+	case MEDIA_ENT_F_DTV_DEMOD:
+	case MEDIA_ENT_F_IO_VBI:
+	default:
+		break;
+	}
+	return sharable;
+}
+
 /* Callers should hold graph_mutex */
 static int au0828_enable_source(struct media_entity *entity,
 				struct media_pipeline *pipe)
@@ -314,18 +335,20 @@ static int au0828_enable_source(struct media_entity *entity,
 		/*
 		 * Default input is tuner and default input_type
 		 * is AU0828_VMUX_TELEVISION.
-		 * FIXME:
+		 *
 		 * There is a problem when s_input is called to
 		 * change the default input. s_input will try to
 		 * enable_source before attempting to change the
 		 * input on the device, and will end up enabling
 		 * default source which is tuner.
 		 *
-		 * Additional logic is necessary in au0828
-		 * to detect that the input has changed and
-		 * enable the right source.
+		 * Additional logic is necessary in au0828 to detect
+		 * that the input has changed and enable the right
+		 * source. au0828 handles this case in its s_input.
+		 * It will disable the old source and enable the new
+		 * source.
+		 *
 		*/
-
 		if (dev->input_type == AU0828_VMUX_TELEVISION)
 			find_source = dev->tuner;
 		else if (dev->input_type == AU0828_VMUX_SVIDEO ||
@@ -338,27 +361,33 @@ static int au0828_enable_source(struct media_entity *entity,
 		}
 	}
 
-	/* Is an active link between sink and source */
+	/* Is there an active link between sink and source */
 	if (dev->active_link) {
-		/*
-		 * If DVB is using the tuner and calling entity is
-		 * audio/video, the following check will be false,
-		 * since sink is different. Result is Busy.
-		 */
-		if (dev->active_link->sink->entity == sink &&
-		    dev->active_link->source->entity == find_source) {
-			/*
-			 * Either ALSA or Video own tuner. sink is
-			 * the same for both. Prevent Video stepping
-			 * on ALSA when ALSA owns the source.
+		if (dev->active_link_owner == entity) {
+			/* This check is necessary to handle multiple
+			 * enable_source calls from v4l_ioctls during
+			 * the course of video/vbi application run-time.
 			*/
-			if (dev->active_link_owner != entity &&
-			    dev->active_link_owner->function ==
-						MEDIA_ENT_F_AUDIO_CAPTURE) {
-				pr_debug("ALSA has the tuner\n");
-				ret = -EBUSY;
-				goto end;
-			}
+			pr_debug("%s already owns the tuner\n", entity->name);
+			ret = 0;
+			goto end;
+		} else if (au0828_is_link_sharable(dev->active_link_owner,
+			   entity)) {
+			/* Either ALSA or Video own tuner. Sink is the same
+			 * for both. Allow sharing the active link between
+			 * their common source (tuner) and sink (decoder).
+			 * Starting pipeline between sharing entity and sink
+			 * will fail with pipe mismatch, while owner has an
+			 * active pipeline. Switch pipeline ownership from
+			 * user to owner when owner disables the source.
+			 */
+			dev->active_link_shared = true;
+			/* save the user info to use from disable */
+			dev->active_link_user = entity;
+			dev->active_link_user_pipe = pipe;
+			pr_debug("%s owns the tuner %s can share!\n",
+				 dev->active_link_owner->name,
+				 entity->name);
 			ret = 0;
 			goto end;
 		} else {
@@ -385,7 +414,7 @@ static int au0828_enable_source(struct media_entity *entity,
 	source = found_link->source->entity;
 	ret = __media_entity_setup_link(found_link, MEDIA_LNK_FL_ENABLED);
 	if (ret) {
-		pr_err("Activate tuner link %s->%s. Error %d\n",
+		pr_err("Activate link from %s->%s. Error %d\n",
 			source->name, sink->name, ret);
 		goto end;
 	}
@@ -395,25 +424,26 @@ static int au0828_enable_source(struct media_entity *entity,
 		pr_err("Start Pipeline: %s->%s Error %d\n",
 			source->name, entity->name, ret);
 		ret = __media_entity_setup_link(found_link, 0);
-		pr_err("Deactivate link Error %d\n", ret);
+		if (ret)
+			pr_err("Deactivate link Error %d\n", ret);
 		goto end;
 	}
-	/*
-	 * save active link and active link owner to avoid audio
-	 * deactivating video owned link from disable_source and
-	 * vice versa
+
+	/* save link state to allow audio and video share the link
+	 * and not disable the link while the other is using it.
+	 * active_link_owner is used to deactivate the link.
 	*/
 	dev->active_link = found_link;
 	dev->active_link_owner = entity;
 	dev->active_source = source;
 	dev->active_sink = sink;
 
-	pr_debug("Enabled Source: %s->%s->%s Ret %d\n",
+	pr_info("Enabled Source: %s->%s->%s Ret %d\n",
 		 dev->active_source->name, dev->active_sink->name,
 		 dev->active_link_owner->name, ret);
 end:
-	pr_debug("au0828_enable_source() end %s %d %d\n",
-		 entity->name, entity->function, ret);
+	pr_debug("%s end: ent:%s fnc:%d ret %d\n",
+		 __func__, entity->name, entity->function, ret);
 	return ret;
 }
 
@@ -432,21 +462,95 @@ static void au0828_disable_source(struct media_entity *entity)
 	if (!dev->active_link)
 		return;
 
-	/* link is active - stop pipeline from source (tuner) */
+	/* link is active - stop pipeline from source
+	 * (tuner/s-video/Composite) to the entity
+	 * When DVB/s-video/Composite owns tuner, it won't be in
+	 * shared state.
+	 */
 	if (dev->active_link->sink->entity == dev->active_sink &&
 	    dev->active_link->source->entity == dev->active_source) {
 		/*
-		 * prevent video from deactivating link when audio
-		 * has active pipeline
+		 * Prevent video from deactivating link when audio
+		 * has active pipeline and vice versa. In addition
+		 * handle the case when more than one video/vbi
+		 * application is sharing the link.
 		*/
+		bool owner_is_audio = false;
+
+		if (dev->active_link_owner->function ==
+		    MEDIA_ENT_F_AUDIO_CAPTURE)
+			owner_is_audio = true;
+
+		if (dev->active_link_shared) {
+			pr_debug("Shared link owner %s user %s %d\n",
+				 dev->active_link_owner->name,
+				 entity->name, dev->users);
+
+			/* Handle video device users > 1
+			 * When audio owns the shared link with
+			 * more than one video users, avoid
+			 * disabling the source and/or switching
+			 * the owner until the last disable_source
+			 * call from video _close(). Use dev->users to
+			 * determine when to switch/disable.
+			 */
+			if (dev->active_link_owner != entity) {
+				/* video device has users > 1 */
+				if (owner_is_audio && dev->users > 1)
+					return;
+
+				dev->active_link_user = NULL;
+				dev->active_link_user_pipe = NULL;
+				dev->active_link_shared = false;
+				return;
+			}
+
+			/* video owns the link and has users > 1 */
+			if (!owner_is_audio && dev->users > 1)
+				return;
+
+			/* stop pipeline */
+			__media_pipeline_stop(dev->active_link_owner);
+			pr_debug("Pipeline stop for %s\n",
+				dev->active_link_owner->name);
+
+			ret = __media_pipeline_start(
+					dev->active_link_user,
+					dev->active_link_user_pipe);
+			if (ret) {
+				pr_err("Start Pipeline: %s->%s %d\n",
+					dev->active_source->name,
+					dev->active_link_user->name,
+					ret);
+				goto deactivate_link;
+			}
+			/* link user is now the owner */
+			dev->active_link_owner = dev->active_link_user;
+			dev->active_link_user = NULL;
+			dev->active_link_user_pipe = NULL;
+			dev->active_link_shared = false;
+
+			pr_debug("Pipeline started for %s\n",
+				dev->active_link_owner->name);
+			return;
+		} else if (!owner_is_audio && dev->users > 1)
+			/* video/vbi owns the link and has users > 1 */
+			return;
+
 		if (dev->active_link_owner != entity)
 			return;
-		__media_pipeline_stop(entity);
+
+		/* stop pipeline */
+		__media_pipeline_stop(dev->active_link_owner);
+		pr_debug("Pipeline stop for %s\n",
+			dev->active_link_owner->name);
+
+deactivate_link:
 		ret = __media_entity_setup_link(dev->active_link, 0);
 		if (ret)
 			pr_err("Deactivate link Error %d\n", ret);
 
-		pr_debug("Disabled Source: %s->%s->%s Ret %d\n",
+		pr_info("Disabled Source: %s->%s->%s Ret %d\n",
 			 dev->active_source->name, dev->active_sink->name,
 			 dev->active_link_owner->name, ret);
 
@@ -454,6 +558,8 @@ static void au0828_disable_source(struct media_entity *entity)
 		dev->active_link_owner = NULL;
 		dev->active_source = NULL;
 		dev->active_sink = NULL;
+		dev->active_link_shared = false;
+		dev->active_link_user = NULL;
 	}
 }
 #endif
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 57b00de8d3f2..b47ecc9affd8 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -284,9 +284,12 @@ struct au0828_dev {
 	struct media_entity_notify entity_notify;
 	struct media_entity *tuner;
 	struct media_link *active_link;
-	struct media_entity *active_link_owner;
 	struct media_entity *active_source;
 	struct media_entity *active_sink;
+	struct media_entity *active_link_owner;
+	struct media_entity *active_link_user;
+	struct media_pipeline *active_link_user_pipe;
+	bool active_link_shared;
 #endif
 };
 
-- 
2.17.1

