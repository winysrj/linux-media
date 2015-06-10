Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:34277 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965332AbbFJQvp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:51:45 -0400
Received: from pla-VB.cisco.com ([10.65.58.169])
	by bgl-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id t5AGpgOl025168
	for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 16:51:42 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH v2] Support for reduced blanking version 2
Date: Wed, 10 Jun 2015 22:21:41 +0530
Message-Id: <1433955102-7841-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes compared v1:
1. Extended v4l2_detect_cvt() api to pass active image width. This
   solves the issue related to how to get width in the absence of
   aspect information.
2. Fix: Added condition to correct the clock granularity.
3. Removed "TODO" for reduced blanking version 2.
4. Other comments from review of v1.

Prashant Laddha (1):
  v4l2-dv-timings: add support for reduced blanking v2

 drivers/media/i2c/adv7604.c                  |  2 +-
 drivers/media/i2c/adv7842.c                  |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c    | 80 ++++++++++++++++++++--------
 include/media/v4l2-dv-timings.h              |  6 ++-
 5 files changed, 67 insertions(+), 25 deletions(-)

-- 
1.9.1

