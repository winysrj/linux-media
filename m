Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:59540 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726330AbeI2ESj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:18:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Bad MAINTAINERS pattern in section 'DONGWOON DW9807 LENS VOICE COIL DRIVER'
Date: Fri, 28 Sep 2018 14:52:54 -0700
Message-Id: <20180928215254.29290-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	4447	DONGWOON DW9807 LENS VOICE COIL DRIVER
	4448	M:	Sakari Ailus <sakari.ailus@linux.intel.com>
	4449	L:	linux-media@vger.kernel.org
	4450	T:	git git://linuxtv.org/media_tree.git
	4451	S:	Maintained
-->	4452	F:	drivers/media/i2c/dw9807.c
	4453	F:	Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807-vcm.txt

Commit that introduced this:

commit 5b0a205466578432ce8faadd08f8d7ef895a180f
 Author: Alan Chiang <alanx.chiang@intel.com>
 Date:   Tue Apr 24 22:12:08 2018 -0400
 
     media: dw9807: Add dw9807 vcm driver
     
     DW9807 is a 10 bit DAC from Dongwoon, designed for linear
     control of voice coil motor.
     
     This driver creates a V4L2 subdevice and
     provides control to set the desired focus.
     
     Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
     Signed-off-by: Andy Yeh <andy.yeh@intel.com>
     Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
     Reviewed-by: Tomasz Figa <tfiga@chromium.org>
     Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
     Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
 
  MAINTAINERS                |   7 +
  drivers/media/i2c/Kconfig  |  10 ++
  drivers/media/i2c/Makefile |   1 +
  drivers/media/i2c/dw9807.c | 329 +++++++++++++++++++++++++++++++++++++++++++++
  4 files changed, 347 insertions(+)

Last commit with drivers/media/i2c/dw9807.c

commit e6c17ada3188e0deb43652b0eed249f37e0d44b0
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Fri Jul 20 17:07:15 2018 -0400

    media: dw9807-vcm: Recognise this is just the VCM bit of the device
    
    The dw9807 contains a voice coil lens driver as well as an EEPROM. This
    driver is just for the VCM. Reflect this in the driver's name --- this is
    already the case for the compatible string, for instance.
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/i2c/Kconfig                    | 2 +-
 drivers/media/i2c/Makefile                   | 2 +-
 drivers/media/i2c/{dw9807.c => dw9807-vcm.c} | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
