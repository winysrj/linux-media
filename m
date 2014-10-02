Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55526 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaJBVoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 17:44:54 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4DD8D60093
	for <linux-media@vger.kernel.org>; Fri,  3 Oct 2014 00:44:52 +0300 (EEST)
Date: Fri, 3 Oct 2014 00:44:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.18] smiapp, smiapp-pll improvements, fixes
Message-ID: <20141002214415.GU2939@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set contains a number of fixes to the smiapp driver and the smiapp-pll
pll calculator. Some of the issues had been there for longer while the
(harmless) lockdep warning got introduced by "smiapp: Use unlocked
__v4l2_ctrl_modify_range()".

The format and link frequency combinations are now validated during sensor
initialisation so it's impossible to select an invalid combination anymore.
The driver would simply have returned an error to the user who likely had
little idea of what was wrong.

Please pull.


The following changes since commit cf3167cf1e969b17671a4d3d956d22718a8ceb85:

  [media] pt3: fix DTV FE I2C driver load error paths (2014-09-28 22:23:42 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to 684ca184c145f20b42f84b1277df0cc955b32371:

  smiapp: Update PLL when setting format (2014-10-03 00:37:35 +0300)

----------------------------------------------------------------
Sakari Ailus (18):
      smiapp: Take mutex during PLL update in sensor initialisation
      smiapp-pll: Correct clock debug prints
      smiapp-pll: The clock tree values are unsigned --- fix debug prints
      smiapp-pll: Separate bounds checking into a separate function
      smiapp-pll: External clock frequency isn't an output value
      smiapp-pll: Unify OP and VT PLL structs
      smiapp-pll: Calculate OP clocks only for sensors that have them
      smiapp-pll: Don't validate OP clocks if there are none
      smiapp: The PLL calculator handles sensors with VT clocks only
      smiapp: Remove validation of op_pix_clk_div
      smiapp-pll: Add pixel rate in pixel array as output parameters
      smiapp: Use actual pixel rate calculated by the PLL calculator
      smiapp: Split calculating PLL with sensor's limits from updating it
      smiapp: Gather information on valid link rate and BPP combinations
      smiapp: Take valid link frequencies into account in supported mbus codes
      smiapp: Clean up smiapp_set_format()
      smiapp: Set valid link frequency range
      smiapp: Update PLL when setting format

 drivers/media/i2c/smiapp-pll.c         |  280 ++++++++++++++++++--------------
 drivers/media/i2c/smiapp-pll.h         |   21 +--
 drivers/media/i2c/smiapp/smiapp-core.c |  220 ++++++++++++++++---------
 drivers/media/i2c/smiapp/smiapp.h      |    8 +
 4 files changed, 321 insertions(+), 208 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
