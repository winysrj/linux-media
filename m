Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:13247 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbbHWOJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 10:09:25 -0400
Received: from pla-VB.cisco.com ([10.65.39.227])
	by bgl-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id t7NE9BxV006919
	for <linux-media@vger.kernel.org>; Sun, 23 Aug 2015 14:09:15 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] vivid: reduced fps support
Date: Sun, 23 Aug 2015 19:39:09 +0530
Message-Id: <1440338951-23748-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Following patches add reduced fps support in vivid video transmit
and capture. Please review and share your comments.

Regards,
Prashant

Prashant Laddha (2):
  vivid: add support for reduced fps in video out.
  vivid: add support for reduced fps in video capture

 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c   | 15 ++++++++++++++
 drivers/media/platform/vivid/vivid-vid-cap.c |  7 ++++++-
 drivers/media/platform/vivid/vivid-vid-out.c | 30 +++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
 5 files changed, 56 insertions(+), 2 deletions(-)

-- 
1.9.1

