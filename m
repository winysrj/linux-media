Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:11329 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbdGORmb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 13:42:31 -0400
Date: Sun, 16 Jul 2017 01:42:15 +0800
From: kbuild test robot <lkp@intel.com>
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: kbuild-all@01.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        s.nawrocki@samsung.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: Re: [PATCH v2 2/6] [media] rockchip/rga: v4l2 m2m support
Message-ID: <201707160133.EJTpOgmB%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500101920-24039-3-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

[auto build test WARNING on rockchip/for-next]
[also build test WARNING on v4.12 next-20170714]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jacob-Chen/v4l-add-blend-modes-controls/20170715-214326
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mmind/linux-rockchip.git for-next


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/rockchip-rga/rga-hw.c:124:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
