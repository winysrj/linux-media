Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51364 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbZHFXCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 19:02:54 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v0 0/5] V4L: vpif_capture driver for DM6467
Date: Thu,  6 Aug 2009 19:02:47 -0400
Message-Id: <1249599767-21642-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

This patch series add support for VPIF Capture Driver on DM6467.
VPIF (Video Port Interface) has two channels for capture video
or Raw image data. Currently only video capture is supported
using TVP5147 on each of the channel. That means two simultaneous
capture of NTSC/PAL video is possible using this driver.

Following are the patches in this series:-

1) DaVinci - re-structuring code to support vpif capture driver
2) V4L : vpif updates for DM6467 vpif capture driver
3) V4L : vpif display - updates to support vpif capture on DM6467
4) V4L : vpif_capture driver for DM6467
5) V4L : vpif capture - Kconfig and Makefile changes

Mandatory reviewers : Hans Verkuil <hverkuil@xs4all.nl>
                      Kevin Hilman <khilman@deeprootsystems.com>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
