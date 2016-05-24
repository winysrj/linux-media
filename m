Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36769 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbcEXPG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:06:29 -0400
Received: by mail-pf0-f173.google.com with SMTP id c189so7847939pfb.3
        for <linux-media@vger.kernel.org>; Tue, 24 May 2016 08:06:29 -0700 (PDT)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	ricardo.ribalda@gmail.com, p.zabel@pengutronix.de,
	wuchengli@chromium.org, shuahkh@osg.samsung.com,
	hans.verkuil@cisco.com, renesas@ideasonboard.com,
	guennadi.liakhovetski@intel.com, sakari.ailus@linux.intel.com,
	posciak@chromium.org, djkurtz@chromium.org,
	tiffany.lin@mediatek.com, pc.chen@mediatek.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3] V4L: add VP9 format documentation
Date: Tue, 24 May 2016 23:05:23 +0800
Message-Id: <1464102324-53965-4-git-send-email-wuchengli@chromium.org>
In-Reply-To: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
References: <1464102324-53965-1-git-send-email-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for V4L2_PIX_FMT_VP9.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 5a08aee..ab915c3 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1735,6 +1735,11 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 		<entry>'VP80'</entry>
 		<entry>VP8 video elementary stream.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-VP9">
+		<entry><constant>V4L2_PIX_FMT_VP9</constant></entry>
+		<entry>'VP90'</entry>
+		<entry>VP9 video elementary stream.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.8.0.rc3.226.g39d4020

