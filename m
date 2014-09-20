Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3914 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaITI4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 04:56:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, m.chehab@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] DocBook media: fix the poll() 'no QBUF' documentation
Date: Sat, 20 Sep 2014 10:56:14 +0200
Message-Id: <1411203375-15310-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Clarify what poll() returns if STREAMON was called but not QBUF.
Make explicit the different behavior for this scenario for
capture and output devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/func-poll.xml | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/func-poll.xml b/Documentation/DocBook/media/v4l/func-poll.xml
index 85cad8b..b7ed9e8 100644
--- a/Documentation/DocBook/media/v4l/func-poll.xml
+++ b/Documentation/DocBook/media/v4l/func-poll.xml
@@ -44,10 +44,18 @@ Capture devices set the <constant>POLLIN</constant> and
 flags. When the function timed out it returns a value of zero, on
 failure it returns <returnvalue>-1</returnvalue> and the
 <varname>errno</varname> variable is set appropriately. When the
-application did not call &VIDIOC-QBUF; or &VIDIOC-STREAMON; yet the
+application did not call &VIDIOC-STREAMON; the
 <function>poll()</function> function succeeds, but sets the
 <constant>POLLERR</constant> flag in the
-<structfield>revents</structfield> field.</para>
+<structfield>revents</structfield> field. When the
+application calls &VIDIOC-STREAMON; for a capture device without a
+preceeding &VIDIOC-QBUF; the <function>poll()</function> function
+succeeds, but sets the <constant>POLLERR</constant> flag in the
+<structfield>revents</structfield> field. For output devices this
+same situation will cause <function>poll()</function> to succeed
+as well, but it sets the <constant>POLLOUT</constant> and
+<constant>POLLWRNORM</constant> flags in the <structfield>revents</structfield>
+field.</para>
 
     <para>When use of the <function>read()</function> function has
 been negotiated and the driver does not capture yet, the
-- 
2.1.0

