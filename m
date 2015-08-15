Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:35155 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbbHORPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2015 13:15:18 -0400
Received: from pla-VB.cisco.com ([10.65.77.74])
	by bgl-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id t7FHFF2s009097
	for <linux-media@vger.kernel.org>; Sat, 15 Aug 2015 17:15:15 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH] support reduced fps for vivid video out
Date: Sat, 15 Aug 2015 22:45:14 +0530
Message-Id: <1439658915-2511-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks to inputs from Hans, I have tried adding reduced fps support for video out in vivid. Please review this patch and share your comments, suggestions.

I am working on adding similar support for video capture. Actually, I wanted to include both patches in one series. However, the changes on capture side are taking time. So, I thought of posting this patch and gather some early feedback.

Regards,
Prashant

Prashant Laddha (1):
  vivid: add support for reduced fps in video out.

 drivers/media/platform/vivid/vivid-vid-out.c | 30 +++++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
 2 files changed, 34 insertions(+), 1 deletion(-)

-- 
1.9.1

