Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbcE0MsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:48:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de
Subject: [PATCH 0/6] New raw bayer format definitions, fixes
Date: Fri, 27 May 2016 15:44:34 +0300
Message-Id: <1464353080-18300-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches fix and add new raw bayer format definitions. 12-bit packed
V4L2 format definition is added as well as definitions of 14-bit media bus
codes as well as unpacked and packed V4L2 formats.

No driver uses them right now, yet they're common formats needed by newer
devices that use higher bit depths so adding them would make sense.

-- 
Kind regards,
Sakari

