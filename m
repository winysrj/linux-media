Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3987 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaITI4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 04:56:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] DocBook media: improve the poll() documentation
Date: Sat, 20 Sep 2014 10:56:15 +0200
Message-Id: <1411203375-15310-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The poll documentation was incomplete: document how events (POLLPRI)
are handled and fix the documentation of what poll does for display devices
and streaming I/O.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/func-poll.xml | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
index b7ed9e8..1e45709 100644
--- a/Documentation/DocBook/media/v4l/func-poll.xml
+++ b/Documentation/DocBook/media/v4l/func-poll.xml
@@ -29,9 +29,12 @@ can suspend execution until the driver has captured data or is ready
 to accept data for output.</para>
 
     <para>When streaming I/O has been negotiated this function waits
-until a buffer has been filled or displayed and can be dequeued with
-the &VIDIOC-DQBUF; ioctl. When buffers are already in the outgoing
-queue of the driver the function returns immediately.</para>
+until a buffer has been filled by the capture device and can be dequeued
+with the &VIDIOC-DQBUF; ioctl. For output devices this function waits
+until the device is ready to accept a new buffer to be queued up with
+the &VIDIOC-QBUF; ioctl for display. When buffers are already in the outgoing
+queue of the driver (capture) or the incoming queue isn't full (display)
+the function returns immediately.</para>
 
     <para>On success <function>poll()</function> returns the number of
 file descriptors that have been selected (that is, file descriptors
@@ -57,6 +60,10 @@ as well, but it sets the <constant>POLLOUT</constant> and
 <constant>POLLWRNORM</constant> flags in the <structfield>revents</structfield>
 field.</para>
 
+    <para>If an event occurred (see &VIDIOC-DQEVENT;) then
+<constant>POLLPRI</constant> will be set in the <structfield>revents</structfield>
+field and <function>poll()</function> will return.</para>
+
     <para>When use of the <function>read()</function> function has
 been negotiated and the driver does not capture yet, the
 <function>poll</function> function starts capturing. When that fails
@@ -66,10 +73,18 @@ continuously (as opposed to, for example, still images) the function
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

