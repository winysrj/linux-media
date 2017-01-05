Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52820 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S970377AbdAEJjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jan 2017 04:39:20 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id EF52E60096
        for <linux-media@vger.kernel.org>; Thu,  5 Jan 2017 11:39:12 +0200 (EET)
Date: Thu, 5 Jan 2017 11:39:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES FOR v4.10] Media entity enumeration entity type fix
Message-ID: <20170105093912.GS3958@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The big Media controller changes seem to have broken media entity type
reporting in MEDIA_IOC_ENUM_ENTITIES IOCTL for non-device node types. No-one
seems to have noticed until now.

Stable is cc'd (for v4.5 and up).

Please pull.


The following changes since commit 0e0694ff1a7791274946b7f51bae692da0001a08:

  Merge branch 'patchwork' into v4l_for_linus (2016-12-26 14:09:28 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git media-enum-fix

for you to fetch changes up to 81154b500c6b82083aa3428f94698254d5126d84:

  media: Properly pass through media entity types in entity enumeration (2017-01-05 11:33:39 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      media: Properly pass through media entity types in entity enumeration

 drivers/media/media-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
