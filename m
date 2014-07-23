Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46706 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292AbaGWP31 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/8] Split CODA driver into multiple files
Date: Wed, 23 Jul 2014 17:28:37 +0200
Message-Id: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Hans suggested to split the CODA driver, so this series moves it into
its own subdirectory and splits it roughly in half by moving the BIT
processor handling and H.264 specific helper function out into their
own files.
The coda-bit.c will get its coda-jpeg.c counterpart in the future
for JPEG encoding and decoding on i.MX6.

regards
Philipp

Philipp Zabel (8):
  [media] coda: move coda driver into its own directory
  [media] coda: move defines, enums, and structs into shared header
  [media] coda: add context ops
  [media] coda: move BIT processor command execution out of pic_run_work
  [media] coda: add coda_bit_stream_set_flag helper
  [media] coda: move per-instance buffer allocation and cleanup
  [media] coda: move H.264 helper function into separate file
  [media] coda: move BIT specific functions into separate file

 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/coda.c                      | 4000 --------------------
 drivers/media/platform/coda/Makefile               |    3 +
 drivers/media/platform/coda/coda-bit.c             | 1810 +++++++++
 drivers/media/platform/coda/coda-common.c          | 2003 ++++++++++
 drivers/media/platform/coda/coda-h264.c            |   36 +
 drivers/media/platform/coda/coda.h                 |  287 ++
 .../media/platform/{coda.h => coda/coda_regs.h}    |    0
 8 files changed, 4140 insertions(+), 4001 deletions(-)
 delete mode 100644 drivers/media/platform/coda.c
 create mode 100644 drivers/media/platform/coda/Makefile
 create mode 100644 drivers/media/platform/coda/coda-bit.c
 create mode 100644 drivers/media/platform/coda/coda-common.c
 create mode 100644 drivers/media/platform/coda/coda-h264.c
 create mode 100644 drivers/media/platform/coda/coda.h
 rename drivers/media/platform/{coda.h => coda/coda_regs.h} (100%)

-- 
2.0.1

