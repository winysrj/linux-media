Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51010 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753456AbcIEHin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 03:38:43 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 162526009C
        for <linux-media@vger.kernel.org>; Mon,  5 Sep 2016 10:38:39 +0300 (EEST)
Date: Mon, 5 Sep 2016 10:38:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] Media IOCTL handling rework
Message-ID: <20160905073838.GA12130@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These four patches rework Media controller IOCTL handling for cleanups and
preparation for variable sized IOCTL arguments.

I've postponed the last patch of the reviewed set until the patch will
actually be needed. It's available here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=media-ioctl-varargsize>


Please pull.


The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

  [media] dvb_frontend: Use memdup_user() rather than duplicating its implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git media-ioctl-rework

for you to fetch changes up to 0412ff9e1e3ca06328e62366ac11c987a6869b46:

  media: Add flags to tell whether to take graph mutex for an IOCTL (2016-09-05 10:03:55 +0300)

----------------------------------------------------------------
Sakari Ailus (4):
      media: Determine early whether an IOCTL is supported
      media: Unify IOCTL handler calling
      media: Refactor copying IOCTL arguments from and to user space
      media: Add flags to tell whether to take graph mutex for an IOCTL

 drivers/media/media-device.c | 295 ++++++++++++++++++++++---------------------
 1 file changed, 154 insertions(+), 141 deletions(-)


-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
