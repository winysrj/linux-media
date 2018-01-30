Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.150.114]:42307 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752035AbeA3Axp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 19:53:45 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 22FDC1E0CA3
        for <linux-media@vger.kernel.org>; Mon, 29 Jan 2018 18:30:07 -0600 (CST)
Date: Mon, 29 Jan 2018 18:30:03 -0600
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        lnux-arm-kernel@lists.infradead.org, inux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Antti Palosaari <crope@iki.fi>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 0/8] fix potential integer overflows
Message-ID: <cover.1517268667.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset aims to fix potential integer overflows reported
by Coverity.

In all cases the potential overflowing expressions are evaluated
using 32-bit arithmetic before being used in contexts that expect
a 64-bit arithmetic. So a cast to the proper type was added to each
of those expressions in order to avoid any potential integer overflow.

This also gives the compiler complete information about the proper
arithmetic for each expression and improves code quality.

Addresses the following Coverity IDs reported as
"Unintentional integer overflow" issues:

200604, 1056807, 1056808, 1271223,
1324146, 1392628, 1392630, 1446589,
1454996, 1458347.

Thank you

Gustavo A. R. Silva (8):
  rtl2832: fix potential integer overflow
  dvb-frontends: ves1820: fix potential integer overflow
  i2c: max2175: fix potential integer overflow in max2175_set_nco_freq
  i2c: ov9650: fix potential integer overflow in
    __ov965x_set_frame_interval
  pci: cx88-input: fix potential integer overflow
  rockchip/rga: fix potential integer overflow in rga_buf_map
  platform: sh_veu: fix potential integer overflow in
    sh_veu_colour_offset
  platform: vivid-cec: fix potential integer overflow in
    vivid_cec_pin_adap_events

 drivers/media/dvb-frontends/rtl2832.c         | 4 ++--
 drivers/media/dvb-frontends/ves1820.c         | 2 +-
 drivers/media/i2c/max2175.c                   | 2 +-
 drivers/media/i2c/ov9650.c                    | 2 +-
 drivers/media/pci/cx88/cx88-input.c           | 4 ++--
 drivers/media/platform/rockchip/rga/rga-buf.c | 2 +-
 drivers/media/platform/sh_veu.c               | 4 ++--
 drivers/media/platform/vivid/vivid-cec.c      | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.7.4
