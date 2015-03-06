Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbCFKSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2015 05:18:35 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 0/5] Signalling last decoded frame by V4L2_BUF_FLAG_LAST and -EPIPE
Date: Fri,  6 Mar 2015 11:18:25 +0100
Message-Id: <1425637110-12100-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At the V4L2 codec API session during ELC-E 2014, we agreed that for the decoder
draining flow, after a V4L2_DEC_CMD_STOP decoder command was issued, the last
decoded buffer should get dequeued with a V4L2_BUF_FLAG_LAST set. After that,
poll should immediately return and all following VIDIOC_DQBUF should return
-EPIPE until the stream is stopped or decoding continued via V4L2_DEC_CMD_START.
(or STREAMOFF/STREAMON).

Changes since v2:
 - Made V4L2_BUF_FLAG_LAST known to trace events

regards
Philipp

Peter Seiderer (1):
  [media] videodev2: Add V4L2_BUF_FLAG_LAST

Philipp Zabel (4):
  [media] videobuf2: return -EPIPE from DQBUF after the last buffer
  [media] coda: Set last buffer flag and fix EOS event
  [media] s5p-mfc: Set last buffer flag
  [media] DocBooc: mention mem2mem codecs for encoder/decoder commands

 Documentation/DocBook/media/v4l/io.xml             | 10 ++++++++
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  6 ++++-
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |  5 +++-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |  8 +++++++
 drivers/media/platform/coda/coda-bit.c             |  4 ++--
 drivers/media/platform/coda/coda-common.c          | 27 +++++++++-------------
 drivers/media/platform/coda/coda.h                 |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c             | 10 +++++++-
 drivers/media/v4l2-core/videobuf2-core.c           | 18 ++++++++++++++-
 include/media/videobuf2-core.h                     | 10 ++++++++
 include/trace/events/v4l2.h                        |  3 ++-
 include/uapi/linux/videodev2.h                     |  2 ++
 13 files changed, 84 insertions(+), 23 deletions(-)

-- 
2.1.4

