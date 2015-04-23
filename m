Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:46041 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbD2RHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 13:07:17 -0400
Received: from pla-VB.cisco.com ([10.65.70.142])
	by bgl-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id t3TH6bC6012845
	for <linux-media@vger.kernel.org>; Wed, 29 Apr 2015 17:06:37 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/4] Support for interlaced in cvt/gtf timings
Date: Thu, 23 Apr 2015 14:29:47 +0530
Message-Id: <1429779591-26134-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, detect_cvt/gtf() functions in v4l2-dv-timings do not calculate
timings for interlaced format. Besides the set-dv-bt-timings control in
vivid, drivers for adv7604 and adv7842 may also need cvt/gtf timings for
interlaced format. This patch series is a proposal for adding interlaced
support in cvt/gtf timing calculation. Previously, I had submitted a patch
for the same. https://patchwork.linuxtv.org/patch/29130/  Hans had reviewed
and asked to rework and resubmit the patches as RFC.

Patch 1/4 extends the detect_cvt/gtf() API to pass on an interlaced flag
(this flag, if true, indicates interlaced format type). This patch adds the
timings calculation for interlaced format. Since detect_cvt/gtf() API is
changed, all caller functions also modified in the same patch. To begin with,
interlaced flag is passed as false.

Subsequent patches 2/4 to 4/4, contain changes in caller functions to pass the
appropriate values for interlaced flag.

Please review this patch series and share your comments, suggestions.

Regards,
Prashant


Prashant Laddha (4):
  v4l2-dv-timings: Add interlace support in detect cvt/gtf
  vivid: Use interlaced info for cvt/gtf timing detection
  adv7604: Use interlaced info for cvt/gtf timing detection
  adv7842: Use interlaced info for cvt/gtf timing detection

 drivers/media/i2c/adv7604.c                  |  4 +--
 drivers/media/i2c/adv7842.c                  |  4 +--
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 39 +++++++++++++++++++++++-----
 include/media/v4l2-dv-timings.h              |  6 +++--
 5 files changed, 44 insertions(+), 14 deletions(-)

-- 
1.9.1

