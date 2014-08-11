Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41943 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753133AbaHKNbt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 09:31:49 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id AF8C660093
	for <linux-media@vger.kernel.org>; Mon, 11 Aug 2014 16:31:47 +0300 (EEST)
Date: Mon, 11 Aug 2014 16:31:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FIXES FOR 3.17] smiapp: Fix power down for multiple users
Message-ID: <20140811133145.GI16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The smiapp driver failed to properly count its users that needed to access
it, and it ended up powering off the sensor whenever a user went away,
leading to multiple power down sequences being executed if the device had
more than one user.

Please pull.

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

  [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-power

for you to fetch changes up to 97cb4201257c508f96b69bd7a386705e48e5c13d:

  smiapp: Fix power count handling (2014-08-11 16:09:40 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: Fix power count handling

 drivers/media/i2c/smiapp/smiapp-core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
