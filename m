Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35542 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313Ab3FUHzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 03:55:38 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH v2 0/8] CODA7541 decoding support
Date: Fri, 21 Jun 2013 09:55:26 +0200
Message-Id: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch series depends on the CODA patches queued in Kamil's branch
and on the "mem2mem: add support for hardware buffered queue" patch I've posted
earlier. It should allow decoding h.264 high profile 1080p streams on i.MX53
with the current CODA7541 firmware version 1.4.50.

Changes since v1:
 - Only the last patch "coda: add CODA7541 decoding support" is changed, including 
   a coda_stop_streaming() locking fix by Wei Yongjun, and a fixed coda_job_ready()
   for the encoder case.

regards
Philipp

---
 drivers/media/platform/coda.c | 1469 +++++++++++++++++++++++++++++++++++------
 drivers/media/platform/coda.h |  107 ++-
 2 files changed, 1389 insertions(+), 187 deletions(-)

