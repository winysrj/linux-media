Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36962 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993AbaDWMGB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 08:06:01 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id DBBC360093
	for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 15:05:57 +0300 (EEST)
Date: Wed, 23 Apr 2014 15:05:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.16] smiapp: small fixes and cleanups
Message-ID: <20140423120556.GI8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset contains small cleanups and fixes to the smiapp driver from
the patchset "smiapp and smiapp-pll quirk improvements, fixes". I'm sending
just the driver patches now; the PLL patches are still pending. The PLL
patches are dependent on the patches in this pull request.

The following changes since commit 701b57ee3387b8e3749845b02310b5625fbd8da0:

  [media] vb2: Add videobuf2-dvb support (2014-04-16 18:59:29 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to 1e350219b4c70ce7bfa0a8b26c58db38357168ac:

  smiapp: Use %u for printing u32 value (2014-04-22 20:42:16 +0300)

----------------------------------------------------------------
Sakari Ailus (11):
      smiapp: Remove unused quirk register functionality
      smiapp: Rename SMIA_REG to SMIAPP_REG for consistency
      smiapp: Fix determining the need for 8-bit read access
      smiapp: Add a macro for constructing 8-bit quirk registers
      smiapp: Use I2C adapter ID and address in the sub-device name
      smiapp: Make PLL flags separate from regular quirk flags
      smiapp: Make PLL flags unsigned long
      smiapp: Make PLL (quirk) flags a function
      smiapp: Add register diversion quirk
      smiapp: Define macros for obtaining properties of register definitions
      smiapp: Use %u for printing u32 value

 drivers/media/i2c/smiapp-pll.h             |    2 +-
 drivers/media/i2c/smiapp/smiapp-core.c     |   12 ++--
 drivers/media/i2c/smiapp/smiapp-quirk.c    |   55 +++--------------
 drivers/media/i2c/smiapp/smiapp-quirk.h    |   24 +++++---
 drivers/media/i2c/smiapp/smiapp-reg-defs.h |    8 +--
 drivers/media/i2c/smiapp/smiapp-regs.c     |   89 +++++++++++++++++++---------
 drivers/media/i2c/smiapp/smiapp-regs.h     |   19 +++---
 7 files changed, 105 insertions(+), 104 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
