Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:34870 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbbFXOAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 10:00:07 -0400
Received: from pla-VB.cisco.com ([10.142.61.237])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t5ODxuZu020124
	for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 13:59:57 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH v2 0/2] utils/v4l2-ctl/v4l2-ctl-modes.cpp
Date: Wed, 24 Jun 2015 19:29:54 +0530
Message-Id: <1435154396-11548-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Posting v2 again.

Change compared to v1:
Updated function description that was missed in v1

Prashant Laddha (2):
  v4l2-utils: add support for reduced fps in cvt modeline
  v4l2-utils: extend set-dv-timings to support reduced fps

 utils/v4l2-ctl/v4l2-ctl-modes.cpp |  7 ++++++-
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 14 ++++++++++++--
 utils/v4l2-ctl/v4l2-ctl.h         |  3 ++-
 3 files changed, 20 insertions(+), 4 deletions(-)

-- 
1.9.1

