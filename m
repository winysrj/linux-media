Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:53958 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730314AbeG0OPj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 10:15:39 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] rcar fix
Message-ID: <b8daca08-62fd-d507-1141-2979203cb032@xs4all.nl>
Date: Fri, 27 Jul 2018 14:53:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 5bfffa0c86915e5afbfe56d9790457b2a9887f2d:

  media: pci: ivtv: Replace GFP_ATOMIC with GFP_KERNEL (2018-07-27 08:15:55 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19o

for you to fetch changes up to 2d0c53910d63f27f489e96324a2164bb3dfc2c90:

  rcar-csi2: update stream start for V3M (2018-07-27 14:52:47 +0200)

----------------------------------------------------------------
Niklas Söderlund (1):
      rcar-csi2: update stream start for V3M

 drivers/media/platform/rcar-vin/rcar-csi2.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)
