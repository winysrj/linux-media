Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35853 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbdHPJRR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 05:17:17 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        maintainers@bluecherrydvr.com, andrey.utkin@corp.bluecherry.net,
        ismael@iodev.co.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/2] [media]: make snd_kcontrol_new const 
Date: Wed, 16 Aug 2017 14:47:03 +0530
Message-Id: <1502875025-3224-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const. Done using Coccinelle.

Bhumika Goyal (2):
  [media] cx88: make snd_kcontrol_new const
  [media] solo6x10: make snd_kcontrol_new const

 drivers/media/pci/cx88/cx88-alsa.c         | 2 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.1
