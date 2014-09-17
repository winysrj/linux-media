Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3242 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaIQJO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 05:14:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] DocBook media: fix poll specification
Date: Wed, 17 Sep 2014 11:14:30 +0200
Message-Id: <1410945272-48149-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The poll specification mentioned that it would return POLLERR if no
buffers are queued. This makes no sense since the buffer queue can
become empty during capturing and you want poll to wait until another
thread queues up a new buffer and not to return POLLERR.

In the case where STREAMON is called without any buffers queued, the
STREAMON ioctl will already check if enough buffers have been queued
and return an error if that's not the case. This is driver dependent,
some drivers require that buffers are queued, others don't.

The poll() function certainly shouldn't check for this.

Just drop the part about POLLERR being returned if QBUF wasn't called.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/func-poll.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
index 85cad8b..2f91ca6 100644
--- a/Documentation/DocBook/media/v4l/func-poll.xml
+++ b/Documentation/DocBook/media/v4l/func-poll.xml
@@ -44,7 +44,7 @@ Capture devices set the <constant>POLLIN</constant> and
 flags. When the function timed out it returns a value of zero, on
 failure it returns <returnvalue>-1</returnvalue> and the
 <varname>errno</varname> variable is set appropriately. When the
-application did not call &VIDIOC-QBUF; or &VIDIOC-STREAMON; yet the
+application did not call &VIDIOC-STREAMON; the
 <function>poll()</function> function succeeds, but sets the
 <constant>POLLERR</constant> flag in the
 <structfield>revents</structfield> field.</para>
-- 
2.1.0

