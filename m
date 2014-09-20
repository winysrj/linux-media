Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1594 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330AbaITTQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 15:16:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/3] DocBook media: fix the poll() 'no QBUF' documentation
Date: Sat, 20 Sep 2014 21:16:36 +0200
Message-Id: <1411240597-2105-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411240597-2105-1-git-send-email-hverkuil@xs4all.nl>
References: <1411240597-2105-1-git-send-email-hverkuil@xs4all.nl>
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
index 85cad8b..bd07104 100644
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
+application has called &VIDIOC-STREAMON; for a capture device but hasn't
+yet called &VIDIOC-QBUF;, the <function>poll()</function> function
+succeeds and sets the <constant>POLLERR</constant> flag in the
+<structfield>revents</structfield> field. For output devices this
+same situation will cause <function>poll()</function> to succeed
+as well, but it sets the <constant>POLLOUT</constant> and
+<constant>POLLWRNORM</constant> flags in the <structfield>revents</structfield>
+field.</para>
 
     <para>When use of the <function>read()</function> function has
 been negotiated and the driver does not capture yet, the
-- 
2.1.0

