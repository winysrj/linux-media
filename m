Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:49316
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751136AbdFYUAb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 16:00:31 -0400
Date: Sun, 25 Jun 2017 16:00:19 -0400 (EDT)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Hugues Fruchet <hugues.fruchet@st.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>, kbuild-all@01.org
Subject: Re: [PATCH v1 5/6] [media] ov9650: add multiple variant support
 (fwd)
Message-ID: <alpine.DEB.2.20.1706251559180.3109@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Braces are probably missing aroud lines 1618-1620.

julia

---------- Forwarded message ----------
Date: Sun, 25 Jun 2017 23:06:03 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v1 5/6] [media] ov9650: add multiple variant support

Hi Hugues,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.12-rc6 next-20170623]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hugues-Fruchet/Add-support-of-OV9655-camera/20170625-201153
base:   git://linuxtv.org/media_tree.git master
:::::: branch date: 3 hours ago
:::::: commit date: 3 hours ago

>> drivers/media/i2c/ov9650.c:1618:2-44: code aligned with following code on line 1619

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout a9fe8c23240a7f8df39c6238d98e41f41fedb641
vim +1618 drivers/media/i2c/ov9650.c

a9fe8c23 Hugues Fruchet     2017-06-22  1612  	ov965x->set_params = __ov965x_set_params;
84a15ded Sylwester Nawrocki 2012-12-26  1613
a9fe8c23 Hugues Fruchet     2017-06-22  1614  	ov965x->frame_size = &ov965x->framesizes[0];
a9fe8c23 Hugues Fruchet     2017-06-22  1615  	ov965x_get_default_format(ov965x, &ov965x->format);
a9fe8c23 Hugues Fruchet     2017-06-22  1616
a9fe8c23 Hugues Fruchet     2017-06-22  1617  	if (ov965x->initialize_controls)
a9fe8c23 Hugues Fruchet     2017-06-22 @1618  		ret = ov965x->initialize_controls(ov965x);
84a15ded Sylwester Nawrocki 2012-12-26 @1619  		if (ret < 0)
84a15ded Sylwester Nawrocki 2012-12-26  1620  			goto err_ctrls;
84a15ded Sylwester Nawrocki 2012-12-26  1621
84a15ded Sylwester Nawrocki 2012-12-26  1622  	/* Update exposure time min/max to match frame format */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
