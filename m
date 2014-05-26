Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35014 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751705AbaEZMZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 08:25:38 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0C37D60093
	for <linux-media@vger.kernel.org>; Mon, 26 May 2014 15:25:35 +0300 (EEST)
Date: Mon, 26 May 2014 15:25:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.16] smiapp: Sub-device rename fix
Message-ID: <20140526122503.GB25908@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There was an issue with an earlier patch which renamed the sub-devices (by
adding the i2c address to them) after the sensor name, not at the end of the
sub-device name as it should have been. No other patches this time.

This should definitely go to 3.16 since otherwise there will be two renames
rather than just a single one.

The following changes since commit f7a27ff1fb77e114d1059a5eb2ed1cffdc508ce8:

  [media] xc5000: delay tuner sleep to 5 seconds (2014-05-25 17:50:16 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to 612705cd90171a775ba7e5c8e21ac6d156d37ec3:

  smiapp: I2C address is the last part of the subdev name (2014-05-26 11:49:21 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: I2C address is the last part of the subdev name

 drivers/media/i2c/smiapp/smiapp-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
