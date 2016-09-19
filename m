Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44192 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751414AbcISGxW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 02:53:22 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9EDF760093
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2016 09:53:16 +0300 (EEST)
Date: Mon, 19 Sep 2016 09:53:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 FOR v4.10] Media IOCTL handling rework
Message-ID: <20160919065315.GI5086@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These four patches rework Media controller IOCTL handling for cleanups and      
preparation for variable sized IOCTL arguments.                                 
                                                                                
What's changed since the previous set is that the compat handling is kept
as-is, i.e. it simply calls the regular handler if the IOCTL is something
else than MEDIA_IOC_ENUM_LINKS32.

Please pull.


The following changes since commit c3b809834db8b1a8891c7ff873a216eac119628d:

  [media] pulse8-cec: fix compiler warning (2016-09-12 06:42:44 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git media-ioctl-rework

for you to fetch changes up to 267abb2f81a2457d0552eb1b3d988407f3f5eabc:

  media: Add flags to tell whether to take graph mutex for an IOCTL (2016-09-16 12:36:08 +0300)

----------------------------------------------------------------
Sakari Ailus (4):
      media: Determine early whether an IOCTL is supported
      media: Unify IOCTL handler calling
      media: Refactor copying IOCTL arguments from and to user space
      media: Add flags to tell whether to take graph mutex for an IOCTL

 drivers/media/media-device.c | 224 +++++++++++++++++++++----------------------
 1 file changed, 111 insertions(+), 113 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
