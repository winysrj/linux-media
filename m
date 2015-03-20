Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:5119 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbCTG4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 02:56:43 -0400
Received: from pla-VB.cisco.com ([10.65.67.170])
	by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id t2K6l00b009882
	for <linux-media@vger.kernel.org>; Fri, 20 Mar 2015 06:47:01 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Support for CVT, GTF timings 
Date: Fri, 20 Mar 2015 12:03:30 +0530
Message-Id: <1426833213-7777-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches add support for calculating CVT and GTF timings in v4l2-ctl.

vl2-ctl already has a support setting up of fully specified timings. In
this case user needs to specify all values like pixel clock, sync, front
and back porches etc in v4l2_bt_timings structure. Hans had suggested
that it would be nice to add support for calculating CVT and GTF timings
in v4l2-ctl. I have been working with Hans on adding this support. Please
find following patches for the same.

0001-v4l2-ctl-Add-support-for-CVT-GTF-modeline-calculatio.patch
0002-v4l2-ctl-stds-Restructured-suboption-parsing-code.patch
0003-v4l2-ctl-stds-Support-cvt-gtf-options-in-set-dv-bt-t.patch

Please review and share your comments and suggestions.

Regards,
Prashant
