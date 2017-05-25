Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62770 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968617AbdEYHwM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 03:52:12 -0400
Date: Thu, 25 May 2017 15:51:39 +0800
From: kbuild test robot <lkp@intel.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: kbuild-all@01.org, robh+dt@kernel.org, mark.rutland@arm.com,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v7 18/34] platform: video-mux: include temporary mmio-mux
 support
Message-ID: <201705251540.fnn67915%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495672189-29164-19-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12-rc2 next-20170525]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Steve-Longerbeam/i-MX-Media-Driver/20170525-135051
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/video-mux.c:246:1-3: WARNING: PTR_ERR_OR_ZERO can be used

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
