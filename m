Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:53391 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbbEVF1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2015 01:27:37 -0400
Received: from pla-VB.cisco.com ([10.142.60.254])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t4M5RYRu017726
	for <linux-media@vger.kernel.org>; Fri, 22 May 2015 05:27:34 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH v2 0/4]  Support for interlaced in cvt/gtf timings
Date: Fri, 22 May 2015 10:57:33 +0530
Message-Id: <1432272457-709-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please find version 2 of patches adding interlaced support in cvt/gtf
timing.

Changes compared to v1:
Incorporated the comments from review of first RFC. It was about the 
error calculation of vertical back porch due to rounding. (Thanks to
Hans for spoting this error).

Prashant Laddha (4):
  v4l2-dv-timings: add interlace support in detect cvt/gtf
  vivid: Use interlaced info for cvt/gtf timing detection
  adv7604: Use interlaced info for cvt/gtf timing detection
  adv7842: Use interlaced info for cvt/gtf timing detection

 drivers/media/i2c/adv7604.c                  |  4 +--
 drivers/media/i2c/adv7842.c                  |  4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 +--
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 53 ++++++++++++++++++++++++----
 include/media/v4l2-dv-timings.h              |  6 ++--
 5 files changed, 58 insertions(+), 14 deletions(-)

-- 
1.9.1

