Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-1.cisco.com ([72.163.197.25]:60710 "EHLO
	bgl-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbbFXGi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 02:38:56 -0400
Received: from pla-VB.cisco.com ([10.142.61.237])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t5O6cqSY006255
	for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 06:38:52 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 0/2] Support for reduced fps in v4l2-utils
Date: Wed, 24 Jun 2015 12:08:50 +0530
Message-Id: <1435127932-10193-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches add support for reduced fps option in cvt timings. Please review and share your comments.

Regards,
Prashant

Prashant Laddha (2):
  v4l2-utils: add support for reduced fps in cvt modeline
  v4l2-utils: extend set-dv-timings to support reduced fps

 utils/v4l2-ctl/v4l2-ctl-modes.cpp |  6 +++++-
 utils/v4l2-ctl/v4l2-ctl-stds.cpp  | 14 ++++++++++++--
 utils/v4l2-ctl/v4l2-ctl.h         |  3 ++-
 3 files changed, 19 insertions(+), 4 deletions(-)

-- 
1.9.1

