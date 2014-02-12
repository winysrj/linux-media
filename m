Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3906 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaBLH5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 02:57:21 -0500
Message-ID: <52FB292C.7040109@xs4all.nl>
Date: Wed, 12 Feb 2014 08:56:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 35/34] DocBook media: clarify how the matrix maps
 to the grid.
References: <1392022019-5519-1-git-send-email-hverkuil@xs4all.nl> <1392022019-5519-35-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392022019-5519-35-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This patch is an addition to the "Add support for complex controls, use in solo/go7007"
patch series)

Make it explicit that matrix element (0, 0) maps to the top-left cell
of the grid.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 5f3e138..4749216 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5102,7 +5102,8 @@ description of this control class.</entry>
 	  </row>
 	  <row><entry spanname="descr">Sets the motion detection thresholds for each cell in the grid.
 	  To be used with the <constant>V4L2_DETECT_MD_MODE_THRESHOLD_GRID</constant>
-	  motion detection mode.</entry>
+	  motion detection mode. Matrix element (0, 0) represents the cell at the top-left of the
+	  grid.</entry>
           </row>
           <row>
 	    <entry spanname="id"><constant>V4L2_CID_DETECT_MD_REGION_GRID</constant>&nbsp;</entry>
@@ -5110,7 +5111,8 @@ description of this control class.</entry>
 	  </row>
 	  <row><entry spanname="descr">Sets the motion detection region value for each cell in the grid.
 	  To be used with the <constant>V4L2_DETECT_MD_MODE_REGION_GRID</constant>
-	  motion detection mode.</entry>
+	  motion detection mode. Matrix element (0, 0) represents the cell at the top-left of the
+	  grid.</entry>
           </row>
         </tbody>
       </tgroup>
-- 
1.8.5.2


