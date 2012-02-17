Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37507 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2BQPET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 10:04:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZJ0060GLV5NR70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZJ00MC7LV4QU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Date: Fri, 17 Feb 2012 16:04:11 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/2] Add support for JPEG controls in s5p-jpeg driver
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1329491053-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

These two patches add support for JPEG controls and remove VIDIOC_G/S_JPEGCOMP
ioctl handlers in the s5p-jpeg JPEG codec driver.

The relevant JPEG class patches can be found in git repository at:

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/media-for-next


Sylwester Nawrocki (2):
  s5p-jpeg: Use struct v4l2_fh
  s5p-jpeg: Add JPEG controls support

 drivers/media/video/s5p-jpeg/jpeg-core.c |  182 +++++++++++++++++++++---------
 drivers/media/video/s5p-jpeg/jpeg-core.h |   11 ++-
 drivers/media/video/s5p-jpeg/jpeg-hw.h   |   18 ++-
 3 files changed, 151 insertions(+), 60 deletions(-)

---
Thanks,
Sylwester

