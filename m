Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60414 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751375AbdCIKXE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Mar 2017 05:23:04 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 4FC616009C
        for <linux-media@vger.kernel.org>; Thu,  9 Mar 2017 11:28:55 +0200 (EET)
Date: Thu, 9 Mar 2017 11:28:23 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] Make v4l2_device_register_subdev_nodes() safer
Message-ID: <20170309092823.GM3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just one patch from Sebastian this time --- calling
v4l2_device_register_subdev_nodes() multiple times lead to memory leaks and
memory corruption. Make it safer.

Please pull.


The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-reg-nodes-safe

for you to fetch changes up to 9d6a5c2391433d866bb277787126c1f673177965:

  v4l: Allow calling v4l2_device_register_subdev_nodes() multiple times (2017-03-09 10:03:25 +0200)

----------------------------------------------------------------
Sebastian Reichel (1):
      v4l: Allow calling v4l2_device_register_subdev_nodes() multiple times

 drivers/media/v4l2-core/v4l2-device.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
