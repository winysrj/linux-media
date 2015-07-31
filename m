Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55635 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbGaCLL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 22:11:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 12/13] DocBook: fix S_FREQUENCY => G_FREQUENCY
Date: Fri, 31 Jul 2015 05:10:49 +0300
Message-Id: <1438308650-2702-13-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-1-git-send-email-crope@iki.fi>
References: <1438308650-2702-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is VIDIOC_G_FREQUENCY which does not use type to identify tuner,
not VIDIOC_S_FREQUENCY. VIDIOC_S_FREQUENCY uses both tuner and type
fields. One of these V4L API weirdness...

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/common.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 8b5e014..f7008ea 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -428,7 +428,7 @@ zero, no video outputs.</para>
 modulator. Two separate device nodes will have to be used for such
 hardware, one that supports the tuner functionality and one that supports
 the modulator functionality. The reason is a limitation with the
-&VIDIOC-S-FREQUENCY; ioctl where you cannot specify whether the frequency
+&VIDIOC-G-FREQUENCY; ioctl where you cannot specify whether the frequency
 is for a tuner or a modulator.</para>
 
       <para>To query and change modulator properties applications use
-- 
http://palosaari.fi/

