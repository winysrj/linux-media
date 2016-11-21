Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51320 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754540AbcKUPef (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 10:34:35 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] Various fixes
Message-ID: <83950906-b856-ac19-1856-7edb2c10df03@xs4all.nl>
Date: Mon, 21 Nov 2016 16:34:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f2709c206d8a3e11729e68d80c57e7470bbe8e5e:

   Revert "[media] dvb_frontend: merge duplicate dvb_tuner_ops.release 
implementations" (2016-11-18 20:44:33 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.10d

for you to fetch changes up to a02c4d75a8a04d32c6a7aca34261442944c7db3d:

   cec: ignore messages that we initiated. (2016-11-21 16:15:45 +0100)

----------------------------------------------------------------
Colin Ian King (1):
       zoran: fix spelling mistake in dprintk message

Hans Verkuil (2):
       vivid: fix HDMI VSDB block in the EDID
       cec: ignore messages that we initiated.

Minghsiu Tsai (1):
       mtk-mdp: allocate video_device dynamically

Wei Yongjun (1):
       atmel-isc: fix error return code in atmel_isc_probe()

  drivers/media/cec/cec-adap.c                  | 15 +++++++++++++++
  drivers/media/pci/zoran/zoran_driver.c        |  2 +-
  drivers/media/platform/atmel/atmel-isc.c      |  1 +
  drivers/media/platform/mtk-mdp/mtk_mdp_core.h |  2 +-
  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 33 
++++++++++++++++++++-------------
  drivers/media/platform/vivid/vivid-core.c     |  4 ++--
  6 files changed, 40 insertions(+), 17 deletions(-)
