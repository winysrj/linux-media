Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45631 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbeBTFJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 00:09:44 -0500
Date: Tue, 20 Feb 2018 13:22:23 +0800
From: kbuild test robot <lkp@intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: kbuild-all@01.org, laurent.pinchart@ideasonboard.com,
        magnus.damm@gmail.com, geert@glider.be, hverkuil@xs4all.nl,
        mchehab@kernel.org, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com, pombredanne@nexb.com,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 07/11] media: i2c: ov772x: Support frame interval
 handling
Message-ID: <201802201353.dQxggfw5%fengguang.wu@intel.com>
References: <1519059584-30844-8-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519059584-30844-8-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.16-rc2 next-20180220]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jacopo-Mondi/Renesas-Capture-Engine-Unit-CEU-V4L2-driver/20180220-101027
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/i2c/ov772x.c:386:3: sparse: symbol 'ov772x_pll' was not declared. Should it be
>> drivers/media/i2c/ov772x.c:535:14: sparse: symbol 'ov772x_frame_intervals' was not declared. Should it be
   drivers/media/i2c/ov772x.c: In function 'ov772x_set_frame_rate.isra.2':
   drivers/media/i2c/ov772x.c:643:7: warning: 'fsize' may be used uninitialized in this function
    pclk = fps COPYING CREDITS Documentation Kbuild Kconfig LICENSES MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt fsize;
    ~~~~~^~~~~~~~~~~~~

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
