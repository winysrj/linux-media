Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:33583 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757487AbbGQKB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 06:01:58 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E5FE72A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 12:00:55 +0200 (CEST)
Message-ID: <55A8D257.7060004@xs4all.nl>
Date: Fri, 17 Jul 2015 12:00:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] coda driver fixes/enhancements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git coda

for you to fetch changes up to 841847fa5b355add85a0d925ad63156347d422e5:

  coda: make NV12 format default (2015-07-17 11:54:04 +0200)

----------------------------------------------------------------
Lucas Stach (1):
      coda: clamp frame sequence counters to 16 bit

Philipp Zabel (15):
      coda: fix mvcol buffer for MPEG4 decoding
      coda: fix bitstream preloading for MPEG4 decoding
      coda: keep buffers on the queue in bitstream end mode
      coda: avoid calling SEQ_END twice
      coda: reset stream end in stop_streaming
      coda: drop custom list of pixel format descriptions
      coda: use event class to deduplicate v4l2 trace events
      coda: reuse src_bufs in coda_job_ready
      coda: rework meta counting and add separate lock
      coda: reset CODA960 hardware after sequence end
      coda: implement VBV delay and buffer size controls
      coda: Use S_PARM to set nominal framerate for h.264 encoder
      coda: move cache setup into coda9_set_frame_cache, also use it in start_encoding
      coda: add macroblock tiling support
      coda: make NV12 format default

 drivers/media/platform/coda/Makefile      |   2 +-
 drivers/media/platform/coda/coda-bit.c    | 140 +++++++++++++++++++++++++---------
 drivers/media/platform/coda/coda-common.c | 336 ++++++++++++++++++++++++++++++++++++++++++++--------------------------------------
 drivers/media/platform/coda/coda-gdi.c    | 150 +++++++++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |  15 ++--
 drivers/media/platform/coda/coda_regs.h   |  10 +++
 drivers/media/platform/coda/trace.h       |  89 +++++++---------------
 7 files changed, 478 insertions(+), 264 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-gdi.c
