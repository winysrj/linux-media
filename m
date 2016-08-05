Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33147 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759610AbcHEKqh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:46:37 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH v3 00/11] New raw bayer format definitions, fixes
Date: Fri,  5 Aug 2016 13:45:30 +0300
Message-Id: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is a third version of the new bayer format patchset. The second version
of the set may be found here:

<URL:http://www.spinics.net/lists/linux-media/msg101498.html>

These patches fix and add new raw bayer format definitions. 12-bit packed
V4L2 format definition is added as well as definitions of 14-bit media bus
codes as well as unpacked and packed V4L2 formats.

No driver uses them right now, yet they're common formats needed by newer
devices that use higher bit depths so adding them would make sense.

16-bit pixel formats are added as well, and the 16-bit formats are now
expected to have 16 bits of data. 8-bit format documentation is unified. 

Since v2:

- Convert documentation changes to ReST

- Use figures and word numerals consistently (3rd patch)

- Change "colour component" -> sample. This makes more sense. (3rd patch as
  well as the patches adding new formats)

- Unify the documentation of 8 bits per sample formats

- 16 bpp formats now have 16 significant bits. The drivers that use them
  do not depend on the optionally lower bit depth allowed by the old
  definition (10th patch)


Despite these changes, I've cunningly kept Hans's acks. I hope that works
out well.

-- 
Cheers,
Sakari


