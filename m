Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4508 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbeFTLpw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 07:45:52 -0400
Date: Wed, 20 Jun 2018 19:45:40 +0800
From: kbuild test robot <lkp@intel.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: kbuild-all@01.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH v3] media: ov5640: fix frame interval enumeration
Message-ID: <201806201946.wInxExRR%fengguang.wu@intel.com>
References: <1529484057-2361-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1529484057-2361-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.18-rc1 next-20180619]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hugues-Fruchet/media-ov5640-fix-frame-interval-enumeration/20180620-175405
base:   git://linuxtv.org/media_tree.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/i2c/ov5640.c:1394:14: sparse: incorrect type in assignment (different base types) @@    expected struct ov5640_mode_info const *mode @@    got ststruct ov5640_mode_info const *mode @@
   drivers/media/i2c/ov5640.c:1394:14:    expected struct ov5640_mode_info const *mode
   drivers/media/i2c/ov5640.c:1394:14:    got struct ov5640_mode_info const ( *<noident> )[9]

vim +1394 drivers/media/i2c/ov5640.c

  1387	
  1388	static const struct ov5640_mode_info *
  1389	ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
  1390			 int width, int height, bool nearest)
  1391	{
  1392		const struct ov5640_mode_info *mode;
  1393	
> 1394		mode = v4l2_find_nearest_size(ov5640_mode_data[fr],
  1395					      ARRAY_SIZE(ov5640_mode_data[fr]),
  1396					      hact, vact,
  1397					      width, height);
  1398	
  1399		if (!mode ||
  1400		    (!nearest && (mode->hact != width || mode->vact != height)))
  1401			return NULL;
  1402	
  1403		return mode;
  1404	}
  1405	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
