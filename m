Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52234 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaHERAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 13:00:42 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RESEND 00/15] CODA patches for v3.17
Date: Tue,  5 Aug 2014 19:00:05 +0200
Message-Id: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil, Mauro,

thank you for merging most of the pending coda patches in time for v3.17.
Here are the remaining patches, rebased on top of the current media
for-3.17 branch.
I have left all checkpatch warnings in the "[media] coda: request BIT
processor interrupt by name" patch untouched, as this only moves code
around. The other patches are checkpatch clean, except for the
CODA_CODEC definition lines that I'd like to keep unbroken.
I've also added a fixup for 38932df4cb17 "coda: move H.264 helper
function into separate file" in the front.

regards
Philipp

Philipp Zabel (15):
  [media] coda: include header for memcpy
  [media] coda: move BIT specific functions into separate file
  [media] coda: remove unnecessary peek at next destination buffer from
    coda_finish_decode
  [media] coda: request BIT processor interrupt by name
  [media] coda: dequeue buffers if start_streaming fails
  [media] coda: dequeue buffers on streamoff
  [media] coda: skip calling coda_find_codec in encoder try_fmt_vid_out
  [media] coda: allow running coda without iram on mx6dl
  [media] coda: increase max vertical frame size to 1088
  [media] coda: add an intermediate debug level
  [media] coda: improve allocation error messages
  [media] coda: fix timestamp list handling
  [media] coda: fix coda_s_fmt_vid_out
  [media] coda: set capture frame size with output S_FMT
  [media] coda: disable old cropping ioctls

 drivers/media/platform/coda/Makefile      |    2 +-
 drivers/media/platform/coda/coda-bit.c    | 1823 +++++++++++++++++++++++++++
 drivers/media/platform/coda/coda-common.c | 1944 ++---------------------------
 drivers/media/platform/coda/coda-h264.c   |    1 +
 drivers/media/platform/coda/coda.h        |   56 +
 5 files changed, 1976 insertions(+), 1850 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-bit.c

-- 
2.0.1

