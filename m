Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3818 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaEWJHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 05:07:53 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s4N97nHc061064
	for <linux-media@vger.kernel.org>; Fri, 23 May 2014 11:07:51 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 9B4E22A19A6
	for <linux-media@vger.kernel.org>; Fri, 23 May 2014 11:07:25 +0200 (CEST)
Message-ID: <537F0FCD.207@xs4all.nl>
Date: Fri, 23 May 2014 11:07:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] davinci updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are cleanup patches for the davinci drivers. A total of about 1200 lines
of code are removed. Not bad!

Regards,

	Hans


The following changes since commit e899966f626f1f657a4a7bac736c0b9ae5a243ea:

  Merge tag 'v3.15-rc6' into patchwork (2014-05-21 23:03:15 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git davinci

for you to fetch changes up to c1022cd59bb34dbb435cda9a2fc98bb6fb931f61:

  media: davinci: vpif: add Copyright message (2014-05-23 10:12:34 +0200)

----------------------------------------------------------------
Lad, Prabhakar (49):
      media: davinci: vpif_display: initialize vb2 queue and DMA context during probe
      media: davinci: vpif_display: drop buf_init() callback
      media: davinci: vpif_display: use vb2_ops_wait_prepare/finish helper functions
      media: davinci: vpif_display: release buffers in case start_streaming() call back fails
      media: davinci: vpif_display: drop buf_cleanup() callback
      media: davinci: vpif_display: improve vpif_buffer_prepare() callback
      media: davinci: vpif_display: improve vpif_buffer_queue_setup() function
      media: davinci: vpif_display: improve start/stop_streaming callbacks
      media: davinci: vpif_display: use vb2_fop_mmap/poll
      media: davinci: vpif_display: use v4l2_fh_open and vb2_fop_release
      media: davinci: vpif_display: use vb2_ioctl_* helpers
      media: davinci: vpif_display: drop unused member fbuffers
      media: davinci: vpif_display: drop reserving memory for device
      media: davinci: vpif_display: drop unnecessary field memory
      media: davinci: vpif_display: drop numbuffers field from common_obj
      media: davinic: vpif_display: drop started member from struct common_obj
      media: davinci: vpif_display: initialize the video device in single place
      media: davinci: vpif_display: drop unneeded module params
      media: davinci: vpif_display: drop cropcap
      media: davinci: vpif_display: group v4l2_ioctl_ops
      media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
      media: davinci: vpif_display: return -ENODATA for *dv_timings calls
      media: davinci: vpif_display: return -ENODATA for *std calls
      media: davinci; vpif_display: fix checkpatch error
      media: davinci: vpif_display: fix v4l-complinace issues
      media: davinci: vpif_capture: initalize vb2 queue and DMA context during probe
      media: davinci: vpif_capture: drop buf_init() callback
      media: davinci: vpif_capture: use vb2_ops_wait_prepare/finish helper functions
      media: davinci: vpif_capture: release buffers in case start_streaming() call back fails
      media: davinci: vpif_capture: drop buf_cleanup() callback
      media: davinci: vpif_capture: improve vpif_buffer_prepare() callback
      media: davinci: vpif_capture: improve vpif_buffer_queue_setup() function
      media: davinci: vpif_capture: improve start/stop_streaming callbacks
      media: davinci: vpif_capture: use vb2_fop_mmap/poll
      media: davinci: vpif_capture: use v4l2_fh_open and vb2_fop_release
      media: davinci: vpif_capture: use vb2_ioctl_* helpers
      media: davinci: vpif_capture: drop reserving memory for device
      media: davinci: vpif_capture: drop unnecessary field memory
      media: davinic: vpif_capture: drop started member from struct common_obj
      media: davinci: vpif_capture: initialize the video device in single place
      media: davinci: vpif_capture: drop unneeded module params
      media: davinci: vpif_capture: drop cropcap
      media: davinci: vpif_capture: group v4l2_ioctl_ops
      media: davinci: vpif_capture: use SIMPLE_DEV_PM_OPS
      media: davinci: vpif_capture: return -ENODATA for *dv_timings calls
      media: davinci: vpif_capture: return -ENODATA for *std calls
      media: davinci: vpif_capture: drop check __KERNEL__
      media: davinci: vpif_capture: fix v4l-complinace issues
      media: davinci: vpif: add Copyright message

 drivers/media/platform/davinci/vpif_capture.c | 1420 +++++++++++++++++++++--------------------------------------------------------
 drivers/media/platform/davinci/vpif_capture.h |   39 ---
 drivers/media/platform/davinci/vpif_display.c | 1196 +++++++++++++++++++----------------------------------------------
 drivers/media/platform/davinci/vpif_display.h |   44 +--
 4 files changed, 746 insertions(+), 1953 deletions(-)
