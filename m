Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58576 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933878AbcIFMzP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:55:15 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id A219A600A4
        for <linux-media@vger.kernel.org>; Tue,  6 Sep 2016 15:55:10 +0300 (EEST)
Date: Tue, 6 Sep 2016 15:55:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] ad5820 driver cleanup
Message-ID: <20160906125510.GC3236@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch fixes the int bitfield issue you found in the ad5820 driver.

Please pull.


The following changes since commit e62c30e76829d46bf11d170fd81b735f13a014ac:

  [media] smiapp: Remove set_xclk() callback from hwconfig (2016-09-05 15:53:20 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ad5820

for you to fetch changes up to 021a6d55696421194b72fbc3c6abc50b7f3f1dc4:

  ad5820: Use bool for boolean values (2016-09-06 15:23:46 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      ad5820: Use bool for boolean values

 drivers/media/i2c/ad5820.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
