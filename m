Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41130 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZHNVBg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2009 17:01:36 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	khilman@deeprootsystems.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v1 0/5] V4L: vpif_capture driver for DM6467
Date: Fri, 14 Aug 2009 17:01:29 -0400
Message-Id: <1250283689-5554-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch series add support for VPIF Capture Driver on DM6467.
VPIF (Video Port Interface) has two channels for capture video
or Raw image data. Currently only video capture is supported
using TVP5147 on each of the channel. That means two simultaneous
capture of NTSC/PAL video is possible using this driver.

This has incorporated comments received against version v0 of the
patch series

Following are the patches in this series:-

1) DaVinci - re-structuring code to support vpif capture driver
2) V4L : vpif capture - Kconfig and Makefile changes
3) V4L : vpif_capture driver for DM6467
4) V4L : vpif updates for DM6467 vpif capture driver
5) V4L : vpif display - updates to support vpif capture on DM6467

NOTE: All patches are to be applied before build.

Mandatory reviewers : Hans Verkuil <hverkuil@xs4all.nl> for V4L tree
                      Kevin Hilman <khilman@deeprootsystems.com> for DaVinci tree

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
