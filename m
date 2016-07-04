Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51445 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932500AbcGDNfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:35:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] DocBook media: document the v4l2_bt_timings reserved field
Date: Mon,  4 Jul 2016 15:34:51 +0200
Message-Id: <1467639292-1066-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
References: <1467639292-1066-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This field was never documented, and neither was it mentioned that
it should be zeroed by the application.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index 06952d7..8bb20d3 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -186,6 +186,13 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	    See <xref linkend="dv-bt-flags"/> for a description of the flags.
 	    </entry>
 	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[14]</entry>
+	    <entry>Reserved for future extensions. Drivers and applications must set
+	    the array to zero.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.8.1

