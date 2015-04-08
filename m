Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:59675 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbDHNVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 09:21:49 -0400
Received: from pla-VB.cisco.com ([10.142.61.66])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t38D9V0T015562
	for <linux-media@vger.kernel.org>; Wed, 8 Apr 2015 13:09:32 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: fix for rounding errors in cvt/gtf calculation 
Date: Wed,  8 Apr 2015 18:39:27 +0530
Message-Id: <1428498569-6751-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While I was testing cvt / gtf timings against the timings given by
standards timing generator spreadsheets, there were differences in 
results for some of the formats. Those differences could be traced 
back to the rounding used to compute some of the intermediate values.
 
Following two patches fixes two such rounding errors.

[PATCH 1/2] v4l2-dv-timings: fix rounding error in vsync_bp
[PATCH 2/2] v4l2-dv-timings: fix rounding in hblank and hsync

Please review and share your comments.

Regards,
Prashant
