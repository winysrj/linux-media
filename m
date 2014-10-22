Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3192 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaJVLbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 07:31:35 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9MBVWbt051121
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 13:31:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.200.78] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id CC2E62A0432
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 13:31:20 +0200 (CEST)
Message-ID: <54479593.9060803@xs4all.nl>
Date: Wed, 22 Oct 2014 13:31:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] davinci vpbe cleanups and improvements
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note: I skipped patch https://patchwork.linuxtv.org/patch/26430/ from Prabhakar's
patch series since that needs a bit more work, but all other patches from that
series are part of this pull request.

Over 300 lines deleted, always nice!

Regards,

	Hans

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

   Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v3.19a

for you to fetch changes up to fc1079f3dd25adfe5eaf8c7b0d097994f91f8601:

   media: davinci: vpbe: return -ENODATA for *dv_timings/*_std calls (2014-10-22 13:22:13 +0200)

----------------------------------------------------------------
Prabhakar Lad (14):
       media: davinci: vpbe: initialize vb2 queue and DMA context in probe
       media: davinci: vpbe: drop buf_init() callback
       media: davinci: vpbe: use vb2_ops_wait_prepare/finish helper functions
       media: davinci: vpbe: drop buf_cleanup() callback
       media: davinci: vpbe: improve vpbe_buffer_prepare() callback
       media: davinci: vpbe: use vb2_fop_mmap/poll
       media: davinci: vpbe: use fh handling provided by v4l
       media: davinci: vpbe: use vb2_ioctl_* helpers
       media: davinci: vpbe: add support for VB2_DMABUF
       media: davinci: vpbe: add support for VIDIOC_EXPBUF
       media: davinci: vpbe: use helpers provided by core if streaming is started
       media: davinci: vpbe: drop unused member memory from vpbe_layer
       media: davinci: vpbe: group v4l2_ioctl_ops
       media: davinci: vpbe: return -ENODATA for *dv_timings/*_std calls

  drivers/media/platform/davinci/vpbe.c         |  18 +-
  drivers/media/platform/davinci/vpbe_display.c | 606 +++++++++++++++------------------------------------------------
  include/media/davinci/vpbe_display.h          |  19 --
  3 files changed, 158 insertions(+), 485 deletions(-)
