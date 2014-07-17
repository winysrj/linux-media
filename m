Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1685 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGQNsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 09:48:02 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HDlwfq045713
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 15:48:00 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 11A192A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 15:47:56 +0200 (CEST)
Message-ID: <53C7D40C.7050406@xs4all.nl>
Date: Thu, 17 Jul 2014 15:47:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] DocBook improvement for U8 and U16 control types
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removed the "This type is only used-in array controls." sentence in DocBook
which was thought to only confuse.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index d9a3f23..62163d9 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -518,8 +518,8 @@ Older drivers which do not support this feature return an
 	    <entry>any</entry>
 	    <entry>An unsigned 8-bit valued control ranging from minimum to
 maximum inclusive. The step value indicates the increment between
-values which are actually different on the hardware. This type is only used
-in array controls.</entry>
+values which are actually different on the hardware.
+</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_U16</constant></entry>
@@ -528,8 +528,8 @@ in array controls.</entry>
 	    <entry>any</entry>
 	    <entry>An unsigned 16-bit valued control ranging from minimum to
 maximum inclusive. The step value indicates the increment between
-values which are actually different on the hardware. This type is only used
-in array controls.</entry>
+values which are actually different on the hardware.
+</entry>
 	  </row>
 	</tbody>
       </tgroup>
