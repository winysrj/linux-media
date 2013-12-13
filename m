Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4677 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3LMQOI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 9/9] DocBook: drop the word 'only'.
Date: Fri, 13 Dec 2013 17:13:46 +0100
Message-Id: <1386951226-27655-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
References: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There are already video output drivers that allow STREAMON without
any buffers queued, and with the change in vb2 there are now more
drivers like that.

So saying "The ioctl will succeed only when at least one output
buffer is in the incoming queue." isn't true. Just drop the word
'only'. We cannot say that it will also work if no output buffers are
queued as long as not all drivers are converted to vb2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-streamon.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-streamon.xml b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
index 716ea15..65dff55 100644
--- a/Documentation/DocBook/media/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-streamon.xml
@@ -59,7 +59,7 @@ buffers are filled (if there are any empty buffers in the incoming
 queue) until <constant>VIDIOC_STREAMON</constant> has been called.
 Accordingly the output hardware is disabled, no video signal is
 produced until <constant>VIDIOC_STREAMON</constant> has been called.
-The ioctl will succeed only when at least one output buffer is in the
+The ioctl will succeed when at least one output buffer is in the
 incoming queue.</para>
 
     <para>The <constant>VIDIOC_STREAMOFF</constant> ioctl, apart of
-- 
1.8.4.3

