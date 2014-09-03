Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4680 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbaICHav (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 03:30:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] vivid: add missing includes
Date: Wed,  3 Sep 2014 09:30:31 +0200
Message-Id: <1409729431-7870-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1409729431-7870-1-git-send-email-hverkuil@xs4all.nl>
References: <1409729431-7870-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix kbuild test robot warnings about missing vmalloc.h and string.h
includes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c    | 1 +
 drivers/media/platform/vivid/vivid-rds-gen.c | 1 +
 drivers/media/platform/vivid/vivid-tpg.h     | 1 +
 drivers/media/platform/vivid/vivid-vbi-gen.c | 1 +
 drivers/media/platform/vivid/vivid-vid-cap.c | 1 +
 5 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index fb3b0aa..2c61a62 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/font.h>
 #include <linux/mutex.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
index dab5463..c382343 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.c
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/ktime.h>
+#include <linux/string.h>
 #include <linux/videodev2.h>
 
 #include "vivid-rds-gen.h"
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 51ef7d1..8ef3e52 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/random.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/videodev2.h>
 
 #include "vivid-tpg-colors.h"
diff --git a/drivers/media/platform/vivid/vivid-vbi-gen.c b/drivers/media/platform/vivid/vivid-vbi-gen.c
index 22f4bcc..450ec3c 100644
--- a/drivers/media/platform/vivid/vivid-vbi-gen.c
+++ b/drivers/media/platform/vivid/vivid-vbi-gen.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/ktime.h>
+#include <linux/string.h>
 #include <linux/videodev2.h>
 
 #include "vivid-vbi-gen.h"
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 115437a..b016aed 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -20,6 +20,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/vmalloc.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-common.h>
-- 
2.1.0

