Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50509 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752291AbbDRMA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2015 08:00:56 -0400
Date: Sat, 18 Apr 2015 15:00:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz, sre@kernel.org
Subject: [GIT PULL FOR v4.2] adp1653 DT support
Message-ID: <20150418120016.GL27451@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These two patches document and add support for the adp1653 LED flash driver.

Please pull.


The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git adp1653

for you to fetch changes up to 917f9a6c303482f2e2f006b5154dba71fee89e55:

  media: i2c/adp1653: Devicetree support for adp1653 (2015-04-14 01:51:12 +0300)

----------------------------------------------------------------
Pavel Machek (2):
      media: i2c/adp1653: Documentation for devicetree support for adp1653
      media: i2c/adp1653: Devicetree support for adp1653

 .../devicetree/bindings/media/i2c/adp1653.txt      |   37 ++++++++
 drivers/media/i2c/adp1653.c                        |  100 ++++++++++++++++++--
 include/media/adp1653.h                            |    8 +-
 3 files changed, 132 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adp1653.txt

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
