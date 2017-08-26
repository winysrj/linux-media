Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32880 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdHZLNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 07:13:45 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, anton@corp.bluecherry.net,
        andrey.utkin@corp.bluecherry.net, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/5] [media] PCI: make video_device const
Date: Sat, 26 Aug 2017 16:43:29 +0530
Message-Id: <1503746014-16489-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make video_device const.

Bhumika Goyal (5):
  [media] meye:  make video_device const
  [media] saa7134: make video_device const
  [media] solo6x10:  make video_device const
  [media] sta2x11: make video_device const
  [media] tw68:  make video_device const

 drivers/media/pci/meye/meye.c               | 2 +-
 drivers/media/pci/saa7134/saa7134-empress.c | 2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c  | 2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c     | 2 +-
 drivers/media/pci/tw68/tw68-video.c         | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.9.1
