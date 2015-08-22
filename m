Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbbHVR2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:38 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 21/39] [media] v4l2-ctls: don't document v4l2_ctrl_fill()
Date: Sat, 22 Aug 2015 14:28:06 -0300
Message-Id: <7e73e9d69234792aa76c268cd56929bff6d9b4b9.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440264165.git.mchehab@osg.samsung.com>
References: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an obsolete function that has several missing
arguments:
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'id'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'name'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'type'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'min'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'max'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'step'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'def'
	Warning(.//include/media/v4l2-ctrls.h:340): No description found for parameter 'flags'

However, this is an obsolete function that should be
removed soon. And are not meant to be used anymore. So,
instead of documenting those stuff, let's just make
DocBook to not handle it, by replacing "/**" by "/*".

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 88f736661c06..946d5d3d6ff7 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -313,7 +313,7 @@ struct v4l2_ctrl_config {
 	unsigned int is_private:1;
 };
 
-/**
+/*
  * v4l2_ctrl_fill() - Fill in the control fields based on the control ID.
  *
  * This works for all standard V4L2 controls.
-- 
2.4.3

