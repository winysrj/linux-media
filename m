Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:11187 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbbFPJ0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 05:26:43 -0400
Received: from pla-VB.cisco.com ([10.142.61.237])
	by bgl-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id t5G9HpHM011984
	for <linux-media@vger.kernel.org>; Tue, 16 Jun 2015 09:17:52 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] v4l2-utils: miscellaneous fixes in cvt, gtf modeline
Date: Tue, 16 Jun 2015 14:47:49 +0530
Message-Id: <1434446272-21256-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Recently, while testing reduced blanking implementation, I came across few differences
between the results produced by cvt, gtf modeline implementation and results given by
standards spreadsheet. The resultant timing differences were minor and seen only for
few input combinations. However, it would be good to have it fixed. Please find the
fixes for the same.

Regards,
Prashant

Prashant Laddha (3):
  v4l2-utils: handle interlace fraction correctly in gtf
  v4l2-utils gtf: use round instead of roundown for v_lines_rnd
  v4l2-utils: fix pixel clock calc for cvt reduced blanking

 utils/v4l2-ctl/v4l2-ctl-modes.cpp | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

-- 
1.9.1

