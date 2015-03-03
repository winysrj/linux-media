Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34401 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbbCCKXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 05:23:45 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 67FAE2A008D
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2015 11:23:28 +0100 (CET)
Message-ID: <54F58BA0.4060100@xs4all.nl>
Date: Tue, 03 Mar 2015 11:23:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] Blackfin cleanups
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request improves the blackfin driver.

Regards,

	Hans

The following changes since commit b44b2e06ae463327334235bf160e804632b9b37c:

  [media] media: i2c: ADV7604: Rename adv7604 prefixes (2015-03-02 16:59:32 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1d

for you to fetch changes up to 7686f35fec9745fd9e4fe0c7bff6ba468e742047:

  media: blackfin: bfin_capture: set v4l2 buffer sequence (2015-03-03 11:07:26 +0100)

----------------------------------------------------------------
Lad, Prabhakar (15):
      media: blackfin: bfin_capture: drop buf_init() callback
      media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
      media: blackfin: bfin_capture: set min_buffers_needed
      media: blackfin: bfin_capture: improve buf_prepare() callback
      media: blackfin: bfin_capture: improve queue_setup() callback
      media: blackfin: bfin_capture: use vb2_fop_mmap/poll
      media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
      media: blackfin: bfin_capture: use vb2_ioctl_* helpers
      media: blackfin: bfin_capture: make sure all buffers are returned on stop_streaming() callback
      media: blackfin: bfin_capture: return -ENODATA for *std calls
      media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
      media: blackfin: bfin_capture: add support for vidioc_create_bufs
      media: blackfin: bfin_capture: add support for VB2_DMABUF
      media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
      media: blackfin: bfin_capture: set v4l2 buffer sequence

 drivers/media/platform/blackfin/bfin_capture.c | 306 ++++++++++++++++++++++++-----------------------------------------------------
 1 file changed, 94 insertions(+), 212 deletions(-)
