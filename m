Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36083 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756995Ab2KHVCK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:10 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E580760099
	for <linux-media@vger.kernel.org>; Thu,  8 Nov 2012 23:02:07 +0200 (EET)
Date: Thu, 8 Nov 2012 23:02:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] SMIA++, adp1653 driver and V4L2 events/fh
Message-ID: <20121108210205.GG25623@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just contact info change. My @maxwell.research.nokia.com no longer works.

Please pull:

The following changes since commit 2cb654fd281e1929aa3b9f5f54f492135157a613:

  MAINTAINERS: add support for tea5761/tea5767 tuners (2012-11-02 12:09:00 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-for-3.8

Sakari Ailus (1):
      v4l, smiapp, smiapp-pll, adp1653: Update contact information

 drivers/media/i2c/adp1653.c                |    4 ++--
 drivers/media/i2c/smiapp-pll.c             |    4 ++--
 drivers/media/i2c/smiapp-pll.h             |    2 +-
 drivers/media/i2c/smiapp/smiapp-core.c     |    6 +++---
 drivers/media/i2c/smiapp/smiapp-limits.c   |    2 +-
 drivers/media/i2c/smiapp/smiapp-limits.h   |    2 +-
 drivers/media/i2c/smiapp/smiapp-quirk.c    |    2 +-
 drivers/media/i2c/smiapp/smiapp-quirk.h    |    2 +-
 drivers/media/i2c/smiapp/smiapp-reg-defs.h |    2 +-
 drivers/media/i2c/smiapp/smiapp-reg.h      |    2 +-
 drivers/media/i2c/smiapp/smiapp-regs.c     |    2 +-
 drivers/media/i2c/smiapp/smiapp-regs.h     |    2 +-
 drivers/media/i2c/smiapp/smiapp.h          |    2 +-
 drivers/media/v4l2-core/v4l2-event.c       |    2 +-
 drivers/media/v4l2-core/v4l2-fh.c          |    2 +-
 include/media/adp1653.h                    |    4 ++--
 include/media/smiapp.h                     |    2 +-
 include/media/v4l2-event.h                 |    2 +-
 include/media/v4l2-fh.h                    |    2 +-
 19 files changed, 24 insertions(+), 24 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
