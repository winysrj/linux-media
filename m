Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4663 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932450AbcFTQ04 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:26:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v2 0/7] New raw bayer format definitions, fixes
Date: Mon, 20 Jun 2016 19:20:01 +0300
Message-Id: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

These patches fix and add new raw bayer format definitions. 12-bit packed
V4L2 format definition is added as well as definitions of 14-bit media bus
codes as well as unpacked and packed V4L2 formats.

No driver uses them right now, yet they're common formats needed by newer
devices that use higher bit depths so adding them would make sense.

since v1:

- Fix issues Hans pointed out in his review,

- add one patch to fix similar issues in already defined 10-bit and 12-bit
  formats found in 14-bit format definitions.

The previous set with the review comments can be found here:

<URL:http://www.spinics.net/lists/linux-media/msg100763.html>

-- 
Kind regards,
Sakari

