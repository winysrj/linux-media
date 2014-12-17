Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57502 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750799AbaLQJhY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 04:37:24 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4E83A60093
	for <linux-media@vger.kernel.org>; Wed, 17 Dec 2014 11:37:22 +0200 (EET)
Date: Wed, 17 Dec 2014 11:37:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] Smiapp driver improvements and cleanups
Message-ID: <20141217093721.GG17565@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains smiapp driver cleanups and improvements in form
of more generic quirk functionality and corrected error handling. It depends
on my earlier pull request "[GIT PULL FOR v3.20] Smiapp OF support".

Please pull.

The following changes since commit 7f6de94da4bd82c80b7346a0e651fb99f3269361:

  smiapp: Fully probe the device in probe (2014-12-17 11:28:52 +0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-next

for you to fetch changes up to 0769c7611e6920bb8a45277148bf0edc3b31e21e:

  smiapp: Add parentheses to macro arguments used in macros (2014-12-17 11:34:07 +0200)

----------------------------------------------------------------
Sakari Ailus (7):
      smiapp: Access flash capabilities through limits
      smiapp: Free control handlers in sub-device cleanup
      smiapp: Clean up smiapp_init_controls()
      smiapp: Separate late controls from the rest
      smiapp: Move enumerating available media bus codes later
      smiapp: Replace pll_flags quirk with more generic init quirk
      smiapp: Add parentheses to macro arguments used in macros

 drivers/media/i2c/smiapp/smiapp-core.c  |  103 ++++++++++++++++---------------
 drivers/media/i2c/smiapp/smiapp-quirk.c |    8 ++-
 drivers/media/i2c/smiapp/smiapp-quirk.h |   18 +++---
 drivers/media/i2c/smiapp/smiapp.h       |    1 -
 4 files changed, 69 insertions(+), 61 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
