Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41408 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750738AbaHAOE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 10:04:29 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 15CD160093
	for <linux-media@vger.kernel.org>; Fri,  1 Aug 2014 17:04:27 +0300 (EEST)
Date: Fri, 1 Aug 2014 17:04:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 3.17] smiapp: Set sub-device owner
Message-ID: <20140801140424.GY16460@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch got accidentally dropped from my patchset which contained another
patch it required:

commit b2a06aecb24329e16edc3108b8192d65ace8da75
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Thu Dec 12 09:36:46 2013 -0300

    [media] v4l: Only get module if it's different than the driver for v4l2_dev
    
    When the sub-device is registered, increment the use count of the sub-device
    owner only if it's different from the owner of the driver for the media
    device. This avoids increasing the use count by the module itself and thus
    making it possible to unload it when it's not in use.
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
    Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Thanks to Laurent for spotting this. Please pull.


The following changes since commit 27dcb00d0dc1d532b0da940e35a6d020ee33bd47:

  [media] radio-miropcm20: fix sparse NULL pointer warning (2014-07-30 19:50:09 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-subdev-owner

for you to fetch changes up to 7ac057ec6296b80529075c47fa5eb304e96344df:

  smiapp: Set sub-device owner (2014-08-01 16:47:15 +0300)

----------------------------------------------------------------
Sakari Ailus (1):
      smiapp: Set sub-device owner

 drivers/media/i2c/smiapp/smiapp-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
