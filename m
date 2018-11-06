Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46701 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387800AbeKFVdT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 16:33:19 -0500
Date: Tue, 6 Nov 2018 20:07:23 +0800
From: kbuild test robot <lkp@intel.com>
To: Maxime Jourdan <mjourdan@baylibre.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v4 2/3] media: meson: add v4l2 m2m video decoder driver
Message-ID: <201811062010.zqwrLaj3%fengguang.wu@intel.com>
References: <20181106075926.19269-3-mjourdan@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106075926.19269-3-mjourdan@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.20-rc1 next-20181106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Maxime-Jourdan/dt-bindings-media-add-Amlogic-Video-Decoder-Bindings/20181106-162646
base:   git://linuxtv.org/media_tree.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/media/platform/meson/vdec/codec_mpeg12.c:149:2-3: Unneeded semicolon
--
>> drivers/media/platform/meson/vdec/vdec_helpers.c:187:3-4: Unneeded semicolon
--
>> drivers/media/platform/meson/vdec/esparser.c:148:13-31: WARNING: dma_zalloc_coherent should be used for eos_vaddr, instead of dma_alloc_coherent/memset

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
