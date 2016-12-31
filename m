Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61461 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754655AbcLaMyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 31 Dec 2016 07:54:17 -0500
Received: from axis700.grange ([81.173.165.59]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M0QLp-1cff0T3E2n-00ubfo for
 <linux-media@vger.kernel.org>; Sat, 31 Dec 2016 13:54:12 +0100
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id B64E48B110
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2016 13:54:10 +0100 (CET)
Date: Sat, 31 Dec 2016 13:54:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 2 patches
Message-ID: <Pine.LNX.4.64.1612311353080.20637@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.11-1

for you to fetch changes up to 1e86b6cf83dd97c61c7aa8a34cd9eaf23e01ac17:

  media: platform: soc_camera_platform : constify v4l2_subdev_* structures (2016-12-31 13:31:13 +0100)

----------------------------------------------------------------
Bhumika Goyal (1):
      media: platform: soc_camera_platform : constify v4l2_subdev_* structures

Christophe JAILLET (1):
      soc-camera: Fix a return value in case of error

 drivers/media/i2c/soc_camera/ov9640.c                   | 2 +-
 drivers/media/platform/soc_camera/soc_camera_platform.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

Thanks
Guennadi
