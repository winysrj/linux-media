Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4378 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbcHFWBa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 18:01:30 -0400
Date: Sun, 7 Aug 2016 06:00:42 +0800
From: kbuild test robot <lkp@intel.com>
To: "Gerard H. Pille" <g.h.p@skynet.be>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	"Gerard H. Pille" <g.h.p@skynet.be>
Subject: Re: [PATCH] This patch allows the Terratec Cinergy HTC Stick HD
 (0ccb:0101) to be used to watch DVB-T.
Message-ID: <201608070557.KyrCqvyo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470495808-7250-1-git-send-email-g.h.p@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerard,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.7 next-20160805]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Gerard-H-Pille/This-patch-allows-the-Terratec-Cinergy-HTC-Stick-HD-0ccb-0101-to-be-used-to-watch-DVB-T/20160807-042525
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/dvb-frontends/si2165.c:1192:3-8: No need to set .owner here. The core will do it.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
