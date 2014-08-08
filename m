Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1706 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHHHiX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 03:38:23 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id s787cJGb040587
	for <linux-media@vger.kernel.org>; Fri, 8 Aug 2014 09:38:21 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 1748A2A2651
	for <linux-media@vger.kernel.org>; Fri,  8 Aug 2014 09:38:10 +0200 (CEST)
Message-ID: <53E47E61.1060007@xs4all.nl>
Date: Fri, 08 Aug 2014 09:38:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix order of v4l2_edid fields
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The order of the last two fields in the G/S_EDID specification was swapped from
what is in the actual struct. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
index ce4563b..fa91651 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-edid.xml
@@ -125,17 +125,17 @@
 	    <structfield>blocks</structfield> is 0, then the EDID is disabled or erased.</entry>
 	  </row>
 	  <row>
-	    <entry>__u8&nbsp;*</entry>
-	    <entry><structfield>edid</structfield></entry>
-	    <entry>Pointer to memory that contains the EDID. The minimum size is
-	    <structfield>blocks</structfield>&nbsp;*&nbsp;128.</entry>
-	  </row>
-	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[5]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
+	  <row>
+	    <entry>__u8&nbsp;*</entry>
+	    <entry><structfield>edid</structfield></entry>
+	    <entry>Pointer to memory that contains the EDID. The minimum size is
+	    <structfield>blocks</structfield>&nbsp;*&nbsp;128.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
