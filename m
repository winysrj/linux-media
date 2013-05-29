Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4759 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966098Ab3E2OTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/14] DocBook/media/v4l: clarify the QUERYSTD documentation.
Date: Wed, 29 May 2013 16:19:05 +0200
Message-Id: <1369837147-8747-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explicitly mention that this ioctl should return V4L2_STD_UNKNOWN if
not signal was detected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querystd.xml |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querystd.xml b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
index fe80a18..2223485 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querystd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querystd.xml
@@ -54,7 +54,8 @@ standard automatically. To do so, applications call <constant>
 VIDIOC_QUERYSTD</constant> with a pointer to a &v4l2-std-id; type. The
 driver stores here a set of candidates, this can be a single flag or a
 set of supported standards if for example the hardware can only
-distinguish between 50 and 60 Hz systems. When detection is not
+distinguish between 50 and 60 Hz systems. If no signal was detected,
+then the driver will return V4L2_STD_UNKNOWN. When detection is not
 possible or fails, the set must contain all standards supported by the
 current video input or output.</para>
 
-- 
1.7.10.4

