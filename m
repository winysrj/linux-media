Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751547AbbGIOv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 10:51:57 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 6B7F560096
	for <linux-media@vger.kernel.org>; Thu,  9 Jul 2015 17:51:55 +0300 (EEST)
Date: Thu, 9 Jul 2015 17:51:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.2] Videobuf 2 QUEUED behaviour revert, new state
 for requeuing
Message-ID: <20150709145155.GK3709@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the videobuf2 fix for reverting the VB2_BUF_STATE_QUEUED behaviour in
vb2_buffer_done() to what it was before v4.1. VB2_BUF_STATE_REQUEUEING can
be used as an argument to vb2_buffer_done() for returning the buffer back to
the driver if needed (as in cobalt driver).

Please pull.


The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git vb2-fix

for you to fetch changes up to aae5225b63d0eee9e725a032c3f3f1811f5119a5:

  vb2: Only requeue buffers immediately once streaming is started (2015-07-09 17:46:27 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      vb2: Only requeue buffers immediately once streaming is started

 drivers/media/pci/cobalt/cobalt-irq.c    |  2 +-
 drivers/media/v4l2-core/videobuf2-core.c | 25 +++++++++++++++++--------
 include/media/videobuf2-core.h           |  2 ++
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
