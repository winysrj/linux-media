Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45797 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619Ab2ITUfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 16:35:21 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id EE4A660099
	for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 23:35:18 +0300 (EEST)
Date: Thu, 20 Sep 2012 23:35:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.7] SMIA++ fixes and improvements
Message-ID: <20120920203516.GB12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch contains three fixes for the SMIA++ driver and one patch that
provides additional module identification information through sysfs --- the
non-volatile memory contents are already provided through sysfs.

The following changes since commit 780d61704cf62a51c06c0ca8210d0282591e00b2:

  [media] gspca_pac7302: extend register documentation (2012-09-13 17:54:49 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-for-3.7

Sachin Kamat (2):
      smiapp: Use devm_* functions in smiapp-core.c file
      smiapp: Remove unused function

Sakari Ailus (2):
      smiapp: Use highest bits-per-pixel for sensor internal format
      smiapp: Provide module identification information through sysfs

 drivers/media/i2c/smiapp/smiapp-core.c  |   81 ++++++++++++++++---------------
 drivers/media/i2c/smiapp/smiapp-quirk.c |   20 --------
 2 files changed, 42 insertions(+), 59 deletions(-)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
