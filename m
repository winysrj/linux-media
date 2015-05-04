Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-2.cisco.com ([72.163.197.26]:35436 "EHLO
	bgl-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbEDLSC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 07:18:02 -0400
Received: from pla-VB.cisco.com ([10.142.58.44])
	by bgl-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t44BHv4a027169
	for <linux-media@vger.kernel.org>; Mon, 4 May 2015 11:17:58 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/2] rounding and overflow fix in cvt,gtf calculations
Date: Mon,  4 May 2015 16:18:57 +0530
Message-Id: <1430736539-28469-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please find patches for rounding and overflow fixes in cvt,gtf
timings calculations in v4l2-utils. Similar fixes are posted for
v4l2-dv-timings recently.

Regards,
Prashant

Prashant Laddha (2):
  v4l2-ctl-modes: fix hblank, hsync rounding in gtf calculation
  v4l2-utils: fix overflow in cvt, gtf calculations

 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

-- 
1.9.1

