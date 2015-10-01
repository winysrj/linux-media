Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbJAR0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 13:26:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3/5] [media] DocBook: Fix documentation for struct v4l2_dv_timings
Date: Thu,  1 Oct 2015 14:26:00 -0300
Message-Id: <fb91aecb96cb852f0989432968b3c50d6247ed7f.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
In-Reply-To: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
References: <1ccd66cca96a377ef924d2ee76fbb753a7bec9ea.1443720347.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:
	include/media/v4l2-dv-timings.h:29: warning: cannot understand function prototype: 'const struct v4l2_dv_timings v4l2_dv_timings_presets[]; '

Unfortunately, currently, it seems that doc-nano doesn't support
documenting extern static vars.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 9c7147bc43cf..a209526b6014 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -23,7 +23,7 @@
 
 #include <linux/videodev2.h>
 
-/**
+/*
  * v4l2_dv_timings_presets: list of all dv_timings presets.
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
-- 
2.4.3

