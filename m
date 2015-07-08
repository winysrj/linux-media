Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:46572 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758653AbbGHNoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jul 2015 09:44:38 -0400
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-media@vger.kernel.org, p.zabel@pengutronix.de,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	hans.verkuil@cisco.com
Subject: [PATCH 0/2] RFC: m2m device fixes
Date: Wed,  8 Jul 2015 15:37:18 +0200
Message-Id: <cover.1436361987.git.zahari.doychev@linux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These patches fix some problems that I am experiencing when decoding video
using the coda driver. The first one fixes the video playback termination and
the second a kernel bug due to mutex unlock balance.

Regards
Zahari

Zahari Doychev (2):
  [media] coda: fix sequence counter increment
  [media] m2m: fix bad unlock balance

 drivers/media/platform/coda/coda-bit.c |  3 ++-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.4.5

