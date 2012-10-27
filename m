Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59697 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759324Ab2J0Rh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 13:37:56 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3C8E860099
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 20:37:54 +0300 (EEST)
Date: Sat, 27 Oct 2012 20:37:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] SMIA++ PLL and driver fixes and improvements
Message-ID: <20121027173751.GE24073@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset contains SMIA++ PLL support for parallel bus, more robust PLL
calculation and SMIA++ driver fixes and cleanups.

Please pull:

The following changes since commit 01aea0bfd8dfa8bc868df33904461984bb10a87a:

  [media] i2c: adv7183: use module_i2c_driver to simplify the code (2012-10-25 17:08:46 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-for-3.8

Laurent Pinchart (3):
      smiapp-pll: Add missing trailing newlines to warning messages
      smiapp-pll: Create a structure for OP and VT limits
      smiapp-pll: Constify limits argument to smiapp_pll_calculate()

Sakari Ailus (4):
      smiapp-pll: Correct type for min_t()
      smiapp-pll: Try other pre-pll divisors
      smiapp: Input for PLL configuration is mostly static
      smiapp-pll: Parallel bus support

 drivers/media/i2c/smiapp-pll.c         |  215 ++++++++++++++++++--------------
 drivers/media/i2c/smiapp-pll.h         |   59 +++++----
 drivers/media/i2c/smiapp/smiapp-core.c |   68 +++++------
 3 files changed, 186 insertions(+), 156 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
