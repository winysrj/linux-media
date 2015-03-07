Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33512 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750838AbbCGWHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 17:07:07 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id D954060093
	for <linux-media@vger.kernel.org>; Sun,  8 Mar 2015 00:07:04 +0200 (EET)
Date: Sun, 8 Mar 2015 00:06:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.1] smiapp DT u64 property workaround removal
Message-ID: <20150307220634.GD6539@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request reverts the smiapp driver's u64 array DT property read
workaround, and uses of_property_read_u64_array() (second patch) which is
the correct API function for reading u64 arrays from DT.

Please pull.


The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-dt

for you to fetch changes up to 5f36db86e0cbb48c102fee8a3fe2b98a33f13199:

  smiapp: Use of_property_read_u64_array() to read a 64-bit number array (2015-03-08 00:00:20 +0200)

----------------------------------------------------------------
Sakari Ailus (2):
      Revert "[media] smiapp: Don't compile of_read_number() if CONFIG_OF isn't defined"
      smiapp: Use of_property_read_u64_array() to read a 64-bit number array

 drivers/media/i2c/smiapp/smiapp-core.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
