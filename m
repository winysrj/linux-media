Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2745 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaDDJ6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Apr 2014 05:58:11 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id s349w8x5026401
	for <linux-media@vger.kernel.org>; Fri, 4 Apr 2014 11:58:10 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 0360E2A03F4
	for <linux-media@vger.kernel.org>; Fri,  4 Apr 2014 11:57:58 +0200 (CEST)
Message-ID: <533E8225.6020208@xs4all.nl>
Date: Fri, 04 Apr 2014 11:57:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] Bug fixes for 3.15
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A bunch of fixes for the davinci driver (found with the new vb2 instrumentation
and kmemleak) and a vb2 fix: the finish memop wasn't called for prepared or
queued buffers. Found with v4l2-compliance and the vb2 instrumentation.

This happens in the corner case where you call QBUF and/or PREPARE_BUF without
ever calling STREAMON, and then the vb2 queue is canceled either by calling
REQBUFS or closing the filehandle.

Regards,

	Hans

The following changes since commit 8432164ddf7bfe40748ac49995356ab4dfda43b7:

  [media] Sensoray 2255 uses videobuf2 (2014-03-24 17:23:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.15g

for you to fetch changes up to cb49f006c756c5fefe94d4e892d902f44bbfc54d:

  vb2: call finish() memop for prepared/queued buffers (2014-03-28 12:38:38 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      vb2: call finish() memop for prepared/queued buffers

Lad, Prabhakar (5):
      media: davinci: vpif_capture: fix releasing of active buffers
      media: davinci: vpif_display: fix releasing of active buffers
      media: davinci: vpbe_display: fix releasing of active buffers
      staging: media: davinci: vpfe: make sure all the buffers are released
      media: davinci: vpfe: make sure all the buffers unmapped and released

 drivers/media/platform/davinci/vpbe_display.c   | 16 +++++++++++++++-
 drivers/media/platform/davinci/vpfe_capture.c   |  2 ++
 drivers/media/platform/davinci/vpif_capture.c   | 34 +++++++++++++++++++++++-----------
 drivers/media/platform/davinci/vpif_display.c   | 35 +++++++++++++++++++++++------------
 drivers/media/v4l2-core/videobuf2-core.c        | 16 +++++++++++++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 13 +++++++++++--
 6 files changed, 87 insertions(+), 29 deletions(-)
