Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40401 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbbCTRFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <mats.randgaard@cisco.com>
Subject: [PATCH 3/5] DocBook media: document the new V4L2_DV_FL_IS_CE_VIDEO flag
Date: Fri, 20 Mar 2015 18:05:04 +0100
Message-Id: <1426871106-31914-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this new flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <mats.randgaard@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index 7d10784..764b635 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -325,6 +325,15 @@ the same number of half-lines. Whether half-lines can be detected or used depend
 the hardware.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_IS_CE_VIDEO</entry>
+	    <entry>If set, then this is a Consumer Electronics (CE) video format.
+Such formats differ from other formats (commonly called IT formats) in that if
+R'G'B' encoding is used then by default the R'G'B' values use limited range
+(i.e. 16-235) as opposed to full range (i.e. 0-255). All formats defined in CEA-861
+except for the 640x480p59.94 format are CE formats.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.1.4

