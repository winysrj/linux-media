Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51904 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751447AbeGEFua (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 01:50:30 -0400
Date: Thu, 5 Jul 2018 13:49:09 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Antti Palosaari <crope@iki.fi>,
        Jemma Denson <jdenson@gmail.com>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] media: dvb: represent min/max/step/tolerance freqs
 in Hz
Message-ID: <201807051308.JLzggaRp%fengguang.wu@intel.com>
References: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3d63a8f038d136b26692bc3a14554960e767f4a.1530740760.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.18-rc3 next-20180704]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mauro-Carvalho-Chehab/DVB-represent-frequencies-at-tuner-frontend-info-in-Hz/20180705-105703
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/dvb-core/dvb_frontend.c:2396:18-24: ERROR: application of sizeof to pointer

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
