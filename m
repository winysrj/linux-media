Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:48161 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbbFPJ1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:27:02 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 2/3] v4l2-utils gtf: use round instead of roundown for v_lines_rnd
Date: Tue, 16 Jun 2015 14:47:51 +0530
Message-Id: <1434446272-21256-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
References: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GTF standards document specifies to use round() for v_lines_rnd
calculations. This change will affect only if image height is odd.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-modes.cpp b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
index ef528c0..d65cd75 100644
--- a/utils/v4l2-ctl/v4l2-ctl-modes.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-modes.cpp
@@ -410,7 +410,7 @@ bool calc_gtf_modeline(int image_width, int image_height,
 
 	if (interlaced) {
 		interlace = 1;
-		v_lines_rnd = v_lines / 2;
+		v_lines_rnd = (v_lines + 1) / 2;
 		v_refresh = v_refresh * 2;
 	} else {
 		interlace = 0;
-- 
1.9.1

