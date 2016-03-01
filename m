Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1544 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbcCACpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 21:45:40 -0500
Date: Tue, 1 Mar 2016 10:45:01 +0800
From: kbuild test robot <lkp@intel.com>
To: Jung Zhao <jung.zhao@rock-chips.com>
Cc: kbuild-all@01.org, tfiga@chromium.org, posciak@chromium.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Pawel Osciak <posciak@google.com>,
	eddie.cai@rock-chips.com, alpha.lin@rock-chips.com,
	jeffy.chen@rock-chips.com, herman.chen@rock-chips.com
Subject: Re: [PATCH v3 2/3] [NOT FOR REVIEW] v4l: Add VP8 low-level decoder
 API controls.
Message-ID: <201603011017.lSprSEU8%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <1456799017-8612-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pawel,

[auto build test WARNING on sailus-media/master]
[also build test WARNING on v4.5-rc6 next-20160229]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Jung-Zhao/Add-Rockchip-VP8-Video-Decoder-Driver/20160301-103522
base:   git://linuxtv.org/media_tree.git master
config: i386-tinyconfig (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

>> ./usr/include/linux/v4l2-controls.h:983: found __[us]{8,16,32,64} type without #include <linux/types.h>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--C7zPtVaVf+AK4Oqc
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--C7zPtVaVf+AK4Oqc--
