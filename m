Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:44855 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbbDWJ47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 05:56:59 -0400
Received: from pla-VB.cisco.com ([10.142.61.147])
	by bgl-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t3N9uuda029660
	for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 09:56:56 GMT
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Subject: fix for rounding errors in cvt/gtf calculation
Date: Wed, 22 Apr 2015 23:02:33 +0530
Message-Id: <1429723957-8308-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <fix for rounding errors in cvt/gtf calculation>
References: <fix for rounding errors in cvt/gtf calculation>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is second version of patch series towards fixing rounding errors
in cvt,gtf timing calculations.

In version 1, the fixes for rounding errors have added on top of patches
meant for interlaced support. Based on the feedback from Hans, I have 
now (in v2), reworked the patches such that, patches for rounding fixes
will go first.

Also, based on suggestion from Martin, added sanity checks in v2.

Please review following patches and share your comments.   

[PATCH v2 1/4] v4l2-dv-timings: fix rounding error in vsync_bp
[PATCH v2 2/4] v4l2-dv-timings: fix rounding in hblank and hsync
[PATCH v2 3/4] v4l2-dv-timings: add sanity checks in cvt,gtf
[PATCH v2 4/4] v4l2-dv-timings: replace hsync magic number with a

Thanks to Martin for helping me to validate the rounding fixes.

Regards,
Prashant
