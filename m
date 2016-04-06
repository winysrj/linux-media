Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37144 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753711AbcDFVRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 17:17:21 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 8430E60096
	for <linux-media@vger.kernel.org>; Thu,  7 Apr 2016 00:17:17 +0300 (EEST)
Date: Thu, 7 Apr 2016 00:16:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.7] Fix videobuf2 plane validation
Message-ID: <20160406211646.GO32125@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains two patches to fix the videobuf2 plane validation
issue introduced in v4.4 kernel. I've added cc stable to both of the
patches.

Please prioritise. Thanks!


The following changes since commit d3f5193019443ef8e556b64f3cd359773c4d377b:

  Merge tag 'v4.6-rc1' into patchwork (2016-03-29 17:17:26 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git vb2-overwrite-fix-error

for you to fetch changes up to 05e337849107c2ae5484e2600acb0a86bcaf56fb:

  videobuf2-v4l2: Verify planes array in buffer dequeueing (2016-04-07 00:00:45 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      videobuf2-core: Check user space planes array in dqbuf
      videobuf2-v4l2: Verify planes array in buffer dequeueing

 drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
 drivers/media/v4l2-core/videobuf2-v4l2.c |  6 ++++++
 include/media/videobuf2-core.h           |  4 ++++
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
