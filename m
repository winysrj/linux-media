Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40560 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753696AbeARWTd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 17:19:33 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 413C560100
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 00:19:31 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ecIWw-0006uk-Oe
        for linux-media@vger.kernel.org; Fri, 19 Jan 2018 00:19:30 +0200
Date: Fri, 19 Jan 2018 00:19:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] ov7740 fix, imx258 driver
Message-ID: <20180118221930.p364xyxrlc7ta24p@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a compile fix for the ov7740 driver and a driver for Sony imx258
sensors.

Please pull.


The following changes since commit e3ee691dbf24096ea51b3200946b11d68ce75361:

  media: ov5640: add support of RGB565 and YUYV formats (2018-01-05 12:54:14 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.16-4

for you to fetch changes up to 80e757d1ad2fe3596c43bbd7cfc7cca9780922f2:

  media: imx258: Add imx258 camera sensor driver (2018-01-19 00:15:37 +0200)

----------------------------------------------------------------
Andy Yeh (1):
      media: imx258: Add imx258 camera sensor driver

Arnd Bergmann (1):
      media: i2c: ov7740: use gpio/consumer.h instead of gpio.h

 MAINTAINERS                |    7 +
 drivers/media/i2c/Kconfig  |   11 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/imx258.c | 1148 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ov7740.c |    2 +-
 5 files changed, 1168 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/i2c/imx258.c

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
