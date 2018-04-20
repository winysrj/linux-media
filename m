Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14219 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeDTSsf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 14:48:35 -0400
From: Vladislav Zhurba <vzhurba@nvidia.com>
To: <linux-kernel@vger.kernel.org>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        Vladislav Zhurba <vzhurba@nvidia.com>
Subject: [PATCH 0/1] Add two IR keymaps for NVIDIA devices
Date: Fri, 20 Apr 2018 11:47:46 -0700
Message-ID: <20180420184747.29022-1-vzhurba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds two IR keymaps for NVIDIA devices.
The RC types are SONY12 and NEC.

Jun Yan (1):
  media: rc: Add NVIDIA IR keymapping

 drivers/media/rc/keymaps/Makefile        |  2 +
 drivers/media/rc/keymaps/rc-nvidia-nec.c | 66 ++++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-nvidia.c     | 66 ++++++++++++++++++++++++
 include/media/rc-map.h                   |  2 +
 4 files changed, 136 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-nvidia-nec.c
 create mode 100644 drivers/media/rc/keymaps/rc-nvidia.c

-- 
2.17.0
