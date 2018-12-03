Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbeLCKmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 05:42:32 -0500
Date: Mon, 3 Dec 2018 13:43:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Lubomir Rintel <lkundrak@v3.sk>
Cc: kbuild-all@01.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH 4/6] media: ov2680: get rid of extra ifdefs
Message-ID: <20181203104339.GD3073@unbuntlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128171918.160643-5-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lubomir,

url:    https://github.com/0day-ci/linux/commits/Lubomir-Rintel/media-don-t-ifdef-v4l2_subdev_get_try_format-any-more/20181129-205631
base:   git://linuxtv.org/media_tree.git master

smatch warnings:
drivers/media/i2c/ov2680.c:687 ov2680_get_fmt() warn: inconsistent returns 'mutex:&sensor->lock'.
  Locked on:   line 677
  Unlocked on: line 670

# https://github.com/0day-ci/linux/commit/45699a2f04294ea9ca96a3d178232ecae7f607ed
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 45699a2f04294ea9ca96a3d178232ecae7f607ed
vim +687 drivers/media/i2c/ov2680.c

3ee47cad Rui Miguel Silva 2018-07-03  660  
3ee47cad Rui Miguel Silva 2018-07-03  661  static int ov2680_get_fmt(struct v4l2_subdev *sd,
3ee47cad Rui Miguel Silva 2018-07-03  662  			  struct v4l2_subdev_pad_config *cfg,
3ee47cad Rui Miguel Silva 2018-07-03  663  			  struct v4l2_subdev_format *format)
3ee47cad Rui Miguel Silva 2018-07-03  664  {
3ee47cad Rui Miguel Silva 2018-07-03  665  	struct ov2680_dev *sensor = to_ov2680_dev(sd);
3ee47cad Rui Miguel Silva 2018-07-03  666  	struct v4l2_mbus_framefmt *fmt = NULL;
3ee47cad Rui Miguel Silva 2018-07-03  667  	int ret = 0;
3ee47cad Rui Miguel Silva 2018-07-03  668  
3ee47cad Rui Miguel Silva 2018-07-03  669  	if (format->pad != 0)
3ee47cad Rui Miguel Silva 2018-07-03  670  		return -EINVAL;
3ee47cad Rui Miguel Silva 2018-07-03  671  
3ee47cad Rui Miguel Silva 2018-07-03  672  	mutex_lock(&sensor->lock);
3ee47cad Rui Miguel Silva 2018-07-03  673  
3ee47cad Rui Miguel Silva 2018-07-03  674  	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
3ee47cad Rui Miguel Silva 2018-07-03  675  		fmt = v4l2_subdev_get_try_format(&sensor->sd, cfg, format->pad);
45699a2f Lubomir Rintel   2018-11-28  676  		if (IS_ERR(fmt))
45699a2f Lubomir Rintel   2018-11-28  677  			return PTR_ERR(fmt);
                                                                ^^^^^^^^^^^^^^^^^^^
goto unlock;

3ee47cad Rui Miguel Silva 2018-07-03  678  	} else {
3ee47cad Rui Miguel Silva 2018-07-03  679  		fmt = &sensor->fmt;
3ee47cad Rui Miguel Silva 2018-07-03  680  	}
3ee47cad Rui Miguel Silva 2018-07-03  681  
3ee47cad Rui Miguel Silva 2018-07-03  682  	if (fmt)
3ee47cad Rui Miguel Silva 2018-07-03  683  		format->format = *fmt;
3ee47cad Rui Miguel Silva 2018-07-03  684  
3ee47cad Rui Miguel Silva 2018-07-03  685  	mutex_unlock(&sensor->lock);
3ee47cad Rui Miguel Silva 2018-07-03  686  
3ee47cad Rui Miguel Silva 2018-07-03 @687  	return ret;
3ee47cad Rui Miguel Silva 2018-07-03  688  }
3ee47cad Rui Miguel Silva 2018-07-03  689  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
