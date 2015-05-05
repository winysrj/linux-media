Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:48204 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422966AbbEENQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 09:16:31 -0400
Received: from pla-VB.cisco.com ([10.142.60.159])
	by bgl-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t45DGSC4011523
	for <linux-media@vger.kernel.org>; Tue, 5 May 2015 13:16:28 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2] v4l2-dv-timings: fix overflow in gtf timings calculation
Date: Tue,  5 May 2015 18:46:26 +0530
Message-Id: <1430831787-16714-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please find version v2 for the overflow fix in gtf timing calculation.
v2 incorporates comments from Hans on version 1 of this patch.

Regards,
Prashant

Prashant Laddha (1):
  v4l2-dv-timings: fix overflow in gtf timings calculation

 drivers/media/v4l2-core/v4l2-dv-timings.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

Changes compared to v1:
1. Use div_u64() for 64 bit division
2. Use u64 instead 
-- 
1.9.1

