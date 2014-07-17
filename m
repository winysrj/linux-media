Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169AbaGQQFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/11] CODA encoder/decoder device split
Date: Thu, 17 Jul 2014 18:05:01 +0200
Message-Id: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the following patches add a few fixes and cleanups and split the
coda video4linux2 device into encoder and decoder.
Following the principle of least surprise, this way the format
enumeration on the output and capture sides is fixed and does
not change depending on whether the given instance is currently
configured as encoder or decoder.

regards
Philipp

Michael Olbrich (2):
  [media] coda: use CODA_MAX_FRAME_SIZE everywhere
  [media] coda: delay coda_fill_bitstream()

Philipp Zabel (9):
  [media] coda: fix CODA7541 hardware reset
  [media] coda: initialize hardware on pm runtime resume only if
    firmware available
  [media] coda: remove CAPTURE and OUTPUT caps
  [media] coda: remove VB2_USERPTR from queue io_modes
  [media] coda: lock capture frame size to output frame size when
    streaming
  [media] coda: split userspace interface into encoder and decoder
    device
  [media] coda: split format enumeration for encoder end decoder device
  [media] coda: default to h.264 decoder on invalid formats
  [media] coda: mark constant structures as such

 drivers/media/platform/coda.c | 316 ++++++++++++++++++++++++++----------------
 1 file changed, 193 insertions(+), 123 deletions(-)

-- 
2.0.1

