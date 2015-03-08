Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47332 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:30:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A13192A0090
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 08:30:03 +0100 (CET)
Message-ID: <54FBFA7B.9040904@xs4all.nl>
Date: Sun, 08 Mar 2015 08:30:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] v4l2-framework.txt: debug -> dev_debug
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The debug attribute was renamed to dev_debug. Update the doc accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-framework.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index f586e29..59e619f 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -793,8 +793,8 @@ video_register_device_no_warn() instead.
 
 Whenever a device node is created some attributes are also created for you.
 If you look in /sys/class/video4linux you see the devices. Go into e.g.
-video0 and you will see 'name', 'debug' and 'index' attributes. The 'name'
-attribute is the 'name' field of the video_device struct. The 'debug' attribute
+video0 and you will see 'name', 'dev_debug' and 'index' attributes. The 'name'
+attribute is the 'name' field of the video_device struct. The 'dev_debug' attribute
 can be used to enable core debugging. See the next section for more detailed
 information on this.
 
@@ -821,7 +821,7 @@ unregister the device if the registration failed.
 video device debugging
 ----------------------
 
-The 'debug' attribute that is created for each video, vbi, radio or swradio
+The 'dev_debug' attribute that is created for each video, vbi, radio or swradio
 device in /sys/class/video4linux/<devX>/ allows you to enable logging of
 file operations.
 
-- 
2.1.4

