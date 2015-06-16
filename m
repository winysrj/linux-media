Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-4.cisco.com ([72.163.197.28]:23252 "EHLO
	bgl-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbbFPJhd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:37:33 -0400
Received: from pla-VB.cisco.com ([10.142.61.237])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t5G9UTv9014878
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2015 09:30:29 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] v4l2-utils: add support for RB v2 in cvt modeline
Date: Tue, 16 Jun 2015 15:00:29 +0530
Message-Id: <1434447031-21434-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find patches adding support for reduced blanking v2 (RB v2) in cvt modeline
calculations in v4l2-utils. Recently, RB v2 support was added to v4l2-dv-timings and
RB v2 support in v4l2-utils is a follow up on that work. Please review.

Regards,
Prashant

Prashant Laddha (2):
  v4l2-ctl-modes: add support for reduced blanking version 2
  v4l2-utils: extend set-dv-timing options for RB version

 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 44 +++++++++++++++++++++++++++++++--------
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 11 +++++++++-
 utils/v4l2-ctl/v4l2-ctl.h         |  3 ++-
 3 files changed, 47 insertions(+), 11 deletions(-)

-- 
1.9.1

