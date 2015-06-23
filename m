Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:62168 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbFWF4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 01:56:16 -0400
Received: from pla-VB.cisco.com ([10.142.61.237])
	by bgl-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id t5N5uDBN010411
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 05:56:13 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH v2 0/2] v4l2-utils: add support for RB v2 in cvt
Date: Tue, 23 Jun 2015 11:26:11 +0530
Message-Id: <1435038973-2076-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Posting v2 of patches adding support for reduced blanking version 2 in
v4l2-utils. 

Changes compared to v1:
Incorporated comments on v1. Removed an extra option that was added for 
use-rb-v2. Instead, it now allows reduced-blanking = 2 to indicate the
version 2 of reduced blanking.

Prashant Laddha (2):
  v4l2-ctl-modes: add support for reduced blanking version 2
  v4l2-utils: Modify usage for set-dv-timing to support RB V2

 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 63 +++++++++++++++++++++++++++++----------
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 19 ++++++------
 utils/v4l2-ctl/v4l2-ctl.h         |  4 +--
 3 files changed, 58 insertions(+), 28 deletions(-)

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
