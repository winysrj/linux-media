Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33582 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161375AbcFMWys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 18:54:48 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9FF8960096
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 01:54:44 +0300 (EEST)
Date: Tue, 14 Jun 2016 01:54:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.7] Fix videobuf2 plane validation
Message-ID: <20160613225413.GE26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a new pull request for the same, this time as fixes for v4.7. There
are no changes except rebase to the previous version (which already included
fixes) and updated commit message.

Please pull (after testing it works for you!).


The following changes since commit 6519c3d7b8621c9f4333c98ed4b703029b51ba79:

  [media] adv7604: Don't ignore pad number in subdev DV timings pad operations (2016-06-07 15:33:54 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git vb2-overwrite-fix-error-on-fixes-v2

for you to fetch changes up to ba7962e9fb2ecc88da27be29998701a5467d4d0a:

  videobuf2-v4l2: Verify planes array in buffer dequeueing (2016-06-14 01:18:41 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      vb2: core: Skip planes array verification if pb is NULL
      videobuf2-v4l2: Verify planes array in buffer dequeueing

 drivers/media/v4l2-core/videobuf2-core.c | 10 ++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c |  6 ++++++
 2 files changed, 12 insertions(+), 4 deletions(-)


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
