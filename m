Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46099 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab3EWOnI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 0/9] CODA patches in preparation for decoding support
Date: Thu, 23 May 2013 16:42:52 +0200
Message-Id: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch series contains a few fixes and cleanups
in preparation for decoding support.
I've simplified the parameter buffer setup code, changed the hardware
command register access locking for multi-instance support on CODA7,
and added a list of supported codecs per device type, where each codec
can have its own frame size limitation.

I intend follow up with a series that adds h.264 decoding support
for CODA7541 (i.MX53) and CODA960 (i.MX6), but what I'll send
to the list exactly depends a bit on whether the mem2mem changes in
the patch "[media] mem2mem: add support for hardware buffered queue"
will be accepted.

regards
Philipp

---
 drivers/media/platform/coda.c | 600 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------
 drivers/media/platform/coda.h |  11 ++-
 2 files changed, 326 insertions(+), 285 deletions(-)

