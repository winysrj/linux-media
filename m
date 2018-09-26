Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50926 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbeIZT6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 15:58:41 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [GIT PULL FOR linux-media] adv748x/for-next
Date: Wed, 26 Sep 2018 14:45:33 +0100
Message-Id: <20180926134533.28420-1-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Mauro,

Please consider including these updates for linux-media

--
Regards

Kieran

The following changes since commit 4158757395b300b6eb308fc20b96d1d231484413:

  media: davinci: Fix implicit enum conversion warning (2018-09-24 09:43:13 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git adv748x/for-next

for you to fetch changes up to b3abd58a66523a5e5b6644ff481fdf74f942e083:

  media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down (2018-09-26 14:14:33 +0100)

----------------------------------------------------------------
Jacopo Mondi (4):
      media: i2c: adv748x: Support probing a single output
      media: i2c: adv748x: Handle TX[A|B] power management
      media: i2c: adv748x: Conditionally enable only CSI-2 outputs
      media: i2c: adv748x: Register only enabled inputs

Niklas Söderlund (1):
      media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down

 drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c | 85 +++++++++++++++++---------------
 drivers/media/i2c/adv748x/adv748x-csi2.c | 29 ++++-------
 drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
 drivers/media/i2c/adv748x/adv748x.h      | 19 +++++--
 5 files changed, 69 insertions(+), 68 deletions(-)
