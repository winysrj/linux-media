Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:45776 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab2JZNCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 09:02:07 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Rob Landley <rob@landley.net>
Date: Fri, 26 Oct 2012 15:01:55 +0200
Subject: [PATCH TRIVIAL for 3.7] Documentation: fix outdated statement re.
 v4l2
Message-ID: <508A89C3.7010200@st.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix tense used for describing struct v4l2_fh as it has been added a
while ago.

Signed-off-by: Nicolas Thery <nicolas.thery@st.com>
---
 Documentation/video4linux/v4l2-framework.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 32bfe92..0a1ef67 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -68,8 +68,7 @@ Structure of the framework
 The framework closely resembles the driver structure: it has a v4l2_device
 struct for the device instance data, a v4l2_subdev struct to refer to
 sub-device instances, the video_device struct stores V4L2 device node data
-and in the future a v4l2_fh struct will keep track of filehandle instances
-(this is not yet implemented).
+and the v4l2_fh struct keeps track of filehandle instances.
 
 The V4L2 framework also optionally integrates with the media framework. If a
 driver sets the struct v4l2_device mdev field, sub-devices and video nodes
-- 
1.7.11.3