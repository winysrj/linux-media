Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3263 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaIQJO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 05:14:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] DocBook media: update poll() documentation
Date: Wed, 17 Sep 2014 11:14:31 +0200
Message-Id: <1410945272-48149-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No mention was made about the handling of POLLPRI. And the section
on write() was missing that, just like in the read() case, the driver
will start streaming if it wasn't yet in streaming mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/func-poll.xml | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
index 2f91ca6..ac61c37 100644
--- a/Documentation/DocBook/media/v4l/func-poll.xml
+++ b/Documentation/DocBook/media/v4l/func-poll.xml
@@ -49,6 +49,10 @@ application did not call &VIDIOC-STREAMON; the
 <constant>POLLERR</constant> flag in the
 <structfield>revents</structfield> field.</para>
 
+    <para>If an event occurred (see &VIDIOC-DQEVENT;) then
+<constant>POLLPRI</constant> will be set in the <structfield>revents</structfield>
+field and <function>poll()</function> will return.</para>
+
     <para>When use of the <function>read()</function> function has
 been negotiated and the driver does not capture yet, the
 <function>poll</function> function starts capturing. When that fails
@@ -58,10 +62,18 @@ continuously (as opposed to, for example, still images) the function
 may return immediately.</para>
 
     <para>When use of the <function>write()</function> function has
-been negotiated the <function>poll</function> function just waits
+been negotiated and the driver does not stream yet, the
+<function>poll</function> function starts streaming. When that fails
+it returns a <constant>POLLERR</constant> as above. Otherwise it waits
 until the driver is ready for a non-blocking
 <function>write()</function> call.</para>
 
+    <para>If the caller is only interested in events (just
+<constant>POLLPRI</constant> is set in the <structfield>events</structfield>
+field), then <function>poll()</function> will <emphasis>not</emphasis>
+start streaming if the driver does not stream yet. This makes it
+possible to just poll for events and not for buffers.</para>
+
     <para>All drivers implementing the <function>read()</function> or
 <function>write()</function> function or streaming I/O must also
 support the <function>poll()</function> function.</para>
-- 
2.1.0

