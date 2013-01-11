Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1497 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKN5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:57:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCHv3 2/3] DocBook: improve the error_idx field documentation.
Date: Fri, 11 Jan 2013 14:57:01 +0100
Message-Id: <3a86e97ac8eb93a9110ed5fbb7eb5e825bdcdef5.1357912476.git.hans.verkuil@cisco.com>
In-Reply-To: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
References: <1357912622-24736-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <66daf776429bc348c156f96eb36141588087783b.1357912476.git.hans.verkuil@cisco.com>
References: <66daf776429bc348c156f96eb36141588087783b.1357912476.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The documentation of the error_idx field was incomplete and confusing.
This patch improves it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   47 +++++++++++++++++---
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 0a4b90f..42ffbff 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -199,13 +199,46 @@ also be zero.</entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>error_idx</structfield></entry>
-	    <entry>Set by the driver in case of an error. If it is equal
-to <structfield>count</structfield>, then no actual changes were made to
-controls. In other words, the error was not associated with setting a particular
-control. If it is another value, then only the controls up to <structfield>error_idx-1</structfield>
-were modified and control <structfield>error_idx</structfield> is the one that
-caused the error. The <structfield>error_idx</structfield> value is undefined
-if the ioctl returned 0 (success).</entry>
+	    <entry><para>Set by the driver in case of an error. If the error is
+associated with a particular control, then <structfield>error_idx</structfield>
+is set to the index of that control. If the error is not related to a specific
+control, or the validation step failed (see below), then
+<structfield>error_idx</structfield> is set to <structfield>count</structfield>.
+The value is undefined if the ioctl returned 0 (success).</para>
+
+<para>Before controls are read from/written to hardware a validation step
+takes place: this checks if all controls in the list are valid controls,
+if no attempt is made to write to a read-only control or read from a write-only
+control, and any other up-front checks that can be done without accessing the
+hardware. The exact validations done during this step are driver dependent
+since some checks might require hardware access for some devices, thus making
+it impossible to do those checks up-front. However, drivers should make a
+best-effort to do as many up-front checks as possible.</para>
+
+<para>This check is done to avoid leaving the hardware in an inconsistent state due
+to easy-to-avoid problems. But it leads to another problem: the application needs to
+know whether an error came from the validation step (meaning that the hardware
+was not touched) or from an error during the actual reading from/writing to hardware.</para>
+
+<para>The, in hindsight quite poor, solution for that is to set <structfield>error_idx</structfield>
+to <structfield>count</structfield> if the validation failed. This has the
+unfortunate side-effect that it is not possible to see which control failed the
+validation. If the validation was successful and the error happened while
+accessing the hardware, then <structfield>error_idx</structfield> is less than
+<structfield>count</structfield> and only the controls up to
+<structfield>error_idx-1</structfield> were read or written correctly, and the
+state of the remaining controls is undefined.</para>
+
+<para>Since <constant>VIDIOC_TRY_EXT_CTRLS</constant> does not access hardware
+there is also no need to handle the validation step in this special way,
+so <structfield>error_idx</structfield> will just be set to the control that
+failed the validation step instead of to <structfield>count</structfield>.
+This means that if <constant>VIDIOC_S_EXT_CTRLS</constant> fails with
+<structfield>error_idx</structfield> set to <structfield>count</structfield>,
+then you can call <constant>VIDIOC_TRY_EXT_CTRLS</constant> to try to discover
+the actual control that failed the validation step. Unfortunately, there
+is no <constant>TRY</constant> equivalent for <constant>VIDIOC_G_EXT_CTRLS</constant>.
+</para></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-- 
1.7.10.4

