Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47550 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520AbbGQMon (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 08:44:43 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 8E4382A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 14:43:40 +0200 (CEST)
Message-ID: <55A8F87C.3060805@xs4all.nl>
Date: Fri, 17 Jul 2015 14:43:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Various fixes/enhancements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3b

for you to fetch changes up to fdc2ba95f935e6bae2da955b10cf7afb3ad191ae:

  cobalt: allow fewer than 8 PCIe lanes (2015-07-17 14:27:39 +0200)

----------------------------------------------------------------
Benoit Parrot (1):
      media: am437x-vpfe: Fix a race condition during release

Hans Verkuil (2):
      cobalt: accept unchanged timings when vb2_is_busy().
      cobalt: allow fewer than 8 PCIe lanes

Philipp Zabel (3):
      v4l2-dev: use event class to deduplicate v4l2 trace events
      v4l2-mem2mem: set the queue owner field just as vb2_ioctl_reqbufs does
      videobuf2: add trace events

 drivers/media/pci/cobalt/cobalt-driver.c    |  11 ++--
 drivers/media/pci/cobalt/cobalt-v4l2.c      |  11 +++-
 drivers/media/platform/am437x/am437x-vpfe.c |  14 ++++-
 drivers/media/v4l2-core/v4l2-mem2mem.c      |   9 ++-
 drivers/media/v4l2-core/videobuf2-core.c    |  11 ++++
 include/trace/events/v4l2.h                 | 257 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------
 6 files changed, 220 insertions(+), 93 deletions(-)
