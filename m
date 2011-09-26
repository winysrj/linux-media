Return-path: <linux-media-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40458 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1I0LnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:19 -0400
From: Jonghun Han <jonghun.han@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Jonghun Han <jonghun.han@samsung.com>
Subject: [PATCH] media: DocBook: Fix trivial typo in Sub-device Interface
Date: Mon, 26 Sep 2011 13:05:01 +0900
Message-Id: <1317009901-10837-1-git-send-email-jonghun.han@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When satisfied with the try results, applications can set the active formats
by setting the which argument to V4L2_SUBDEV_FORMAT_ACTIVE
not V4L2_SUBDEV_FORMAT_TRY.

Signed-off-by: Jonghun Han <jonghun.han@samsung.com>
---
 Documentation/DocBook/v4l/dev-subdev.xml |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/v4l/dev-subdev.xml b/Documentation/DocBook/v4l/dev-subdev.xml
index 05c8fef..0916a73 100644
--- a/Documentation/DocBook/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/v4l/dev-subdev.xml
@@ -266,7 +266,7 @@
 
       <para>When satisfied with the try results, applications can set the active
       formats by setting the <structfield>which</structfield> argument to
-      <constant>V4L2_SUBDEV_FORMAT_TRY</constant>. Active formats are changed
+      <constant>V4L2_SUBDEV_FORMAT_ACTIVE</constant>. Active formats are changed
       exactly as try formats by drivers. To avoid modifying the hardware state
       during format negotiation, applications should negotiate try formats first
       and then modify the active settings using the try formats returned during
-- 
1.7.1

