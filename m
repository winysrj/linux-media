Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934327AbaDITZN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Apr 2014 15:25:13 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id CEEBC20DF4
	for <linux-media@vger.kernel.org>; Wed,  9 Apr 2014 22:24:52 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/17] smiapp and smiapp-pll quirk improvements, fixes
Date: Wed,  9 Apr 2014 22:24:52 +0300
Message-Id: <1397071509-2071-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

This patchset contains PLL quirk improvements to take quirks in some
implementations into account, as well as make the quirk mechanisms more
flexible. The driver core is mostly unaffected by these changes.

The PLL tree calculation itself is concerned less with the factual
frequencies but focuses on producing multipliers and dividers that are valid
for the hardware. Quirk flags are primarily used to convert input and output
parameters.

The limit values are also made 64 bits; 64-bit values are needed in more
generic case when floating point numbers are converted to fixed point.

There are some miscellaneous fixes as well.

-- 
Kind regards,
Sakari

