Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2319 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2IGN3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 11/28] DocBook: fix awkward language and fix the documented return value.
Date: Fri,  7 Sep 2012 15:29:11 +0200
Message-Id: <9190d2916210424b0f49a0ea678698ff9ea5dcaf.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The Video Standard section contains some awkward language. It also wasn't
updated when the error code for unimplemented ioctls changed from EINVAL
to ENOTTY.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index b91d253..9378d7b 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -589,8 +589,8 @@ switch to a standard by &v4l2-std-id;.</para>
 when the device has one or more video inputs or outputs.</para>
 
     <para>Special rules apply to USB cameras where the notion of video
-standards makes little sense. More generally any capture device,
-output devices accordingly, which is <itemizedlist>
+standards makes little sense. More generally for any capture or output device
+which is: <itemizedlist>
 	<listitem>
 	  <para>incapable of capturing fields or frames at the nominal
 rate of the video standard, or</para>
@@ -605,17 +605,17 @@ capture time, or</para>
 refer to the frames received by the driver, not the captured
 frames.</para>
 	</listitem>
-      </itemizedlist> Here the driver shall set the
+      </itemizedlist> the driver shall set the
 <structfield>std</structfield> field of &v4l2-input; and &v4l2-output;
-to zero, the <constant>VIDIOC_G_STD</constant>,
+to zero and the <constant>VIDIOC_G_STD</constant>,
 <constant>VIDIOC_S_STD</constant>,
 <constant>VIDIOC_QUERYSTD</constant> and
 <constant>VIDIOC_ENUMSTD</constant> ioctls shall return the
-&EINVAL;.<footnote>
-	<para>See <xref linkend="buffer" /> for a rationale. Probably
-even USB cameras follow some well known video standard. It might have
-been better to explicitly indicate elsewhere if a device cannot live
-up to normal expectations, instead of this exception.</para>
+&ENOTTY;.<footnote>
+	<para>See <xref linkend="buffer" /> for a rationale.</para>
+	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
+<xref linkend="output-capabilities"/> flags to determine whether the video standard ioctls
+are available for the device.</para>
 	    </footnote></para>
 
     <example>
-- 
1.7.10.4

