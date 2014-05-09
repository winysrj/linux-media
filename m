Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50249 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751306AbaEINvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 May 2014 09:51:35 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CD16D60098
	for <linux-media@vger.kernel.org>; Fri,  9 May 2014 16:51:32 +0300 (EEST)
Date: Fri, 9 May 2014 16:51:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.16] smiapp: Scaling configuration fix, rename
 regulator; fixes
Message-ID: <20140509135101.GL8753@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset contains a few miscellaneous fixes but more importantly, a fix
for calculating the best scaling and binning ratios. The regulator is also
renamed as lower case.

The following changes since commit 393cbd8dc532c1ebed60719da8d379f50d445f28:

  [media] smiapp: Use %u for printing u32 value (2014-04-23 16:05:06 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to 183f76494e92a585d9c71f130759553d57bab5f9:

  smiapp: Return correct return value in smiapp_registered() (2014-05-09 15:44:11 +0300)

----------------------------------------------------------------
Sakari Ailus (6):
      smiapp: Print the index of the format descriptor
      smiapp: Call limits quirk immediately after retrieving the limits
      smiapp: Scaling goodness is signed
      smiapp: Use better regulator name for the Device tree
      smiapp: Check for GPIO validity using gpio_is_valid()
      smiapp: Return correct return value in smiapp_registered()

 drivers/media/i2c/smiapp/smiapp-core.c |   45 ++++++++++++++++----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
