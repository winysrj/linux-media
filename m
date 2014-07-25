Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38040 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaGYPJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 11:09:07 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/11] CODA Cleanup & fixes
Date: Fri, 25 Jul 2014 17:08:26 +0200
Message-Id: <1406300917-18169-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the following series applies on top of the previous "Split CODA driver into
multiple files" series. It contains various accumulated fixes, including
dequeueing of buffers in stop_streaming and after start_streaming failure,
a crash fix for the timestamp list handling, better error reporting, and
the interrupt request by name in preparation for the second JPEG interrupt
on CODA960.

regards
Philipp

Fabio Estevam (2):
  [media] coda: Return the real error on platform_get_irq()
  [media] coda: Propagate the correct error on
    devm_request_threaded_irq()

Michael Olbrich (1):
  [media] coda: fix timestamp list handling

Philipp Zabel (8):
  [media] coda: remove unnecessary peek at next destination buffer from
    coda_finish_decode
  [media] coda: request BIT processor interrupt by name
  [media] coda: dequeue buffers if start_streaming fails
  [media] coda: dequeue buffers on streamoff
  [media] coda: skip calling coda_find_codec in encoder try_fmt_vid_out
  [media] coda: increase max vertical frame size to 1088
  [media] coda: add an intermediate debug level
  [media] coda: improve allocation error messages

 drivers/media/platform/coda/coda-bit.c    | 33 +++++++----
 drivers/media/platform/coda/coda-common.c | 96 +++++++++++++++++++++----------
 2 files changed, 87 insertions(+), 42 deletions(-)

-- 
2.0.1

