Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53318 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbbCTRFU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 13:05:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/5] DocBook media: improve V4L2_DV_FL_HALF_LINE documentation
Date: Fri, 20 Mar 2015 18:05:02 +0100
Message-Id: <1426871106-31914-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1426871106-31914-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Explicitly specify where the half-line is added or removed in
each field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prashant Laddha <prladdha@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index c433657..7d10784 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -318,10 +318,11 @@ can't generate such frequencies, then the flag will also be cleared.
 	  </row>
 	  <row>
 	    <entry>V4L2_DV_FL_HALF_LINE</entry>
-	    <entry>Specific to interlaced formats: if set, then field 1 (aka the odd field)
-is really one half-line longer and field 2 (aka the even field) is really one half-line
-shorter, so each field has exactly the same number of half-lines. Whether half-lines can be
-detected or used depends on the hardware.
+	    <entry>Specific to interlaced formats: if set, then the vertical frontporch
+of field 1 (aka the odd field) is really one half-line longer and the vertical backporch
+of field 2 (aka the even field) is really one half-line shorter, so each field has exactly
+the same number of half-lines. Whether half-lines can be detected or used depends on
+the hardware.
 	    </entry>
 	  </row>
 	</tbody>
-- 
2.1.4

