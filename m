Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46380 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3I3NfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH v2 0/10] CODA driver fixes
Date: Mon, 30 Sep 2013 15:34:43 +0200
Message-Id: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series contains a few fixes for the CODA driver to allow more than
four simultaneous instances on i.MX53, and to make v4l2-compliance a
bit happier.

Changes since v1:
 - Removed no-op lines leaving FMOPARAM fields of CMD_ENC_SEQ_FMO
   at zero values on CodaDx6.
 - Use coda_ instead of coda_vidioc_ prefix for v4l2_ioctl_ops
 - Clear pixel format priv in try_fmt only

regards
Philipp

---
 drivers/media/platform/coda.c | 278 ++++++++++++++++++++++++++----------------
 1 file changed, 172 insertions(+), 106 deletions(-)

